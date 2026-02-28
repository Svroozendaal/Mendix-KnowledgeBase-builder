using System.Text;
using System.Text.RegularExpressions;

namespace AutoCommitMessage;

/// <summary>
/// Service for storing commit messages with deterministic naming and git commit metadata.
///
/// Filename format: &lt;storyId&gt;_&lt;signature&gt;_&lt;yyyyMMdd&gt;.txt
/// - storyId and signature are sanitized to [A-Za-z0-9_-] only.
/// - If sanitized storyId is empty, empty segment is retained (e.g., "_JD_20260228.txt").
/// - Date uses local system time.
///
/// File content format:
/// #commit:&lt;shortCommitHash&gt;
/// &lt;blank line&gt;
/// &lt;message body&gt;
///
/// Collision strategy (for same date/storyId/signature):
/// 1. If file does not exist: create new file.
/// 2. If file exists:
///    - Read first line hash.
///    - If hash matches current HEAD: overwrite same file.
///    - If hash differs: try suffix variants (_2, _3, ...) until:
///      - Free slot found → write new file.
///      - Existing slot with matching hash → overwrite that slot.
/// </summary>
internal static class AutoCommitMessageCommitMessageStoreService
{
    private const string CommitHeaderPrefix = "#commit:";

    /// <summary>
    /// Stores a commit message with deterministic filename and commit hash header.
    /// </summary>
    /// <param name="commitMessage">The message body (without header).</param>
    /// <param name="storyId">Story identifier; sanitized to [A-Za-z0-9_-].</param>
    /// <param name="signature">User/author signature; sanitized to [A-Za-z0-9_-].</param>
    /// <param name="shortCommitHash">First 8 chars of current HEAD SHA.</param>
    /// <param name="projectPath">Project directory path.</param>
    /// <param name="commitMessagesBasePath">Optional override for messages base folder.</param>
    /// <returns>Full path to stored file.</returns>
    public static string StoreCommitMessage(
        string commitMessage,
        string storyId,
        string signature,
        string shortCommitHash,
        string projectPath,
        string? commitMessagesBasePath)
    {
        if (string.IsNullOrWhiteSpace(commitMessage))
        {
            throw new InvalidOperationException("Commit message is empty.");
        }

        if (string.IsNullOrWhiteSpace(shortCommitHash))
        {
            throw new InvalidOperationException("Commit hash is required.");
        }

        var folderPath = ExtensionDataPaths.GetCommitMessagesFolder(commitMessagesBasePath, projectPath);
        Directory.CreateDirectory(folderPath);

        var sanitizedStoryId = SanitizeFileToken(storyId ?? string.Empty);
        var sanitizedSignature = SanitizeFileToken(signature ?? string.Empty);
        var today = DateTime.Now.ToString("yyyyMMdd");
        var fileName = $"{sanitizedStoryId}_{sanitizedSignature}_{today}.txt";

        // Build file content with header.
        var fileContent = BuildFileContent(commitMessage, shortCommitHash);

        // Find target path applying collision strategy.
        var destinationPath = FindOrCreateDestinationPath(folderPath, fileName, shortCommitHash);

        // Write via temp file + atomic move.
        var tempPath = Path.Combine(
            folderPath,
            $"{Path.GetFileNameWithoutExtension(fileName)}_{Guid.NewGuid():N}.tmp");

        try
        {
            File.WriteAllText(tempPath, fileContent, new UTF8Encoding(false));
            File.Move(tempPath, destinationPath, overwrite: true);
            return destinationPath;
        }
        finally
        {
            TryDeleteTempFile(tempPath);
        }
    }

    /// <summary>
    /// Sanitizes a string to [A-Za-z0-9_-] characters only.
    /// Used for storyId and signature fields.
    /// </summary>
    private static string SanitizeFileToken(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        var sanitized = Regex.Replace(value.Trim(), @"[^A-Za-z0-9_\-]", string.Empty);
        return sanitized;
    }

    /// <summary>
    /// Builds file content: header with commit hash, blank line, then message body.
    /// </summary>
    private static string BuildFileContent(string commitMessage, string shortCommitHash)
    {
        var header = $"{CommitHeaderPrefix}{shortCommitHash}";
        return $"{header}\n\n{commitMessage.TrimEnd()}";
    }

    /// <summary>
    /// Finds target path applying collision strategy.
    /// </summary>
    private static string FindOrCreateDestinationPath(
        string folderPath,
        string baseFileName,
        string currentHash)
    {
        var basePath = Path.Combine(folderPath, baseFileName);

        // If file doesn't exist, use it.
        if (!File.Exists(basePath))
        {
            return basePath;
        }

        // If file exists, check hash.
        var existingHash = TryReadCommitHash(basePath);
        if (string.Equals(existingHash, currentHash, StringComparison.OrdinalIgnoreCase))
        {
            // Same hash: overwrite.
            return basePath;
        }

        // Different hash: try suffix variants.
        var stem = Path.GetFileNameWithoutExtension(baseFileName);
        var ext = Path.GetExtension(baseFileName);
        var suffix = 2;
        while (suffix < 100)
        {
            var suffixedName = $"{stem}_{suffix}{ext}";
            var suffixedPath = Path.Combine(folderPath, suffixedName);

            if (!File.Exists(suffixedPath))
            {
                return suffixedPath;
            }

            var suffixedHash = TryReadCommitHash(suffixedPath);
            if (string.Equals(suffixedHash, currentHash, StringComparison.OrdinalIgnoreCase))
            {
                return suffixedPath;
            }

            suffix++;
        }

        // Fallback (should not happen).
        return basePath;
    }

    /// <summary>
    /// Reads the commit hash from the first line of a file.
    /// Returns null if unable to read or parse.
    /// </summary>
    private static string? TryReadCommitHash(string filePath)
    {
        try
        {
            if (!File.Exists(filePath))
            {
                return null;
            }

            var firstLine = File.ReadLines(filePath).FirstOrDefault();
            if (string.IsNullOrWhiteSpace(firstLine) || !firstLine.StartsWith(CommitHeaderPrefix))
            {
                return null;
            }

            return firstLine[CommitHeaderPrefix.Length..];
        }
        catch
        {
            return null;
        }
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
}
