using System.Reflection;

namespace AutoCommitMessage;

internal static class ExtensionDataPaths
{
    private const string DataRootEnvironmentVariable = "MENDIX_GIT_DATA_ROOT";
    private const string DataRootMetadataKey = "MendixDataRoot";

    public static readonly string DataRoot = ResolveDataRoot();
    public static readonly string ExportFolder = Path.Combine(DataRoot, "exports");
    public static readonly string ProcessedFolder = Path.Combine(DataRoot, "processed");
    public static readonly string ErrorsFolder = Path.Combine(DataRoot, "errors");
    public static readonly string StructuredFolder = Path.Combine(DataRoot, "structured");
    public static readonly string DumpsFolder = Path.Combine(DataRoot, "dumps");

    private static string ResolveDataRoot()
    {
        var fromEnvironment = Environment.GetEnvironmentVariable(DataRootEnvironmentVariable);
        if (!string.IsNullOrWhiteSpace(fromEnvironment))
        {
            return Path.GetFullPath(fromEnvironment);
        }

        var fromMetadata = Assembly
            .GetExecutingAssembly()
            .GetCustomAttributes<AssemblyMetadataAttribute>()
            .FirstOrDefault(attribute => string.Equals(attribute.Key, DataRootMetadataKey, StringComparison.Ordinal))
            ?.Value;

        if (!string.IsNullOrWhiteSpace(fromMetadata))
        {
            return Path.GetFullPath(fromMetadata);
        }

        return Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "MendixAutoCommitMessage",
            "mendix-data");
    }
}
