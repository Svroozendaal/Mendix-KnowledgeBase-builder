using System.Text.RegularExpressions;

namespace AutoCommitMessage;

internal static class MendixModelChangeDisplayTextFormatter
{
    private static readonly IReadOnlyDictionary<string, string> Abbreviations =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["Entity"] = string.Empty,
            ["NonPersistentEntity"] = "NP",
            ["Microflow"] = "MF",
            ["Nanoflow"] = "NF",
            ["Page"] = "PG",
            ["Snippet"] = string.Empty,
            ["Constant"] = "Constant",
            ["Queue"] = "TQ",
            ["Enumeration"] = "ENUM",
            ["ExportMapping"] = "EM",
            ["ImportMapping"] = "IM",
            ["Workflow"] = "WF",
        };

    public static string Format(MendixModelChange change)
    {
        ArgumentNullException.ThrowIfNull(change);
        return Format(change.ChangeType, change.ElementType, change.ElementName, change.Details);
    }

    public static string Format(
        string? changeType,
        string? elementType,
        string? elementName,
        string? details)
    {
        var normalizedChangeType = (changeType ?? string.Empty).Trim();
        var normalizedElementType = (elementType ?? string.Empty).Trim();
        var normalizedElementName = NormalizeElementName(elementName);
        var normalizedDetails = ResolveDetails(normalizedChangeType, normalizedElementType, details);

        var changeMarker = ResolveChangeMarker(normalizedChangeType, normalizedElementType);
        var abbreviation = ResolveAbbreviation(normalizedElementType);

        var formatted = $"{changeMarker} {abbreviation} {normalizedElementName} : {normalizedDetails}";
        return CollapseWhitespace(formatted);
    }

    private static string NormalizeElementName(string? elementName)
    {
        var value = (elementName ?? string.Empty).Trim();
        if (value.Length == 0)
        {
            return "<unnamed>";
        }

        var separatorIndex = value.IndexOf('.');
        if (separatorIndex > 0 && separatorIndex < value.Length - 1)
        {
            var unprefixed = value[(separatorIndex + 1)..].Trim();
            if (unprefixed.Length > 0)
            {
                return unprefixed;
            }
        }

        return value;
    }

    private static string ResolveAbbreviation(string elementType) =>
        Abbreviations.TryGetValue(elementType, out var abbreviation) ? abbreviation : string.Empty;

    private static string ResolveDetails(string changeType, string elementType, string? details)
    {
        if (string.Equals(changeType, "Deleted", StringComparison.OrdinalIgnoreCase) &&
            IsFlowElementType(elementType))
        {
            return "deleted";
        }

        if (!string.IsNullOrWhiteSpace(details))
        {
            var normalizedDetails = details.Trim();
            var compactFlowDetails = TryBuildCompactFlowDetails(changeType, elementType, normalizedDetails);
            var selectedDetails = string.IsNullOrWhiteSpace(compactFlowDetails) ? normalizedDetails : compactFlowDetails;
            var filteredDetails = RemoveZeroOnlyDetailSegments(selectedDetails);
            if (!string.IsNullOrWhiteSpace(filteredDetails))
            {
                return filteredDetails;
            }

            if (IsEntityElementType(elementType))
            {
                return string.Empty;
            }
        }

        if (IsEntityElementType(elementType))
        {
            return string.Empty;
        }

        if (string.Equals(changeType, "Added", StringComparison.OrdinalIgnoreCase))
        {
            return "added";
        }

        if (string.Equals(changeType, "Modified", StringComparison.OrdinalIgnoreCase))
        {
            return "modified";
        }

        if (string.Equals(changeType, "Deleted", StringComparison.OrdinalIgnoreCase))
        {
            return "deleted";
        }

        return "changed";
    }

    private static string RemoveZeroOnlyDetailSegments(string details)
    {
        if (string.IsNullOrWhiteSpace(details))
        {
            return string.Empty;
        }

        var filteredSegments = details
            .Split(';', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .Where(segment => !IsZeroOnlyDetailSegment(segment))
            .Select(segment => segment.Trim())
            .Where(segment => segment.Length > 0)
            .ToArray();

        return filteredSegments.Length == 0
            ? string.Empty
            : string.Join("; ", filteredSegments);
    }

    private static bool IsZeroOnlyDetailSegment(string segment)
    {
        if (string.IsNullOrWhiteSpace(segment))
        {
            return true;
        }

        var numberMatches = Regex.Matches(segment, @"\b\d+\b");
        if (numberMatches.Count == 0)
        {
            return false;
        }

        foreach (Match numberMatch in numberMatches)
        {
            if (!int.TryParse(numberMatch.Value, out var parsed) || parsed != 0)
            {
                return false;
            }
        }

        return true;
    }

    private static string? TryBuildCompactFlowDetails(string changeType, string elementType, string details)
    {
        if (!IsFlowElementType(elementType) ||
            (!details.Contains("actions delta:", StringComparison.OrdinalIgnoreCase) &&
             !details.Contains("decisions delta:", StringComparison.OrdinalIgnoreCase)))
        {
            return null;
        }

        var isDeletedFlow = string.Equals(changeType, "Deleted", StringComparison.OrdinalIgnoreCase);
        if (isDeletedFlow)
        {
            return "deleted";
        }

        var addedItems = BuildActionBucketItems(details, "added");
        var modifiedItems = BuildActionBucketItems(details, "modified", normalizeModifiedDescriptor: true);
        var removedItems = BuildActionBucketItems(details, "removed");
        var loopDescriptors = ParseLoopDescriptors(details);
        var decisionCaptions = ParseDecisionCaptions(details);
        var returnChangeDetails = ParseReturnChangeDetails(details);

        var sections = new List<string>();
        if (addedItems.Count > 0)
        {
            sections.Add($"added: {string.Join(", ", addedItems)}");
        }

        if (modifiedItems.Count > 0)
        {
            sections.Add($"modified: {string.Join(", ", modifiedItems)}");
        }

        if (removedItems.Count > 0)
        {
            sections.Add($"removed: {string.Join(", ", removedItems)}");
        }

        if (loopDescriptors.Count > 0)
        {
            sections.Add($"loops: {string.Join(", ", loopDescriptors)}");
        }

        if (decisionCaptions.Count > 0)
        {
            sections.Add($"decisions: {string.Join(", ", decisionCaptions)}");
        }

        if (!string.IsNullOrWhiteSpace(returnChangeDetails))
        {
            sections.Add(returnChangeDetails);
        }

        if (sections.Count == 0)
        {
            return null;
        }

        return string.Join("; ", sections);
    }

    private static List<string> BuildActionBucketItems(
        string details,
        string bucket,
        bool normalizeModifiedDescriptor = false)
    {
        var actionTypes = ParseActionTypeNames(details, bucket);
        var anchor = $"{bucket} action details:";
        var actionDetails = ParseActionDetailEntries(details, anchor, normalizeModifiedDescriptor);

        var items = new List<string>();
        var seenItems = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var coveredTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var actionDetail in actionDetails)
        {
            coveredTypes.Add(actionDetail.ActionType);
            var phrase = BuildSimpleActionPhrase(actionDetail.ActionType, actionDetail.DescriptorText);
            AddUniqueIfNotEmpty(items, seenItems, phrase);
        }

        foreach (var actionType in actionTypes)
        {
            if (coveredTypes.Contains(actionType))
            {
                continue;
            }

            var phrase = BuildSimpleActionPhrase(actionType, descriptor: null);
            AddUniqueIfNotEmpty(items, seenItems, phrase);
        }

        return items;
    }

    private static string BuildSimpleActionPhrase(string actionType, string? descriptor)
    {
        switch (actionType)
        {
            case "ShowPageAction":
            {
                var page = ParseShowPageTarget(descriptor);
                return string.IsNullOrWhiteSpace(page) ? "show page" : $"show page {page}";
            }

            case "CreateListAction":
            {
                var listEntity = ParseCreateListEntity(descriptor);
                return string.IsNullOrWhiteSpace(listEntity) ? "create list" : $"create list {listEntity}";
            }

            case "DeleteAction":
            {
                var target = ParseDeleteTarget(descriptor);
                if (string.IsNullOrWhiteSpace(target))
                {
                    return "delete object";
                }

                if (target.EndsWith("_List", StringComparison.OrdinalIgnoreCase))
                {
                    return $"delete list {ShortName(target[..^"_List".Length])}";
                }

                return $"delete object {ShortName(target)}";
            }

            case "CreateObjectAction":
            {
                var entity = ParseCreateObjectEntity(descriptor);
                return string.IsNullOrWhiteSpace(entity) ? "create object" : $"create object {entity}";
            }

            case "ChangeObjectAction":
            {
                var target = ParseChangeObjectVariable(descriptor);
                return string.IsNullOrWhiteSpace(target) ? "change object" : $"change object {ShortName(target)}";
            }

            case "ChangeListAction":
            {
                var target = ParseChangeListVariable(descriptor);
                if (string.IsNullOrWhiteSpace(target))
                {
                    return "change list";
                }

                if (target.EndsWith("_List", StringComparison.OrdinalIgnoreCase))
                {
                    return $"change list {ShortName(target[..^"_List".Length])}";
                }

                return $"change list {ShortName(target)}";
            }

            case "RetrieveAction":
            {
                var retrievePhrase = BuildRetrievePhrase(descriptor);
                return string.IsNullOrWhiteSpace(retrievePhrase) ? "retrieve" : retrievePhrase;
            }

            case "CommitAction":
            {
                var commitTarget = ParseCommitTarget(descriptor);
                if (string.IsNullOrWhiteSpace(commitTarget))
                {
                    return "commit";
                }

                if (commitTarget.EndsWith("_List", StringComparison.OrdinalIgnoreCase))
                {
                    return $"commit list {ShortName(commitTarget[..^"_List".Length])}";
                }

                return $"commit object {ShortName(commitTarget)}";
            }

            case "MicroflowCallAction":
            {
                var target = ParseCallTarget(descriptor, "microflow");
                return string.IsNullOrWhiteSpace(target) ? "call MF" : $"call MF {target}";
            }

            case "NanoflowCallAction":
            {
                var target = ParseCallTarget(descriptor, "nanoflow");
                return string.IsNullOrWhiteSpace(target) ? "call NF" : $"call NF {target}";
            }

            case "ShowMessageAction":
                return "show message";

            case "CloseFormAction":
                return "close page";

            default:
                return HumanizeActionType(actionType);
        }
    }

    private static string NormalizeActionTypeName(string actionType)
    {
        var trimmed = actionType.Trim();
        if (trimmed.EndsWith("Action", StringComparison.OrdinalIgnoreCase))
        {
            return trimmed[..^"Action".Length];
        }

        return trimmed;
    }

    private static List<string> ParseDecisionCaptions(string details)
    {
        var captions = new List<string>();
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var anchor in new[] { "decisions added (", "decisions removed (", "decisions modified (" })
        {
            var segment = ExtractSegment(
                details,
                anchor,
                "; decisions added (",
                "; decisions removed (",
                "; decisions modified (",
                "; loops delta:",
                "; actions delta:");
            if (string.IsNullOrWhiteSpace(segment))
            {
                continue;
            }

            var colonIndex = segment.IndexOf(':');
            if (colonIndex >= 0 && colonIndex < segment.Length - 1)
            {
                segment = segment[(colonIndex + 1)..].Trim();
            }

            foreach (var token in segment.Split('|', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                if (token.StartsWith("+", StringComparison.Ordinal))
                {
                    continue;
                }

                var caption = ExtractDecisionCaption(token);
                AddUniqueIfNotEmpty(captions, seen, caption);
            }
        }

        return captions;
    }

    private static List<string> ParseLoopDescriptors(string details)
    {
        var loops = new List<string>();
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var anchor in new[] { "loops added (", "loops removed (", "loops modified (" })
        {
            var segment = ExtractSegment(
                details,
                anchor,
                "; loops added (",
                "; loops removed (",
                "; loops modified (",
                "; decisions delta:",
                "; actions delta:");
            if (string.IsNullOrWhiteSpace(segment))
            {
                continue;
            }

            var colonIndex = segment.IndexOf(':');
            if (colonIndex >= 0 && colonIndex < segment.Length - 1)
            {
                segment = segment[(colonIndex + 1)..].Trim();
            }

            foreach (var token in segment.Split('|', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                if (token.StartsWith("+", StringComparison.Ordinal))
                {
                    continue;
                }

                var loopDescriptor = NormalizeLoopDescriptor(token);
                AddUniqueIfNotEmpty(loops, seen, loopDescriptor);
            }
        }

        return loops;
    }

    private static string? NormalizeLoopDescriptor(string token)
    {
        var working = token.Trim();
        if (working.Length == 0)
        {
            return null;
        }

        var arrowIndex = working.LastIndexOf("->", StringComparison.Ordinal);
        if (arrowIndex >= 0 && arrowIndex < working.Length - 2)
        {
            working = working[(arrowIndex + 2)..].Trim();
        }

        working = working.Trim(' ', ',', ';');
        return working.Length == 0 ? null : NormalizeInlineToken(working);
    }

    private static string? ParseReturnChangeDetails(string details)
    {
        var hasReturnTypeChange = Regex.IsMatch(details, @"\bmicroflowReturnType\b", RegexOptions.IgnoreCase);

        string? returnVariableSegment = null;
        var returnVariableMatch = Regex.Match(
            details,
            @"\breturnVariableName\s*(?<from>[^;]*?)\s*->\s*(?<to>[^;]+)",
            RegexOptions.IgnoreCase);
        if (returnVariableMatch.Success)
        {
            var previous = returnVariableMatch.Groups["from"].Value.Trim();
            var current = returnVariableMatch.Groups["to"].Value.Trim();
            var normalizedCurrent = NormalizeInlineToken(current);
            if (normalizedCurrent.Length > 0)
            {
                returnVariableSegment = string.IsNullOrWhiteSpace(previous)
                    ? $"variable {normalizedCurrent}"
                    : $"variable {NormalizeInlineToken(previous)}->{normalizedCurrent}";
            }
        }

        if (!hasReturnTypeChange && string.IsNullOrWhiteSpace(returnVariableSegment))
        {
            return null;
        }

        if (hasReturnTypeChange && string.IsNullOrWhiteSpace(returnVariableSegment))
        {
            return "return: type changed";
        }

        if (!hasReturnTypeChange && !string.IsNullOrWhiteSpace(returnVariableSegment))
        {
            return $"return: {returnVariableSegment}";
        }

        return $"return: type changed, {returnVariableSegment}";
    }

    private static string? ExtractDecisionCaption(string token)
    {
        var working = token.Trim();
        if (working.Length == 0)
        {
            return null;
        }

        var arrowIndex = working.LastIndexOf("->", StringComparison.Ordinal);
        if (arrowIndex >= 0 && arrowIndex < working.Length - 2)
        {
            working = working[(arrowIndex + 2)..].Trim();
        }

        var expressionIndex = working.IndexOf("expression=", StringComparison.OrdinalIgnoreCase);
        if (expressionIndex >= 0)
        {
            working = working[..expressionIndex].Trim();
        }

        working = working.Trim(' ', ',', ';');
        return working.Length == 0 ? null : NormalizeInlineToken(working);
    }

    private static string? ParseCallTarget(string? descriptor, string flowKind)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(
            descriptor,
            $@"\bcall\s+{Regex.Escape(flowKind)}\s+(?<target>[^\s\-\(]+)",
            RegexOptions.IgnoreCase);
        if (match.Success)
        {
            return ShortName(match.Groups["target"].Value);
        }

        var arrowMatch = Regex.Match(
            descriptor,
            @"->\s*(?<target>[A-Za-z0-9_\.]+)",
            RegexOptions.IgnoreCase);
        if (arrowMatch.Success)
        {
            return ShortName(arrowMatch.Groups["target"].Value);
        }

        return null;
    }

    private static string? ParseShowPageTarget(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(descriptor, @"\bshow\s+page\s+(?<target>[^\s\-\(]+)", RegexOptions.IgnoreCase);
        return match.Success ? ShortName(match.Groups["target"].Value) : null;
    }

    private static string? ParseCreateListEntity(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(descriptor, @"\bcreate\s+list\s+(?<target>[^\s\(\;]+)", RegexOptions.IgnoreCase);
        if (!match.Success)
        {
            return null;
        }

        var target = match.Groups["target"].Value;
        if (target.EndsWith("_List", StringComparison.OrdinalIgnoreCase))
        {
            target = target[..^"_List".Length];
        }

        return ShortName(target);
    }

    private static string? ParseDeleteTarget(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(descriptor, @"\bdelete\s+(?<target>[^\s\(\;]+)", RegexOptions.IgnoreCase);
        return match.Success ? match.Groups["target"].Value : null;
    }

    private static string? BuildRetrievePhrase(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var outputMatch = Regex.Match(descriptor, @"\bretrieve\s+(?<output>[^\s\(\;]+)", RegexOptions.IgnoreCase);
        var output = outputMatch.Success ? outputMatch.Groups["output"].Value.Trim() : string.Empty;

        var normalizedOutputTarget = NormalizeRetrieveTarget(output);
        var fromMatch = Regex.Match(descriptor, @"\bfrom\s+(?<entity>[A-Za-z0-9_\.]+)", RegexOptions.IgnoreCase);
        var fromEntity = fromMatch.Success ? ShortName(fromMatch.Groups["entity"].Value) : null;
        var target = !string.IsNullOrWhiteSpace(fromEntity) ? fromEntity : normalizedOutputTarget;

        var hasListSignal =
            descriptor.Contains("retrieveType=List", StringComparison.OrdinalIgnoreCase) ||
            descriptor.Contains("retrieveType=All", StringComparison.OrdinalIgnoreCase) ||
            output.EndsWith("_List", StringComparison.OrdinalIgnoreCase);
        var hasObjectSignal =
            descriptor.Contains("retrieveType=First", StringComparison.OrdinalIgnoreCase) ||
            descriptor.Contains("retrieveType=One", StringComparison.OrdinalIgnoreCase) ||
            (!string.IsNullOrWhiteSpace(output) &&
             !output.EndsWith("_List", StringComparison.OrdinalIgnoreCase) &&
             !string.Equals(output, "object(s)", StringComparison.OrdinalIgnoreCase));

        if (string.IsNullOrWhiteSpace(target))
        {
            return "retrieve";
        }

        if (hasListSignal)
        {
            return $"retrieve list {target}";
        }

        if (hasObjectSignal)
        {
            return $"retrieve object {target}";
        }

        return $"retrieve {target}";
    }

    private static string? NormalizeRetrieveTarget(string value)
    {
        if (string.IsNullOrWhiteSpace(value) ||
            string.Equals(value, "object(s)", StringComparison.OrdinalIgnoreCase))
        {
            return null;
        }

        var normalized = value.Trim();
        if (normalized.EndsWith("_List", StringComparison.OrdinalIgnoreCase))
        {
            normalized = normalized[..^"_List".Length];
        }

        return ShortName(normalized);
    }

    private static string NormalizeInlineToken(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        return value.Replace('\r', ' ').Replace('\n', ' ').Trim();
    }

    private static void AddUniqueIfNotEmpty(
        ICollection<string> values,
        ISet<string> seen,
        string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return;
        }

        var normalized = value.Trim();
        if (seen.Add(normalized))
        {
            values.Add(normalized);
        }
    }

    private static Dictionary<string, string> BuildActionDescriptorLookup(
        IEnumerable<ActionDetailEntry> addedDetails,
        IEnumerable<ActionDetailEntry> modifiedDetails)
    {
        var lookup = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        foreach (var entry in modifiedDetails)
        {
            if (string.IsNullOrWhiteSpace(entry.DescriptorText) ||
                string.Equals(entry.DescriptorText, "payload changed", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(entry.DescriptorText, "action payload changed", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            lookup[entry.ActionType] = entry.DescriptorText;
        }

        foreach (var entry in addedDetails)
        {
            if (string.IsNullOrWhiteSpace(entry.DescriptorText) ||
                string.Equals(entry.DescriptorText, "payload changed", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(entry.DescriptorText, "action payload changed", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            lookup[entry.ActionType] = entry.DescriptorText;
        }

        return lookup;
    }

    private static ActionDeltaCounts ParseActionDeltaCounts(string details)
    {
        var match = Regex.Match(
            details,
            @"actions\s+delta:\s*added\s*(?<added>\d+)\s*,\s*removed\s*(?<removed>\d+)\s*,\s*modified\s*(?<modified>\d+)",
            RegexOptions.IgnoreCase);
        if (!match.Success)
        {
            return new ActionDeltaCounts(0, 0, 0);
        }

        var added = ParseIntOrDefault(match.Groups["added"].Value);
        var removed = ParseIntOrDefault(match.Groups["removed"].Value);
        var modified = ParseIntOrDefault(match.Groups["modified"].Value);
        return new ActionDeltaCounts(added, removed, modified);
    }

    private static int ParseIntOrDefault(string value)
    {
        return int.TryParse(value, out var parsed) ? parsed : 0;
    }

    private static List<string> ParseActionTypeNames(string details, string bucket)
    {
        var match = Regex.Match(
            details,
            $@"actions\s+{Regex.Escape(bucket)}\s*\(\d+\):\s*(?<items>[^;]+)",
            RegexOptions.IgnoreCase);
        if (!match.Success)
        {
            return new List<string>();
        }

        var names = Regex.Matches(match.Groups["items"].Value, @"(?<name>[A-Za-z][A-Za-z0-9_]+)\s+x\d+", RegexOptions.IgnoreCase)
            .Cast<Match>()
            .Select(m => m.Groups["name"].Value.Trim())
            .Where(name => name.Length > 0)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToList();

        return names;
    }

    private static List<ActionDetailEntry> ParseActionDetailEntries(
        string details,
        string anchor,
        bool normalizeModifiedDescriptor = false)
    {
        var detailSegment = ExtractSegment(
            details,
            anchor,
            "; added action details:",
            "; removed action details:",
            "; modified action details:",
            "; loops delta:",
            "; decisions delta:");
        if (string.IsNullOrWhiteSpace(detailSegment))
        {
            return new List<ActionDetailEntry>();
        }

        var entries = new List<ActionDetailEntry>();
        foreach (var token in detailSegment.Split('|', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
        {
            var separatorIndex = token.IndexOf(':');
            if (separatorIndex <= 0 || separatorIndex >= token.Length - 1)
            {
                continue;
            }

            var actionType = token[..separatorIndex].Trim();
            var descriptor = token[(separatorIndex + 1)..].Trim();
            if (actionType.Length == 0 || descriptor.Length == 0)
            {
                continue;
            }

            if (normalizeModifiedDescriptor)
            {
                var arrowIndex = descriptor.LastIndexOf("->", StringComparison.Ordinal);
                if (arrowIndex >= 0 && arrowIndex < descriptor.Length - 2)
                {
                    descriptor = descriptor[(arrowIndex + 2)..].Trim();
                }
            }

            entries.Add(new ActionDetailEntry(actionType, descriptor));
        }

        return entries;
    }

    private static string? BuildRetrieveSummary(IReadOnlyDictionary<string, string> actionDescriptors)
    {
        if (!actionDescriptors.TryGetValue("RetrieveAction", out var descriptor) ||
            string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        return BuildRetrievePhrase(descriptor);
    }

    private static string? BuildChangeSummary(IReadOnlyDictionary<string, string> actionDescriptors, string details)
    {
        if (!actionDescriptors.TryGetValue("ChangeObjectAction", out var descriptor) ||
            string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var variableMatch = Regex.Match(descriptor, @"\bchange\s+(?<variable>[^\s\(]+)", RegexOptions.IgnoreCase);
        var variableName = variableMatch.Success ? variableMatch.Groups["variable"].Value : string.Empty;

        var changedMembers = Regex.Matches(descriptor, @"(?<member>[A-Za-z0-9_\.]+)\s*=", RegexOptions.IgnoreCase)
            .Cast<Match>()
            .Select(match => ShortName(match.Groups["member"].Value))
            .Where(member => !string.IsNullOrWhiteSpace(member))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(member => member, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        var hasLoop = HasLoopSignal(details) ||
                      variableName.Contains("iterator", StringComparison.OrdinalIgnoreCase) ||
                      descriptor.Contains("iterator", StringComparison.OrdinalIgnoreCase);

        if (hasLoop)
        {
            return changedMembers.Length == 0
                ? "iterate and update"
                : $"iterate and update ({string.Join(", ", changedMembers)})";
        }

        var target = string.IsNullOrWhiteSpace(variableName) ? "object" : variableName;
        return changedMembers.Length == 0
            ? $"update {target}"
            : $"update {target} ({string.Join(", ", changedMembers)})";
    }

    private static string? BuildCreateSummary(IReadOnlyDictionary<string, string> actionDescriptors)
    {
        if (!actionDescriptors.TryGetValue("CreateObjectAction", out var descriptor) ||
            string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var entityMatch = Regex.Match(descriptor, @"\bcreate\s+(?<entity>[A-Za-z0-9_\.]+)", RegexOptions.IgnoreCase);
        if (!entityMatch.Success)
        {
            return "create object";
        }

        return $"create new {ShortName(entityMatch.Groups["entity"].Value)}";
    }

    private static string? BuildCommitSummary(IReadOnlyDictionary<string, string> actionDescriptors)
    {
        if (!actionDescriptors.TryGetValue("CommitAction", out var descriptor) ||
            string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var targetMatch = Regex.Match(descriptor, @"\bcommit\s+(?<target>[^\s\(]+)", RegexOptions.IgnoreCase);
        var commitLabel = "commit";
        if (targetMatch.Success)
        {
            var target = targetMatch.Groups["target"].Value;
            commitLabel = target.EndsWith("_List", StringComparison.OrdinalIgnoreCase)
                ? "commit list"
                : $"commit {ShortName(target)}";
        }

        var commitOptions = new List<string>();
        if (descriptor.Contains("withEvents=true", StringComparison.OrdinalIgnoreCase))
        {
            commitOptions.Add("with events");
        }

        if (descriptor.Contains("refreshInClient=false", StringComparison.OrdinalIgnoreCase))
        {
            commitOptions.Add("no client refresh");
        }
        else if (descriptor.Contains("refreshInClient=true", StringComparison.OrdinalIgnoreCase))
        {
            commitOptions.Add("client refresh");
        }

        return commitOptions.Count == 0
            ? commitLabel
            : $"{commitLabel} ({string.Join(", ", commitOptions)})";
    }

    private static IEnumerable<string> BuildVariableSummaries(
        IReadOnlyDictionary<string, string> actionDescriptors,
        IReadOnlyCollection<string> addedActionTypes,
        IReadOnlyCollection<string> modifiedActionTypes)
    {
        var summaries = new List<string>();

        if (actionDescriptors.TryGetValue("CreateVariableAction", out var createVariableDescriptor))
        {
            var name = ParseVariableName(createVariableDescriptor, "create variable");
            summaries.Add(string.IsNullOrWhiteSpace(name) ? "create variable" : $"create variable {name}");
        }
        else if (ContainsActionType(addedActionTypes, modifiedActionTypes, "CreateVariableAction"))
        {
            summaries.Add("create variable");
        }

        if (actionDescriptors.TryGetValue("ChangeVariableAction", out var changeVariableDescriptor))
        {
            var name = ParseVariableName(changeVariableDescriptor, "change variable");
            var expression = ParseVariableExpression(changeVariableDescriptor);

            if (!string.IsNullOrWhiteSpace(expression) &&
                expression.Replace(" ", string.Empty, StringComparison.Ordinal).EndsWith("+1", StringComparison.Ordinal))
            {
                summaries.Add(string.IsNullOrWhiteSpace(name) ? "increment variable" : $"increment variable {name}");
            }
            else
            {
                summaries.Add(string.IsNullOrWhiteSpace(name) ? "change variable" : $"change variable {name}");
            }
        }
        else if (ContainsActionType(addedActionTypes, modifiedActionTypes, "ChangeVariableAction"))
        {
            summaries.Add("change variable");
        }

        return summaries
            .Where(summary => !string.IsNullOrWhiteSpace(summary))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static string? ParseVariableName(string descriptor, string actionPrefix)
    {
        var match = Regex.Match(
            descriptor,
            $@"\b{Regex.Escape(actionPrefix)}\s+(?<name>[A-Za-z_][A-Za-z0-9_]*)",
            RegexOptions.IgnoreCase);
        return match.Success ? match.Groups["name"].Value : null;
    }

    private static string? ParseVariableExpression(string descriptor)
    {
        var match = Regex.Match(
            descriptor,
            @"\bchange\s+variable\s+[A-Za-z_][A-Za-z0-9_]*\s*=\s*(?<expr>.+)$",
            RegexOptions.IgnoreCase);
        return match.Success ? match.Groups["expr"].Value.Trim() : null;
    }

    private static IEnumerable<string> BuildUiActionSummaries(
        IReadOnlyCollection<string> addedActionTypes,
        IReadOnlyCollection<string> modifiedActionTypes)
    {
        var summaries = new List<string>();
        if (ContainsActionType(addedActionTypes, modifiedActionTypes, "ShowPageAction"))
        {
            summaries.Add("show page");
        }

        if (ContainsActionType(addedActionTypes, modifiedActionTypes, "ShowMessageAction"))
        {
            summaries.Add("show message");
        }

        if (ContainsActionType(addedActionTypes, modifiedActionTypes, "CloseFormAction"))
        {
            summaries.Add("close page");
        }

        return summaries;
    }

    private static bool ContainsActionType(
        IReadOnlyCollection<string> first,
        IReadOnlyCollection<string> second,
        string actionType)
    {
        return first.Contains(actionType, StringComparer.OrdinalIgnoreCase) ||
               second.Contains(actionType, StringComparer.OrdinalIgnoreCase);
    }

    private static string? BuildDecisionSummary(string details)
    {
        var decisionSegment = ExtractSegment(
            details,
            "decisions added (",
            "; decisions removed (",
            "; decisions modified (",
            "; loops delta:",
            "; actions delta:");
        if (string.IsNullOrWhiteSpace(decisionSegment))
        {
            return null;
        }

        var colonIndex = decisionSegment.IndexOf(':');
        if (colonIndex >= 0 && colonIndex < decisionSegment.Length - 1)
        {
            decisionSegment = decisionSegment[(colonIndex + 1)..].Trim();
        }

        var expressions = Regex.Matches(decisionSegment, @"expression\s*=\s*(?<expr>[^\),|]+)", RegexOptions.IgnoreCase)
            .Cast<Match>()
            .Select(match => match.Groups["expr"].Value.Trim())
            .Where(expr => expr.Length > 0)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();

        if (expressions.Length == 0)
        {
            return "decision added";
        }

        return expressions.Length == 1
            ? $"decision {expressions[0]}"
            : $"decisions {string.Join(", ", expressions)}";
    }

    private static string? BuildRemovedActionsSummary(
        IReadOnlyCollection<ActionDetailEntry> removedDetails,
        IReadOnlyCollection<string> removedActionTypes)
    {
        var phrases = new List<string>();
        var coveredActionTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var removedDetail in removedDetails)
        {
            coveredActionTypes.Add(removedDetail.ActionType);
            var phrase = BuildRemovedActionPhrase(removedDetail.ActionType, removedDetail.DescriptorText);
            phrases.AddIfNotEmpty(phrase);
        }

        foreach (var actionType in removedActionTypes)
        {
            if (coveredActionTypes.Contains(actionType))
            {
                continue;
            }

            var phrase = BuildRemovedActionPhrase(actionType, descriptor: null);
            phrases.AddIfNotEmpty(phrase);
        }

        var normalized = phrases
            .Where(phrase => !string.IsNullOrWhiteSpace(phrase))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();

        return normalized.Length == 0
            ? null
            : $"removed: {string.Join(", ", normalized)}";
    }

    private static string BuildRemovedActionPhrase(string actionType, string? descriptor)
    {
        switch (actionType)
        {
            case "CreateObjectAction":
            {
                var entity = ParseCreateObjectEntity(descriptor);
                return string.IsNullOrWhiteSpace(entity) ? "create object" : $"create object {entity}";
            }

            case "CommitAction":
            {
                var target = ParseCommitTarget(descriptor);
                if (string.IsNullOrWhiteSpace(target))
                {
                    return "commit";
                }

                if (target.EndsWith("_List", StringComparison.OrdinalIgnoreCase))
                {
                    return $"commit list {ShortName(target[..^"_List".Length])}";
                }

                return $"commit {ShortName(target)}";
            }

            case "RetrieveAction":
            {
                var retrieveSummary = BuildRetrieveSummary(new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
                {
                    ["RetrieveAction"] = descriptor ?? string.Empty,
                });

                return string.IsNullOrWhiteSpace(retrieveSummary)
                    ? "retrieve"
                    : retrieveSummary;
            }

            case "ChangeObjectAction":
            {
                var variable = ParseChangeObjectVariable(descriptor);
                return string.IsNullOrWhiteSpace(variable)
                    ? "change object"
                    : $"change object {ShortName(variable)}";
            }

            case "ChangeListAction":
            {
                var variable = ParseChangeListVariable(descriptor);
                if (string.IsNullOrWhiteSpace(variable))
                {
                    return "change list";
                }

                if (variable.EndsWith("_List", StringComparison.OrdinalIgnoreCase))
                {
                    return $"change list {ShortName(variable[..^"_List".Length])}";
                }

                return $"change list {ShortName(variable)}";
            }

            case "CreateVariableAction":
            {
                var name = ParseVariableName(descriptor ?? string.Empty, "create variable");
                return string.IsNullOrWhiteSpace(name) ? "create variable" : $"create variable {name}";
            }

            case "ChangeVariableAction":
            {
                var name = ParseVariableName(descriptor ?? string.Empty, "change variable");
                return string.IsNullOrWhiteSpace(name) ? "change variable" : $"change variable {name}";
            }

            case "ShowPageAction":
                return "show page";

            case "ShowMessageAction":
                return "show message";

            case "CloseFormAction":
                return "close page";

            default:
                return HumanizeActionType(actionType);
        }
    }

    private static string? ParseCreateObjectEntity(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(descriptor, @"\bcreate\s+(?<entity>[A-Za-z0-9_\.]+)", RegexOptions.IgnoreCase);
        return match.Success ? ShortName(match.Groups["entity"].Value) : null;
    }

    private static string? ParseCommitTarget(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(descriptor, @"\bcommit\s+(?<target>[^\s\(]+)", RegexOptions.IgnoreCase);
        return match.Success ? match.Groups["target"].Value : null;
    }

    private static string? ParseChangeObjectVariable(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(descriptor, @"\bchange\s+(?<target>[^\s\(]+)", RegexOptions.IgnoreCase);
        return match.Success ? match.Groups["target"].Value : null;
    }

    private static string? ParseChangeListVariable(string? descriptor)
    {
        if (string.IsNullOrWhiteSpace(descriptor))
        {
            return null;
        }

        var match = Regex.Match(descriptor, @"\bchange\s+(?<target>[^\s\(]+)", RegexOptions.IgnoreCase);
        return match.Success ? match.Groups["target"].Value : null;
    }

    private static string HumanizeActionType(string actionType)
    {
        if (string.IsNullOrWhiteSpace(actionType))
        {
            return "action";
        }

        var withoutSuffix = actionType.EndsWith("Action", StringComparison.OrdinalIgnoreCase)
            ? actionType[..^"Action".Length]
            : actionType;

        return Regex.Replace(withoutSuffix, "([a-z])([A-Z])", "$1 $2").ToLowerInvariant();
    }

    private static bool HasLoopSignal(string details)
    {
        var loopDeltaMatch = Regex.Match(details, @"\bloops\s+delta:\s*added\s*(?<added>\d+)", RegexOptions.IgnoreCase);
        if (loopDeltaMatch.Success && int.TryParse(loopDeltaMatch.Groups["added"].Value, out var addedCount))
        {
            return addedCount > 0;
        }

        return false;
    }

    private static bool IsFlowElementType(string elementType) =>
        string.Equals(elementType, "Microflow", StringComparison.OrdinalIgnoreCase) ||
        string.Equals(elementType, "Nanoflow", StringComparison.OrdinalIgnoreCase);

    private static bool IsEntityElementType(string elementType) =>
        string.Equals(elementType, "Entity", StringComparison.OrdinalIgnoreCase) ||
        string.Equals(elementType, "NonPersistentEntity", StringComparison.OrdinalIgnoreCase);

    private static string ResolveChangeMarker(string changeType, string elementType)
    {
        if (string.Equals(changeType, "Added", StringComparison.OrdinalIgnoreCase))
        {
            return "NEW";
        }

        if (string.Equals(changeType, "Deleted", StringComparison.OrdinalIgnoreCase) &&
            IsFlowElementType(elementType))
        {
            return "DEL";
        }

        return string.Empty;
    }

    private static string ShortName(string value)
    {
        var trimmed = value.Trim();
        var dotIndex = trimmed.LastIndexOf('.');
        return dotIndex >= 0 && dotIndex < trimmed.Length - 1
            ? trimmed[(dotIndex + 1)..]
            : trimmed;
    }

    private static string? ExtractSegment(string text, string startAnchor, params string[] endAnchors)
    {
        var startIndex = text.IndexOf(startAnchor, StringComparison.OrdinalIgnoreCase);
        if (startIndex < 0)
        {
            return null;
        }

        var contentStart = startIndex + startAnchor.Length;
        var contentEnd = text.Length;
        foreach (var endAnchor in endAnchors)
        {
            var candidateIndex = text.IndexOf(endAnchor, contentStart, StringComparison.OrdinalIgnoreCase);
            if (candidateIndex >= 0 && candidateIndex < contentEnd)
            {
                contentEnd = candidateIndex;
            }
        }

        if (contentStart >= contentEnd)
        {
            return null;
        }

        var segment = text[contentStart..contentEnd].Trim();
        return segment.Length == 0 ? null : segment;
    }

    private static string CollapseWhitespace(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        return string.Join(
            ' ',
            value.Split(' ', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries));
    }

    private static void AddIfNotEmpty(this ICollection<string> parts, string? value)
    {
        if (!string.IsNullOrWhiteSpace(value))
        {
            parts.Add(value.Trim());
        }
    }

    private sealed record ActionDeltaCounts(int Added, int Removed, int Modified);

    private sealed record ActionDetailEntry(string ActionType, string DescriptorText);
}
