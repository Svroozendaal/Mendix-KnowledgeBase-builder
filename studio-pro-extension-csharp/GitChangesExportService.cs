using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using LibGit2Sharp;

namespace AutoCommitMessage;

internal static class GitChangesExportService
{
    private const string ExportFileTimestampFormat = "yyyy-MM-ddTHH-mm-ss.fffZ";
    private const string UnknownUserName = "Unknown";
    private const string UnknownUserEmail = "unknown@example.com";
    private const string SchemaVersion = "1.0";

    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = true,
    };

    public static string ExportChanges(GitChangesPayload payload, string projectPath)
    {
        ArgumentNullException.ThrowIfNull(payload);

        if (!payload.IsGitRepo)
        {
            throw new InvalidOperationException("Current project is not a Git repository.");
        }

        if (!string.IsNullOrWhiteSpace(payload.Error))
        {
            throw new InvalidOperationException($"Cannot export changes: {payload.Error}");
        }

        if (payload.Changes.Count == 0)
        {
            throw new InvalidOperationException("No uncommitted changes to export.");
        }

        var discoveredRepositoryPath = Repository.Discover(projectPath);
        if (string.IsNullOrWhiteSpace(discoveredRepositoryPath))
        {
            throw new InvalidOperationException("Could not resolve the Git repository path.");
        }

        using var repository = new Repository(discoveredRepositoryPath);

        var projectName = ResolveProjectName(projectPath, repository.Info.WorkingDirectory);
        var branchName = ResolveBranchName(payload, repository);
        var userName = ResolveGitConfigValue(repository, "user.name", UnknownUserName);
        var userEmail = ResolveGitConfigValue(repository, "user.email", UnknownUserEmail);
        var timestampUtc = DateTimeOffset.UtcNow;

        var exportPayload = new ExportPayload(
            SchemaVersion,
            timestampUtc.ToString("O"),
            projectName,
            branchName,
            userName,
            userEmail,
            payload.Changes.Select(BuildExportFileChange).ToArray());

        EnsureFoldersExist();

        var timestampToken = timestampUtc.ToString(ExportFileTimestampFormat);
        var projectToken = SanitizeFileToken(projectName);
        var fileName = $"{timestampToken}_{projectToken}.json";
        var destinationPath = BuildUniqueDestinationPath(ExtensionDataPaths.ExportFolder, fileName);
        var tempPath = Path.Combine(
            ExtensionDataPaths.ExportFolder,
            $"{Path.GetFileNameWithoutExtension(fileName)}_{Guid.NewGuid():N}.tmp");

        try
        {
            var json = JsonSerializer.Serialize(exportPayload, SerializerOptions);
            File.WriteAllText(tempPath, json, new UTF8Encoding(false));
            File.Move(tempPath, destinationPath);
            return destinationPath;
        }
        finally
        {
            TryDeleteTempFile(tempPath);
        }
    }

    private static void EnsureFoldersExist()
    {
        Directory.CreateDirectory(ExtensionDataPaths.ExportFolder);
        Directory.CreateDirectory(ExtensionDataPaths.ProcessedFolder);
        Directory.CreateDirectory(ExtensionDataPaths.ErrorsFolder);
        Directory.CreateDirectory(ExtensionDataPaths.StructuredFolder);
        Directory.CreateDirectory(ExtensionDataPaths.DumpsFolder);
    }

    private static ExportFileChange BuildExportFileChange(GitFileChange change)
    {
        IReadOnlyList<MendixModuleChangeGroup>? groupedModelChanges = change.ModelChangesByModule;
        if ((groupedModelChanges is null || groupedModelChanges.Count == 0) &&
            change.ModelChanges is { Count: > 0 })
        {
            groupedModelChanges = MendixModelChangeStructurer.GroupByModule(change.ModelChanges);
        }

        var exportGroupedModelChanges = groupedModelChanges is null || groupedModelChanges.Count == 0
            ? null
            : groupedModelChanges
                .Select(moduleGroup => new ExportModuleChangeGroup(
                    moduleGroup.Module,
                    ToExportModelChanges(moduleGroup.DomainModel),
                    ToExportModelChanges(moduleGroup.Microflows),
                    ToExportModelChanges(moduleGroup.Pages),
                    ToExportModelChanges(moduleGroup.Nanoflows),
                    ToExportModelChanges(moduleGroup.Resources)))
                .ToArray();

        var exportDumpArtifact = change.ModelDumpArtifact is null
            ? null
            : new ExportModelDumpArtifact(
                change.ModelDumpArtifact.FolderPath,
                change.ModelDumpArtifact.WorkingDumpPath,
                change.ModelDumpArtifact.HeadDumpPath);

        return new ExportFileChange(
            change.FilePath,
            change.Status,
            change.IsStaged,
            change.DiffText,
            exportGroupedModelChanges,
            exportDumpArtifact);
    }

    private static ExportModelChange[] ToExportModelChanges(IReadOnlyList<MendixModelChange>? modelChanges)
    {
        if (modelChanges is null || modelChanges.Count == 0)
        {
            return Array.Empty<ExportModelChange>();
        }

        return modelChanges
            .Select(modelChange => new ExportModelChange(
                modelChange.ChangeType,
                modelChange.ElementType,
                modelChange.ElementName,
                modelChange.Details))
            .ToArray();
    }

    private static string ResolveProjectName(string projectPath, string repositoryRoot)
    {
        if (!string.IsNullOrWhiteSpace(projectPath))
        {
            var normalizedProjectPath = Path.GetFullPath(projectPath);
            if (Directory.Exists(normalizedProjectPath))
            {
                var directoryName = new DirectoryInfo(normalizedProjectPath).Name;
                if (!string.IsNullOrWhiteSpace(directoryName))
                {
                    return directoryName;
                }
            }
        }

        var normalizedRepositoryRoot = Path.GetFullPath(repositoryRoot);
        return new DirectoryInfo(normalizedRepositoryRoot).Name;
    }

    private static string ResolveBranchName(GitChangesPayload payload, Repository repository)
    {
        if (!string.IsNullOrWhiteSpace(payload.BranchName))
        {
            return payload.BranchName;
        }

        return repository.Head?.FriendlyName ?? string.Empty;
    }

    private static string ResolveGitConfigValue(Repository repository, string key, string fallback)
    {
        var entry = repository.Config.Get<string>(key);
        if (!string.IsNullOrWhiteSpace(entry?.Value))
        {
            return entry.Value;
        }

        return fallback;
    }

    private static string SanitizeFileToken(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return "project";
        }

        var invalidCharacters = Path.GetInvalidFileNameChars();
        var sanitized = new StringBuilder(value.Length);
        foreach (var character in value.Trim())
        {
            if (invalidCharacters.Contains(character))
            {
                sanitized.Append('_');
            }
            else
            {
                sanitized.Append(character);
            }
        }

        return sanitized.Length == 0 ? "project" : sanitized.ToString();
    }

    private static string BuildUniqueDestinationPath(string folderPath, string fileName)
    {
        var destinationPath = Path.Combine(folderPath, fileName);
        if (!File.Exists(destinationPath))
        {
            return destinationPath;
        }

        var stem = Path.GetFileNameWithoutExtension(fileName);
        var extension = Path.GetExtension(fileName);
        var suffix = DateTimeOffset.UtcNow.ToString("yyyyMMddHHmmssfff");
        return Path.Combine(folderPath, $"{stem}_{suffix}{extension}");
    }

    private static void TryDeleteTempFile(string tempPath)
    {
        try
        {
            if (!string.IsNullOrWhiteSpace(tempPath) && File.Exists(tempPath))
            {
                File.Delete(tempPath);
            }
        }
        catch
        {
            // Ignore temp cleanup failures.
        }
    }

    private sealed record ExportPayload(
        [property: JsonPropertyName("schemaVersion")] string SchemaVersion,
        [property: JsonPropertyName("timestamp")] string Timestamp,
        [property: JsonPropertyName("projectName")] string ProjectName,
        [property: JsonPropertyName("branchName")] string BranchName,
        [property: JsonPropertyName("userName")] string UserName,
        [property: JsonPropertyName("userEmail")] string UserEmail,
        [property: JsonPropertyName("changes")] ExportFileChange[] Changes);

    private sealed record ExportFileChange(
        [property: JsonPropertyName("filePath")] string FilePath,
        [property: JsonPropertyName("status")] string Status,
        [property: JsonPropertyName("isStaged")] bool IsStaged,
        [property: JsonPropertyName("diffText")] string DiffText,
        [property: JsonPropertyName("modelChangesByModule")] ExportModuleChangeGroup[]? ModelChangesByModule = null,
        [property: JsonPropertyName("modelDumpArtifact")] ExportModelDumpArtifact? ModelDumpArtifact = null);

    private sealed record ExportModuleChangeGroup(
        [property: JsonPropertyName("module")] string Module,
        [property: JsonPropertyName("domainModel")] ExportModelChange[] DomainModel,
        [property: JsonPropertyName("microflows")] ExportModelChange[] Microflows,
        [property: JsonPropertyName("pages")] ExportModelChange[] Pages,
        [property: JsonPropertyName("nanoflows")] ExportModelChange[] Nanoflows,
        [property: JsonPropertyName("resources")] ExportModelChange[] Resources);

    private sealed record ExportModelChange(
        [property: JsonPropertyName("changeType")] string ChangeType,
        [property: JsonPropertyName("elementType")] string ElementType,
        [property: JsonPropertyName("elementName")] string ElementName,
        [property: JsonPropertyName("details")] string? Details = null);

    private sealed record ExportModelDumpArtifact(
        [property: JsonPropertyName("folderPath")] string FolderPath,
        [property: JsonPropertyName("workingDumpPath")] string WorkingDumpPath,
        [property: JsonPropertyName("headDumpPath")] string HeadDumpPath);
}
