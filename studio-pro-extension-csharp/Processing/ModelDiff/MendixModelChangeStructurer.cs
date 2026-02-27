using System.Text.RegularExpressions;

namespace AutoCommitMessage;

internal static class MendixModelChangeStructurer
{
    private const string UnknownModuleName = "Unknown";
    private const string NonPersistentEntityElementType = "NonPersistentEntity";

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

            if (IsAssociationChange(change))
            {
                moduleBucket.Associations.Add(change);
                continue;
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

        foreach (var moduleBucket in moduleMap.Values)
        {
            PromoteAssociationsToDomainModel(moduleBucket);
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

    private static void PromoteAssociationsToDomainModel(MutableModuleBucket moduleBucket)
    {
        if (moduleBucket.Associations.Count == 0)
        {
            return;
        }

        var domainEntityIndexByName = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        for (var index = 0; index < moduleBucket.DomainModel.Count; index++)
        {
            var domainChange = moduleBucket.DomainModel[index];
            if (!IsDomainEntityType(domainChange.ElementType))
            {
                continue;
            }

            var key = (domainChange.ElementName ?? string.Empty).Trim();
            if (key.Length == 0 || domainEntityIndexByName.ContainsKey(key))
            {
                continue;
            }

            domainEntityIndexByName[key] = index;
        }

        var summaryByParentEntity = new Dictionary<string, AssociationSummaryBucket>(StringComparer.OrdinalIgnoreCase);
        foreach (var associationChange in moduleBucket.Associations)
        {
            if (!TryParseAssociationSummary(associationChange, out var parentEntityName, out var summaryText))
            {
                moduleBucket.Resources.Add(associationChange);
                continue;
            }

            if (!summaryByParentEntity.TryGetValue(parentEntityName, out var summaryBucket))
            {
                summaryBucket = new AssociationSummaryBucket();
                summaryByParentEntity[parentEntityName] = summaryBucket;
            }

            summaryBucket.Add(associationChange.ChangeType, summaryText);
        }

        foreach (var (parentEntityName, summaryBucket) in summaryByParentEntity)
        {
            var associationDetails = summaryBucket.ToDetails();
            if (string.IsNullOrWhiteSpace(associationDetails))
            {
                continue;
            }

            if (domainEntityIndexByName.TryGetValue(parentEntityName, out var domainEntityIndex))
            {
                var existingEntityChange = moduleBucket.DomainModel[domainEntityIndex];
                moduleBucket.DomainModel[domainEntityIndex] = existingEntityChange with
                {
                    Details = MergeDetails(existingEntityChange.Details, associationDetails),
                };
                continue;
            }

            moduleBucket.DomainModel.Add(new MendixModelChange(
                "Modified",
                "Entity",
                parentEntityName,
                associationDetails));
        }

        moduleBucket.Associations.Clear();
    }

    private static bool TryParseAssociationSummary(
        MendixModelChange associationChange,
        out string parentEntityName,
        out string summaryText)
    {
        parentEntityName = string.Empty;
        summaryText = string.Empty;

        if (!IsAssociationChange(associationChange))
        {
            return false;
        }

        var details = associationChange.Details ?? string.Empty;
        var parsedParentName = ExtractAssociationField(details, "parent");
        if (string.IsNullOrWhiteSpace(parsedParentName))
        {
            return false;
        }

        var compactAssociationText = ExtractCompactAssociationText(details);
        if (string.IsNullOrWhiteSpace(compactAssociationText))
        {
            var parsedChildName = ExtractAssociationField(details, "child");
            if (string.IsNullOrWhiteSpace(parsedChildName))
            {
                return false;
            }

            var associationType = ExtractAssociationField(details, "type");
            var associationOwner = ExtractAssociationField(details, "owner");
            var storageFormat = ExtractAssociationField(details, "storageFormat");

            var associationCardinality = ResolveAssociationCardinality(
                associationType,
                associationOwner,
                fromParentPerspective: true);

            var metadata = new List<string>();
            if (!string.IsNullOrWhiteSpace(associationType) &&
                !string.Equals(associationType, "Reference", StringComparison.OrdinalIgnoreCase))
            {
                metadata.Add($"type={associationType}");
            }

            if (!string.IsNullOrWhiteSpace(associationOwner) &&
                !string.Equals(associationOwner, "Default", StringComparison.OrdinalIgnoreCase))
            {
                metadata.Add($"owner={associationOwner}");
            }

            if (!string.IsNullOrWhiteSpace(storageFormat) &&
                !string.Equals(storageFormat, "Table", StringComparison.OrdinalIgnoreCase))
            {
                metadata.Add($"storageFormat={storageFormat}");
            }

            compactAssociationText = $"[{associationCardinality}] {ShortName(parsedChildName)}";
            if (metadata.Count > 0)
            {
                compactAssociationText = $"{compactAssociationText} ({string.Join(", ", metadata)})";
            }
        }

        parentEntityName = parsedParentName.Trim();
        summaryText = NormalizeInlineText(compactAssociationText);
        return !string.IsNullOrWhiteSpace(summaryText);
    }

    private static string? ExtractCompactAssociationText(string details)
    {
        if (string.IsNullOrWhiteSpace(details))
        {
            return null;
        }

        var equalsMatch = Regex.Match(
            details,
            @"\bassociation\s*=\s*(?<value>[^;]+)",
            RegexOptions.IgnoreCase);
        if (equalsMatch.Success)
        {
            return equalsMatch.Groups["value"].Value.Trim();
        }

        var legacyMatch = Regex.Match(
            details,
            @"\bassociation\s*:\s*(?<value>[^;]+)",
            RegexOptions.IgnoreCase);
        if (!legacyMatch.Success)
        {
            return null;
        }

        var legacyValue = legacyMatch.Groups["value"].Value.Trim();
        return legacyValue.StartsWith("[", StringComparison.Ordinal) ? legacyValue : null;
    }

    private static string? ExtractAssociationField(string details, string fieldName)
    {
        if (string.IsNullOrWhiteSpace(details))
        {
            return null;
        }

        var match = Regex.Match(
            details,
            $@"\b{Regex.Escape(fieldName)}\s*=\s*(?<value>[^,;]+)",
            RegexOptions.IgnoreCase);
        if (!match.Success)
        {
            return null;
        }

        var value = match.Groups["value"].Value.Trim();
        return value.Length == 0 ? null : value;
    }

    private static string ResolveAssociationCardinality(
        string? associationType,
        string? associationOwner,
        bool fromParentPerspective)
    {
        if (string.Equals(associationType, "ReferenceSet", StringComparison.OrdinalIgnoreCase))
        {
            return "*-*";
        }

        if (string.Equals(associationType, "Reference", StringComparison.OrdinalIgnoreCase))
        {
            if (string.Equals(associationOwner, "Both", StringComparison.OrdinalIgnoreCase))
            {
                return "1-1";
            }

            return fromParentPerspective ? "*-1" : "1-*";
        }

        return "1-1";
    }

    private static string MergeDetails(string? primary, string secondary)
    {
        var normalizedPrimary = string.IsNullOrWhiteSpace(primary) ? string.Empty : primary.Trim();
        var normalizedSecondary = string.IsNullOrWhiteSpace(secondary) ? string.Empty : secondary.Trim();

        if (normalizedPrimary.Length == 0)
        {
            return normalizedSecondary;
        }

        if (normalizedSecondary.Length == 0)
        {
            return normalizedPrimary;
        }

        if (normalizedPrimary.Contains(normalizedSecondary, StringComparison.OrdinalIgnoreCase))
        {
            return normalizedPrimary;
        }

        return $"{normalizedPrimary}; {normalizedSecondary}";
    }

    private static string NormalizeInlineText(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        return string.Join(
            " ",
            value.Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries));
    }

    private static bool IsAssociationChange(MendixModelChange change) =>
        string.Equals(change.ElementType, "Association", StringComparison.OrdinalIgnoreCase);

    private static bool IsDomainEntityType(string? elementType) =>
        string.Equals(elementType, "Entity", StringComparison.OrdinalIgnoreCase) ||
        string.Equals(elementType, NonPersistentEntityElementType, StringComparison.OrdinalIgnoreCase);

    private static string ShortName(string value)
    {
        var trimmed = value.Trim();
        var dotIndex = trimmed.LastIndexOf('.');
        return dotIndex >= 0 && dotIndex < trimmed.Length - 1
            ? trimmed[(dotIndex + 1)..]
            : trimmed;
    }

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
        if (string.Equals(elementType, "Entity", StringComparison.OrdinalIgnoreCase) ||
            string.Equals(elementType, NonPersistentEntityElementType, StringComparison.OrdinalIgnoreCase))
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
        public List<MendixModelChange> Associations { get; } = new();
        public List<MendixModelChange> Resources { get; } = new();
    }

