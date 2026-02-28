namespace AutoCommitMessage;

/// <summary>
/// Holds shared extension configuration including Mendix installation detection results.
/// Thread-safe singleton for accessing configuration state across the extension.
/// </summary>
public static class ExtensionConfigurationService
{
    private static readonly object SyncRoot = new();
    private static DetectionResult? detectionResult;
    private static string? installRootOverride;

    /// <summary>
    /// Gets the current detection result.
    /// </summary>
    public static DetectionResult? GetDetectionResult()
    {
        lock (SyncRoot)
        {
            return detectionResult;
        }
    }

    /// <summary>
    /// Sets the detection result.
    /// </summary>
    public static void SetDetectionResult(DetectionResult? result)
    {
        lock (SyncRoot)
        {
            detectionResult = result;
        }
    }

    /// <summary>
    /// Gets the current install root override.
    /// </summary>
    public static string? GetInstallRootOverride()
    {
        lock (SyncRoot)
        {
            return installRootOverride;
        }
    }

    /// <summary>
    /// Sets the install root override.
    /// </summary>
    public static void SetInstallRootOverride(string? path)
    {
        lock (SyncRoot)
        {
            installRootOverride = path;
        }
    }

    /// <summary>
    /// Clears both detection result and override (for re-detection scenarios).
    /// </summary>
    public static void Reset()
    {
        lock (SyncRoot)
        {
            detectionResult = null;
            installRootOverride = null;
        }
    }
}
