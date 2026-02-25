namespace AutoCommitMessage;

internal static class MendixModelChangeStructurer
{
    private const string UnknownModuleName = "Unknown";

    public static IReadOnlyList<MendixModuleChangeGroup> GroupByModule(
        IReadOnlyList<MendixModelChange>? modelChanges)
    {
        if (modelChanges is null || modelChanges.Count == 0)
        {
            return Array.Empty<MendixModuleChangeGroup>();
        }

        var moduleMap = new Dictionary<string, MutableModuleBucket>(StringComparer.OrdinalIgnoreCase);

        foreach (var change in modelChanges)
        {
            var moduleName = ResolveModuleName(change.ElementName);
            if (!moduleMap.TryGetValue(moduleName, out var moduleBucket))
            {
                moduleBucket = new MutableModuleBucket(moduleName);
                moduleMap[moduleName] = moduleBucket;
            }

            switch (ResolveCategory(change.ElementType))
            {
                case ModelChangeCategory.DomainModel:
                    moduleBucket.DomainModel.Add(change);
                    break;
                case ModelChangeCategory.Microflows:
                    moduleBucket.Microflows.Add(change);
                    break;
                case ModelChangeCategory.Pages:
                    moduleBucket.Pages.Add(change);
                    break;
                case ModelChangeCategory.Nanoflows:
                    moduleBucket.Nanoflows.Add(change);
                    break;
                default:
                    moduleBucket.Resources.Add(change);
                    break;
            }
        }

        return moduleMap.Values
            .OrderBy(bucket => bucket.Module, StringComparer.OrdinalIgnoreCase)
            .Select(bucket => new MendixModuleChangeGroup(
                bucket.Module,
                OrderChanges(bucket.DomainModel),
                OrderChanges(bucket.Microflows),
                OrderChanges(bucket.Pages),
                OrderChanges(bucket.Nanoflows),
                OrderChanges(bucket.Resources)))
            .ToArray();
    }

    private static IReadOnlyList<MendixModelChange> OrderChanges(IEnumerable<MendixModelChange> changes) =>
        changes
            .OrderBy(change => change.ElementName ?? string.Empty, StringComparer.OrdinalIgnoreCase)
            .ThenBy(change => change.ChangeType ?? string.Empty, StringComparer.OrdinalIgnoreCase)
            .ThenBy(change => change.ElementType ?? string.Empty, StringComparer.OrdinalIgnoreCase)
            .ToArray();

    private static string ResolveModuleName(string? elementName)
    {
        if (string.IsNullOrWhiteSpace(elementName))
        {
            return UnknownModuleName;
        }

        var trimmed = elementName.Trim();
        var separatorIndex = trimmed.IndexOf('.');
        if (separatorIndex <= 0)
        {
            return UnknownModuleName;
        }

        var moduleName = trimmed[..separatorIndex].Trim();
        return string.IsNullOrWhiteSpace(moduleName) ? UnknownModuleName : moduleName;
    }

    private static ModelChangeCategory ResolveCategory(string? elementType)
    {
        if (string.Equals(elementType, "Entity", StringComparison.OrdinalIgnoreCase))
        {
            return ModelChangeCategory.DomainModel;
        }

        if (string.Equals(elementType, "Microflow", StringComparison.OrdinalIgnoreCase))
        {
            return ModelChangeCategory.Microflows;
        }

        if (string.Equals(elementType, "Page", StringComparison.OrdinalIgnoreCase))
        {
            return ModelChangeCategory.Pages;
        }

        if (string.Equals(elementType, "Nanoflow", StringComparison.OrdinalIgnoreCase))
        {
            return ModelChangeCategory.Nanoflows;
        }

        return ModelChangeCategory.Resources;
    }

    private enum ModelChangeCategory
    {
        DomainModel,
        Microflows,
        Pages,
        Nanoflows,
        Resources,
    }

    private sealed class MutableModuleBucket(string module)
    {
        public string Module { get; } = module;
        public List<MendixModelChange> DomainModel { get; } = new();
        public List<MendixModelChange> Microflows { get; } = new();
        public List<MendixModelChange> Pages { get; } = new();
        public List<MendixModelChange> Nanoflows { get; } = new();
        public List<MendixModelChange> Resources { get; } = new();
    }
}
