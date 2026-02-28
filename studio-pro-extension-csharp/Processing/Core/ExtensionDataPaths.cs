using System.Reflection;

namespace AutoCommitMessage;

internal static class ExtensionDataPaths
{
    private const string DataRootEnvironmentVariable = "MENDIX_GIT_DATA_ROOT";
    private const string DataRootMetadataKey = "MendixDataRoot";
    private const string DataRootFolderName = "mendix-data";
    private const string RawChangesFolderName = "raw-changes";
    private const string AppOverviewFolderName = "app-overview";
    private const string CommitMessagesFolderName = "Commit messages";

    private static readonly string? BuildConfiguredDataRoot = ResolveBuildConfiguredDataRoot();

    public static string DataRoot => ResolveDataRoot(Environment.CurrentDirectory);
    public static string ExportFolder => Path.Combine(DataRoot, RawChangesFolderName);
    public static string ProcessedFolder => Path.Combine(DataRoot, "processed");
    public static string ErrorsFolder => Path.Combine(DataRoot, "errors");
    public static string StructuredFolder => Path.Combine(DataRoot, AppOverviewFolderName);
    public static string DumpsFolder => Path.Combine(DataRoot, "dumps");

    public static string ResolveDataRoot(string projectPath, string? dataRootBasePath = null)
    {
        if (!string.IsNullOrWhiteSpace(dataRootBasePath))
        {
            return NormalizeDataRootPath(dataRootBasePath);
        }

        if (!string.IsNullOrWhiteSpace(BuildConfiguredDataRoot))
        {
            return Path.GetFullPath(BuildConfiguredDataRoot);
        }

        var fallbackProjectPath = string.IsNullOrWhiteSpace(projectPath)
            ? Environment.CurrentDirectory
            : projectPath;
        return Path.Combine(Path.GetFullPath(fallbackProjectPath), DataRootFolderName);
    }

    public static string ResolveDefaultDataRootBasePath(string projectPath)
    {
        if (!string.IsNullOrWhiteSpace(BuildConfiguredDataRoot))
        {
            return ResolveBasePathFromDataRoot(BuildConfiguredDataRoot);
        }

        var fallbackProjectPath = string.IsNullOrWhiteSpace(projectPath)
            ? Environment.CurrentDirectory
            : projectPath;
        return Path.GetFullPath(fallbackProjectPath);
    }

    public static string GetExportFolder(string projectPath, string? dataRootBasePath = null) =>
        Path.Combine(ResolveDataRoot(projectPath, dataRootBasePath), RawChangesFolderName);

    public static string GetProcessedFolder(string projectPath, string? dataRootBasePath = null) =>
        Path.Combine(ResolveDataRoot(projectPath, dataRootBasePath), "processed");

    public static string GetErrorsFolder(string projectPath, string? dataRootBasePath = null) =>
        Path.Combine(ResolveDataRoot(projectPath, dataRootBasePath), "errors");

    public static string GetStructuredFolder(string projectPath, string? dataRootBasePath = null) =>
        Path.Combine(ResolveDataRoot(projectPath, dataRootBasePath), AppOverviewFolderName);

    public static string GetDumpsFolder(string projectPath, string? dataRootBasePath = null) =>
        Path.Combine(ResolveDataRoot(projectPath, dataRootBasePath), "dumps");

    public static string GetCommitMessagesFolder(string? commitMessagesBasePath, string projectPath)
    {
        var basePath = !string.IsNullOrWhiteSpace(commitMessagesBasePath)
            ? Path.GetFullPath(commitMessagesBasePath)
            : ResolveDefaultDataRootBasePath(projectPath);

        return Path.Combine(basePath, CommitMessagesFolderName);
    }

    private static string? ResolveBuildConfiguredDataRoot()
    {
        var fromEnvironment = Environment.GetEnvironmentVariable(DataRootEnvironmentVariable);
        if (!string.IsNullOrWhiteSpace(fromEnvironment))
        {
            return Path.GetFullPath(fromEnvironment);
        }

        var fromMetadata = Assembly
            .GetExecutingAssembly()
            .GetCustomAttributes<AssemblyMetadataAttribute>()
            .FirstOrDefault(attribute =>
                string.Equals(attribute.Key, DataRootMetadataKey, StringComparison.Ordinal))
            ?.Value;

        if (!string.IsNullOrWhiteSpace(fromMetadata))
        {
            return Path.GetFullPath(fromMetadata);
        }

        return null;
    }

    private static string NormalizeDataRootPath(string basePathOrDataRoot)
    {
        var normalizedPath = Path.GetFullPath(basePathOrDataRoot);
        var folderName = new DirectoryInfo(normalizedPath).Name;
        if (string.Equals(folderName, DataRootFolderName, StringComparison.OrdinalIgnoreCase))
        {
            return normalizedPath;
        }

        return Path.Combine(normalizedPath, DataRootFolderName);
    }

    private static string ResolveBasePathFromDataRoot(string dataRootPath)
    {
        var normalizedDataRoot = Path.GetFullPath(dataRootPath);
        var folderName = new DirectoryInfo(normalizedDataRoot).Name;
        if (!string.Equals(folderName, DataRootFolderName, StringComparison.OrdinalIgnoreCase))
        {
            return normalizedDataRoot;
        }

        var parentDirectory = Directory.GetParent(normalizedDataRoot);
        return parentDirectory?.FullName ?? normalizedDataRoot;
    }
}