    private sealed class AssociationSummaryBucket
    {
        private readonly HashSet<string> _added = new(StringComparer.OrdinalIgnoreCase);
        private readonly HashSet<string> _modified = new(StringComparer.OrdinalIgnoreCase);
        private readonly HashSet<string> _removed = new(StringComparer.OrdinalIgnoreCase);

        public void Add(string? changeType, string summary)
        {
            if (string.IsNullOrWhiteSpace(summary))
            {
                return;
            }

            if (string.Equals(changeType, "Added", StringComparison.OrdinalIgnoreCase))
            {
                _added.Add(summary);
                return;
            }

            if (string.Equals(changeType, "Deleted", StringComparison.OrdinalIgnoreCase))
            {
                _removed.Add(summary);
                return;
            }

            _modified.Add(summary);
        }

        public string ToDetails()
        {
            var sections = new List<string>();
            AddSection(sections, "added", _added);
            AddSection(sections, "modified", _modified);
            AddSection(sections, "removed", _removed);
            return string.Join("; ", sections);
        }

        private static void AddSection(
            ICollection<string> sections,
            string label,
            IReadOnlyCollection<string> values)
        {
            if (values.Count == 0)
            {
                return;
            }

            var orderedValues = values
                .OrderBy(value => value, StringComparer.OrdinalIgnoreCase)
                .ToArray();
            sections.Add($"associations {label} ({orderedValues.Length}): {string.Join(", ", orderedValues)}");
        }
    }
}
