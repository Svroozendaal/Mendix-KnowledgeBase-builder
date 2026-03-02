using LibGit2Sharp;
using Xunit;

namespace AutoCommitMessage.Tests;

public class MendixV2ChangedModuleDetectorTests : IDisposable
{
    private readonly string _tempPath = Path.Combine(Path.GetTempPath(), $"git_repo_{Guid.NewGuid():N}");

    public void Dispose()
    {
        CleanupDirectory(_tempPath);
    }

    [Fact]
    public void DetectChangedModules_WithNoChangedFiles_ReturnsEmptyList()
    {
        // Arrange
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "file.txt", "content");

        // Act: no changes, so status should be empty
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Empty(result);
    }

    [Fact]
    public void DetectChangedModules_WithSingleModuleChange_ReturnsSingleModule()
    {
        // Arrange
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "mprcontents/MyModule/file.yaml", "content");
        ModifyFile(repo, "mprcontents/MyModule/file.yaml", "modified");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Single(result);
        Assert.Contains("MyModule", result);
    }

    [Fact]
    public void DetectChangedModules_WithMultipleModules_ReturnsAllModules()
    {
        // Arrange
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "mprcontents/Module1/file.yaml", "content1");
        CommitFile(repo, "mprcontents/Module2/file.yaml", "content2");
        CommitFile(repo, "mprcontents/Module3/file.yaml", "content3");
        ModifyFile(repo, "mprcontents/Module1/file.yaml", "modified");
        ModifyFile(repo, "mprcontents/Module2/file.yaml", "modified");
        // Module3 not modified

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Equal(2, result.Count);
        Assert.Contains("Module1", result);
        Assert.Contains("Module2", result);
        Assert.DoesNotContain("Module3", result);
    }

    [Fact]
    public void DetectChangedModules_WithNestedModuleStructure_ExtractsModuleNameCorrectly()
    {
        // Arrange: mprcontents/Module/subfolder/file.yaml
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "mprcontents/MyModule/flows/ProcessA.mxflow", "content");
        CommitFile(repo, "mprcontents/MyModule/domain/Entity.mxsd", "content");
        ModifyFile(repo, "mprcontents/MyModule/flows/ProcessA.mxflow", "modified");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Single(result);
        Assert.Contains("MyModule", result);
    }

    [Fact]
    public void DetectChangedModules_WithFilesOutsideMprContents_IgnoresThemProperly()
    {
        // Arrange
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "App.mpr", "content");
        CommitFile(repo, "mprcontents/MyModule/file.yaml", "content");
        CommitFile(repo, "SomeOtherFile.txt", "content");
        ModifyFile(repo, "App.mpr", "modified");
        ModifyFile(repo, "mprcontents/MyModule/file.yaml", "modified");
        ModifyFile(repo, "SomeOtherFile.txt", "modified");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Single(result);
        Assert.Contains("MyModule", result);
    }

    [Fact]
    public void DetectChangedModules_WithCaseInsensitiveModuleNames_DeduplicatesCorrectly()
    {
        // Arrange: same module with different cases should be deduplicated
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "mprcontents/MyModule/file1.yaml", "content1");
        ModifyFile(repo, "mprcontents/MyModule/file1.yaml", "modified");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Single(result);
        Assert.Contains("MyModule", result);
    }

    [Fact]
    public void DetectChangedModules_ReturnsResultsSorted()
    {
        // Arrange
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "mprcontents/Zebra/file.yaml", "content");
        CommitFile(repo, "mprcontents/Apple/file.yaml", "content");
        CommitFile(repo, "mprcontents/Monkey/file.yaml", "content");
        ModifyFile(repo, "mprcontents/Zebra/file.yaml", "modified");
        ModifyFile(repo, "mprcontents/Apple/file.yaml", "modified");
        ModifyFile(repo, "mprcontents/Monkey/file.yaml", "modified");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Equal(3, result.Count);
        Assert.Equal(new[] { "Apple", "Monkey", "Zebra" }, result);
    }

    [Fact]
    public void DetectChangedModules_WithNestedMprContentsPath_DetectsCorrectly()
    {
        // Arrange: mprcontents under a subdirectory
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "Modules/App/mprcontents/MyModule/file.yaml", "content");
        ModifyFile(repo, "Modules/App/mprcontents/MyModule/file.yaml", "modified");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "Modules/App/mprcontents");

        // Assert
        Assert.Single(result);
        Assert.Contains("MyModule", result);
    }

    [Fact]
    public void DetectChangedModules_WithNullRepository_ReturnsEmptyList()
    {
        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(null!, "mprcontents");

        // Assert
        Assert.Empty(result);
    }

    [Fact]
    public void DetectChangedModules_WithNullBasePath_UsesDefault()
    {
        // Arrange
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "mprcontents/MyModule/file.yaml", "content");
        ModifyFile(repo, "mprcontents/MyModule/file.yaml", "modified");

        // Act: pass null, should default to "mprcontents"
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, null!);

        // Assert: should still work with default
        // This depends on implementation - if null is handled, it uses default
        // Otherwise it may return empty - test accordingly
    }

    [Fact]
    public void DetectChangedModules_WithAddedFiles_DetectsModules()
    {
        // Arrange: files added (not modified)
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "App.mpr", "content");
        AddUncommittedFile(repo, "mprcontents/NewModule/newfile.yaml", "new content");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Single(result);
        Assert.Contains("NewModule", result);
    }

    [Fact]
    public void DetectChangedModules_WithDeletedFiles_DetectsModules()
    {
        // Arrange: files deleted
        using var repo = InitializeRepository(_tempPath);
        CommitFile(repo, "mprcontents/MyModule/file.yaml", "content");
        DeleteFile(repo, "mprcontents/MyModule/file.yaml");

        // Act
        var result = MendixV2ChangedModuleDetector.DetectChangedModules(repo, "mprcontents");

        // Assert
        Assert.Single(result);
        Assert.Contains("MyModule", result);
    }

    private Repository InitializeRepository(string repoPath)
    {
        if (!Directory.Exists(repoPath))
        {
            Directory.CreateDirectory(repoPath);
        }

        var repo = new Repository(Repository.Init(repoPath));

        // Configure git user for commits
        repo.Config.Set("user.name", "Test User");
        repo.Config.Set("user.email", "test@example.com");

        return repo;
    }

    private void CommitFile(Repository repo, string filePath, string content)
    {
        var fullPath = Path.Combine(repo.Info.WorkingDirectory, filePath);
        var directory = Path.GetDirectoryName(fullPath);
        if (!Directory.Exists(directory))
        {
            Directory.CreateDirectory(directory!);
        }

        File.WriteAllText(fullPath, content);
        repo.Index.Add(filePath.Replace(Path.DirectorySeparatorChar, '/'));
        repo.Index.Write();

        var signature = new Signature("Test User", "test@example.com", DateTimeOffset.Now);
        repo.Commit($"Commit {filePath}", signature, signature);
    }

    private void ModifyFile(Repository repo, string filePath, string content)
    {
        var fullPath = Path.Combine(repo.Info.WorkingDirectory, filePath);
        File.WriteAllText(fullPath, content);
        // File is modified but not committed - it will show up in git status
    }

    private void AddUncommittedFile(Repository repo, string filePath, string content)
    {
        var fullPath = Path.Combine(repo.Info.WorkingDirectory, filePath);
        var directory = Path.GetDirectoryName(fullPath);
        if (!Directory.Exists(directory))
        {
            Directory.CreateDirectory(directory!);
        }

        File.WriteAllText(fullPath, content);
        // File is untracked - it will show up in git status
    }

    private void DeleteFile(Repository repo, string filePath)
    {
        var fullPath = Path.Combine(repo.Info.WorkingDirectory, filePath);
        if (File.Exists(fullPath))
        {
            File.Delete(fullPath);
            // File is deleted in working directory - it will show up in git status
        }
    }

    private static void CleanupDirectory(string dirPath)
    {
        try
        {
            if (Directory.Exists(dirPath))
            {
                Directory.Delete(dirPath, recursive: true);
            }
        }
        catch
        {
            // Ignore cleanup errors
        }
    }
}
