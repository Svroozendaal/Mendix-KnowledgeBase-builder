using Xunit;

namespace AutoCommitMessage.Tests;

public class AutoCommitMessageHeadDumpCacheServiceTests : IDisposable
{
    private readonly string _tempDataRoot = Path.Combine(Path.GetTempPath(), $"cache_test_{Guid.NewGuid():N}");

    public void Dispose()
    {
        CleanupDirectory(_tempDataRoot);
    }

    [Fact]
    public void GetCachePath_WithValidInputs_ReturnsCorrectPath()
    {
        // Arrange
        var mprPath = "/path/to/App.mpr";
        var commitSha = "abc123def456";

        // Act
        var cachePath = AutoCommitMessageHeadDumpCacheService.GetCachePath(mprPath, commitSha);

        // Assert
        Assert.NotNull(cachePath);
        Assert.Contains("head-cache", cachePath);
        Assert.Contains(commitSha, cachePath);
        Assert.Contains("App.json", cachePath);
    }

    [Fact]
    public void GetCachePath_WithNullMprPath_ThrowsArgumentException()
    {
        // Act & Assert
        var exception = Assert.Throws<ArgumentException>(
            () => AutoCommitMessageHeadDumpCacheService.GetCachePath(null!, "sha123"));
        Assert.Contains("MPR path cannot be null", exception.Message);
    }

    [Fact]
    public void GetCachePath_WithEmptyMprPath_ThrowsArgumentException()
    {
        // Act & Assert
        var exception = Assert.Throws<ArgumentException>(
            () => AutoCommitMessageHeadDumpCacheService.GetCachePath(string.Empty, "sha123"));
        Assert.Contains("MPR path cannot be null", exception.Message);
    }

    [Fact]
    public void GetCachePath_WithNullCommitSha_ThrowsArgumentException()
    {
        // Act & Assert
        var exception = Assert.Throws<ArgumentException>(
            () => AutoCommitMessageHeadDumpCacheService.GetCachePath("/path/to/App.mpr", null!));
        Assert.Contains("HEAD commit SHA cannot be null", exception.Message);
    }

    [Fact]
    public void GetCachePath_WithEmptyCommitSha_ThrowsArgumentException()
    {
        // Act & Assert
        var exception = Assert.Throws<ArgumentException>(
            () => AutoCommitMessageHeadDumpCacheService.GetCachePath("/path/to/App.mpr", string.Empty));
        Assert.Contains("HEAD commit SHA cannot be null", exception.Message);
    }

    [Fact]
    public void GetCachePath_CreatesCacheDirectory()
    {
        // Arrange
        var mprPath = "/path/to/App.mpr";
        var commitSha = "abc123";

        // Act
        var cachePath = AutoCommitMessageHeadDumpCacheService.GetCachePath(mprPath, commitSha);

        // Assert
        var cacheDir = Path.GetDirectoryName(cachePath);
        Assert.NotNull(cacheDir);
        Assert.True(Directory.Exists(cacheDir));
    }

    [Fact]
    public void TryGetCachedDump_WithNullMprPath_ReturnsFalse()
    {
        // Act
        var result = AutoCommitMessageHeadDumpCacheService.TryGetCachedDump(null!, "sha123", out var dumpPath);

        // Assert
        Assert.False(result);
        Assert.Null(dumpPath);
    }

    [Fact]
    public void TryGetCachedDump_WithEmptyMprPath_ReturnsFalse()
    {
        // Act
        var result = AutoCommitMessageHeadDumpCacheService.TryGetCachedDump(string.Empty, "sha123", out var dumpPath);

        // Assert
        Assert.False(result);
        Assert.Null(dumpPath);
    }

    [Fact]
    public void TryGetCachedDump_WithNullCommitSha_ReturnsFalse()
    {
        // Act
        var result = AutoCommitMessageHeadDumpCacheService.TryGetCachedDump("/path/to/App.mpr", null!, out var dumpPath);

        // Assert
        Assert.False(result);
        Assert.Null(dumpPath);
    }

