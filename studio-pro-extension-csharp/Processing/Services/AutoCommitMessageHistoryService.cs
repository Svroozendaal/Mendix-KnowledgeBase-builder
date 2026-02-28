using System.Text.RegularExpressions;

namespace AutoCommitMessage;

/// <summary>
/// Service for reading and listing stored commit messages.
/// Provides read-only access with filename parsing and path traversal guards.
/// </summary>
internal static class AutoCommitMessageHistoryService
{
    private const string CommitHeaderPrefix = "#commit:";

    /// <summary>
    /// Represents metadata for a single commit message file.
    /// </summary>
    public class CommitMessageMetadata
    {
        public required string FileName { get; init; }
        public string? StoryId { get; init; }
        public string? Signature { get; init; }
        public DateTime? Date { get; init; }
        public required string FilePath { get; init; }
    }

    /// <summary>
    /// Result of listing commit messages.
    /// </summary>
    public class CommitMessageListResult
    {
        public required List<CommitMessageMetadata> Messages { get; init; }
        public required string Folder { get; init; }
        public required bool FolderExists { get; init; }
    }

    /// <summary>
    /// Result of reading a single commit message.
    /// </summary>
    public class CommitMessageReadResult
    {
        public required string FileName { get; init; }
        public required string Content { get; init; }
    }

    /// <summary>
    /// Lists all commit messages in the target folder.
    /// Parses filenames and sorts by date (newest first).
    /// </summary>
    public static CommitMessageListResult ListMessages(string commitMessagesBasePath, string projectPath)
    {
        var folderPath = ExtensionDataPaths.GetCommitMessagesFolder(commitMessagesBasePath, projectPath);
        var messages = new List<CommitMessageMetadata>();

        var folderExists = Directory.Exists(folderPath);
        if (folderExists)
        {
            try
            {
                var files = Directory.EnumerateFiles(folderPath, "*.txt", SearchOption.TopDirectoryOnly);
                foreach (var filePath in files)
                {
                    var fileName = Path.GetFileName(filePath);
                    var metadata = ParseFilename(fileName, filePath);
                    messages.Add(metadata);
                }
            }
            catch
            {
                // Ignore enumeration errors.
            }
        }

        // Sort by date descending, with unparseable dates last.
        messages.Sort((a, b) =>
        {
            if (a.Date.HasValue && b.Date.HasValue)
            {
                return b.Date.Value.CompareTo(a.Date.Value);
            }

            if (a.Date.HasValue)
            {
                return -1;
            }

            if (b.Date.HasValue)
            {
                return 1;
            }

            return 0;
        });

        return new CommitMessageListResult
        {
            Messages = messages,
            Folder = folderPath,
            FolderExists = folderExists,
        };
    }

    /// <summary>
    /// Reads a single commit message file.
    /// Returns content with #commit: header stripped.
    /// Guards against path traversal.
    /// </summary>
    public static CommitMessageReadResult ReadMessage(
        string filePath,
        string commitMessagesBasePath,
        string projectPath)
    {
        if (string.IsNullOrWhiteSpace(filePath))
        {
            throw new InvalidOperationException("File path is required.");
        }

        var folderPath = ExtensionDataPaths.GetCommitMessagesFolder(commitMessagesBasePath, projectPath);
        var resolvedFilePath = Path.GetFullPath(filePath);
        var resolvedFolderPath = Path.GetFullPath(folderPath);

        // Path traversal guard: file must be within folder.
        if (!resolvedFilePath.StartsWith(resolvedFolderPath, StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException("Path traversal not allowed.");
        }

        if (!File.Exists(resolvedFilePath))
        {
            throw new FileNotFoundException("File not found.", resolvedFilePath);
        }

        var fileName = Path.GetFileName(resolvedFilePath);
        var content = File.ReadAllText(resolvedFilePath);

        // Strip #commit: header and following blank line.
        var strippedContent = StripCommitHeader(content);

        return new CommitMessageReadResult
        {
            FileName = fileName,
            Content = strippedContent,
        };
    }

    /// <summary>
    /// Parses filename in format: storyId_signature_yyyyMMdd.txt
    /// Returns metadata with parsed fields or nulls if unparseable.
    /// </summary>
    private static CommitMessageMetadata ParseFilename(string fileName, string filePath)
    {
        // Pattern: <storyId>_<signature>_<yyyyMMdd>.txt
        var match = Regex.Match(fileName, @"^([^_]*)_([^_]*)_(\d{8})\.txt$");

        if (match.Success)
        {
            var storyId = match.Groups[1].Value;
            var signature = match.Groups[2].Value;
            var dateStr = match.Groups[3].Value;

            var isParsed = DateTime.TryParseExact(
                dateStr,
                "yyyyMMdd",
                System.Globalization.CultureInfo.InvariantCulture,
                System.Globalization.DateTimeStyles.None,
                out var date);

            return new CommitMessageMetadata
            {
                FileName = fileName,
                StoryId = string.IsNullOrEmpty(storyId) ? null : storyId,
                Signature = string.IsNullOrEmpty(signature) ? null : signature,
                Date = isParsed ? date : null,
                FilePath = filePath,
            };
        }

        // Unparseable filename.
        return new CommitMessageMetadata
        {
            FileName = fileName,
            StoryId = null,
            Signature = null,
            Date = null,
            FilePath = filePath,
        };
    }

    /// <summary>
    /// Strips #commit: header line and following blank line from content.
    /// </summary>
    private static string StripCommitHeader(string content)
    {
        if (string.IsNullOrWhiteSpace(content))
        {
            return content;
        }

        var lines = content.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
        var startIndex = 0;

        // Remove #commit: line.
        if (lines.Length > 0 && lines[0].StartsWith(CommitHeaderPrefix))
        {
            startIndex = 1;
        }

        // Remove following blank line.
        if (startIndex < lines.Length && string.IsNullOrWhiteSpace(lines[startIndex]))
        {
            startIndex++;
        }

        if (startIndex >= lines.Length)
        {
            return string.Empty;
        }

        return string.Join(Environment.NewLine, lines[startIndex..]);
    }
}
