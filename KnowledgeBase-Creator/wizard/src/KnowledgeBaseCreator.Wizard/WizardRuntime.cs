using System.Diagnostics;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace KnowledgeBaseCreator.Wizard;

internal sealed class WizardConfig
{
    public string? LastMprPath { get; set; }
    public string? LastAppName { get; set; }
    public string? LastInstallRoot { get; set; }
    public string? LastMxExePath { get; set; }
    public string? LastDataRoot { get; set; }
    public string? LastClaudePath { get; set; }
    public bool? AutoEnrichAfterPipeline { get; set; }
}

internal sealed class DetectionResult
{
    public bool Success { get; set; }
    public bool UsedFallback { get; set; }
    public string? RequiredVersion { get; set; }
    public string? SelectedMxPath { get; set; }
    public string? Error { get; set; }
    public List<string> DiscoveredMxPaths { get; } = new();
}

internal static class WizardRuntime
{
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        WriteIndented = true,
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    };

    public static string FindWizardRoot(string startPath)
    {
        foreach (var candidate in EnumerateAncestorPaths(startPath))
        {
            if (File.Exists(Path.Combine(candidate, "run-dump-parser.ps1")))
            {
                return candidate;
            }

            var childWizard = Path.Combine(candidate, "wizard");
            if (File.Exists(Path.Combine(childWizard, "run-dump-parser.ps1")))
            {
                return childWizard;
            }
        }

        foreach (var candidate in EnumerateAncestorPaths(Environment.CurrentDirectory))
        {
            if (File.Exists(Path.Combine(candidate, "run-dump-parser.ps1")))
            {
                return candidate;
            }

            var childWizard = Path.Combine(candidate, "wizard");
            if (File.Exists(Path.Combine(childWizard, "run-dump-parser.ps1")))
            {
                return childWizard;
            }
        }

        throw new DirectoryNotFoundException("Could not locate wizard root (missing run-dump-parser.ps1).");
    }

    public static WizardConfig LoadConfig(string path)
    {
        if (!File.Exists(path))
        {
            return new WizardConfig();
        }

        try
        {
            var json = File.ReadAllText(path);
            return JsonSerializer.Deserialize<WizardConfig>(json, JsonOptions) ?? new WizardConfig();
        }
        catch
        {
            return new WizardConfig();
        }
    }

    public static void SaveConfig(string path, WizardConfig config)
    {
        var json = JsonSerializer.Serialize(config, JsonOptions);
        File.WriteAllText(path, json);
    }

    public static string ResolveInstallRootDefault(WizardConfig config)
    {
        if (!string.IsNullOrWhiteSpace(config.LastInstallRoot))
        {
            return config.LastInstallRoot!;
        }

        var envRoot = Environment.GetEnvironmentVariable("MENDIX_INSTALL_ROOT");
        if (!string.IsNullOrWhiteSpace(envRoot))
        {
            return envRoot.Trim();
        }

        return @"C:\Program Files\Mendix";
    }

    public static string ValidateMprPath(string path)
    {
        var fullPath = Path.GetFullPath(path.Trim().Trim('"'));
        if (!File.Exists(fullPath))
        {
            throw new FileNotFoundException($"MPR file not found: {fullPath}");
        }
        if (!string.Equals(Path.GetExtension(fullPath), ".mpr", StringComparison.OrdinalIgnoreCase))
        {
            throw new ArgumentException($"File is not an .mpr: {fullPath}");
        }
        return fullPath;
    }

    public static string ValidateMxPath(string path)
    {
        var fullPath = Path.GetFullPath(path.Trim().Trim('"'));
        if (!File.Exists(fullPath))
        {
            throw new FileNotFoundException($"mx.exe not found: {fullPath}");
        }
        if (!string.Equals(Path.GetFileName(fullPath), "mx.exe", StringComparison.OrdinalIgnoreCase))
        {
            throw new ArgumentException($"Path is not mx.exe: {fullPath}");
        }
        return fullPath;
    }

    public static string GetSuggestedDataRoot(string mprPath)
    {
        return Path.Combine(Path.GetDirectoryName(mprPath)!, "mendix-data");
    }

    public static string NormalizeDataRootInput(string path)
    {
        if (string.IsNullOrWhiteSpace(path))
        {
            throw new ArgumentException("Output data root is required.");
        }

        var fullPath = Path.GetFullPath(path.Trim().Trim('"'));
        if (File.Exists(fullPath))
        {
            throw new ArgumentException($"Output data root points to a file: {fullPath}");
        }

        if (string.Equals(Path.GetFileName(fullPath), "knowledge-base", StringComparison.OrdinalIgnoreCase))
        {
            var parent = Directory.GetParent(fullPath)?.FullName;
            if (string.IsNullOrWhiteSpace(parent))
            {
                throw new ArgumentException($"Could not derive mendix-data folder from knowledge-base path: {fullPath}");
            }

            return parent;
        }

        return fullPath;
    }

    public static DetectionResult DetectMxPath(string mprPath, string installRoot)
    {
        var result = new DetectionResult();

        if (!Directory.Exists(installRoot))
        {
            result.Error = $"Install root not found: {installRoot}";
            return result;
        }

        var candidates = GetCandidateMxPaths(installRoot).ToList();
        result.DiscoveredMxPaths.AddRange(candidates);
        if (candidates.Count == 0)
        {
            result.Error = $"No mx.exe files found under {installRoot}";
            return result;
        }

        var probeMx = candidates[0];
        if (!TryRunShowVersion(probeMx, mprPath, out var showVersionOutput, out var showVersionError))
        {
            result.Error = $"Failed to run `mx.exe show-version`: {showVersionError}";
            return result;
        }

        var requiredVersion = ParseVersion(showVersionOutput);
        if (string.IsNullOrWhiteSpace(requiredVersion))
        {
            result.Error = $"Could not parse Mendix version from output: {showVersionOutput}";
            return result;
        }

        result.RequiredVersion = requiredVersion;

        var exactCandidates = new[]
        {
            Path.Combine(installRoot, requiredVersion, "modeler", "mx.exe"),
            Path.Combine(installRoot, requiredVersion, "mx.exe"),
        };

        foreach (var candidate in exactCandidates)
        {
            if (File.Exists(candidate))
            {
                result.Success = true;
                result.SelectedMxPath = candidate;
                result.UsedFallback = false;
                return result;
            }
        }

        var fallback = FindMajorMinorFallback(requiredVersion, installRoot);
        if (!string.IsNullOrWhiteSpace(fallback))
        {
            result.Success = true;
            result.SelectedMxPath = fallback;
            result.UsedFallback = true;
            return result;
        }

        result.Error = $"No matching mx.exe installation found for required version {requiredVersion}.";
        return result;
    }

    public static async Task<int> RunPipelineAsync(
        string packageRoot,
        string wizardRoot,
        string mprPath,
        string appName,
        string mxPath,
        string dataRoot,
        Action<string>? log = null)
    {
        var runScript = Path.Combine(wizardRoot, "run-dump-parser.ps1");
        if (!File.Exists(runScript))
        {
            throw new FileNotFoundException($"Pipeline script not found: {runScript}");
        }

        var psi = new ProcessStartInfo
        {
            FileName = "powershell",
            UseShellExecute = false,
            WorkingDirectory = packageRoot,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true,
        };
        psi.ArgumentList.Add("-NoProfile");
        psi.ArgumentList.Add("-ExecutionPolicy");
        psi.ArgumentList.Add("Bypass");
        psi.ArgumentList.Add("-File");
        psi.ArgumentList.Add(runScript);

        psi.Environment["MPR_FILE_PATH"] = mprPath;
        psi.Environment["APP_NAME"] = appName;
        psi.Environment["MENDIX_MX_EXE"] = mxPath;
        psi.Environment["MENDIX_DATA_ROOT"] = dataRoot;
        psi.Environment["MENDIX_APP_PATH"] = Path.GetDirectoryName(mprPath)!;

        var studioProPath = InferStudioProPath(mxPath);
        if (!string.IsNullOrWhiteSpace(studioProPath))
        {
            psi.Environment["STUDIO_PRO_PATH"] = studioProPath;
            psi.Environment["MENDIX_STUDIO_PRO_PATH"] = studioProPath;
        }

        using var process = new Process { StartInfo = psi, EnableRaisingEvents = true };
        process.OutputDataReceived += (_, e) => { if (!string.IsNullOrWhiteSpace(e.Data)) { log?.Invoke(e.Data); } };
        process.ErrorDataReceived += (_, e) => { if (!string.IsNullOrWhiteSpace(e.Data)) { log?.Invoke($"[ERR] {e.Data}"); } };

        if (!process.Start())
        {
            throw new InvalidOperationException("Failed to start PowerShell pipeline process.");
        }

        process.BeginOutputReadLine();
        process.BeginErrorReadLine();
        await process.WaitForExitAsync().ConfigureAwait(false);
        return process.ExitCode;
    }

    public static async Task<int> RunEnrichmentAsync(
        string packageRoot,
        string wizardRoot,
        string kbRoot,
        string appName,
        string? claudePath,
        Action<string>? log = null)
    {
        var runScript = Path.Combine(wizardRoot, "run-enrichkb.ps1");
        if (!File.Exists(runScript))
        {
            throw new FileNotFoundException($"Enrichment script not found: {runScript}");
        }

        var psi = new ProcessStartInfo
        {
            FileName = "powershell",
            UseShellExecute = false,
            WorkingDirectory = packageRoot,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true,
        };
        psi.ArgumentList.Add("-NoProfile");
        psi.ArgumentList.Add("-ExecutionPolicy");
        psi.ArgumentList.Add("Bypass");
        psi.ArgumentList.Add("-File");
        psi.ArgumentList.Add(runScript);

        psi.Environment["KNOWLEDGE_BASE_ROOT"] = kbRoot;
        psi.Environment["APP_NAME"] = appName;
        psi.Environment["CREATOR_ROOT"] = packageRoot;

        if (!string.IsNullOrWhiteSpace(claudePath))
        {
            psi.Environment["CLAUDE_CLI_PATH"] = claudePath;
        }

        using var process = new Process { StartInfo = psi, EnableRaisingEvents = true };
        process.OutputDataReceived += (_, e) => { if (!string.IsNullOrWhiteSpace(e.Data)) { log?.Invoke(e.Data); } };
        process.ErrorDataReceived += (_, e) => { if (!string.IsNullOrWhiteSpace(e.Data)) { log?.Invoke($"[ERR] {e.Data}"); } };

        if (!process.Start())
        {
            throw new InvalidOperationException("Failed to start PowerShell enrichment process.");
        }

        process.BeginOutputReadLine();
        process.BeginErrorReadLine();
        await process.WaitForExitAsync().ConfigureAwait(false);
        return process.ExitCode;
    }

    public static string? FindLatestRunFolder(string dataRoot)
    {
        var appOverviewRoot = Path.Combine(dataRoot, "app-overview");
        if (!Directory.Exists(appOverviewRoot))
        {
            return null;
        }

        return Directory.GetDirectories(appOverviewRoot)
            .Where(d => File.Exists(Path.Combine(d, "manifest.json")))
            .OrderByDescending(d => new DirectoryInfo(d).LastWriteTimeUtc)
            .FirstOrDefault();
    }

    public static string WriteCreatorLink(
        string packageRoot,
        string kbRoot,
        string dataRoot,
        string appName,
        string mprPath,
        string runFolder)
    {
        var sourcesDir = Path.Combine(kbRoot, "_sources");
        Directory.CreateDirectory(sourcesDir);

        var payload = new Dictionary<string, object>
        {
            ["schemaVersion"] = "1.0",
            ["creatorRoot"] = packageRoot,
            ["appName"] = appName,
            ["mprPath"] = mprPath,
            ["dataRoot"] = dataRoot,
            ["knowledgeBaseRoot"] = kbRoot,
            ["lastRunFolder"] = runFolder,
            ["updatedAtUtc"] = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ"),
        };

        var linkPath = Path.Combine(sourcesDir, "creator-link.json");
        var json = JsonSerializer.Serialize(payload, JsonOptions);
        File.WriteAllText(linkPath, json);
        return linkPath;
    }

    public static (bool Found, string? Path) DetectClaudeCli(string? userPath = null)
    {
        if (!string.IsNullOrWhiteSpace(userPath))
        {
            var fullPath = Path.GetFullPath(userPath.Trim().Trim('"'));
            if (File.Exists(fullPath))
            {
                return (true, fullPath);
            }
        }

        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = "where",
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true,
            };
            psi.ArgumentList.Add("claude");

            using var process = Process.Start(psi);
            if (process is not null)
            {
                var output = process.StandardOutput.ReadToEnd().Trim();
                process.WaitForExit();
                if (process.ExitCode == 0 && !string.IsNullOrWhiteSpace(output))
                {
                    var firstLine = output.Split('\n', StringSplitOptions.RemoveEmptyEntries)[0].Trim();
                    if (File.Exists(firstLine))
                    {
                        return (true, firstLine);
                    }
                }
            }
        }
        catch
        {
            // where command failed; continue to fallback checks
        }

        var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);

        string?[] candidates =
        [
            string.IsNullOrWhiteSpace(localAppData) ? null : Path.Combine(localAppData, "Programs", "claude", "claude.exe"),
            string.IsNullOrWhiteSpace(appData) ? null : Path.Combine(appData, "npm", "claude.cmd"),
            string.IsNullOrWhiteSpace(localAppData) ? null : Path.Combine(localAppData, "Microsoft", "WinGet", "Links", "claude.exe"),
        ];

        foreach (var candidate in candidates)
        {
            if (!string.IsNullOrWhiteSpace(candidate) && File.Exists(candidate))
            {
                return (true, candidate);
            }
        }

        return (false, null);
    }

    private static IEnumerable<string> GetCandidateMxPaths(string installRoot)
    {
        foreach (var directory in Directory.GetDirectories(installRoot))
        {
            var modelerMx = Path.Combine(directory, "modeler", "mx.exe");
            if (File.Exists(modelerMx))
            {
                yield return modelerMx;
            }

            var rootMx = Path.Combine(directory, "mx.exe");
            if (File.Exists(rootMx))
            {
                yield return rootMx;
            }
        }
    }

    private static bool TryRunShowVersion(string mxPath, string mprPath, out string stdout, out string error)
    {
        var psi = new ProcessStartInfo
        {
            FileName = mxPath,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true,
        };
        psi.ArgumentList.Add("show-version");
        psi.ArgumentList.Add(mprPath);

        using var process = Process.Start(psi);
        if (process is null)
        {
            stdout = string.Empty;
            error = "Could not start mx.exe process.";
            return false;
        }

        stdout = process.StandardOutput.ReadToEnd().Trim();
        var stderr = process.StandardError.ReadToEnd().Trim();
        process.WaitForExit();

        if (process.ExitCode != 0)
        {
            error = string.IsNullOrWhiteSpace(stderr) ? $"exit code {process.ExitCode}" : stderr;
            return false;
        }

        error = string.Empty;
        return true;
    }

    private static string? ParseVersion(string text)
    {
        if (string.IsNullOrWhiteSpace(text))
        {
            return null;
        }

        var match = Regex.Match(text, @"\b\d+\.\d+(?:\.\d+){0,2}\b");
        return match.Success ? match.Value : null;
    }

    private static string? FindMajorMinorFallback(string requiredVersion, string installRoot)
    {
        var parts = requiredVersion.Split('.', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length < 2)
        {
            return null;
        }

        var majorMinor = $"{parts[0]}.{parts[1]}";
        var directories = Directory.GetDirectories(installRoot)
            .Select(path => new DirectoryInfo(path))
            .Where(info =>
            {
                var name = info.Name;
                return name.Equals(majorMinor, StringComparison.OrdinalIgnoreCase)
                    || name.Equals($"{majorMinor}.x", StringComparison.OrdinalIgnoreCase)
                    || name.StartsWith($"{majorMinor}.", StringComparison.OrdinalIgnoreCase);
            })
            .OrderByDescending(info => info.Name, StringComparer.OrdinalIgnoreCase);

        foreach (var directory in directories)
        {
            var modelerMx = Path.Combine(directory.FullName, "modeler", "mx.exe");
            if (File.Exists(modelerMx))
            {
                return modelerMx;
            }

            var rootMx = Path.Combine(directory.FullName, "mx.exe");
            if (File.Exists(rootMx))
            {
                return rootMx;
            }
        }

        return null;
    }

    private static string? InferStudioProPath(string mxPath)
    {
        var parent = Directory.GetParent(mxPath);
        if (parent is null)
        {
            return null;
        }

        if (parent.Name.Equals("modeler", StringComparison.OrdinalIgnoreCase))
        {
            return parent.Parent?.FullName;
        }

        return parent.FullName;
    }

    private static IEnumerable<string> EnumerateAncestorPaths(string path)
    {
        var directory = new DirectoryInfo(path);
        while (directory is not null)
        {
            yield return directory.FullName;
            directory = directory.Parent;
        }
    }
}
