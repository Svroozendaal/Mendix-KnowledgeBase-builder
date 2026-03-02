namespace AutoCommitMessage;

/// <summary>
/// Detects whether a Mendix project uses MPR v2 storage format.
/// Detection rule: presence of 'mprcontents' directory next to the .mpr file indicates MPR v2.
/// </summary>
public static class MendixMprFormatDetector
{
    /// <summary>
    /// Detects whether an MPR file uses v2 storage format.
    /// </summary>
    /// <param name="mprFilePath">Full path to the .mpr file.</param>
    /// <returns>True if the project uses MPR v2 (mprcontents directory exists); false for v1 or on error.</returns>
    public static bool IsMprV2(string mprFilePath)
    {
        if (string.IsNullOrWhiteSpace(mprFilePath))
        {
            return false;
        }

        try
        {
            var mprDirectory = Path.GetDirectoryName(mprFilePath);
            if (string.IsNullOrWhiteSpace(mprDirectory))
            {
                return false;
            }

            var mprContentsPath = Path.Combine(mprDirectory, "mprcontents");
            return Directory.Exists(mprContentsPath);
        }
        catch
        {
            // On any error (invalid path, permission issues), default to v1
            return false;
        }
    }
}
