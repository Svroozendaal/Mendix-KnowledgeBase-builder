using System.Diagnostics;
using System.Text.RegularExpressions;

namespace AutoCommitMessage;

/// <summary>
/// Detects the correct mx.exe path for a given Mendix project by:
///   1. Running mx.exe show-version on the .mpr file to determine the required version.
///   2. Scanning the Mendix installations root (default: C:\Program Files\Mendix\)
///      for a matching version folder.
///   3. Returning the full path to mx.exe within that folder.
///
/// Detection steps in order:
///   Step 1 - Determine required version:
///     Run: <any available mx.exe> show-version <mprFilePath>
///     To bootstrap this, scan the installations root for any installed version
///     and use the first found mx.exe to run show-version. The version string
///     returned identifies which installation the project needs.
///
///   Step 2 - Find matching installation:
///     Look for C:\Program Files\Mendix\<requiredVersion>\modeler\mx.exe
///     Match on exact version string as returned by show-version.
///
///   Step 3 - Fallback:
///     If no exact match is found, attempt a major.minor match (e.g. 10.24.x).
///     Log a warning if fallback matching is used.
///
/// The installations root can be overridden via the Settings UI or the
/// MENDIX_INSTALL_ROOT environment variable.
/// </summary>
public class MendixInstallationDetectorService
{
    private const string DefaultInstallRoot = @"C:\Program Files\Mendix";
    private const int ShowVersionTimeoutMs = 15 * 1000;
    private static readonly Regex VersionRegex = new(@"^(\d+\.\d+\.\d+(?:\.\d+)?)$", RegexOptions.Compiled);

    /// <summary>
    /// Detects the correct mx.exe path for a given Mendix project.
    /// </summary>
    /// <param name="mprFilePath">Full path to the .mpr file.</param>
    /// <param name="installRootOverride">Optional override for the Mendix installations root.</param>
    /// <returns>A DetectionResult with success status, mx.exe path, and diagnostic information.</returns>
    public DetectionResult Detect(string mprFilePath, string? installRootOverride = null)
    {
        if (string.IsNullOrWhiteSpace(mprFilePath))
        {
            return new DetectionResult
            {
                Success = false,
                FailureReason = "MPR file path is required.",
            };
        }

        if (!File.Exists(mprFilePath))
        {
            return new DetectionResult
            {
                Success = false,
                FailureReason = $"MPR file not found: {mprFilePath}",
            };
        }

        // Resolve the installations root.
        var installRoot = ResolveInstallRoot(installRootOverride);

        // Step 1: Determine the required Mendix version by running show-version.
        var requiredVersionResult = DetermineRequiredVersion(mprFilePath, installRoot);
        if (string.IsNullOrWhiteSpace(requiredVersionResult.Version))
        {
            return new DetectionResult
            {
                Success = false,
                InstallRoot = installRoot,
                FailureReason = requiredVersionResult.Error ?? "Could not determine required Mendix version.",
            };
        }

        var requiredVersion = requiredVersionResult.Version;

        // Step 2: Search for an exact match in the installations root.
        var exactMatch = FindMxExePath(installRoot, requiredVersion);
        if (!string.IsNullOrWhiteSpace(exactMatch) && File.Exists(exactMatch))
        {
            return new DetectionResult
            {
                Success = true,
                MxExePath = exactMatch,
                DetectedVersion = requiredVersion,
                InstallRoot = installRoot,
            };
        }

        // Step 3: Fallback to major.minor matching.
        var majorMinor = ExtractMajorMinor(requiredVersion);
        if (!string.IsNullOrWhiteSpace(majorMinor))
        {
            var fallbackMatch = FindMxExeByMajorMinor(installRoot, majorMinor);
            if (!string.IsNullOrWhiteSpace(fallbackMatch) && File.Exists(fallbackMatch))
            {
                return new DetectionResult
                {
                    Success = true,
                    MxExePath = fallbackMatch,
                    DetectedVersion = requiredVersion,
                    InstallRoot = installRoot,
                    WarningReason = $"No exact version match found for {requiredVersion}. Using {majorMinor}.x fallback.",
                };
            }
        }

        return new DetectionResult
        {
            Success = false,
            DetectedVersion = requiredVersion,
            InstallRoot = installRoot,
            FailureReason = $"No Mendix {requiredVersion} (or {majorMinor}.x) installation found in {installRoot}.",
        };
    }

    /// <summary>
    /// Resolves the installations root in order of precedence:
    /// 1. installRootOverride parameter
    /// 2. MENDIX_INSTALL_ROOT environment variable
    /// 3. Default: C:\Program Files\Mendix\
    /// </summary>
    private string ResolveInstallRoot(string? installRootOverride)
    {
        if (!string.IsNullOrWhiteSpace(installRootOverride))
        {
            return Path.GetFullPath(installRootOverride);
        }

        var envOverride = Environment.GetEnvironmentVariable("MENDIX_INSTALL_ROOT");
        if (!string.IsNullOrWhiteSpace(envOverride))
        {
            return Path.GetFullPath(envOverride);
        }

        return Path.GetFullPath(DefaultInstallRoot);
    }

