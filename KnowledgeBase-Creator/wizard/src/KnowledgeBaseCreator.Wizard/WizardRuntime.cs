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
    public bool? LastOpenVsCode { get; set; }
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

    public static bool IsCodeOnPath()
    {
        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = "where.exe",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
            };
            psi.ArgumentList.Add("code");

            using var process = Process.Start(psi);
            if (process is null)
            {
                return false;
            }

            process.WaitForExit();
            return process.ExitCode == 0;
        }
        catch
        {
            return false;
        }
    }

    public static void OpenInVsCode(string path)
    {
        var psi = new ProcessStartInfo
        {
            FileName = "code",
            UseShellExecute = false,
            WorkingDirectory = path,
        };
        psi.ArgumentList.Add(path);
        Process.Start(psi);
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
