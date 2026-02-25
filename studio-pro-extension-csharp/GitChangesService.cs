using System.Text;
using LibGit2Sharp;

namespace AutoCommitMessage;

/// <summary>
/// Reads uncommitted Git changes for Mendix project files.
/// </summary>
public static class GitChangesService
{
    private static readonly string[] FilteredPathSpec = { "*.mpr", "*.mprops" };

    private const string StatusModified = "Modified";
    private const string StatusAdded = "Added";
    private const string StatusDeleted = "Deleted";
    private const string StatusRenamed = "Renamed";

    private const string BinaryDiffMessage = "Binary file changed - diff not available";
    private const string DiffUnavailableMessage = "Diff unavailable";

    /// <summary>
    /// Reads the current repository status and diff data for supported Mendix files.
    /// </summary>
    /// <param name="projectPath">The path to the project root.</param>
    /// <returns>A payload containing repository state, change items, and optional errors.</returns>
    public static GitChangesPayload ReadChanges(string projectPath, bool persistModelDumps = false)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(projectPath))
            {
                return new GitChangesPayload
                {
                    IsGitRepo = false,
                    BranchName = string.Empty,
                    Changes = Array.Empty<GitFileChange>(),
                    Error = "Project path is empty.",
                };
            }

            var discoveredPath = Repository.Discover(projectPath);
            if (string.IsNullOrWhiteSpace(discoveredPath))
            {
                return new GitChangesPayload
                {
                    IsGitRepo = false,
                    BranchName = string.Empty,
                    Changes = Array.Empty<GitFileChange>(),
                    Error = null,
                };
            }

            using var repository = new Repository(discoveredPath);
            var repositoryRoot = repository.Info.WorkingDirectory;

            var statusOptions = new StatusOptions
            {
                IncludeIgnored = false,
                IncludeUntracked = true,
                RecurseUntrackedDirs = true,
                PathSpec = FilteredPathSpec,
            };

            var statusEntries = repository.RetrieveStatus(statusOptions);
            var patch = repository.Diff.Compare<Patch>(FilteredPathSpec, includeUntracked: true);

            var changes = new List<GitFileChange>();
            foreach (var entry in statusEntries)
            {
                if (entry.State == FileStatus.Unaltered || entry.State == FileStatus.Ignored)
                {
                    continue;
                }

                var fileChange = new GitFileChange
                {
                    FilePath = entry.FilePath,
                    Status = DetermineStatus(entry.State),
                    IsStaged = IsStaged(entry.State),
                    DiffText = GetDiffText(entry.FilePath, patch),
                };

                if (entry.FilePath.EndsWith(".mpr", StringComparison.OrdinalIgnoreCase))
                {
                    try
                    {
                        var modelAnalysis = AnalyzeMprChanges(
                            repository,
                            repositoryRoot,
                            NormalizeRepositoryPath(entry.FilePath),
                            persistModelDumps);

                        fileChange = fileChange with
                        {
                            ModelChanges = modelAnalysis.ModelChanges,
                            ModelChangesByModule = MendixModelChangeStructurer.GroupByModule(modelAnalysis.ModelChanges),
                            ModelDumpArtifact = modelAnalysis.ModelDumpArtifact,
                        };
                    }
                    catch (Exception exception)
                    {
                        var analysisUnavailableChanges = new List<MendixModelChange>
                        {
                            new(
                                "Modified",
                                "Model Analysis",
                                Path.GetFileName(entry.FilePath),
                                $"Model analysis unavailable: {exception.Message}"),
                        };

                        fileChange = fileChange with
                        {
                            ModelChanges = analysisUnavailableChanges,
                            ModelChangesByModule =
                                MendixModelChangeStructurer.GroupByModule(analysisUnavailableChanges),
                        };
                    }
                }

                changes.Add(fileChange);
            }

            return new GitChangesPayload
            {
                IsGitRepo = true,
                BranchName = repository.Head?.FriendlyName ?? string.Empty,
                Changes = changes,
                Error = null,
            };
        }
        catch (RepositoryNotFoundException)
        {
            return new GitChangesPayload
            {
                IsGitRepo = false,
                BranchName = string.Empty,
                Changes = Array.Empty<GitFileChange>(),
                Error = null,
            };
        }
        catch (Exception exception)
        {
            return new GitChangesPayload
            {
                IsGitRepo = true,
                BranchName = string.Empty,
                Changes = Array.Empty<GitFileChange>(),
                Error = exception.Message,
            };
        }
    }

    private static string DetermineStatus(FileStatus status)
    {
        if ((status & (FileStatus.RenamedInIndex | FileStatus.RenamedInWorkdir)) != 0)
        {
            return StatusRenamed;
        }

        if ((status & (FileStatus.DeletedFromIndex | FileStatus.DeletedFromWorkdir)) != 0)
        {
            return StatusDeleted;
        }

        if ((status & (FileStatus.NewInIndex | FileStatus.NewInWorkdir)) != 0)
        {
            return StatusAdded;
        }

        return StatusModified;
    }

    private static bool IsStaged(FileStatus status)
    {
        const FileStatus stagedMask =
            FileStatus.NewInIndex |
            FileStatus.ModifiedInIndex |
            FileStatus.DeletedFromIndex |
            FileStatus.RenamedInIndex |
            FileStatus.TypeChangeInIndex;

        return (status & stagedMask) != 0;
    }

    private static string GetDiffText(string filePath, Patch patch)
    {
        try
        {
            var patchEntry = patch[filePath];
            if (patchEntry is null)
            {
                return DiffUnavailableMessage;
            }

            if (patchEntry.IsBinaryComparison || filePath.EndsWith(".mpr", StringComparison.OrdinalIgnoreCase))
            {
                return BinaryDiffMessage;
            }

            return string.IsNullOrWhiteSpace(patchEntry.Patch)
                ? DiffUnavailableMessage
                : patchEntry.Patch;
        }
        catch
        {
            return DiffUnavailableMessage;
        }
    }

    private static ModelAnalysisResult AnalyzeMprChanges(
        Repository repository,
        string repositoryRoot,
        string repositoryRelativeMprPath,
        bool persistModelDumps)
    {
        var workingDumpPath = CreateTempPath(".json");
        var headDumpPath = CreateTempPath(".json");
        var headWorkspacePath = CreateTempDirectoryPath();
        var workingMprPath = Path.Combine(repositoryRoot, repositoryRelativeMprPath.Replace('/', Path.DirectorySeparatorChar));

        try
        {
            if (File.Exists(workingMprPath))
            {
                try
                {
                    MxToolService.DumpMpr(workingMprPath, workingDumpPath);
                }
                catch (Exception exception) when (LooksLikeDumpEnvironmentIssue(exception))
                {
                    // In some Studio Pro states the local mprcontents workspace is temporarily inconsistent.
                    return new ModelAnalysisResult(new List<MendixModelChange>(), null);
                }
            }
            else
            {
                WriteEmptyDump(workingDumpPath);
            }

            if (TryWriteHeadMpr(repository, repositoryRelativeMprPath, workingMprPath, headWorkspacePath, out var headMprPath))
            {
                try
                {
                    MxToolService.DumpMpr(headMprPath, headDumpPath);
                }
                catch (Exception exception) when (LooksLikeDumpEnvironmentIssue(exception))
                {
                    // Some repositories cannot be reconstructed for HEAD snapshot analysis.
                    return new ModelAnalysisResult(new List<MendixModelChange>(), null);
                }
            }
            else
            {
                WriteEmptyDump(headDumpPath);
            }

            var modelChanges = MendixModelDiffService.CompareDumps(workingDumpPath, headDumpPath);
            var modelDumpArtifact = persistModelDumps
                ? PersistModelDumpArtifacts(repositoryRelativeMprPath, workingDumpPath, headDumpPath)
                : null;

            return new ModelAnalysisResult(modelChanges, modelDumpArtifact);
        }
        finally
        {
            TryDeleteFile(workingDumpPath);
            TryDeleteFile(headDumpPath);
            TryDeleteDirectory(headWorkspacePath);
        }
    }

    private static bool TryWriteHeadMpr(
        Repository repository,
        string repositoryRelativeMprPath,
        string workingMprPath,
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
        if (!TryCopyMprContentsFromHeadCommit(headCommit, repositoryRelativeMprPath, headWorkspacePath))
        {
            CopyMprContentsIfPresent(workingMprPath, headWorkspacePath);
        }

        var mprFileName = Path.GetFileName(workingMprPath);
        if (string.IsNullOrWhiteSpace(mprFileName))
        {
            mprFileName = Path.GetFileName(repositoryRelativeMprPath);
        }

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
        var normalizedMprDirectory = string.IsNullOrWhiteSpace(mprDirectoryPath) || string.Equals(mprDirectoryPath, ".", StringComparison.Ordinal)
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

    private static string CreateTempPath(string extension) =>
        Path.Combine(Path.GetTempPath(), $"autocommitmessage_{Guid.NewGuid():N}{extension}");

    private static string CreateTempDirectoryPath() =>
        Path.Combine(Path.GetTempPath(), $"autocommitmessage_mpr_{Guid.NewGuid():N}");

    private static string NormalizeRepositoryPath(string path) =>
        path.Replace('\\', '/');

    private static ModelDumpArtifact PersistModelDumpArtifacts(
        string repositoryRelativeMprPath,
        string workingDumpPath,
        string headDumpPath)
    {
        Directory.CreateDirectory(ExtensionDataPaths.DumpsFolder);

        var timestamp = DateTimeOffset.UtcNow.ToString("yyyy-MM-ddTHH-mm-ss.fffZ");
        var mprToken = SanitizePathToken(repositoryRelativeMprPath);
        var folderName = $"{timestamp}_{mprToken}_{Guid.NewGuid():N}";
        var destinationFolder = Path.Combine(ExtensionDataPaths.DumpsFolder, folderName);
        Directory.CreateDirectory(destinationFolder);

        var destinationWorkingDumpPath = Path.Combine(destinationFolder, "working-dump.json");
        var destinationHeadDumpPath = Path.Combine(destinationFolder, "head-dump.json");

        File.Copy(workingDumpPath, destinationWorkingDumpPath, overwrite: true);
        File.Copy(headDumpPath, destinationHeadDumpPath, overwrite: true);

        return new ModelDumpArtifact(destinationFolder, destinationWorkingDumpPath, destinationHeadDumpPath);
    }

    private static string SanitizePathToken(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return "model";
        }

        var token = value.Replace('\\', '_').Replace('/', '_').Trim();
        var invalidFileNameChars = Path.GetInvalidFileNameChars();
        var sanitized = new StringBuilder(token.Length);

        foreach (var character in token)
        {
            sanitized.Append(invalidFileNameChars.Contains(character) ? '_' : character);
        }

        return sanitized.Length == 0 ? "model" : sanitized.ToString();
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
        var tempWorkspaceMissingPath =
            message.IndexOf("Exception during exporting the model to JSON", StringComparison.OrdinalIgnoreCase) >= 0 &&
            message.IndexOf("Could not find a part of the path", StringComparison.OrdinalIgnoreCase) >= 0;

        return missingContents || mismatchedMprName || tempWorkspaceMissingPath;
    }

    private static void WriteEmptyDump(string outputPath)
    {
        const string emptyDumpJson = "{\"units\":[]}";
        File.WriteAllText(outputPath, emptyDumpJson, new UTF8Encoding(false));
    }

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
            // Ignore cleanup failures for temp artifacts.
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
            // Ignore cleanup failures for temp artifacts.
        }
    }

    private static void CopyMprContentsIfPresent(string workingMprPath, string headWorkspacePath)
    {
        var workingDirectory = Path.GetDirectoryName(workingMprPath);
        if (string.IsNullOrWhiteSpace(workingDirectory))
        {
            return;
        }

        var sourceMprContentsPath = Path.Combine(workingDirectory, "mprcontents");
        if (!Directory.Exists(sourceMprContentsPath))
        {
            return;
        }

        var targetMprContentsPath = Path.Combine(headWorkspacePath, "mprcontents");
        CopyDirectory(sourceMprContentsPath, targetMprContentsPath);
    }

    private static void CopyDirectory(string sourcePath, string destinationPath)
    {
        Directory.CreateDirectory(destinationPath);

        foreach (var sourceFilePath in Directory.EnumerateFiles(sourcePath, "*", SearchOption.AllDirectories))
        {
            var relativePath = Path.GetRelativePath(sourcePath, sourceFilePath);
            var destinationFilePath = Path.Combine(destinationPath, relativePath);
            var destinationDirectory = Path.GetDirectoryName(destinationFilePath);
            if (!string.IsNullOrWhiteSpace(destinationDirectory))
            {
                Directory.CreateDirectory(destinationDirectory);
            }

            File.Copy(sourceFilePath, destinationFilePath, overwrite: true);
        }
    }

    private sealed record ModelAnalysisResult(
        List<MendixModelChange> ModelChanges,
        ModelDumpArtifact? ModelDumpArtifact);
}
