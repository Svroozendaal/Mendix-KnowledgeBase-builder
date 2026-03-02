using Xunit;

namespace AutoCommitMessage.Tests;

public class MendixMprFormatDetectorTests
{
    [Fact]
    public void IsMprV2_WithMprContentsDirectory_ReturnsTrue()
    {
        // Arrange
        var tempDir = Path.Combine(Path.GetTempPath(), $"test_mpr_v2_{Guid.NewGuid():N}");
        var mprContentsDir = Path.Combine(tempDir, "mprcontents");
        var mprPath = Path.Combine(tempDir, "App.mpr");

        try
        {
            Directory.CreateDirectory(mprContentsDir);
            File.WriteAllText(mprPath, "dummy");

            // Act
            var result = MendixMprFormatDetector.IsMprV2(mprPath);

            // Assert
            Assert.True(result);
        }
        finally
        {
            CleanupDirectory(tempDir);
        }
    }

    [Fact]
    public void IsMprV2_WithoutMprContentsDirectory_ReturnsFalse()
    {
        // Arrange
        var tempDir = Path.Combine(Path.GetTempPath(), $"test_mpr_v1_{Guid.NewGuid():N}");
        var mprPath = Path.Combine(tempDir, "App.mpr");

        try
        {
            Directory.CreateDirectory(tempDir);
            File.WriteAllText(mprPath, "dummy");

            // Act
            var result = MendixMprFormatDetector.IsMprV2(mprPath);

            // Assert
            Assert.False(result);
        }
        finally
        {
            CleanupDirectory(tempDir);
        }
    }

    [Fact]
    public void IsMprV2_WithNullPath_ReturnsFalse()
    {
        // Act
        var result = MendixMprFormatDetector.IsMprV2(null!);

        // Assert
        Assert.False(result);
    }

    [Fact]
    public void IsMprV2_WithEmptyPath_ReturnsFalse()
    {
        // Act
        var result = MendixMprFormatDetector.IsMprV2(string.Empty);

        // Assert
        Assert.False(result);
    }

    [Fact]
    public void IsMprV2_WithWhitespacePath_ReturnsFalse()
    {
        // Act
        var result = MendixMprFormatDetector.IsMprV2("   ");

        // Assert
        Assert.False(result);
    }

    [Fact]
    public void IsMprV2_WithInvalidPath_ReturnsFalse()
    {
        // Act
        var result = MendixMprFormatDetector.IsMprV2("C:\\NonExistent\\Path\\To\\App.mpr");

        // Assert
        Assert.False(result);
    }

    [Fact]
    public void IsMprV2_WithMprContentsAsFile_ReturnsFalse()
    {
        // Arrange: mprcontents is a file, not a directory
        var tempDir = Path.Combine(Path.GetTempPath(), $"test_mpr_invalid_{Guid.NewGuid():N}");
        var mprContentsFile = Path.Combine(tempDir, "mprcontents");
        var mprPath = Path.Combine(tempDir, "App.mpr");

        try
        {
            Directory.CreateDirectory(tempDir);
            File.WriteAllText(mprContentsFile, "not a directory");
            File.WriteAllText(mprPath, "dummy");

            // Act
            var result = MendixMprFormatDetector.IsMprV2(mprPath);

            // Assert
            Assert.False(result);
        }
        finally
        {
            CleanupDirectory(tempDir);
        }
    }

    [Fact]
    public void IsMprV2_WithNestedMprContentsDirectory_ReturnsTrue()
    {
        // Arrange: test nested structure like Modules/MyModule/App.mpr with mprcontents
        var tempDir = Path.Combine(Path.GetTempPath(), $"test_nested_mpr_{Guid.NewGuid():N}");
        var moduleDir = Path.Combine(tempDir, "Modules", "MyModule");
        var mprContentsDir = Path.Combine(moduleDir, "mprcontents");
        var mprPath = Path.Combine(moduleDir, "App.mpr");

        try
        {
            Directory.CreateDirectory(mprContentsDir);
            File.WriteAllText(mprPath, "dummy");

            // Act
            var result = MendixMprFormatDetector.IsMprV2(mprPath);

            // Assert
            Assert.True(result);
        }
        finally
        {
            CleanupDirectory(tempDir);
        }
    }

    [Fact]
    public void IsMprV2_Deterministic_ConsistentResults()
    {
        // Arrange
        var tempDir = Path.Combine(Path.GetTempPath(), $"test_determinism_{Guid.NewGuid():N}");
        var mprContentsDir = Path.Combine(tempDir, "mprcontents");
        var mprPath = Path.Combine(tempDir, "App.mpr");

        try
        {
            Directory.CreateDirectory(mprContentsDir);
            File.WriteAllText(mprPath, "dummy");

            // Act: run multiple times
            var result1 = MendixMprFormatDetector.IsMprV2(mprPath);
            var result2 = MendixMprFormatDetector.IsMprV2(mprPath);
            var result3 = MendixMprFormatDetector.IsMprV2(mprPath);

            // Assert: all results should be identical
            Assert.True(result1);
            Assert.Equal(result1, result2);
            Assert.Equal(result2, result3);
        }
        finally
        {
            CleanupDirectory(tempDir);
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
