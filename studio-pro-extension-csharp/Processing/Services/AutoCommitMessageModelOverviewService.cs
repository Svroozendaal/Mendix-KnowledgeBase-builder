using System.Text;
using System.Text.Json;
using LibGit2Sharp;

namespace AutoCommitMessage;

public enum ModelOverviewGenerationMode
{
    App,
    Modules,
    Both,
}

public static class AutoCommitMessageModelOverviewService
{
    private const string OverviewFolderName = "overviews";
    private const string ModuleCategorySystem = "System";
    private const string ModuleCategoryMarketplace = "Marketplace";
    private const string ModuleCategoryCustom = "Custom";

    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = true,
    };

    public static ModelOverviewGenerationResult GenerateOverview(
        string projectPath,
        ModelOverviewGenerationMode mode = ModelOverviewGenerationMode.Both,
        string? selectedModule = null,
        IReadOnlyList<string>? selectedModules = null,
        bool includeStructuredOutput = true,
        bool includePseudocodeOutput = true,
        string? dataRootBasePath = null)
    {
        if (!includeStructuredOutput && !includePseudocodeOutput)
        {
            return BuildFailure(
                "No overview output formats selected.",
                mode,
                selectedModule,
                selectedModules);
        }

        var payload = AutoCommitMessageChangeService.ReadChanges(projectPath);
        if (!payload.IsGitRepo)
        {
            return BuildFailure("Current project is not a Git repository.", mode, selectedModule, selectedModules);
        }

        if (!string.IsNullOrWhiteSpace(payload.Error))
        {
            return BuildFailure(payload.Error, mode, selectedModule, selectedModules);
        }

        var discoveredPath = Repository.Discover(projectPath);
        if (string.IsNullOrWhiteSpace(discoveredPath))
        {
            return BuildFailure("Could not resolve repository root.", mode, selectedModule, selectedModules);
        }

        using var repository = new Repository(discoveredPath);
        var repositoryRoot = repository.Info.WorkingDirectory;
        if (repository.Head?.Tip is null)
        {
            return BuildFailure("No committed revision (HEAD) is available.", mode, selectedModule, selectedModules);
        }

        var mprPaths = ResolveHeadMprPaths(repository);
        if (mprPaths.Count == 0)
        {
            return BuildFailure("No committed .mpr files were found in the repository.", mode, selectedModule, selectedModules);
        }

        var requestedModules = NormalizeRequestedModules(selectedModule, selectedModules);
        var generatedAtUtc = DateTimeOffset.UtcNow;
        var runFolder = CreateOverviewRunFolder(repositoryRoot, generatedAtUtc, dataRootBasePath);
        var exportedPaths = new List<string>();
        var exportManifestEntries = new List<OverviewArtifactEntry>();
        var appPreviewBuilder = new StringBuilder();
        var modulePreviewBuilder = new StringBuilder();
        var exportedModuleCount = 0;
        var skippedMprMessages = new List<string>();

        foreach (var repositoryRelativeMprPath in mprPaths)
        {
            var dumpPath = CreateTempPath(".json");
            var headWorkspacePath = CreateTempDirectoryPath();
            var sourceMprPath = ResolveDisplayMprPath(repositoryRoot, repositoryRelativeMprPath);
            try
            {
                if (!TryWriteHeadMpr(repository, repositoryRelativeMprPath, headWorkspacePath, out var headMprPath))
                {
                    skippedMprMessages.Add(
                        $"Skipped '{Path.GetFileName(sourceMprPath)}' because the committed MPR could not be reconstructed.");
                    continue;
                }

                try
                {
                    MxToolService.DumpMpr(headMprPath, dumpPath);

                    var document = MendixModelOverviewParser.ParseDump(dumpPath, sourceMprPath, generatedAtUtc);
                    var mprToken = BuildMprToken(repositoryRelativeMprPath, mprPaths.Count > 1);
                    exportedModuleCount += WriteOverviewArtifacts(
                        document,
                        runFolder,
                        mprToken,
                        mode,
                        includeStructuredOutput,
                        includePseudocodeOutput,
                        exportedPaths,
                        exportManifestEntries,
                        appPreviewBuilder,
                        modulePreviewBuilder,
                        requestedModules);
                }
                catch (Exception exception) when (LooksLikeDumpEnvironmentIssue(exception))
                {
                    skippedMprMessages.Add(BuildMprSkipMessage(sourceMprPath, exception));
                }
            }
            finally
            {
                TryDeleteFile(dumpPath);
                TryDeleteDirectory(headWorkspacePath);
            }
        }

        if (requestedModules.Count > 0 && exportedModuleCount == 0)
        {
            TryDeleteDirectory(runFolder);
            if (skippedMprMessages.Count > 0)
            {
                return BuildFailure(skippedMprMessages[0], mode, selectedModule, selectedModules);
            }

            var requestedLabel = string.Join(", ", requestedModules.OrderBy(module => module, StringComparer.OrdinalIgnoreCase));
            return BuildFailure(
                $"Selected module(s) were not found in the committed model: {requestedLabel}.",
                mode,
                selectedModule,
                selectedModules);
        }

        if (exportedPaths.Count == 0)
        {
            TryDeleteDirectory(runFolder);
            if (skippedMprMessages.Count > 0)
            {
                return BuildFailure(skippedMprMessages[0], mode, selectedModule, selectedModules);
            }

            return BuildFailure("No overview artifacts were generated.", mode, selectedModule, selectedModules);
        }

        WriteManifest(
            runFolder,
            generatedAtUtc,
            mode,
            requestedModules,
            includeStructuredOutput,
            includePseudocodeOutput,
            exportManifestEntries,
            exportedPaths);

        var previewText = BuildPreviewText(
            mode,
            appPreviewBuilder,
            modulePreviewBuilder,
            runFolder,
            exportedPaths.Count,
            requestedModules);

        var selectedModuleList = requestedModules.OrderBy(module => module, StringComparer.OrdinalIgnoreCase).ToArray();
        var selectedModuleText = selectedModuleList.Length == 0
            ? string.Empty
            : $" Selected modules: {string.Join(", ", selectedModuleList)}.";

        var message = $"Model overview exported to {runFolder}. Files: {exportedPaths.Count}.{selectedModuleText}";
        if (skippedMprMessages.Count > 0)
        {
            message = $"{message} Skipped {skippedMprMessages.Count} .mpr file(s) due to dump issues.";
        }

        return new ModelOverviewGenerationResult(
            Success: true,
            Message: message,
            OverviewText: previewText,
            ChangedFileCount: payload.Changes.Count,
            ChangedModelFileCount: payload.Changes.Count(
                change => change.FilePath.EndsWith(".mpr", StringComparison.OrdinalIgnoreCase)),
            MprFileCount: mprPaths.Count,
            OutputFolderPath: runFolder,
            OutputPaths: exportedPaths,
            Mode: mode.ToString(),
            GeneratedAtUtc: generatedAtUtc,
            SelectedModule: selectedModuleList.Length == 1 ? selectedModuleList[0] : null,
            SelectedModules: selectedModuleList);
    }

    public static ModelOverviewModuleListResult ListOverviewModules(string projectPath)
    {
        var payload = AutoCommitMessageChangeService.ReadChanges(projectPath);
        if (!payload.IsGitRepo)
        {
            return BuildModuleListFailure("Current project is not a Git repository.");
        }

        if (!string.IsNullOrWhiteSpace(payload.Error))
        {
            return BuildModuleListFailure(payload.Error);
        }

        var discoveredPath = Repository.Discover(projectPath);
        if (string.IsNullOrWhiteSpace(discoveredPath))
        {
            return BuildModuleListFailure("Could not resolve repository root.");
        }

        using var repository = new Repository(discoveredPath);
        var repositoryRoot = repository.Info.WorkingDirectory;
        if (repository.Head?.Tip is null)
        {
            return BuildModuleListFailure("No committed revision (HEAD) is available.");
        }

        var mprPaths = ResolveHeadMprPaths(repository);
        if (mprPaths.Count == 0)
        {
            return BuildModuleListFailure("No committed .mpr files were found in the repository.");
        }

        var appName = ResolveAppName(repositoryRoot);
        var generatedAtUtc = DateTimeOffset.UtcNow;
        var moduleMap = new Dictionary<string, ModelOverviewModuleReference>(StringComparer.OrdinalIgnoreCase);
        var skippedMprMessages = new List<string>();

        foreach (var repositoryRelativeMprPath in mprPaths)
        {
            var dumpPath = CreateTempPath(".json");
            var headWorkspacePath = CreateTempDirectoryPath();
            var sourceMprPath = ResolveDisplayMprPath(repositoryRoot, repositoryRelativeMprPath);

            try
            {
                if (!TryWriteHeadMpr(repository, repositoryRelativeMprPath, headWorkspacePath, out var headMprPath))
                {
                    skippedMprMessages.Add(
                        $"Skipped '{Path.GetFileName(sourceMprPath)}' because the committed MPR could not be reconstructed.");
                    continue;
                }

                try
                {
                    MxToolService.DumpMpr(headMprPath, dumpPath);
                    var modules = ReadProjectModuleReferencesFromDump(dumpPath, sourceMprPath, appName);
                    foreach (var module in modules)
                    {
                        var key = $"{module.SourceMprPath}|{module.Name}";
                        if (!moduleMap.ContainsKey(key))
                        {
                            moduleMap[key] = module;
                        }
                    }
                }
                catch (Exception exception) when (LooksLikeDumpEnvironmentIssue(exception))
                {
                    skippedMprMessages.Add(BuildMprSkipMessage(sourceMprPath, exception));
                }
            }
            finally
            {
                TryDeleteFile(dumpPath);
                TryDeleteDirectory(headWorkspacePath);
            }
        }
        var modulesResult = moduleMap.Values
            .OrderBy(module => GetModuleCategorySortOrder(module.Category))
            .ThenBy(module => module.Name, StringComparer.OrdinalIgnoreCase)
            .ThenBy(module => module.SourceMprPath, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        if (modulesResult.Length == 0 && skippedMprMessages.Count > 0)
        {
            return BuildModuleListFailure(skippedMprMessages[0]);
        }

        var message = $"Loaded {modulesResult.Length} module(s).";
        if (skippedMprMessages.Count > 0)
        {
            message = $"{message} Skipped {skippedMprMessages.Count} .mpr file(s) due to dump issues.";
        }

        return new ModelOverviewModuleListResult(
            Success: true,
            Message: message,
            MprFileCount: mprPaths.Count,
            AppName: appName,
            Modules: modulesResult,
            GeneratedAtUtc: generatedAtUtc);
    }

    private static string BuildPreviewText(
        ModelOverviewGenerationMode mode,
        StringBuilder appPreviewBuilder,
        StringBuilder modulePreviewBuilder,
        string runFolder,
        int outputCount,
        IReadOnlyCollection<string> selectedModules)
    {
        var builder = new StringBuilder();
        builder.AppendLine("# Model Overview Export");
        builder.AppendLine($"Mode: {mode}");
        if (selectedModules.Count > 0)
        {
            var selectedLabel = string.Join(", ", selectedModules.OrderBy(module => module, StringComparer.OrdinalIgnoreCase));
            builder.AppendLine($"SelectedModules: {selectedLabel}");
        }

        builder.AppendLine($"OutputFolder: {runFolder}");
        builder.AppendLine($"ExportedFiles: {outputCount}");
        builder.AppendLine();

        if (mode is ModelOverviewGenerationMode.App or ModelOverviewGenerationMode.Both &&
            appPreviewBuilder.Length > 0)
        {
            builder.AppendLine("## App Overview (Preview)");
            builder.AppendLine(appPreviewBuilder.ToString().TrimEnd());
        }

        if (mode is ModelOverviewGenerationMode.Modules or ModelOverviewGenerationMode.Both &&
            modulePreviewBuilder.Length > 0)
        {
            if (builder.Length > 0)
            {
                builder.AppendLine();
            }

            builder.AppendLine("## Module Overview (Preview)");
            builder.AppendLine(modulePreviewBuilder.ToString().TrimEnd());
        }

        return builder.ToString().TrimEnd();
    }

    private static int WriteOverviewArtifacts(
        ModelOverviewDocument document,
        string runFolder,
        string mprToken,
        ModelOverviewGenerationMode mode,
        bool includeStructuredOutput,
        bool includePseudocodeOutput,
        ICollection<string> exportedPaths,
        ICollection<OverviewArtifactEntry> manifestEntries,
        StringBuilder appPreviewBuilder,
        StringBuilder modulePreviewBuilder,
        IReadOnlySet<string> selectedModules)
    {
        var tokenPrefix = string.IsNullOrWhiteSpace(mprToken) ? string.Empty : $"{mprToken}_";
        var exportedModuleCount = 0;

        if (mode is ModelOverviewGenerationMode.App or ModelOverviewGenerationMode.Both)
        {
            if (includeStructuredOutput)
            {
                var appJsonPath = Path.Combine(runFolder, $"{tokenPrefix}app-overview.json");
                File.WriteAllText(appJsonPath, JsonSerializer.Serialize(document, JsonOptions), new UTF8Encoding(false));
                exportedPaths.Add(appJsonPath);
                manifestEntries.Add(new OverviewArtifactEntry("app-json", appJsonPath));
            }

            if (includePseudocodeOutput)
            {
                var appPseudoPath = Path.Combine(runFolder, $"{tokenPrefix}app-overview.pseudo.txt");
                File.WriteAllText(appPseudoPath, document.AppPseudocode, new UTF8Encoding(false));
                exportedPaths.Add(appPseudoPath);
                manifestEntries.Add(new OverviewArtifactEntry("app-pseudocode", appPseudoPath));

                if (appPreviewBuilder.Length == 0)
                {
                    appPreviewBuilder.AppendLine(document.AppPseudocode);
                }
            }
        }

        if (mode is ModelOverviewGenerationMode.Modules or ModelOverviewGenerationMode.Both)
        {
            IReadOnlyList<OverviewModule> modulesToExport = selectedModules.Count == 0
                ? document.Modules
                : document.Modules
                    .Where(module => selectedModules.Contains(module.Module))
                    .ToArray();

            if (modulesToExport.Count == 0)
            {
                return exportedModuleCount;
            }

            var modulesFolderName = string.IsNullOrWhiteSpace(mprToken) ? "modules" : $"{mprToken}_modules";
            var modulesFolder = Path.Combine(runFolder, modulesFolderName);
            Directory.CreateDirectory(modulesFolder);

            var moduleIndexEntries = new List<object>();
            var previewCaptured = false;
            foreach (var module in modulesToExport)
            {
                var moduleToken = SanitizeToken(module.Module);
                string? moduleJsonPath = null;
                string? modulePseudoPath = null;
                if (includeStructuredOutput)
                {
                    moduleJsonPath = Path.Combine(modulesFolder, $"{moduleToken}.overview.json");
                    var moduleExport = new ModuleOverviewExport(
                        document.SchemaVersion,
                        document.GeneratedAtUtc,
                        document.SourceMprPath,
                        document.SourceDumpPath,
                        module,
                        document.FlowCallGraph
                            .Where(edge =>
                                string.Equals(edge.CallerModule, module.Module, StringComparison.OrdinalIgnoreCase) ||
                                string.Equals(edge.TargetModule, module.Module, StringComparison.OrdinalIgnoreCase))
                            .ToArray());
                    File.WriteAllText(moduleJsonPath, JsonSerializer.Serialize(moduleExport, JsonOptions), new UTF8Encoding(false));
                    exportedPaths.Add(moduleJsonPath);
                    manifestEntries.Add(new OverviewArtifactEntry("module-json", moduleJsonPath));
                }

                if (includePseudocodeOutput)
                {
                    var modulePseudoText = MendixModelOverviewParser.BuildModulePseudocode(module, document.FlowCallGraph);
                    modulePseudoPath = Path.Combine(modulesFolder, $"{moduleToken}.overview.pseudo.txt");
                    File.WriteAllText(modulePseudoPath, modulePseudoText, new UTF8Encoding(false));
                    exportedPaths.Add(modulePseudoPath);
                    manifestEntries.Add(new OverviewArtifactEntry("module-pseudocode", modulePseudoPath));

                    if (!previewCaptured)
                    {
                        modulePreviewBuilder.AppendLine(modulePseudoText);
                        previewCaptured = true;
                    }
                }

                moduleIndexEntries.Add(new
                {
                    module = module.Module,
                    jsonPath = moduleJsonPath ?? string.Empty,
                    pseudocodePath = modulePseudoPath ?? string.Empty,
                });

                exportedModuleCount++;
            }

            if (includeStructuredOutput)
            {
                var moduleIndexPath = Path.Combine(modulesFolder, "modules.index.json");
                File.WriteAllText(moduleIndexPath, JsonSerializer.Serialize(moduleIndexEntries, JsonOptions), new UTF8Encoding(false));
                exportedPaths.Add(moduleIndexPath);
                manifestEntries.Add(new OverviewArtifactEntry("module-index", moduleIndexPath));
            }
        }

        return exportedModuleCount;
    }

    private static void WriteManifest(
        string runFolder,
        DateTimeOffset generatedAtUtc,
        ModelOverviewGenerationMode mode,
        IReadOnlyCollection<string> selectedModules,
        bool includeStructuredOutput,
        bool includePseudocodeOutput,
        IReadOnlyCollection<OverviewArtifactEntry> manifestEntries,
        IReadOnlyCollection<string> exportedPaths)
    {
        var manifestPath = Path.Combine(runFolder, "manifest.json");
        var manifest = new
        {
            schemaVersion = "1.0",
            generatedAtUtc = generatedAtUtc.ToString("O"),
            mode = mode.ToString(),
            selectedModules = selectedModules
                .OrderBy(module => module, StringComparer.OrdinalIgnoreCase)
                .ToArray(),
            includeStructuredOutput,
            includePseudocodeOutput,
            artifactCount = exportedPaths.Count,
            artifacts = manifestEntries,
        };

        File.WriteAllText(manifestPath, JsonSerializer.Serialize(manifest, JsonOptions), new UTF8Encoding(false));
    }

    private static string BuildMprToken(string mprPath, bool includePrefix)
    {
        if (!includePrefix)
        {
            return string.Empty;
        }

        var mprFileName = Path.GetFileNameWithoutExtension(mprPath);
        return SanitizeToken(string.IsNullOrWhiteSpace(mprFileName) ? "app" : mprFileName);
    }

    private static string CreateOverviewRunFolder(
        string repositoryRoot,
        DateTimeOffset generatedAtUtc,
        string? dataRootBasePath)
    {
        var overviewsFolder = Path.Combine(
            ExtensionDataPaths.GetStructuredFolder(repositoryRoot, dataRootBasePath),
            OverviewFolderName);
        Directory.CreateDirectory(overviewsFolder);

        var repositoryToken = SanitizeToken(Path.GetFileName(repositoryRoot));
        var timestamp = generatedAtUtc.ToString("yyyy-MM-ddTHH-mm-ss.fffZ");
        var runFolder = Path.Combine(overviewsFolder, $"{timestamp}_{repositoryToken}_{Guid.NewGuid():N}");
        Directory.CreateDirectory(runFolder);
        return runFolder;
    }
    private static IReadOnlyList<string> ResolveHeadMprPaths(Repository repository)
    {
        var headCommit = repository.Head?.Tip;
        if (headCommit is null)
        {
            return Array.Empty<string>();
        }

        var files = new List<string>();
        CollectHeadMprPaths(headCommit.Tree, string.Empty, files);
        return files
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(path => path, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static void CollectHeadMprPaths(Tree tree, string currentPath, ICollection<string> files)
    {
        foreach (var entry in tree)
        {
            var relativePath = string.IsNullOrWhiteSpace(currentPath)
                ? entry.Name
                : $"{currentPath}/{entry.Name}";

            if (entry.TargetType == TreeEntryTargetType.Blob &&
                entry.Name.EndsWith(".mpr", StringComparison.OrdinalIgnoreCase))
            {
                files.Add(relativePath);
                continue;
            }

            if (entry.TargetType != TreeEntryTargetType.Tree || ShouldSkipDirectory(entry.Name))
            {
                continue;
            }

            if (entry.Target is Tree childTree)
            {
                CollectHeadMprPaths(childTree, relativePath, files);
            }
        }
    }

    private static bool TryWriteHeadMpr(
        Repository repository,
        string repositoryRelativeMprPath,
        string headWorkspacePath,
        out string headMprPath)
    {
        headMprPath = string.Empty;

        var headCommit = repository.Head?.Tip;
        if (headCommit is null)
        {
            return false;
        }

        var treeEntry = headCommit[repositoryRelativeMprPath];
        if (treeEntry?.Target is not Blob headBlob)
        {
            return false;
        }

        Directory.CreateDirectory(headWorkspacePath);
        TryCopyMprContentsFromHeadCommit(headCommit, repositoryRelativeMprPath, headWorkspacePath);

        var mprFileName = Path.GetFileName(repositoryRelativeMprPath);
        if (string.IsNullOrWhiteSpace(mprFileName))
        {
            mprFileName = "App.mpr";
        }

        headMprPath = Path.Combine(headWorkspacePath, mprFileName);
        using var outputStream = File.Create(headMprPath);
        using var blobStream = headBlob.GetContentStream();
        blobStream.CopyTo(outputStream);
        return true;
    }

    private static bool TryCopyMprContentsFromHeadCommit(
        Commit headCommit,
        string repositoryRelativeMprPath,
        string headWorkspacePath)
    {
        var mprDirectoryPath = Path.GetDirectoryName(repositoryRelativeMprPath)?.Replace('\\', '/');
        var normalizedMprDirectory = string.IsNullOrWhiteSpace(mprDirectoryPath) ||
                                     string.Equals(mprDirectoryPath, ".", StringComparison.Ordinal)
            ? string.Empty
            : mprDirectoryPath.TrimEnd('/');

        var mprContentsPath = string.IsNullOrWhiteSpace(normalizedMprDirectory)
            ? "mprcontents"
            : $"{normalizedMprDirectory}/mprcontents";

        var mprContentsEntry = headCommit[mprContentsPath];
        if (mprContentsEntry?.Target is not Tree mprContentsTree)
        {
            return false;
        }

        var destinationRoot = Path.Combine(headWorkspacePath, "mprcontents");
        CopyTreeToDirectory(mprContentsTree, destinationRoot);
        return true;
    }

    private static void CopyTreeToDirectory(Tree tree, string destinationPath)
    {
        Directory.CreateDirectory(destinationPath);

        foreach (var entry in tree)
        {
            var targetPath = Path.Combine(destinationPath, entry.Name);
            switch (entry.TargetType)
            {
                case TreeEntryTargetType.Blob when entry.Target is Blob blob:
                {
                    var targetDirectory = Path.GetDirectoryName(targetPath);
                    if (!string.IsNullOrWhiteSpace(targetDirectory))
                    {
                        Directory.CreateDirectory(targetDirectory);
                    }

                    using var output = File.Create(targetPath);
                    using var input = blob.GetContentStream();
                    input.CopyTo(output);
                    break;
                }

                case TreeEntryTargetType.Tree when entry.Target is Tree childTree:
                    CopyTreeToDirectory(childTree, targetPath);
                    break;
            }
        }
    }

    private static IReadOnlyList<ModelOverviewModuleReference> ReadProjectModuleReferencesFromDump(
        string dumpPath,
        string sourceMprPath,
        string appName)
    {
        using var stream = File.OpenRead(dumpPath);
        using var document = JsonDocument.Parse(stream);
        if (!document.RootElement.TryGetProperty("units", out var units) ||
            units.ValueKind != JsonValueKind.Array)
        {
            return Array.Empty<ModelOverviewModuleReference>();
        }

        var modules = new List<ModelOverviewModuleReference>();
        foreach (var unit in units.EnumerateArray())
        {
            if (!TryReadStringProperty(unit, "$Type", out var modelType) ||
                !string.Equals(modelType, "Projects$Module", StringComparison.Ordinal))
            {
                continue;
            }

            if (!TryReadStringProperty(unit, "name", out var moduleName))
            {
                continue;
            }

            var fromAppStore = TryReadBoolProperty(unit, "fromAppStore", out var value) && value;
            var category = ResolveModuleCategory(moduleName, fromAppStore);
            modules.Add(new ModelOverviewModuleReference(moduleName, sourceMprPath, category, appName));
        }

        return modules
            .OrderBy(module => GetModuleCategorySortOrder(module.Category))
            .ThenBy(module => module.Name, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }
    private static string ResolveDisplayMprPath(string repositoryRoot, string repositoryRelativeMprPath)
    {
        var normalizedRelativePath = repositoryRelativeMprPath.Replace('/', Path.DirectorySeparatorChar);
        return Path.Combine(repositoryRoot, normalizedRelativePath);
    }

    private static string ResolveAppName(string repositoryRoot)
    {
        var trimmedRoot = repositoryRoot.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
        var candidate = Path.GetFileName(trimmedRoot);
        return string.IsNullOrWhiteSpace(candidate) ? "Application" : candidate;
    }

    private static int GetModuleCategorySortOrder(string? category)
    {
        if (string.Equals(category, ModuleCategorySystem, StringComparison.OrdinalIgnoreCase))
        {
            return 0;
        }

        if (string.Equals(category, ModuleCategoryMarketplace, StringComparison.OrdinalIgnoreCase))
        {
            return 1;
        }

        return 2;
    }

    private static string ResolveModuleCategory(string moduleName, bool fromAppStore)
    {
        if (string.Equals(moduleName, "System", StringComparison.OrdinalIgnoreCase))
        {
            return ModuleCategorySystem;
        }

        return fromAppStore ? ModuleCategoryMarketplace : ModuleCategoryCustom;
    }

    private static bool TryReadStringProperty(JsonElement element, string propertyName, out string value)
    {
        value = string.Empty;
        if (element.ValueKind != JsonValueKind.Object ||
            !element.TryGetProperty(propertyName, out var propertyValue) ||
            propertyValue.ValueKind != JsonValueKind.String)
        {
            return false;
        }

        var candidate = propertyValue.GetString();
        if (string.IsNullOrWhiteSpace(candidate))
        {
            return false;
        }

        value = candidate.Trim();
        return value.Length > 0;
    }

    private static bool TryReadBoolProperty(JsonElement element, string propertyName, out bool value)
    {
        value = false;
        if (element.ValueKind != JsonValueKind.Object ||
            !element.TryGetProperty(propertyName, out var propertyValue) ||
            propertyValue.ValueKind != JsonValueKind.True &&
            propertyValue.ValueKind != JsonValueKind.False)
        {
            return false;
        }

        value = propertyValue.GetBoolean();
        return true;
    }

    private static IReadOnlySet<string> NormalizeRequestedModules(
        string? selectedModule,
        IReadOnlyList<string>? selectedModules)
    {
        var normalized = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        AddNormalizedModuleName(normalized, selectedModule);
        if (selectedModules is not null)
        {
            foreach (var module in selectedModules)
            {
                AddNormalizedModuleName(normalized, module);
            }
        }

        return normalized;
    }

    private static void AddNormalizedModuleName(ISet<string> target, string? moduleName)
    {
        if (string.IsNullOrWhiteSpace(moduleName))
        {
            return;
        }

        var trimmed = moduleName.Trim();
        if (trimmed.Length > 0)
        {
            target.Add(trimmed);
        }
    }

    private static bool ShouldSkipDirectory(string? directoryName)
    {
        if (string.IsNullOrWhiteSpace(directoryName))
        {
            return true;
        }

        return string.Equals(directoryName, ".git", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(directoryName, ".mendix-cache", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(directoryName, "node_modules", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(directoryName, "bin", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(directoryName, "obj", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(directoryName, ".idea", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(directoryName, ".vs", StringComparison.OrdinalIgnoreCase);
    }

    private static string CreateTempPath(string extension) =>
        Path.Combine(Path.GetTempPath(), $"autocommitmessage_overview_{Guid.NewGuid():N}{extension}");

    private static string CreateTempDirectoryPath() =>
        Path.Combine(Path.GetTempPath(), $"autocommitmessage_overview_mpr_{Guid.NewGuid():N}");

    private static void TryDeleteFile(string path)
    {
        try
        {
            if (!string.IsNullOrWhiteSpace(path) && File.Exists(path))
            {
                File.Delete(path);
            }
        }
        catch
        {
            // Ignore temporary cleanup failures.
        }
    }

    private static void TryDeleteDirectory(string path)
    {
        try
        {
            if (!string.IsNullOrWhiteSpace(path) && Directory.Exists(path))
            {
                Directory.Delete(path, recursive: true);
            }
        }
        catch
        {
            // Ignore temporary cleanup failures.
        }
    }

    private static bool LooksLikeDumpEnvironmentIssue(Exception exception)
    {
        var message = exception.Message;
        var missingContents =
            message.IndexOf("mprcontents", StringComparison.OrdinalIgnoreCase) >= 0 &&
            message.IndexOf("Could not find a part of the path", StringComparison.OrdinalIgnoreCase) >= 0;
        var mismatchedMprName =
            message.IndexOf("Cannot open MPR file", StringComparison.OrdinalIgnoreCase) >= 0 &&
            message.IndexOf("refer to MPR file", StringComparison.OrdinalIgnoreCase) >= 0;
        var exportJsonFailure =
            message.IndexOf("Exception during exporting the model to JSON", StringComparison.OrdinalIgnoreCase) >= 0;

        return missingContents || mismatchedMprName || exportJsonFailure;
    }

    private static string BuildMprSkipMessage(string mprPath, Exception exception)
    {
        var mprName = Path.GetFileName(mprPath);
        return $"Skipped '{mprName}' due to dump error: {exception.Message}";
    }

    private static string SanitizeToken(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return "overview";
        }

        var invalidChars = Path.GetInvalidFileNameChars();
        var builder = new StringBuilder(value.Length);
        foreach (var character in value.Trim())
        {
            builder.Append(invalidChars.Contains(character) ? '_' : character);
        }

        return builder.Length == 0 ? "overview" : builder.ToString();
    }

    private static ModelOverviewGenerationResult BuildFailure(
        string? message,
        ModelOverviewGenerationMode mode,
        string? selectedModule = null,
        IReadOnlyList<string>? selectedModules = null)
    {
        var normalizedModules = NormalizeRequestedModules(selectedModule, selectedModules)
            .OrderBy(module => module, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        return new ModelOverviewGenerationResult(
            Success: false,
            Message: string.IsNullOrWhiteSpace(message) ? "Overview generation failed." : message,
            OverviewText: null,
            ChangedFileCount: 0,
            ChangedModelFileCount: 0,
            MprFileCount: 0,
            OutputFolderPath: null,
            OutputPaths: Array.Empty<string>(),
            Mode: mode.ToString(),
            GeneratedAtUtc: DateTimeOffset.UtcNow,
            SelectedModule: normalizedModules.Length == 1 ? normalizedModules[0] : null,
            SelectedModules: normalizedModules);
    }

    private static ModelOverviewModuleListResult BuildModuleListFailure(string? message) =>
        new(
            Success: false,
            Message: string.IsNullOrWhiteSpace(message) ? "Module list loading failed." : message,
            MprFileCount: 0,
            AppName: "Application",
            Modules: Array.Empty<ModelOverviewModuleReference>(),
            GeneratedAtUtc: DateTimeOffset.UtcNow);

    private sealed record OverviewArtifactEntry(string Type, string Path);

    private sealed record ModuleOverviewExport(
        string SchemaVersion,
        DateTimeOffset GeneratedAtUtc,
        string SourceMprPath,
        string SourceDumpPath,
        OverviewModule Module,
        IReadOnlyList<OverviewCallEdge> CallEdges);
}

public sealed record ModelOverviewGenerationResult(
    bool Success,
    string Message,
    string? OverviewText,
    int ChangedFileCount,
    int ChangedModelFileCount,
    int MprFileCount,
    string? OutputFolderPath,
    IReadOnlyList<string> OutputPaths,
    string Mode,
    DateTimeOffset GeneratedAtUtc,
    string? SelectedModule,
    IReadOnlyList<string> SelectedModules);

public sealed record ModelOverviewModuleListResult(
    bool Success,
    string Message,
    int MprFileCount,
    string AppName,
    IReadOnlyList<ModelOverviewModuleReference> Modules,
    DateTimeOffset GeneratedAtUtc);

public sealed record ModelOverviewModuleReference(
    string Name,
    string SourceMprPath,
    string Category,
    string AppName);
