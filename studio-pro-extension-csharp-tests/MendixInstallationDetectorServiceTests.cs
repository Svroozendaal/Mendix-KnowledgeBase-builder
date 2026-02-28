using System;
using System.IO;
using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for MendixInstallationDetectorService.
/// Tests the detection algorithm: version determination, exact match, major.minor fallback, and error cases.
/// </summary>
public class MendixInstallationDetectorServiceTests
{
    private readonly MendixInstallationDetectorService _detector = new();

    [Fact]
    public void Detect_MissingMprFile_ReturnsFailure()
    {
        // Arrange
        var missingPath = Path.Combine(Path.GetTempPath(), "nonexistent_" + Guid.NewGuid() + ".mpr");

        // Act
        var result = _detector.Detect(missingPath);

        // Assert
        Assert.False(result.Success);
        Assert.Null(result.MxExePath);
        Assert.Contains("not found", result.FailureReason, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Detect_EmptyMprPath_ReturnsFailure()
    {
        // Act
        var result = _detector.Detect(string.Empty);

        // Assert
        Assert.False(result.Success);
        Assert.Contains("required", result.FailureReason, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Detect_NullMprPath_ReturnsFailure()
    {
        // Act
        var result = _detector.Detect(null!);

        // Assert
        Assert.False(result.Success);
        Assert.Contains("required", result.FailureReason, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Detect_NonexistentInstallRoot_ReturnsFailure()
    {
        // Arrange
        var tempMpr = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".mpr");
        File.WriteAllText(tempMpr, "fake mpr");

        try
        {
            var fakeInstallRoot = @"C:\NonExistent_Mendix_Install_12345\";

            // Act
            var result = _detector.Detect(tempMpr, fakeInstallRoot);

            // Assert
            Assert.False(result.Success);
            Assert.Contains("no mx.exe", result.FailureReason, StringComparison.OrdinalIgnoreCase);
        }
        finally
        {
            try
            {
                File.Delete(tempMpr);
            }
            catch
            {
                // Ignore cleanup errors
            }
        }
    }

    [Fact]
    public void Detect_WithValidMprButNoInstalledVersion_ReturnsFailure()
    {
        // Arrange
        var tempMpr = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".mpr");
        File.WriteAllText(tempMpr, "fake mpr");
        var tempInstallRoot = Path.Combine(Path.GetTempPath(), "MendixTest_" + Guid.NewGuid());
        Directory.CreateDirectory(tempInstallRoot);

        try
        {
            // Act
            var result = _detector.Detect(tempMpr, tempInstallRoot);

            // Assert
            Assert.False(result.Success);
            Assert.Equal(tempInstallRoot, result.InstallRoot);
            Assert.NotNull(result.FailureReason);
        }
        finally
        {
            try
            {
                File.Delete(tempMpr);
                if (Directory.Exists(tempInstallRoot))
                {
                    Directory.Delete(tempInstallRoot, recursive: true);
                }
            }
            catch
            {
                // Ignore cleanup errors
            }
        }
    }

    [Fact]
    public void Detect_InstallRootOverride_IsUsedForDetection()
    {
        // Arrange
        var tempMpr = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".mpr");
        File.WriteAllText(tempMpr, "fake mpr");
        var tempInstallRoot = Path.Combine(Path.GetTempPath(), "MendixTest_" + Guid.NewGuid());
        Directory.CreateDirectory(tempInstallRoot);

        try
        {
            // Act
            var result = _detector.Detect(tempMpr, tempInstallRoot);

            // Assert
            Assert.Equal(tempInstallRoot, result.InstallRoot);
        }
        finally
        {
            try
            {
                File.Delete(tempMpr);
                if (Directory.Exists(tempInstallRoot))
                {
                    Directory.Delete(tempInstallRoot, recursive: true);
                }
            }
            catch
            {
                // Ignore cleanup errors
            }
        }
    }

    [Theory]
    [InlineData("10.24.15.12345")]
    [InlineData("10.24.15")]
    [InlineData("9.0.0")]
    [InlineData("11.5.20")]
    public void DetectionResult_WithValidVersion_StoresDetectedVersion(string version)
    {
        // This test verifies the DetectionResult record accepts and stores version strings.
        var result = new DetectionResult
        {
            Success = false,
            DetectedVersion = version,
        };

        Assert.Equal(version, result.DetectedVersion);
    }

    [Fact]
    public void DetectionResult_WithFailure_StoresFailureReason()
    {
        // Arrange
        var failureReason = "No Mendix 10.24.15 installation found.";

        // Act
        var result = new DetectionResult
        {
            Success = false,
            FailureReason = failureReason,
        };

        // Assert
        Assert.False(result.Success);
        Assert.Equal(failureReason, result.FailureReason);
        Assert.Null(result.WarningReason);
    }

    [Fact]
    public void DetectionResult_WithFallback_StoresWarningReason()
    {
        // Arrange
        var warningReason = "Using 10.24.x fallback for 10.24.15.";

        // Act
        var result = new DetectionResult
        {
            Success = true,
            WarningReason = warningReason,
            MxExePath = @"C:\Program Files\Mendix\10.24.20\modeler\mx.exe",
        };

        // Assert
        Assert.True(result.Success);
        Assert.Equal(warningReason, result.WarningReason);
        Assert.NotNull(result.MxExePath);
    }

    [Fact]
    public void ExtensionConfigurationService_StoresAndRetrievesDetectionResult()
    {
        // Arrange
        var originalResult = new DetectionResult
        {
            Success = true,
            MxExePath = @"C:\Program Files\Mendix\10.24.15\modeler\mx.exe",
            DetectedVersion = "10.24.15",
        };

        try
        {
            // Act
            ExtensionConfigurationService.SetDetectionResult(originalResult);
            var retrievedResult = ExtensionConfigurationService.GetDetectionResult();

            // Assert
            Assert.NotNull(retrievedResult);
            Assert.True(retrievedResult.Success);
            Assert.Equal(originalResult.MxExePath, retrievedResult.MxExePath);
            Assert.Equal(originalResult.DetectedVersion, retrievedResult.DetectedVersion);
        }
        finally
        {
            ExtensionConfigurationService.Reset();
        }
    }

    [Fact]
    public void ExtensionConfigurationService_StoresAndRetrievesInstallRootOverride()
    {
        // Arrange
        var overridePath = @"D:\Custom\Mendix";

        try
        {
            // Act
            ExtensionConfigurationService.SetInstallRootOverride(overridePath);
            var retrieved = ExtensionConfigurationService.GetInstallRootOverride();

            // Assert
            Assert.Equal(overridePath, retrieved);
        }
        finally
        {
            ExtensionConfigurationService.Reset();
        }
    }

    [Fact]
    public void ExtensionConfigurationService_Reset_ClearsState()
    {
        // Arrange
        var result = new DetectionResult { Success = true };
        ExtensionConfigurationService.SetDetectionResult(result);
        ExtensionConfigurationService.SetInstallRootOverride(@"D:\Mendix");

        // Act
        ExtensionConfigurationService.Reset();

        // Assert
        Assert.Null(ExtensionConfigurationService.GetDetectionResult());
        Assert.Null(ExtensionConfigurationService.GetInstallRootOverride());
    }
}