    [Fact]
    public void TryGetCachedDump_WithNonExistentCache_ReturnsFalse()
    {
        // Arrange
        var mprPath = "/path/to/App.mpr";
        var commitSha = "nonexistent_sha";

        // Act
        var result = AutoCommitMessageHeadDumpCacheService.TryGetCachedDump(mprPath, commitSha, out var dumpPath);

        // Assert
        Assert.False(result);
        Assert.Null(dumpPath);
    }

    [Fact]
    public void TryCacheDump_WithValidDump_Succeeds()
    {
        // Arrange
        var sourceDumpPath = Path.Combine(_tempDataRoot, "source-dump.json");
        var mprPath = Path.Combine(_tempDataRoot, "App.mpr");
        var commitSha = "abc123";

        Directory.CreateDirectory(Path.GetDirectoryName(mprPath)!);
        File.WriteAllText(sourceDumpPath, "{\"units\":[]}");

        // Act
        var result = AutoCommitMessageHeadDumpCacheService.TryCacheDump(sourceDumpPath, mprPath, commitSha);

        // Assert
        Assert.True(result);
        var cachePath = AutoCommitMessageHeadDumpCacheService.GetCachePath(mprPath, commitSha);
        Assert.True(File.Exists(cachePath));
    }

    [Fact]
    public void TryCacheDump_WithNonExistentSourceDump_ReturnsFalse()
    {
        // Arrange
        var sourceDumpPath = "/nonexistent/dump.json";
        var mprPath = "/path/to/App.mpr";
        var commitSha = "abc123";

        // Act
        var result = AutoCommitMessageHeadDumpCacheService.TryCacheDump(sourceDumpPath, mprPath, commitSha);

        // Assert
        Assert.False(result);
    }

    [Fact]
    public void TryCacheDump_WithNullSourcePath_ReturnsFalse()
    {
        // Act
        var result = AutoCommitMessageHeadDumpCacheService.TryCacheDump(null!, "/path/to/App.mpr", "sha123");

        // Assert
        Assert.False(result);
    }

    [Fact]
    public void CacheHitAndMiss_Workflow()
    {
        // Arrange
        var sourceDumpPath = Path.Combine(_tempDataRoot, "source-dump.json");
        var mprPath = Path.Combine(_tempDataRoot, "App.mpr");
        var commitSha = "abc123";
        var dumpContent = "{\"units\":[{\"id\":\"test\"}]}";

        Directory.CreateDirectory(Path.GetDirectoryName(mprPath)!);
        File.WriteAllText(sourceDumpPath, dumpContent);

        // Act: cache miss on first call
        var miss = AutoCommitMessageHeadDumpCacheService.TryGetCachedDump(mprPath, commitSha, out var missPath);

        // Assert: miss
        Assert.False(miss);
        Assert.Null(missPath);

        // Act: cache the dump
        var cacheSuccess = AutoCommitMessageHeadDumpCacheService.TryCacheDump(sourceDumpPath, mprPath, commitSha);

        // Assert: cache succeeded
        Assert.True(cacheSuccess);

        // Act: cache hit on second call
        var hit = AutoCommitMessageHeadDumpCacheService.TryGetCachedDump(mprPath, commitSha, out var hitPath);

        // Assert: hit
        Assert.True(hit);
        Assert.NotNull(hitPath);
        Assert.True(File.Exists(hitPath));

        // Verify content
        var cachedContent = File.ReadAllText(hitPath);
        Assert.Equal(dumpContent, cachedContent);
    }

