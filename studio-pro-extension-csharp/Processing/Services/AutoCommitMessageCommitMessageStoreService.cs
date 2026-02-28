using System.Text;

namespace AutoCommitMessage;

internal static class AutoCommitMessageCommitMessageStoreService
{
    private const string TimestampFormat = "yyyy-MM-ddTHH-mm-ss.fffZ";

    public static string StoreCommitMessage(
        string commitMessage,
        string projectPath,
        string? commitMessagesBasePath)
    {
        if (string.IsNullOrWhiteSpace(commitMessage))
        {
            throw new InvalidOperationException("Commit message is empty.");
        }

        var folderPath = ExtensionDataPaths.GetCommitMessagesFolder(commitMessagesBasePath, projectPath);
        Directory.CreateDirectory(folderPath);

        var timestamp = DateTimeOffset.UtcNow;
        var firstLine = ReadFirstLine(commitMessage);
        var stem = SanitizeFileToken(string.IsNullOrWhiteSpace(firstLine) ? "commit-message" : firstLine);
        var fileName = $"{timestamp.ToString(TimestampFormat)}_{stem}.txt";
        var destinationPath = BuildUniqueDestinationPath(folderPath, fileName);
        var tempPath = Path.Combine(
            folderPath,
            $"{Path.GetFileNameWithoutExtension(fileName)}_{Guid.NewGuid():N}.tmp");

        try
        {
            File.WriteAllText(tempPath, commitMessage.TrimEnd(), new UTF8Encoding(false));
            File.Move(tempPath, destinationPath);
            return destinationPath;
        }
        finally
        {
            TryDeleteTempFile(tempPath);
        }
    }

    private static string ReadFirstLine(string value)
    {
        var normalized = value.Replace('\r', '\n');
        var firstLine = normalized.Split('\n', StringSplitOptions.RemoveEmptyEntries)[0].Trim();
        return firstLine;
    }

    private static string SanitizeFileToken(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return "commit-message";
        }

        var invalidCharacters = Path.GetInvalidFileNameChars();
        var builder = new StringBuilder();
        foreach (var character in value.Trim())
        {
            builder.Append(invalidCharacters.Contains(character) ? '_' : character);
        }

        var sanitized = builder.ToString().Trim();
        if (sanitized.Length > 80)
        {
            sanitized = sanitized[..80].TrimEnd();
        }

        return string.IsNullOrWhiteSpace(sanitized) ? "commit-message" : sanitized;
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
}