    /// <summary>
    /// Determines the required Mendix version by running mx.exe show-version.
    /// First tries to find any mx.exe in the install root, then uses it to probe.
    /// </summary>
    private (string? Version, string? Error) DetermineRequiredVersion(string mprFilePath, string installRoot)
    {
        // Find any mx.exe in the install root to bootstrap version detection.
        var bootstrapMx = FindAnyMxExe(installRoot);
        if (string.IsNullOrWhiteSpace(bootstrapMx) || !File.Exists(bootstrapMx))
        {
            return (null, $"No mx.exe found in {installRoot} to bootstrap version detection.");
        }

        try
        {
            var startInfo = new ProcessStartInfo
            {
                FileName = bootstrapMx,
                RedirectStandardError = true,
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true,
            };

            startInfo.ArgumentList.Add("show-version");
            startInfo.ArgumentList.Add(mprFilePath);

            using var process = Process.Start(startInfo)
                ?? throw new InvalidOperationException("Failed to start mx.exe process.");

            var stdoutTask = process.StandardOutput.ReadToEndAsync();
            var stderrTask = process.StandardError.ReadToEndAsync();

            if (!process.WaitForExit(ShowVersionTimeoutMs))
            {
                try
                {
                    process.Kill(entireProcessTree: true);
                }
                catch
                {
                    // Best-effort cleanup.
                }

                return (null, "mx.exe show-version timed out.");
            }

            Task.WaitAll(stdoutTask, stderrTask);
            var stdout = stdoutTask.Result?.Trim() ?? string.Empty;
            var stderr = stderrTask.Result?.Trim() ?? string.Empty;

            if (process.ExitCode != 0)
            {
                return (null, $"mx.exe show-version failed: {(string.IsNullOrWhiteSpace(stderr) ? stdout : stderr)}");
            }

            // Version string should be on stdout.
            if (string.IsNullOrWhiteSpace(stdout))
            {
                return (null, "mx.exe show-version returned no output.");
            }

            // Validate it looks like a version.
            if (!VersionRegex.IsMatch(stdout))
            {
                return (null, $"Invalid version format: {stdout}");
            }

            return (stdout, null);
        }
        catch (Exception ex)
        {
            return (null, $"Exception while running mx.exe show-version: {ex.Message}");
        }
    }

    /// <summary>
    /// Finds any mx.exe in the install root (first found, for bootstrapping version detection).
    /// </summary>
    private string? FindAnyMxExe(string installRoot)
    {
        if (!Directory.Exists(installRoot))
        {
            return null;
        }

        try
        {
            var versionDirs = Directory.EnumerateDirectories(installRoot);
            foreach (var versionDir in versionDirs)
            {
                var candidates = new[]
                {
                    Path.Combine(versionDir, "modeler", "mx.exe"),
                    Path.Combine(versionDir, "mx.exe"),
                };

                foreach (var candidate in candidates)
                {
                    if (File.Exists(candidate))
                    {
                        return candidate;
                    }
                }
            }
        }
        catch
        {
            // Ignore enumeration errors.
        }

        return null;
    }

    /// <summary>
    /// Finds mx.exe at the exact version path: <installRoot>\<version>\modeler\mx.exe
    /// </summary>
    private string? FindMxExePath(string installRoot, string version)
    {
        if (string.IsNullOrWhiteSpace(version))
        {
            return null;
        }

        // Try exact version match.
        var candidates = new[]
        {
            Path.Combine(installRoot, version, "modeler", "mx.exe"),
            Path.Combine(installRoot, version, "mx.exe"),
        };

        foreach (var candidate in candidates)
        {
            if (File.Exists(candidate))
            {
                return candidate;
            }
        }

        return null;
    }

    /// <summary>
    /// Extracts major.minor from a version string (e.g., "10.24.15.12345" -> "10.24").
    /// </summary>
    private string? ExtractMajorMinor(string version)
    {
        if (string.IsNullOrWhiteSpace(version))
        {
            return null;
        }

        var parts = version.Split('.');
        if (parts.Length >= 2)
        {
            return $"{parts[0]}.{parts[1]}";
        }

        return null;
    }

    /// <summary>
    /// Finds mx.exe by scanning for the best major.minor.x match.
    /// </summary>
    private string? FindMxExeByMajorMinor(string installRoot, string majorMinor)
    {
        if (!Directory.Exists(installRoot))
        {
            return null;
        }

        try
        {
            var versionDirs = Directory.EnumerateDirectories(installRoot);
            foreach (var versionDir in versionDirs)
            {
                var dirName = Path.GetFileName(versionDir);
                if (!string.IsNullOrWhiteSpace(dirName) && dirName.StartsWith(majorMinor, StringComparison.OrdinalIgnoreCase))
                {
                    var candidates = new[]
                    {
                        Path.Combine(versionDir, "modeler", "mx.exe"),
                        Path.Combine(versionDir, "mx.exe"),
                    };

                    foreach (var candidate in candidates)
                    {
                        if (File.Exists(candidate))
                        {
                            return candidate;
                        }
                    }
                }
            }
        }
        catch
        {
            // Ignore enumeration errors.
        }

        return null;
    }
}

/// <summary>
/// Result of Mendix installation detection.
/// </summary>
public record DetectionResult
{
    /// <summary>
    /// True if detection succeeded and MxExePath is valid.
    /// </summary>
    public bool Success { get; init; }

    /// <summary>
    /// Full path to the detected (or fallback) mx.exe, or null if detection failed.
    /// </summary>
    public string? MxExePath { get; init; }

    /// <summary>
    /// The Mendix version detected from the .mpr file.
    /// </summary>
    public string? DetectedVersion { get; init; }

    /// <summary>
    /// The installations root used for detection.
    /// </summary>
    public string? InstallRoot { get; init; }

    /// <summary>
    /// If detection failed, the reason why (null if Success is true).
    /// </summary>
    public string? FailureReason { get; init; }

    /// <summary>
    /// If detection succeeded but using a fallback (e.g., major.minor match), the warning reason.
    /// </summary>
    public string? WarningReason { get; init; }
}