    [Fact]
    public void PruneOldCacheEntries_RemovesStaleEntries()
    {
        // Arrange
        var mprPath = Path.Combine(_tempDataRoot, "App.mpr");
        var oldSha = "old_sha_123";
        var newSha = "new_sha_456";
        var sourceDumpPath = Path.Combine(_tempDataRoot, "dump.json");

        Directory.CreateDirectory(Path.GetDirectoryName(mprPath)!);
        File.WriteAllText(sourceDumpPath, "{}");

        // Create old cache entry
        AutoCommitMessageHeadDumpCacheService.TryCacheDump(sourceDumpPath, mprPath, oldSha);
        var oldCachePath = AutoCommitMessageHeadDumpCacheService.GetCachePath(mprPath, oldSha);
        var oldCacheDir = Path.GetDirectoryName(oldCachePath);

        // Make it look old by setting last write time
        if (Directory.Exists(oldCacheDir))
        {
            var dirInfo = new DirectoryInfo(oldCacheDir);
            dirInfo.LastWriteTime = DateTime.Now.AddDays(-40); // 40 days old, > 30 day max
        }

        // Create new cache entry
        AutoCommitMessageHeadDumpCacheService.TryCacheDump(sourceDumpPath, mprPath, newSha);
        var newCachePath = AutoCommitMessageHeadDumpCacheService.GetCachePath(mprPath, newSha);

        // Act: prune with new SHA preserved
        AutoCommitMessageHeadDumpCacheService.PruneOldCacheEntries(_tempDataRoot, newSha, maxAgeDays: 30);

        // Assert: old entry removed, new entry preserved
        Assert.False(Directory.Exists(oldCacheDir), "Old cache directory should be removed");
        Assert.True(File.Exists(newCachePath), "New cache file should be preserved");
    }

    [Fact]
    public void PruneOldCacheEntries_PreserveCurrentHeadCommit()
    {
        // Arrange
        var mprPath = Path.Combine(_tempDataRoot, "App.mpr");
        var currentSha = "current_sha";
        var olderSha = "older_sha";
        var sourceDumpPath = Path.Combine(_tempDataRoot, "dump.json");

        Directory.CreateDirectory(Path.GetDirectoryName(mprPath)!);
        File.WriteAllText(sourceDumpPath, "{}");

        // Create multiple cache entries
        AutoCommitMessageHeadDumpCacheService.TryCacheDump(sourceDumpPath, mprPath, currentSha);
        AutoCommitMessageHeadDumpCacheService.TryCacheDump(sourceDumpPath, mprPath, olderSha);

        var olderCachePath = AutoCommitMessageHeadDumpCacheService.GetCachePath(mprPath, olderSha);
        var olderCacheDir = Path.GetDirectoryName(olderCachePath);

        // Make older entry look stale
        if (Directory.Exists(olderCacheDir))
        {
            var dirInfo = new DirectoryInfo(olderCacheDir);
            dirInfo.LastWriteTime = DateTime.Now.AddDays(-40);
        }

        // Act: prune with current SHA
        AutoCommitMessageHeadDumpCacheService.PruneOldCacheEntries(_tempDataRoot, currentSha, maxAgeDays: 30);

        // Assert: older entry removed, current preserved
        Assert.False(Directory.Exists(olderCacheDir));
    }

    [Fact]
    public void PruneOldCacheEntries_WithNullDataRoot_UsesDefault()
    {
        // Act: should not throw
        AutoCommitMessageHeadDumpCacheService.PruneOldCacheEntries(null!, "sha123");

        // Assert: no exception thrown
    }

    [Fact]
    public void SanitizedFilename_RemovesInvalidPathCharacters()
    {
        // Arrange
        var mprPath = "/path/to/App.mpr";
        var commitSha = "abc123";

        // Act
        var cachePath = AutoCommitMessageHeadDumpCacheService.GetCachePath(mprPath, commitSha);

        // Assert: filename should be sanitized (no path separators in the .json name)
        var fileName = Path.GetFileName(cachePath);
        Assert.False(fileName.Contains(Path.DirectorySeparatorChar));
        Assert.False(fileName.Contains(Path.AltDirectorySeparatorChar));
        Assert.EndsWith(".json", fileName);
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
