using System.Text;
using System.Text.Json;

namespace AutoCommitMessage;

internal static class MendixModelOverviewParser
{
    private const string DomainEntityModelType = "DomainModels$Entity";
    private const string DomainAttributeModelType = "DomainModels$Attribute";
    private const string DomainAssociationModelType = "DomainModels$Association";
    private const string DomainEnumerationModelType = "DomainModels$Enumeration";
    private const string LegacyDomainEnumerationModelType = "Enumerations$Enumeration";

    private const string MicroflowModelType = "Microflows$Microflow";
    private const string NanoflowModelType = "Microflows$Nanoflow";
    private const string RuleModelType = "Microflows$Rule";
    private const string WorkflowModelType = "Workflows$Workflow";

    private const string ActionActivityModelType = "Microflows$ActionActivity";
    private const string LoopedActivityModelType = "Microflows$LoopedActivity";
    private const string ExclusiveSplitModelType = "Microflows$ExclusiveSplit";
    private const string InheritanceSplitModelType = "Microflows$InheritanceSplit";
    private const string SequenceFlowModelType = "Microflows$SequenceFlow";

    private static readonly string[] NameFields = { "$QualifiedName", "name", "$ID" };

    private static readonly HashSet<string> TrackableContainerProperties = new(StringComparer.OrdinalIgnoreCase)
    {
        "documents",
        "projectDocuments",
    };

    private static readonly HashSet<string> TrackableDomainModelTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        DomainEntityModelType,
        DomainAssociationModelType,
        DomainEnumerationModelType,
        LegacyDomainEnumerationModelType,
    };

    private static readonly Dictionary<string, string> ElementTypeOverrides = new(StringComparer.OrdinalIgnoreCase)
    {
        [DomainEntityModelType] = "Entity",
        [DomainAssociationModelType] = "Association",
        [DomainEnumerationModelType] = "Enumeration",
        [LegacyDomainEnumerationModelType] = "Enumeration",
        [MicroflowModelType] = "Microflow",
        [NanoflowModelType] = "Nanoflow",
        [RuleModelType] = "Rule",
        [WorkflowModelType] = "Workflow",
    };

    private static readonly HashSet<string> NonExecutableFlowNodeTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "Microflows$Annotation",
        "Microflows$MicroflowParameterObject",
    };

    public static ModelOverviewDocument ParseDump(string dumpJsonPath, string sourceMprPath, DateTimeOffset generatedAtUtc)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(dumpJsonPath);

        using var document = ParseDumpDocument(dumpJsonPath);
        var snapshot = BuildSnapshot(document.RootElement);
        var modules = BuildModuleOverviews(snapshot);
        var flowLookup = modules
            .SelectMany(module => module.Flows)
            .ToDictionary(flow => flow.QualifiedName, flow => flow, StringComparer.OrdinalIgnoreCase);

        var callGraph = BuildCallGraph(modules, flowLookup);
        var summary = BuildSummary(modules, callGraph);

        return new ModelOverviewDocument(
            SchemaVersion: "1.0",
            GeneratedAtUtc: generatedAtUtc,
            SourceMprPath: sourceMprPath,
            SourceDumpPath: dumpJsonPath,
            Summary: summary,
            Modules: modules,
            FlowCallGraph: callGraph,
            AppPseudocode: BuildApplicationPseudocode(modules, callGraph));
    }

    public static string BuildModulePseudocode(OverviewModule module, IReadOnlyList<OverviewCallEdge> callGraph)
    {
        ArgumentNullException.ThrowIfNull(module);

        var builder = new StringBuilder();
        builder.AppendLine($"# Module: {module.Module}");
        builder.AppendLine($"Entities: {module.DomainModel.Entities.Count}, Associations: {module.DomainModel.Associations.Count}, Enumerations: {module.DomainModel.Enumerations.Count}");
        builder.AppendLine($"Flows: {module.Flows.Count}");

        if (module.DomainModel.Entities.Count > 0)
        {
            builder.AppendLine();
            builder.AppendLine("## Domain Model");
            foreach (var entity in module.DomainModel.Entities)
            {
                var persistenceLabel = entity.IsPersistable ? "persistent" : "non-persistent";
                var generalizationLabel = string.IsNullOrWhiteSpace(entity.Generalization)
                    ? string.Empty
                    : $", generalization={entity.Generalization}";
                builder.AppendLine($"- ENTITY {entity.Name} ({persistenceLabel}{generalizationLabel})");

                foreach (var attribute in entity.Attributes)
                {
                    var typeLabel = string.IsNullOrWhiteSpace(attribute.Type) ? "<unknown>" : attribute.Type;
                    builder.AppendLine($"  - ATTR {attribute.Name}: {typeLabel}");
                }
            }

            foreach (var association in module.DomainModel.Associations)
            {
                builder.AppendLine($"- ASSOC {association.Name}: {association.ParentEntity} [{association.Cardinality}] {association.ChildEntity}");
            }

            foreach (var enumeration in module.DomainModel.Enumerations)
            {
                builder.AppendLine($"- ENUM {enumeration.Name}: {string.Join(", ", enumeration.Values)}");
            }
        }

        if (module.Flows.Count > 0)
        {
            builder.AppendLine();
            builder.AppendLine("## Flows");
            foreach (var flow in module.Flows)
            {
                builder.AppendLine();
                builder.AppendLine(flow.Pseudocode);
            }
        }

        var moduleCalls = callGraph
            .Where(edge => string.Equals(edge.CallerModule, module.Module, StringComparison.OrdinalIgnoreCase))
            .OrderBy(edge => edge.CallerFlow, StringComparer.OrdinalIgnoreCase)
            .ThenBy(edge => edge.TargetFlow, StringComparer.OrdinalIgnoreCase)
            .ToArray();
        if (moduleCalls.Length > 0)
        {
            builder.AppendLine();
            builder.AppendLine("## Outgoing Calls");
            foreach (var edge in moduleCalls)
            {
                var resolution = edge.IsInternal ? "internal" : "external";
                builder.AppendLine($"- {edge.CallerFlow} -> {edge.TargetFlow} ({edge.CallKind}, {resolution})");
            }
        }

        return builder.ToString().TrimEnd();
    }

    private static IReadOnlyList<OverviewModule> BuildModuleOverviews(DumpSnapshot snapshot)
    {
        var modules = new Dictionary<string, MutableOverviewModule>(StringComparer.OrdinalIgnoreCase);

        foreach (var descriptor in snapshot.ResourcesById.Values
                     .OrderBy(item => item.ModelType, StringComparer.OrdinalIgnoreCase)
                     .ThenBy(item => item.ElementName, StringComparer.OrdinalIgnoreCase))
        {
            var moduleName = ResolveModuleName(descriptor.ElementName);
            if (!modules.TryGetValue(moduleName, out var mutable))
            {
                mutable = new MutableOverviewModule(moduleName);
                modules[moduleName] = mutable;
            }

            if (string.Equals(descriptor.ModelType, DomainEntityModelType, StringComparison.OrdinalIgnoreCase))
            {
                mutable.Entities.Add(ParseEntity(descriptor.Object));
                continue;
            }

            if (string.Equals(descriptor.ModelType, DomainAssociationModelType, StringComparison.OrdinalIgnoreCase))
            {
                var association = ParseAssociation(descriptor.Object, snapshot);
                if (association is not null)
                {
                    mutable.Associations.Add(association);
                }

                continue;
            }

            if (IsEnumerationModelType(descriptor.ModelType))
            {
                mutable.Enumerations.Add(ParseEnumeration(descriptor.Object, descriptor.ElementName));
                continue;
            }

            if (IsFlowModelType(descriptor.ModelType))
            {
                mutable.Flows.Add(ParseMicroflowLike(descriptor, moduleName));
                continue;
            }

            if (string.Equals(descriptor.ModelType, WorkflowModelType, StringComparison.OrdinalIgnoreCase))
            {
                mutable.Flows.Add(ParseWorkflow(descriptor, moduleName));
            }
        }

        return modules.Values
            .Select(module => module.ToImmutable())
            .OrderBy(module => module.Module, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static OverviewSummary BuildSummary(IReadOnlyList<OverviewModule> modules, IReadOnlyList<OverviewCallEdge> callGraph)
    {
        var flowCount = modules.Sum(module => module.Flows.Count);
        var nodeCount = modules.Sum(module => module.Flows.Sum(flow => flow.Nodes.Count));
        var edgeCount = modules.Sum(module => module.Flows.Sum(flow => flow.Edges.Count));

        return new OverviewSummary(
            ModuleCount: modules.Count,
            EntityCount: modules.Sum(module => module.DomainModel.Entities.Count),
            AssociationCount: modules.Sum(module => module.DomainModel.Associations.Count),
            EnumerationCount: modules.Sum(module => module.DomainModel.Enumerations.Count),
            FlowCount: flowCount,
            MicroflowCount: modules.Sum(module => module.Flows.Count(flow => string.Equals(flow.Kind, "Microflow", StringComparison.OrdinalIgnoreCase))),
            NanoflowCount: modules.Sum(module => module.Flows.Count(flow => string.Equals(flow.Kind, "Nanoflow", StringComparison.OrdinalIgnoreCase))),
            RuleCount: modules.Sum(module => module.Flows.Count(flow => string.Equals(flow.Kind, "Rule", StringComparison.OrdinalIgnoreCase))),
            WorkflowCount: modules.Sum(module => module.Flows.Count(flow => string.Equals(flow.Kind, "Workflow", StringComparison.OrdinalIgnoreCase))),
            FlowNodeCount: nodeCount,
            FlowEdgeCount: edgeCount,
            FlowCallEdgeCount: callGraph.Count);
    }

    private static IReadOnlyList<OverviewCallEdge> BuildCallGraph(
        IReadOnlyList<OverviewModule> modules,
        IReadOnlyDictionary<string, OverviewFlow> flowLookup)
    {
        var edges = new List<OverviewCallEdge>();
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var flow in modules.SelectMany(module => module.Flows)
                     .OrderBy(item => item.QualifiedName, StringComparer.OrdinalIgnoreCase))
        {
            foreach (var call in flow.Calls
                         .OrderBy(item => item.TargetFlowName, StringComparer.OrdinalIgnoreCase)
                         .ThenBy(item => item.SourceNodeId, StringComparer.OrdinalIgnoreCase))
            {
                var targetFlowName = call.TargetFlowName;
                var targetModule = ResolveModuleName(targetFlowName);
                var isInternal = flowLookup.ContainsKey(targetFlowName);

                var dedupeKey = $"{flow.QualifiedName}|{call.CallKind}|{targetFlowName}|{call.SourceNodeId}";
                if (!seen.Add(dedupeKey))
                {
                    continue;
                }

                edges.Add(new OverviewCallEdge(
                    CallerModule: flow.Module,
                    CallerFlow: flow.QualifiedName,
                    CallerKind: flow.Kind,
                    CallKind: call.CallKind,
                    SourceNodeId: call.SourceNodeId,
                    TargetModule: targetModule,
                    TargetFlow: targetFlowName,
                    IsInternal: isInternal));
            }
        }

        return edges
            .OrderBy(edge => edge.CallerFlow, StringComparer.OrdinalIgnoreCase)
            .ThenBy(edge => edge.TargetFlow, StringComparer.OrdinalIgnoreCase)
            .ThenBy(edge => edge.CallKind, StringComparer.OrdinalIgnoreCase)
            .ThenBy(edge => edge.SourceNodeId, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static string BuildApplicationPseudocode(
        IReadOnlyList<OverviewModule> modules,
        IReadOnlyList<OverviewCallEdge> callGraph)
    {
        var builder = new StringBuilder();
        builder.AppendLine("# Application Overview");
        builder.AppendLine($"Modules: {modules.Count}");
        builder.AppendLine($"Flows: {modules.Sum(module => module.Flows.Count)}");

        builder.AppendLine();
        builder.AppendLine("## Call Graph");
        if (callGraph.Count == 0)
        {
            builder.AppendLine("- <no flow-to-flow calls detected>");
        }
        else
        {
            foreach (var edge in callGraph)
            {
                var resolution = edge.IsInternal ? "internal" : "external";
                builder.AppendLine($"- {edge.CallerFlow} -> {edge.TargetFlow} ({edge.CallKind}, {resolution})");
            }
        }

        foreach (var module in modules)
        {
            builder.AppendLine();
            builder.AppendLine(BuildModulePseudocode(module, callGraph));
        }

        return builder.ToString().TrimEnd();
    }

    private static OverviewEntity ParseEntity(JsonElement entityObject)
    {
        var name =
            TryReadStringProperty(entityObject, "$QualifiedName") ??
            TryReadStringProperty(entityObject, "name") ??
            TryReadStringProperty(entityObject, "$ID") ??
            "<unknown>";

        var generalization = ResolveEntityGeneralization(entityObject);
        var attributes = ParseEntityAttributes(entityObject);
        return new OverviewEntity(
            Name: name,
            IsPersistable: IsPersistableEntity(entityObject),
            Generalization: generalization,
            Attributes: attributes);
    }

    private static string? ResolveEntityGeneralization(JsonElement entityObject)
    {
        if (!TryReadProperty(entityObject, "generalization", out var generalizationElement) ||
            generalizationElement.ValueKind != JsonValueKind.Object)
        {
            return null;
        }

        var generalizationType = TryReadStringProperty(generalizationElement, "$Type");
        if (string.Equals(generalizationType, "DomainModels$NoGeneralization", StringComparison.OrdinalIgnoreCase))
        {
            return null;
        }

        return TryReadStringProperty(generalizationElement, "generalization");
    }

    private static bool IsPersistableEntity(JsonElement entityObject)
    {
        if (TryReadBooleanProperty(entityObject, "persistable", out var persistable))
        {
            return persistable;
        }

        if (TryReadProperty(entityObject, "generalization", out var generalizationElement) &&
            generalizationElement.ValueKind == JsonValueKind.Object &&
            TryReadBooleanProperty(generalizationElement, "persistable", out var generalizedPersistable))
        {
            return generalizedPersistable;
        }

        return true;
    }

    private static IReadOnlyList<OverviewAttribute> ParseEntityAttributes(JsonElement entityObject)
    {
        if (!TryReadProperty(entityObject, "attributes", out var attributesElement) ||
            attributesElement.ValueKind != JsonValueKind.Array)
        {
            return Array.Empty<OverviewAttribute>();
        }

        var attributes = new List<OverviewAttribute>();
        foreach (var attribute in attributesElement.EnumerateArray())
        {
            if (attribute.ValueKind != JsonValueKind.Object)
            {
                continue;
            }

            var modelType = TryReadStringProperty(attribute, "$Type");
            if (!string.Equals(modelType, DomainAttributeModelType, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var name =
                TryReadStringProperty(attribute, "name") ??
                TryReadStringProperty(attribute, "$QualifiedName") ??
                TryReadStringProperty(attribute, "$ID") ??
                "<unknown>";

            var type = ReadAttributeType(attribute);
            attributes.Add(new OverviewAttribute(Name: name, Type: type));
        }

        return attributes
            .OrderBy(attribute => attribute.Name, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static string? ReadAttributeType(JsonElement attribute)
    {
        if (!TryReadProperty(attribute, "type", out var typeElement) ||
            typeElement.ValueKind != JsonValueKind.Object)
        {
            return null;
        }

        var modelType = TryReadStringProperty(typeElement, "$Type");
        if (string.IsNullOrWhiteSpace(modelType))
        {
            return null;
        }

        return ShortTypeName(modelType);
    }

    private static OverviewAssociation? ParseAssociation(JsonElement associationObject, DumpSnapshot snapshot)
    {
        var name =
            TryReadStringProperty(associationObject, "$QualifiedName") ??
            TryReadStringProperty(associationObject, "name") ??
            TryReadStringProperty(associationObject, "$ID") ??
            "<unknown>";

        var parentEntity = ResolveAssociationEntityName(associationObject, "parent", snapshot) ?? "<unknown>";
        var childEntity = ResolveAssociationEntityName(associationObject, "child", snapshot) ?? "<unknown>";
        var associationType = TryReadStringProperty(associationObject, "type");
        var associationOwner = TryReadStringProperty(associationObject, "owner");
        var cardinality = ResolveAssociationCardinality(associationType, associationOwner, fromParentPerspective: true);

        return new OverviewAssociation(
            Name: name,
            ParentEntity: parentEntity,
            ChildEntity: childEntity,
            Cardinality: cardinality,
            Type: associationType,
            Owner: associationOwner,
            StorageFormat: TryReadStringProperty(associationObject, "storageFormat"));
    }

    private static string? ResolveAssociationEntityName(JsonElement associationObject, string endPropertyName, DumpSnapshot snapshot)
    {
        var entityId = TryReadStringProperty(associationObject, endPropertyName);
        if (string.IsNullOrWhiteSpace(entityId) || !snapshot.ObjectsById.TryGetValue(entityId, out var entityObject))
        {
            return entityId;
        }

        var modelType = TryReadStringProperty(entityObject, "$Type");
        if (!string.Equals(modelType, DomainEntityModelType, StringComparison.OrdinalIgnoreCase))
        {
            return entityId;
        }

        return ResolveElementName(entityObject);
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

            if (string.Equals(associationOwner, "Parent", StringComparison.OrdinalIgnoreCase))
            {
                return fromParentPerspective ? "1-*" : "*-1";
            }

            if (string.Equals(associationOwner, "Child", StringComparison.OrdinalIgnoreCase))
            {
                return fromParentPerspective ? "*-1" : "1-*";
            }

            return fromParentPerspective ? "*-1" : "1-*";
        }

        return "1-1";
    }

    private static OverviewEnumeration ParseEnumeration(JsonElement enumerationObject, string fallbackName)
    {
        var name =
            TryReadStringProperty(enumerationObject, "$QualifiedName") ??
            TryReadStringProperty(enumerationObject, "name") ??
            fallbackName;

        var values = new List<string>();
        if (TryReadProperty(enumerationObject, "values", out var valuesElement) &&
            valuesElement.ValueKind == JsonValueKind.Array)
        {
            foreach (var valueElement in valuesElement.EnumerateArray())
            {
                if (valueElement.ValueKind != JsonValueKind.Object)
                {
                    continue;
                }

                var valueName =
                    TryReadStringProperty(valueElement, "name") ??
                    TryReadStringProperty(valueElement, "$QualifiedName") ??
                    TryReadStringProperty(valueElement, "$ID");

                if (!string.IsNullOrWhiteSpace(valueName))
                {
                    values.Add(valueName.Trim());
                }
            }
        }

        return new OverviewEnumeration(
            Name: name,
            Values: values
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(value => value, StringComparer.OrdinalIgnoreCase)
                .ToArray());
    }

    private static OverviewFlow ParseMicroflowLike(ResourceDescriptor descriptor, string moduleName)
    {
        var nodesById = new Dictionary<string, MutableFlowNode>(StringComparer.OrdinalIgnoreCase);
        CollectFlowNodes(descriptor.Object, nodesById, loopOwnerId: null);

        var edges = ParseSequenceEdges(descriptor.Object)
            .Where(edge => nodesById.ContainsKey(edge.OriginNodeId) && nodesById.ContainsKey(edge.DestinationNodeId))
            .ToArray();

        var calls = nodesById.Values
            .SelectMany(node => node.Calls)
            .Distinct()
            .OrderBy(call => call.TargetFlowName, StringComparer.OrdinalIgnoreCase)
            .ThenBy(call => call.SourceNodeId, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        var loopBodyMap = BuildLoopBodyMap(nodesById.Values);
        var mainNodeIds = nodesById.Values
            .Where(node => string.IsNullOrWhiteSpace(node.LoopOwnerId))
            .Select(node => node.NodeId)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        var mainEdges = edges
            .Where(edge => mainNodeIds.Contains(edge.OriginNodeId) && mainNodeIds.Contains(edge.DestinationNodeId))
            .ToArray();

        var startNodeIds = ResolveStartNodeIds(mainNodeIds, mainEdges, nodesById);
        var primaryOrder = BuildPrimaryExecutionOrder(mainNodeIds, mainEdges, nodesById, startNodeIds, loopBodyMap)
            .ToArray();

        var pseudocode = BuildFlowPseudocode(
            kind: ResolveFlowKind(descriptor.ModelType),
            flowQualifiedName: descriptor.ElementName,
            nodesById,
            mainNodeIds,
            mainEdges,
            startNodeIds,
            loopBodyMap);

        return new OverviewFlow(
            FlowId: descriptor.ResourceId,
            Kind: ResolveFlowKind(descriptor.ModelType),
            QualifiedName: descriptor.ElementName,
            Module: moduleName,
            Nodes: nodesById.Values
                .Select(node => node.ToImmutable())
                .OrderBy(node => node.NodeType, StringComparer.OrdinalIgnoreCase)
                .ThenBy(node => node.Label, StringComparer.OrdinalIgnoreCase)
                .ThenBy(node => node.NodeId, StringComparer.OrdinalIgnoreCase)
                .ToArray(),
            Edges: edges,
            Calls: calls,
            StartNodeIds: startNodeIds,
            PrimaryExecutionOrderNodeIds: primaryOrder,
            Pseudocode: pseudocode);
    }

    private static OverviewFlow ParseWorkflow(ResourceDescriptor descriptor, string moduleName)
    {
        var nodes = new Dictionary<string, MutableFlowNode>(StringComparer.OrdinalIgnoreCase);
        var edges = new List<OverviewFlowEdge>();
        var calls = new HashSet<OverviewFlowCall>();

        if (TryReadProperty(descriptor.Object, "flow", out var flowElement) &&
            flowElement.ValueKind == JsonValueKind.Object &&
            TryReadProperty(flowElement, "activities", out var activitiesElement) &&
            activitiesElement.ValueKind == JsonValueKind.Array)
        {
            var index = 0;
            var orderedActivityIds = new List<string>();
            foreach (var activity in activitiesElement.EnumerateArray())
            {
                if (activity.ValueKind != JsonValueKind.Object)
                {
                    index++;
                    continue;
                }

                var nodeId =
                    TryReadStringProperty(activity, "$ID") ??
                    $"activity-{index}";
                var nodeType = ShortTypeName(TryReadStringProperty(activity, "$Type") ?? "Workflows$Activity");
                var label =
                    TryReadStringProperty(activity, "name") ??
                    TryReadStringProperty(activity, "caption") ??
                    nodeType;

                nodes[nodeId] = new MutableFlowNode(
                    NodeId: nodeId,
                    NodeType: nodeType,
                    Label: label,
                    Detail: null,
                    LoopOwnerId: null,
                    IsExecutable: true,
                    Calls: Array.Empty<OverviewFlowCall>());

                orderedActivityIds.Add(nodeId);
                index++;
            }

            for (var i = 0; i < orderedActivityIds.Count - 1; i++)
            {
                edges.Add(new OverviewFlowEdge(
                    EdgeId: $"workflow-edge-{i + 1}",
                    OriginNodeId: orderedActivityIds[i],
                    DestinationNodeId: orderedActivityIds[i + 1],
                    Condition: null,
                    IsErrorHandler: false,
                    OriginConnectionIndex: null,
                    DestinationConnectionIndex: null));
            }
        }

        var startNodeIds = ResolveStartNodeIds(nodes.Keys.ToHashSet(StringComparer.OrdinalIgnoreCase), edges, nodes)
            .ToArray();
        var primaryOrder = BuildPrimaryExecutionOrder(
                nodes.Keys.ToHashSet(StringComparer.OrdinalIgnoreCase),
                edges,
                nodes,
                startNodeIds,
                new Dictionary<string, IReadOnlyList<string>>(StringComparer.OrdinalIgnoreCase))
            .ToArray();

        var pseudocode = BuildFlowPseudocode(
            kind: "Workflow",
            flowQualifiedName: descriptor.ElementName,
            nodes,
            nodes.Keys.ToHashSet(StringComparer.OrdinalIgnoreCase),
            edges,
            startNodeIds,
            new Dictionary<string, IReadOnlyList<string>>(StringComparer.OrdinalIgnoreCase));

        return new OverviewFlow(
            FlowId: descriptor.ResourceId,
            Kind: "Workflow",
            QualifiedName: descriptor.ElementName,
            Module: moduleName,
            Nodes: nodes.Values
                .Select(node => node.ToImmutable())
                .OrderBy(node => node.NodeId, StringComparer.OrdinalIgnoreCase)
                .ToArray(),
            Edges: edges
                .OrderBy(edge => edge.EdgeId, StringComparer.OrdinalIgnoreCase)
                .ToArray(),
            Calls: calls
                .OrderBy(call => call.TargetFlowName, StringComparer.OrdinalIgnoreCase)
                .ToArray(),
            StartNodeIds: startNodeIds,
            PrimaryExecutionOrderNodeIds: primaryOrder,
            Pseudocode: pseudocode);
    }

    private static string[] ResolveStartNodeIds(
        HashSet<string> scopeNodeIds,
        IReadOnlyCollection<OverviewFlowEdge> scopeEdges,
        IReadOnlyDictionary<string, MutableFlowNode> nodes)
    {
        var starts = scopeNodeIds
            .Where(nodeId =>
                nodes.TryGetValue(nodeId, out var node) &&
                string.Equals(node.NodeType, "StartEvent", StringComparison.OrdinalIgnoreCase))
            .OrderBy(nodeId => nodeId, StringComparer.OrdinalIgnoreCase)
            .ToArray();
        if (starts.Length > 0)
        {
            return starts;
        }

        var destinations = scopeEdges
            .Select(edge => edge.DestinationNodeId)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        return scopeNodeIds
            .Where(nodeId => !destinations.Contains(nodeId))
            .Where(nodeId => nodes.TryGetValue(nodeId, out var node) && node.IsExecutable)
            .OrderBy(nodeId => nodeId, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static IReadOnlyList<string> BuildPrimaryExecutionOrder(
        HashSet<string> scopeNodeIds,
        IReadOnlyCollection<OverviewFlowEdge> scopeEdges,
        IReadOnlyDictionary<string, MutableFlowNode> nodes,
        IReadOnlyCollection<string> startNodeIds,
        IReadOnlyDictionary<string, IReadOnlyList<string>> loopBodyMap)
    {
        var adjacency = BuildAdjacency(scopeEdges);
        var visited = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var order = new List<string>();

        void Visit(string nodeId)
        {
            if (!scopeNodeIds.Contains(nodeId) || !visited.Add(nodeId))
            {
                return;
            }

            if (!nodes.TryGetValue(nodeId, out var node))
            {
                return;
            }

            if (node.IsExecutable)
            {
                order.Add(nodeId);
            }

            if (loopBodyMap.TryGetValue(nodeId, out var loopBodyNodeIds))
            {
                var loopBodySet = loopBodyNodeIds.ToHashSet(StringComparer.OrdinalIgnoreCase);
                var loopBodyEdges = scopeEdges
                    .Where(edge => loopBodySet.Contains(edge.OriginNodeId) && loopBodySet.Contains(edge.DestinationNodeId))
                    .ToArray();
                var loopStarts = ResolveStartNodeIds(loopBodySet, loopBodyEdges, nodes);
                foreach (var loopStart in loopStarts)
                {
                    VisitLoopBody(loopStart, loopBodySet, loopBodyEdges);
                }
            }

            if (adjacency.TryGetValue(nodeId, out var outgoingEdges))
            {
                foreach (var edge in outgoingEdges)
                {
                    Visit(edge.DestinationNodeId);
                }
            }
        }

        void VisitLoopBody(string nodeId, HashSet<string> allowedNodeIds, IReadOnlyCollection<OverviewFlowEdge> allowedEdges)
        {
            if (!allowedNodeIds.Contains(nodeId) || !visited.Add(nodeId))
            {
                return;
            }

            if (nodes.TryGetValue(nodeId, out var loopNode) && loopNode.IsExecutable)
            {
                order.Add(nodeId);
            }

            var localAdjacency = BuildAdjacency(allowedEdges);
            if (!localAdjacency.TryGetValue(nodeId, out var outgoingEdges))
            {
                return;
            }

            foreach (var edge in outgoingEdges)
            {
                VisitLoopBody(edge.DestinationNodeId, allowedNodeIds, allowedEdges);
            }
        }

        foreach (var startNodeId in startNodeIds)
        {
            Visit(startNodeId);
        }

        foreach (var remainingNodeId in scopeNodeIds
                     .Where(nodeId => nodes.TryGetValue(nodeId, out var node) && node.IsExecutable)
                     .OrderBy(nodeId => nodeId, StringComparer.OrdinalIgnoreCase))
        {
            Visit(remainingNodeId);
        }

        return order;
    }

    private static string BuildFlowPseudocode(
        string kind,
        string flowQualifiedName,
        IReadOnlyDictionary<string, MutableFlowNode> nodes,
        HashSet<string> mainNodeIds,
        IReadOnlyCollection<OverviewFlowEdge> mainEdges,
        IReadOnlyCollection<string> startNodeIds,
        IReadOnlyDictionary<string, IReadOnlyList<string>> loopBodyMap)
    {
        var builder = new StringBuilder();
        builder.AppendLine($"FLOW {kind}: {flowQualifiedName}");
        builder.AppendLine($"NODES={mainNodeIds.Count}; EDGES={mainEdges.Count}");

        var adjacency = BuildAdjacency(mainEdges);
        var renderedByScope = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var stepCounter = 0;

        void AppendStep(int indent, string text)
        {
            stepCounter++;
            builder.Append(new string(' ', indent * 2));
            builder.Append(stepCounter);
            builder.Append(". ");
            builder.AppendLine(text);
        }

        void RenderScope(
            string nodeId,
            string scopeKey,
            HashSet<string> scopeNodeSet,
            IReadOnlyDictionary<string, List<OverviewFlowEdge>> scopeAdjacency,
            int indent,
            HashSet<string> pathStack)
        {
            if (!scopeNodeSet.Contains(nodeId) || !nodes.TryGetValue(nodeId, out var node))
            {
                return;
            }

            var renderKey = $"{scopeKey}|{nodeId}";
            if (pathStack.Contains(nodeId))
            {
                AppendStep(indent, $"GOTO {node.Label} // cycle");
                return;
            }

            if (!renderedByScope.Add(renderKey))
            {
                AppendStep(indent, $"REF {node.Label}");
                return;
            }

            pathStack.Add(nodeId);
            AppendStep(indent, FormatNodePseudoLine(node));

            if (loopBodyMap.TryGetValue(nodeId, out var loopBodyNodeIds) && loopBodyNodeIds.Count > 0)
            {
                var loopBodySet = loopBodyNodeIds.ToHashSet(StringComparer.OrdinalIgnoreCase);
                var loopBodyEdges = mainEdges
                    .Where(edge => loopBodySet.Contains(edge.OriginNodeId) && loopBodySet.Contains(edge.DestinationNodeId))
                    .ToArray();
                var loopAdjacency = BuildAdjacency(loopBodyEdges);
                var loopStarts = ResolveStartNodeIds(loopBodySet, loopBodyEdges, nodes);

                AppendStep(indent + 1, "LOOP BODY");
                if (loopStarts.Length == 0)
                {
                    AppendStep(indent + 2, "<empty>");
                }
                else
                {
                    foreach (var loopStart in loopStarts)
                    {
                        RenderScope(
                            loopStart,
                            scopeKey: $"loop:{nodeId}",
                            scopeNodeSet: loopBodySet,
                            scopeAdjacency: loopAdjacency,
                            indent: indent + 2,
                            pathStack: new HashSet<string>(StringComparer.OrdinalIgnoreCase));
                    }
                }
            }

            if (!scopeAdjacency.TryGetValue(nodeId, out var outgoingEdges) || outgoingEdges.Count == 0)
            {
                pathStack.Remove(nodeId);
                return;
            }

            if (outgoingEdges.Count == 1)
            {
                var edge = outgoingEdges[0];
                var transition = BuildTransitionLabel(edge);
                if (!string.IsNullOrWhiteSpace(transition))
                {
                    AppendStep(indent, transition);
                }

                RenderScope(
                    edge.DestinationNodeId,
                    scopeKey,
                    scopeNodeSet,
                    scopeAdjacency,
                    indent,
                    new HashSet<string>(pathStack, StringComparer.OrdinalIgnoreCase));
                pathStack.Remove(nodeId);
                return;
            }

            foreach (var edge in outgoingEdges)
            {
                var branchLabel = BuildBranchLabel(edge);
                AppendStep(indent, branchLabel);
                RenderScope(
                    edge.DestinationNodeId,
                    scopeKey,
                    scopeNodeSet,
                    scopeAdjacency,
                    indent + 1,
                    new HashSet<string>(pathStack, StringComparer.OrdinalIgnoreCase));
            }

            pathStack.Remove(nodeId);
        }

        var orderedStarts = startNodeIds
            .Where(mainNodeIds.Contains)
            .OrderBy(nodeId => nodeId, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        if (orderedStarts.Length == 0)
        {
            builder.AppendLine("1. <no start node detected>");
            return builder.ToString().TrimEnd();
        }

        foreach (var startNodeId in orderedStarts)
        {
            RenderScope(
                startNodeId,
                scopeKey: "main",
                scopeNodeSet: mainNodeIds,
                scopeAdjacency: adjacency,
                indent: 0,
                pathStack: new HashSet<string>(StringComparer.OrdinalIgnoreCase));
        }

        var remaining = mainNodeIds
            .Where(nodeId => nodes.TryGetValue(nodeId, out var node) && node.IsExecutable)
            .Where(nodeId => !renderedByScope.Contains($"main|{nodeId}"))
            .OrderBy(nodeId => nodeId, StringComparer.OrdinalIgnoreCase)
            .ToArray();
        if (remaining.Length > 0)
        {
            AppendStep(0, "UNREACHABLE OR DETACHED");
            foreach (var nodeId in remaining)
            {
                RenderScope(
                    nodeId,
                    scopeKey: "main",
                    scopeNodeSet: mainNodeIds,
                    scopeAdjacency: adjacency,
                    indent: 1,
                    pathStack: new HashSet<string>(StringComparer.OrdinalIgnoreCase));
            }
        }

        return builder.ToString().TrimEnd();
    }

    private static string BuildTransitionLabel(OverviewFlowEdge edge)
    {
        if (edge.IsErrorHandler)
        {
            return "ON ERROR";
        }

        if (!string.IsNullOrWhiteSpace(edge.Condition))
        {
            return $"WHEN {edge.Condition}";
        }

        return string.Empty;
    }

    private static string BuildBranchLabel(OverviewFlowEdge edge)
    {
        if (edge.IsErrorHandler)
        {
            return "BRANCH on error";
        }

        if (!string.IsNullOrWhiteSpace(edge.Condition))
        {
            return $"BRANCH when {edge.Condition}";
        }

        return "BRANCH";
    }

    private static string FormatNodePseudoLine(MutableFlowNode node)
    {
        if (string.Equals(node.NodeType, "ActionActivity", StringComparison.OrdinalIgnoreCase))
        {
            return $"ACTION {node.Label}";
        }

        if (string.Equals(node.NodeType, "StartEvent", StringComparison.OrdinalIgnoreCase))
        {
            return "START";
        }

        if (string.Equals(node.NodeType, "EndEvent", StringComparison.OrdinalIgnoreCase))
        {
            return "END";
        }

        if (string.Equals(node.NodeType, "ExclusiveSplit", StringComparison.OrdinalIgnoreCase) ||
            string.Equals(node.NodeType, "InheritanceSplit", StringComparison.OrdinalIgnoreCase))
        {
            return $"DECISION {node.Label}";
        }

        if (string.Equals(node.NodeType, "LoopedActivity", StringComparison.OrdinalIgnoreCase))
        {
            return $"LOOP {node.Label}";
        }

        return $"NODE {node.NodeType}: {node.Label}";
    }

    private static Dictionary<string, IReadOnlyList<string>> BuildLoopBodyMap(IEnumerable<MutableFlowNode> nodes)
    {
        var mapping = nodes
            .Where(node => !string.IsNullOrWhiteSpace(node.LoopOwnerId))
            .GroupBy(node => node.LoopOwnerId!, StringComparer.OrdinalIgnoreCase)
            .ToDictionary(
                group => group.Key,
                group => (IReadOnlyList<string>)group
                    .Select(node => node.NodeId)
                    .OrderBy(nodeId => nodeId, StringComparer.OrdinalIgnoreCase)
                    .ToArray(),
                StringComparer.OrdinalIgnoreCase);

        return mapping;
    }

    private static Dictionary<string, List<OverviewFlowEdge>> BuildAdjacency(IEnumerable<OverviewFlowEdge> edges)
    {
        var adjacency = new Dictionary<string, List<OverviewFlowEdge>>(StringComparer.OrdinalIgnoreCase);

        foreach (var edge in edges)
        {
            if (!adjacency.TryGetValue(edge.OriginNodeId, out var edgeList))
            {
                edgeList = new List<OverviewFlowEdge>();
                adjacency[edge.OriginNodeId] = edgeList;
            }

            edgeList.Add(edge);
        }

        foreach (var edgeList in adjacency.Values)
        {
            edgeList.Sort(CompareEdges);
        }

        return adjacency;
    }

    private static int CompareEdges(OverviewFlowEdge left, OverviewFlowEdge right)
    {
        var originCompare = Nullable.Compare(left.OriginConnectionIndex, right.OriginConnectionIndex);
        if (originCompare != 0)
        {
            return originCompare;
        }

        var destinationCompare = Nullable.Compare(left.DestinationConnectionIndex, right.DestinationConnectionIndex);
        if (destinationCompare != 0)
        {
            return destinationCompare;
        }

        var conditionCompare = string.Compare(left.Condition, right.Condition, StringComparison.OrdinalIgnoreCase);
        if (conditionCompare != 0)
        {
            return conditionCompare;
        }

        var destinationNodeCompare = string.Compare(left.DestinationNodeId, right.DestinationNodeId, StringComparison.OrdinalIgnoreCase);
        if (destinationNodeCompare != 0)
        {
            return destinationNodeCompare;
        }

        return string.Compare(left.EdgeId, right.EdgeId, StringComparison.OrdinalIgnoreCase);
    }

    private static void CollectFlowNodes(
        JsonElement flowResource,
        Dictionary<string, MutableFlowNode> nodesById,
        string? loopOwnerId)
    {
        if (!TryReadProperty(flowResource, "objectCollection", out var objectCollection) ||
            objectCollection.ValueKind != JsonValueKind.Object)
        {
            return;
        }

        CollectNodesFromCollection(objectCollection, nodesById, loopOwnerId);
    }

    private static void CollectNodesFromCollection(
        JsonElement objectCollection,
        Dictionary<string, MutableFlowNode> nodesById,
        string? loopOwnerId)
    {
        if (!TryReadProperty(objectCollection, "objects", out var objectsElement) ||
            objectsElement.ValueKind != JsonValueKind.Array)
        {
            return;
        }

        foreach (var flowObject in objectsElement.EnumerateArray())
        {
            if (flowObject.ValueKind != JsonValueKind.Object)
            {
                continue;
            }

            var nodeId = TryReadStringProperty(flowObject, "$ID");
            if (string.IsNullOrWhiteSpace(nodeId))
            {
                continue;
            }

            var modelType = TryReadStringProperty(flowObject, "$Type") ?? "<unknown>";
            var nodeType = ShortTypeName(modelType);

            var label = BuildFlowNodeLabel(flowObject, modelType, out var details, out var calls);
            nodesById[nodeId] = new MutableFlowNode(
                NodeId: nodeId,
                NodeType: nodeType,
                Label: label,
                Detail: details,
                LoopOwnerId: loopOwnerId,
                IsExecutable: !NonExecutableFlowNodeTypes.Contains(modelType),
                Calls: calls);

            if (string.Equals(modelType, LoopedActivityModelType, StringComparison.OrdinalIgnoreCase) &&
                TryReadProperty(flowObject, "objectCollection", out var nestedObjectCollection) &&
                nestedObjectCollection.ValueKind == JsonValueKind.Object)
            {
                CollectNodesFromCollection(nestedObjectCollection, nodesById, loopOwnerId: nodeId);
            }
        }
    }

    private static string BuildFlowNodeLabel(
        JsonElement flowObject,
        string modelType,
        out string? details,
        out IReadOnlyList<OverviewFlowCall> calls)
    {
        details = null;
        calls = Array.Empty<OverviewFlowCall>();

        if (string.Equals(modelType, ActionActivityModelType, StringComparison.OrdinalIgnoreCase))
        {
            if (TryReadProperty(flowObject, "action", out var action) && action.ValueKind == JsonValueKind.Object)
            {
                var actionType = ShortTypeName(TryReadStringProperty(action, "$Type") ?? "Action");
                var descriptor = BuildActionDescriptor(actionType, action);
                details = descriptor;
                calls = ExtractFlowCalls(actionType, action, TryReadStringProperty(flowObject, "$ID"));
                return string.IsNullOrWhiteSpace(descriptor)
                    ? actionType
                    : $"{actionType}: {descriptor}";
            }

            return "ActionActivity";
        }

        if (string.Equals(modelType, LoopedActivityModelType, StringComparison.OrdinalIgnoreCase))
        {
            details = BuildLoopDescriptor(flowObject);
            return string.IsNullOrWhiteSpace(details) ? "Loop" : details;
        }

        if (string.Equals(modelType, ExclusiveSplitModelType, StringComparison.OrdinalIgnoreCase))
        {
            details = BuildDecisionDescriptor(flowObject);
            return string.IsNullOrWhiteSpace(details) ? "Exclusive split" : details;
        }

        if (string.Equals(modelType, InheritanceSplitModelType, StringComparison.OrdinalIgnoreCase))
        {
            details = BuildInheritanceSplitDescriptor(flowObject);
            return string.IsNullOrWhiteSpace(details) ? "Inheritance split" : details;
        }

        var caption = TryReadStringProperty(flowObject, "caption");
        if (!string.IsNullOrWhiteSpace(caption))
        {
            return NormalizeInlineText(caption, 160);
        }

        return ShortTypeName(modelType);
    }

    private static IReadOnlyList<OverviewFlowCall> ExtractFlowCalls(
        string actionType,
        JsonElement action,
        string? sourceNodeId)
    {
        var calls = new List<OverviewFlowCall>();

        if (string.Equals(actionType, "MicroflowCallAction", StringComparison.OrdinalIgnoreCase))
        {
            var target =
                TryReadStringProperty(action, "microflow") ??
                TryReadNestedStringProperty(action, "microflowCall", "microflow");
            if (!string.IsNullOrWhiteSpace(target))
            {
                calls.Add(new OverviewFlowCall("Microflow", target.Trim(), sourceNodeId ?? string.Empty));
            }
        }
        else if (string.Equals(actionType, "NanoflowCallAction", StringComparison.OrdinalIgnoreCase))
        {
            var target =
                TryReadStringProperty(action, "nanoflow") ??
                TryReadNestedStringProperty(action, "nanoflowCall", "nanoflow");
            if (!string.IsNullOrWhiteSpace(target))
            {
                calls.Add(new OverviewFlowCall("Nanoflow", target.Trim(), sourceNodeId ?? string.Empty));
            }
        }

        return calls;
    }

    private static string ResolveFlowKind(string modelType)
    {
        if (string.Equals(modelType, MicroflowModelType, StringComparison.OrdinalIgnoreCase))
        {
            return "Microflow";
        }

        if (string.Equals(modelType, NanoflowModelType, StringComparison.OrdinalIgnoreCase))
        {
            return "Nanoflow";
        }

        if (string.Equals(modelType, RuleModelType, StringComparison.OrdinalIgnoreCase))
        {
            return "Rule";
        }

        if (string.Equals(modelType, WorkflowModelType, StringComparison.OrdinalIgnoreCase))
        {
            return "Workflow";
        }

        return ShortTypeName(modelType);
    }

    private static IReadOnlyList<OverviewFlowEdge> ParseSequenceEdges(JsonElement flowResource)
    {
        if (!TryReadProperty(flowResource, "flows", out var flowsElement) ||
            flowsElement.ValueKind != JsonValueKind.Array)
        {
            return Array.Empty<OverviewFlowEdge>();
        }

        var edges = new List<OverviewFlowEdge>();
        var index = 0;
        foreach (var edgeElement in flowsElement.EnumerateArray())
        {
            if (edgeElement.ValueKind != JsonValueKind.Object)
            {
                index++;
                continue;
            }

            var modelType = TryReadStringProperty(edgeElement, "$Type");
            if (!string.Equals(modelType, SequenceFlowModelType, StringComparison.OrdinalIgnoreCase))
            {
                index++;
                continue;
            }

            var origin = TryReadStringProperty(edgeElement, "origin");
            var destination = TryReadStringProperty(edgeElement, "destination");
            if (string.IsNullOrWhiteSpace(origin) || string.IsNullOrWhiteSpace(destination))
            {
                index++;
                continue;
            }

            var edgeId =
                TryReadStringProperty(edgeElement, "$ID") ??
                $"edge-{index + 1}";

            edges.Add(new OverviewFlowEdge(
                EdgeId: edgeId,
                OriginNodeId: origin,
                DestinationNodeId: destination,
                Condition: BuildSequenceFlowCondition(edgeElement),
                IsErrorHandler: TryReadBooleanProperty(edgeElement, "isErrorHandler", out var isErrorHandler) && isErrorHandler,
                OriginConnectionIndex: TryReadIntProperty(edgeElement, "originConnectionIndex"),
                DestinationConnectionIndex: TryReadIntProperty(edgeElement, "destinationConnectionIndex")));

            index++;
        }

        return edges;
    }

    private static string? BuildSequenceFlowCondition(JsonElement edgeElement)
    {
        if (!TryReadProperty(edgeElement, "caseValues", out var caseValuesElement) ||
            caseValuesElement.ValueKind != JsonValueKind.Array)
        {
            return null;
        }

        var labels = new List<string>();
        foreach (var caseValue in caseValuesElement.EnumerateArray())
        {
            if (caseValue.ValueKind != JsonValueKind.Object)
            {
                continue;
            }

            var caseType = ShortTypeName(TryReadStringProperty(caseValue, "$Type") ?? "Case");
            if (string.Equals(caseType, "NoCase", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var caseValueToken = TryReadStringProperty(caseValue, "value");
            if (string.IsNullOrWhiteSpace(caseValueToken))
            {
                labels.Add(caseType);
            }
            else
            {
                labels.Add($"{caseType}={NormalizeInlineText(caseValueToken, 120)}");
            }
        }

        if (labels.Count == 0)
        {
            return null;
        }

        return string.Join(" | ", labels.Distinct(StringComparer.OrdinalIgnoreCase));
    }

    private static string? BuildActionDescriptor(string actionType, JsonElement actionElement) =>
        actionType switch
        {
            "RetrieveAction" => BuildRetrieveActionDescriptor(actionElement),
            "ChangeListAction" => BuildChangeListActionDescriptor(actionElement),
            "ChangeObjectAction" => BuildChangeObjectActionDescriptor(actionElement),
            "CommitAction" => BuildCommitActionDescriptor(actionElement),
            "CreateObjectAction" => BuildCreateObjectActionDescriptor(actionElement),
            "ChangeVariableAction" => BuildChangeVariableActionDescriptor(actionElement),
            "CreateVariableAction" => BuildCreateVariableActionDescriptor(actionElement),
            "DeleteAction" => BuildDeleteActionDescriptor(actionElement),
            "MicroflowCallAction" => BuildMicroflowCallActionDescriptor(actionElement),
            "NanoflowCallAction" => BuildNanoflowCallActionDescriptor(actionElement),
            "ShowPageAction" => BuildShowPageActionDescriptor(actionElement),
            "ShowMessageAction" => BuildShowMessageActionDescriptor(actionElement),
            "CloseFormAction" => BuildCloseFormActionDescriptor(actionElement),
            "JavaActionCallAction" => BuildNamedCallActionDescriptor(actionElement, "java action", "javaAction", "actionName"),
            "JavaScriptActionCallAction" => BuildNamedCallActionDescriptor(actionElement, "javascript action", "javaScriptAction", "actionName"),
            _ => BuildGenericActionDescriptor(actionElement),
        };

    private static string? BuildRetrieveActionDescriptor(JsonElement actionElement)
    {
        var outputVariableName = TryReadStringProperty(actionElement, "outputVariableName");
        var outputLabel = string.IsNullOrWhiteSpace(outputVariableName) ? "object(s)" : outputVariableName;
        var details = new List<string>();
        AppendOption(details, "retrieveType", TryReadStringProperty(actionElement, "retrieveType"));
        AppendOption(details, "overAssociations", TryReadStringProperty(actionElement, "retrieveOverAssociations"));
        AppendOption(details, "xPath", TryReadStringProperty(actionElement, "xPathConstraint"), 220);

        if (!TryReadProperty(actionElement, "retrieveSource", out var retrieveSource) ||
            retrieveSource.ValueKind != JsonValueKind.Object)
        {
            return details.Count == 0
                ? $"retrieve {outputLabel}"
                : $"retrieve {outputLabel} ({string.Join(", ", details)})";
        }

        var sourceType = ShortTypeName(TryReadStringProperty(retrieveSource, "$Type") ?? string.Empty);
        string sourceDescriptor;
        if (string.Equals(sourceType, "AssociationRetrieveSource", StringComparison.OrdinalIgnoreCase))
        {
            var association = ShortMemberName(TryReadStringProperty(retrieveSource, "association")) ?? "<association>";
            var startVariable = TryReadStringProperty(retrieveSource, "startVariableName");
            var startLabel = string.IsNullOrWhiteSpace(startVariable) ? "<object>" : startVariable;
            sourceDescriptor = $"retrieve {outputLabel} over association {association} from {startLabel}";
        }
        else if (string.Equals(sourceType, "DatabaseRetrieveSource", StringComparison.OrdinalIgnoreCase))
        {
            var entity = TryReadStringProperty(retrieveSource, "entity");
            var entityLabel = string.IsNullOrWhiteSpace(entity) ? "<entity>" : entity;
            sourceDescriptor = $"retrieve {outputLabel} from {entityLabel}";
        }
        else
        {
            sourceDescriptor = $"retrieve {outputLabel}";
        }

        return details.Count == 0
            ? sourceDescriptor
            : $"{sourceDescriptor} ({string.Join(", ", details)})";
    }

    private static string BuildChangeObjectActionDescriptor(JsonElement actionElement)
    {
        var variableName = TryReadStringProperty(actionElement, "changeVariableName");
        var variableLabel = string.IsNullOrWhiteSpace(variableName) ? "object" : variableName;
        var details = new List<string>();
        var memberSummary = FormatChangedMemberSummary(actionElement);
        if (!string.IsNullOrWhiteSpace(memberSummary))
        {
            details.Add(memberSummary);
        }

        AppendOption(details, "refreshInClient", TryReadStringProperty(actionElement, "refreshInClient"));
        AppendOption(details, "withEvents", TryReadStringProperty(actionElement, "withEvents"));

        return details.Count == 0 ? $"change {variableLabel}" : $"change {variableLabel} ({string.Join("; ", details)})";
    }

    private static string BuildChangeListActionDescriptor(JsonElement actionElement)
    {
        var variableName = TryReadAnyStringProperty(actionElement, "changeVariableName", "inputVariableName", "variableName");
        var variableLabel = string.IsNullOrWhiteSpace(variableName) ? "list" : variableName;

        var details = new List<string>();
        AppendOption(details, "type", TryReadStringProperty(actionElement, "type"));

        var valueExpression = TryReadActionExpression(actionElement, "value", "newValue");
        if (!string.IsNullOrWhiteSpace(valueExpression))
        {
            details.Add($"value={NormalizeInlineText(valueExpression, 140)}");
        }

        return details.Count == 0
            ? $"change {variableLabel}"
            : $"change {variableLabel} ({string.Join(", ", details)})";
    }

    private static string BuildCommitActionDescriptor(JsonElement actionElement)
    {
        var variableName = TryReadStringProperty(actionElement, "commitVariableName");
        var baseDescriptor = string.IsNullOrWhiteSpace(variableName)
            ? "commit object(s)"
            : $"commit {variableName}";

        var details = new List<string>();
        AppendOption(details, "refreshInClient", TryReadStringProperty(actionElement, "refreshInClient"));
        AppendOption(details, "withEvents", TryReadStringProperty(actionElement, "withEvents"));
        return details.Count == 0 ? baseDescriptor : $"{baseDescriptor} ({string.Join(", ", details)})";
    }

    private static string BuildCreateObjectActionDescriptor(JsonElement actionElement)
    {
        var entityName = TryReadStringProperty(actionElement, "entity");
        var outputVariableName = TryReadStringProperty(actionElement, "outputVariableName");
        var entityLabel = string.IsNullOrWhiteSpace(entityName) ? "object" : entityName;

        var baseDescriptor = string.IsNullOrWhiteSpace(outputVariableName)
            ? $"create {entityLabel}"
            : $"create {entityLabel} as {outputVariableName}";

        var details = new List<string>();
        var memberSummary = FormatChangedMemberSummary(actionElement);
        if (!string.IsNullOrWhiteSpace(memberSummary))
        {
            details.Add(memberSummary);
        }

        return details.Count == 0 ? baseDescriptor : $"{baseDescriptor} ({string.Join("; ", details)})";
    }

    private static string? BuildChangeVariableActionDescriptor(JsonElement actionElement)
    {
        var variableName = TryReadAnyStringProperty(actionElement, "changeVariableName", "variableName");
        if (string.IsNullOrWhiteSpace(variableName))
        {
            return null;
        }

        var expression = TryReadActionExpression(actionElement, "value", "newValue", "expression");
        return string.IsNullOrWhiteSpace(expression)
            ? $"change variable {variableName}"
            : $"change variable {variableName}={expression}";
    }

    private static string? BuildCreateVariableActionDescriptor(JsonElement actionElement)
    {
        var variableName = TryReadAnyStringProperty(actionElement, "outputVariableName", "variableName");
        if (string.IsNullOrWhiteSpace(variableName))
        {
            return null;
        }

        var variableType = TryReadAnyStringProperty(actionElement, "variableType", "type");
        var expression = TryReadActionExpression(actionElement, "value", "initialValue", "initialValueExpression", "defaultValue");
        var baseDescriptor = string.IsNullOrWhiteSpace(variableType)
            ? $"create variable {variableName}"
            : $"create variable {variableName}:{variableType}";

        return string.IsNullOrWhiteSpace(expression)
            ? baseDescriptor
            : $"{baseDescriptor}={expression}";
    }

    private static string? BuildDeleteActionDescriptor(JsonElement actionElement)
    {
        var variableName = TryReadAnyStringProperty(actionElement, "deleteVariableName", "inputVariableName", "variableName");
        if (string.IsNullOrWhiteSpace(variableName))
        {
            return null;
        }

        var details = new List<string>();
        AppendOption(details, "refreshInClient", TryReadStringProperty(actionElement, "refreshInClient"));
        return details.Count == 0
            ? $"delete {variableName}"
            : $"delete {variableName} ({string.Join(", ", details)})";
    }

    private static string? BuildMicroflowCallActionDescriptor(JsonElement actionElement)
    {
        var microflowName =
            TryReadStringProperty(actionElement, "microflow") ??
            TryReadNestedStringProperty(actionElement, "microflowCall", "microflow");
        var outputVariableName = TryReadStringProperty(actionElement, "outputVariableName");

        if (string.IsNullOrWhiteSpace(microflowName) && string.IsNullOrWhiteSpace(outputVariableName))
        {
            return null;
        }

        var baseDescriptor = string.IsNullOrWhiteSpace(microflowName)
            ? "call microflow"
            : $"call microflow {microflowName}";

        if (!string.IsNullOrWhiteSpace(outputVariableName))
        {
            baseDescriptor = $"{baseDescriptor} -> {outputVariableName}";
        }

        return baseDescriptor;
    }

    private static string? BuildNanoflowCallActionDescriptor(JsonElement actionElement)
    {
        var nanoflowName =
            TryReadStringProperty(actionElement, "nanoflow") ??
            TryReadNestedStringProperty(actionElement, "nanoflowCall", "nanoflow");
        var outputVariableName = TryReadStringProperty(actionElement, "outputVariableName");

        if (string.IsNullOrWhiteSpace(nanoflowName) && string.IsNullOrWhiteSpace(outputVariableName))
        {
            return null;
        }

        var baseDescriptor = string.IsNullOrWhiteSpace(nanoflowName)
            ? "call nanoflow"
            : $"call nanoflow {nanoflowName}";

        if (!string.IsNullOrWhiteSpace(outputVariableName))
        {
            baseDescriptor = $"{baseDescriptor} -> {outputVariableName}";
        }

        return baseDescriptor;
    }

    private static string BuildShowPageActionDescriptor(JsonElement actionElement)
    {
        var pageName =
            TryReadStringProperty(actionElement, "page") ??
            TryReadNestedStringProperty(actionElement, "pageSettings", "page");

        return string.IsNullOrWhiteSpace(pageName)
            ? "show page"
            : $"show page {pageName}";
    }

    private static string BuildShowMessageActionDescriptor(JsonElement actionElement)
    {
        var details = new List<string>();

        var messageText = TryReadNestedTranslatableTextProperty(actionElement, "template", "text");
        if (!string.IsNullOrWhiteSpace(messageText))
        {
            details.Add($"text={NormalizeInlineText(messageText, 90)}");
        }

        AppendOption(details, "type", TryReadStringProperty(actionElement, "type"));
        AppendOption(details, "blocking", TryReadStringProperty(actionElement, "blocking"));

        return details.Count == 0
            ? "show message"
            : $"show message ({string.Join(", ", details)})";
    }

    private static string BuildCloseFormActionDescriptor(JsonElement actionElement)
    {
        var pagesToClose = TryReadAnyStringProperty(actionElement, "numberOfPagesToClose", "numberOfPagesToClose2");
        return string.IsNullOrWhiteSpace(pagesToClose)
            ? "close page"
            : $"close page (pagesToClose={NormalizeInlineText(pagesToClose, 24)})";
    }

    private static string? BuildNamedCallActionDescriptor(
        JsonElement actionElement,
        string actionLabel,
        params string[] actionNamePropertyCandidates)
    {
        var actionName = TryReadAnyStringProperty(actionElement, actionNamePropertyCandidates);
        var outputVariableName = TryReadStringProperty(actionElement, "outputVariableName");
        if (string.IsNullOrWhiteSpace(actionName) && string.IsNullOrWhiteSpace(outputVariableName))
        {
            return null;
        }

        var baseDescriptor = string.IsNullOrWhiteSpace(actionName)
            ? $"call {actionLabel}"
            : $"call {actionLabel} {actionName}";

        if (!string.IsNullOrWhiteSpace(outputVariableName))
        {
            baseDescriptor = $"{baseDescriptor} -> {outputVariableName}";
        }

        return baseDescriptor;
    }

    private static string? BuildGenericActionDescriptor(JsonElement actionElement)
    {
        var actionType = ShortTypeName(TryReadStringProperty(actionElement, "$Type") ?? "Action");
        var details = new List<string>();
        AppendOption(details, "output", TryReadStringProperty(actionElement, "outputVariableName"));
        AppendOption(details, "entity", TryReadStringProperty(actionElement, "entity"));
        AppendOption(details, "microflow", TryReadStringProperty(actionElement, "microflow"));
        AppendOption(details, "nanoflow", TryReadStringProperty(actionElement, "nanoflow"));
        AppendOption(details, "errorHandlingType", TryReadStringProperty(actionElement, "errorHandlingType"));

        return details.Count == 0
            ? actionType
            : $"{actionType} ({string.Join(", ", details)})";
    }

    private static string? BuildLoopDescriptor(JsonElement loopElement)
    {
        if (!TryReadProperty(loopElement, "loopSource", out var loopSource) ||
            loopSource.ValueKind != JsonValueKind.Object)
        {
            return "iterate";
        }

        var listVariableName = TryReadStringProperty(loopSource, "listVariableName");
        var iteratorVariableName = TryReadStringProperty(loopSource, "variableName");

        if (!string.IsNullOrWhiteSpace(listVariableName) && !string.IsNullOrWhiteSpace(iteratorVariableName))
        {
            return $"iterate {listVariableName} as {iteratorVariableName}";
        }

        if (!string.IsNullOrWhiteSpace(listVariableName))
        {
            return $"iterate {listVariableName}";
        }

        if (!string.IsNullOrWhiteSpace(iteratorVariableName))
        {
            return $"iterate as {iteratorVariableName}";
        }

        return "iterate";
    }

    private static string? BuildDecisionDescriptor(JsonElement decisionElement)
    {
        var caption = TryReadStringProperty(decisionElement, "caption");
        var expression = TryReadNestedStringProperty(decisionElement, "splitCondition", "expression");

        var parts = new List<string>();
        if (!string.IsNullOrWhiteSpace(caption))
        {
            parts.Add(NormalizeInlineText(caption, 120));
        }

        if (!string.IsNullOrWhiteSpace(expression))
        {
            parts.Add($"expression={NormalizeInlineText(expression, 120)}");
        }

        return parts.Count == 0 ? "decision" : string.Join(" ", parts);
    }

    private static string? BuildInheritanceSplitDescriptor(JsonElement splitElement)
    {
        var variableName = TryReadStringProperty(splitElement, "splitVariableName");
        var caption = TryReadStringProperty(splitElement, "caption");

        if (!string.IsNullOrWhiteSpace(variableName) && !string.IsNullOrWhiteSpace(caption))
        {
            return $"split {variableName} ({NormalizeInlineText(caption, 120)})";
        }

        if (!string.IsNullOrWhiteSpace(variableName))
        {
            return $"split {variableName}";
        }

        if (!string.IsNullOrWhiteSpace(caption))
        {
            return NormalizeInlineText(caption, 120);
        }

        return "inheritance split";
    }

    private static string? FormatChangedMemberSummary(JsonElement actionElement, int maxMembers = 8)
    {
        if (!TryReadProperty(actionElement, "items", out var items) || items.ValueKind != JsonValueKind.Array)
        {
            return null;
        }

        var uniqueMemberAssignments = new List<string>();
        var seenMembers = new HashSet<string>(StringComparer.Ordinal);

        foreach (var item in items.EnumerateArray())
        {
            if (item.ValueKind != JsonValueKind.Object)
            {
                continue;
            }

            var attribute = ShortMemberName(TryReadStringProperty(item, "attribute"));
            var association = ShortMemberName(TryReadStringProperty(item, "association"));
            var memberName = string.IsNullOrWhiteSpace(attribute) ? association : attribute;
            memberName ??= "<member>";
            var valueExpression = TryReadPropertyAsText(item, "value", 180);
            var memberAssignment = string.IsNullOrWhiteSpace(valueExpression)
                ? memberName
                : $"{memberName}={valueExpression}";

            if (!seenMembers.Add(memberAssignment))
            {
                continue;
            }

            uniqueMemberAssignments.Add(memberAssignment);
        }

        if (uniqueMemberAssignments.Count == 0)
        {
            return null;
        }

        var visibleMembers = uniqueMemberAssignments.Take(maxMembers).ToList();
        var remaining = uniqueMemberAssignments.Count - visibleMembers.Count;
        if (remaining > 0)
        {
            visibleMembers.Add($"+{remaining} more");
        }

        return string.Join(", ", visibleMembers);
    }

    private static string? ShortMemberName(string? qualifiedName)
    {
        if (string.IsNullOrWhiteSpace(qualifiedName))
        {
            return null;
        }

        var trimmed = qualifiedName.Trim();
        var slashIndex = trimmed.LastIndexOf('/');
        if (slashIndex >= 0 && slashIndex < trimmed.Length - 1)
        {
            trimmed = trimmed[(slashIndex + 1)..];
        }

        var dotIndex = trimmed.LastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < trimmed.Length - 1)
        {
            return trimmed[(dotIndex + 1)..];
        }

        return trimmed;
    }

    private static void AppendOption(ICollection<string> options, string key, string? value, int maxLength = 140)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return;
        }

        var normalized = NormalizeInlineText(value, maxLength);
        if (normalized.Length == 0)
        {
            return;
        }

        options.Add($"{key}={normalized}");
    }

    private static string? TryReadAnyStringProperty(JsonElement element, params string[] propertyNameCandidates)
    {
        foreach (var propertyName in propertyNameCandidates)
        {
            var value = TryReadStringProperty(element, propertyName);
            if (!string.IsNullOrWhiteSpace(value))
            {
                return value;
            }
        }

        return null;
    }

    private static string? TryReadActionExpression(JsonElement actionElement, params string[] propertyNameCandidates)
    {
        foreach (var propertyName in propertyNameCandidates)
        {
            var expression = TryReadPropertyAsText(actionElement, propertyName, 220);
            if (!string.IsNullOrWhiteSpace(expression))
            {
                return expression;
            }
        }

        return null;
    }

    private static string? TryReadPropertyAsText(JsonElement element, string propertyName, int maxLength)
    {
        if (!TryReadProperty(element, propertyName, out var propertyValue))
        {
            return null;
        }

        var text = propertyValue.ValueKind switch
        {
            JsonValueKind.String => propertyValue.GetString(),
            JsonValueKind.Number => propertyValue.GetRawText(),
            JsonValueKind.True => "true",
            JsonValueKind.False => "false",
            JsonValueKind.Null => "null",
            JsonValueKind.Object => NormalizeInlineText(propertyValue.GetRawText(), maxLength),
            JsonValueKind.Array => $"[{propertyValue.GetArrayLength()} item(s)]",
            _ => NormalizeInlineText(propertyValue.GetRawText(), maxLength),
        };

        return string.IsNullOrWhiteSpace(text) ? null : NormalizeInlineText(text, maxLength);
    }

    private static string NormalizeInlineText(string text, int maxLength = 140)
    {
        if (string.IsNullOrWhiteSpace(text))
        {
            return string.Empty;
        }

        var normalized = string.Join(" ", text.Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries)).Trim();
        if (normalized.Length > maxLength)
        {
            normalized = $"{normalized[..maxLength]}...";
        }

        return normalized;
    }

    private static string ResolveModuleName(string elementName)
    {
        if (string.IsNullOrWhiteSpace(elementName))
        {
            return "Unknown";
        }

        var separatorIndex = elementName.IndexOf('.');
        if (separatorIndex <= 0)
        {
            return "Unknown";
        }

        var moduleName = elementName[..separatorIndex].Trim();
        return string.IsNullOrWhiteSpace(moduleName) ? "Unknown" : moduleName;
    }

    private static bool IsFlowModelType(string modelType)
    {
        return string.Equals(modelType, MicroflowModelType, StringComparison.OrdinalIgnoreCase) ||
               string.Equals(modelType, NanoflowModelType, StringComparison.OrdinalIgnoreCase) ||
               string.Equals(modelType, RuleModelType, StringComparison.OrdinalIgnoreCase);
    }

    private static bool IsEnumerationModelType(string modelType)
    {
        return string.Equals(modelType, DomainEnumerationModelType, StringComparison.OrdinalIgnoreCase) ||
               string.Equals(modelType, LegacyDomainEnumerationModelType, StringComparison.OrdinalIgnoreCase);
    }

    private static JsonDocument ParseDumpDocument(string path)
    {
        var text = File.ReadAllText(path);
        if (text.Length > 0 && text[0] == '\uFEFF')
        {
            text = text[1..];
        }

        return JsonDocument.Parse(text);
    }

    private static DumpSnapshot BuildSnapshot(JsonElement root)
    {
        var snapshot = new DumpSnapshot();
        var stack = new Stack<JsonElement>();
        stack.Push(root);

        while (stack.Count > 0)
        {
            var current = stack.Pop();
            switch (current.ValueKind)
            {
                case JsonValueKind.Object:
                {
                    var objectId = TryReadStringProperty(current, "$ID");
                    if (!string.IsNullOrWhiteSpace(objectId))
                    {
                        var clone = current.Clone();
                        snapshot.ObjectsById[objectId] = clone;

                        var parentId = TryReadStringProperty(current, "$ContainerID");
                        if (!string.IsNullOrWhiteSpace(parentId) &&
                            !string.Equals(parentId, objectId, StringComparison.OrdinalIgnoreCase))
                        {
                            snapshot.ParentById[objectId] = parentId;
                        }

                        var modelType = TryReadStringProperty(current, "$Type");
                        var containerProperty = TryReadStringProperty(current, "$ContainerProperty");
                        if (IsTrackableResource(modelType, containerProperty))
                        {
                            var descriptor = BuildResourceDescriptor(clone);
                            if (descriptor is not null)
                            {
                                snapshot.ResourcesById[objectId] = descriptor;
                            }
                        }
                    }

                    foreach (var property in current.EnumerateObject())
                    {
                        stack.Push(property.Value);
                    }

                    break;
                }

                case JsonValueKind.Array:
                    foreach (var item in current.EnumerateArray())
                    {
                        stack.Push(item);
                    }

                    break;
            }
        }

        return snapshot;
    }

    private static bool IsTrackableResource(string? modelType, string? containerProperty)
    {
        if (string.IsNullOrWhiteSpace(modelType))
        {
            return false;
        }

        if (!string.IsNullOrWhiteSpace(containerProperty) &&
            TrackableContainerProperties.Contains(containerProperty))
        {
            return true;
        }

        return TrackableDomainModelTypes.Contains(modelType);
    }

    private static ResourceDescriptor? BuildResourceDescriptor(JsonElement element)
    {
        var resourceId = TryReadStringProperty(element, "$ID");
        var modelType = TryReadStringProperty(element, "$Type");

        if (string.IsNullOrWhiteSpace(resourceId) || string.IsNullOrWhiteSpace(modelType))
        {
            return null;
        }

        var elementType = ResolveElementType(modelType, element);
        var elementName = ResolveElementName(element);
        if (string.Equals(elementName, "<unnamed>", StringComparison.Ordinal))
        {
            var shortId = resourceId.Length > 8 ? resourceId[..8] : resourceId;
            elementName = $"{elementType} [{shortId}]";
        }

        return new ResourceDescriptor(
            ResourceId: resourceId,
            ModelType: modelType,
            ElementType: elementType,
            ElementName: elementName,
            Object: element);
    }

    private static string ResolveElementType(string modelType, JsonElement element)
    {
        var elementType = ResolveElementType(modelType);
        if (string.Equals(elementType, "Entity", StringComparison.OrdinalIgnoreCase) &&
            !IsPersistableEntity(element))
        {
            return "NonPersistentEntity";
        }

        return elementType;
    }

    private static string ResolveElementType(string modelType)
    {
        if (ElementTypeOverrides.TryGetValue(modelType, out var overrideType))
        {
            return overrideType;
        }

        var separatorIndex = modelType.IndexOf('$');
        var typeName = separatorIndex >= 0 && separatorIndex < modelType.Length - 1
            ? modelType[(separatorIndex + 1)..]
            : modelType;

        if (typeName.EndsWith("Document", StringComparison.OrdinalIgnoreCase) &&
            typeName.Length > "Document".Length)
        {
            return typeName[..^"Document".Length];
        }

        return typeName;
    }

    private static string ResolveElementName(JsonElement element)
    {
        foreach (var propertyName in NameFields)
        {
            var value = TryReadStringProperty(element, propertyName);
            if (!string.IsNullOrWhiteSpace(value))
            {
                return value;
            }
        }

        return "<unnamed>";
    }

    private static string ShortTypeName(string modelType)
    {
        if (string.IsNullOrWhiteSpace(modelType))
        {
            return "<unknown>";
        }

        var separatorIndex = modelType.IndexOf('$');
        return separatorIndex >= 0 && separatorIndex < modelType.Length - 1
            ? modelType[(separatorIndex + 1)..]
            : modelType;
    }

    private static string? TryReadStringProperty(JsonElement element, string propertyName)
    {
        foreach (var property in element.EnumerateObject())
        {
            if (!string.Equals(property.Name, propertyName, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            if (property.Value.ValueKind == JsonValueKind.String)
            {
                return property.Value.GetString();
            }

            if (property.Value.ValueKind == JsonValueKind.Number ||
                property.Value.ValueKind == JsonValueKind.True ||
                property.Value.ValueKind == JsonValueKind.False)
            {
                return property.Value.GetRawText();
            }
        }

        return null;
    }

    private static bool TryReadProperty(JsonElement element, string propertyName, out JsonElement value)
    {
        foreach (var property in element.EnumerateObject())
        {
            if (!string.Equals(property.Name, propertyName, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            value = property.Value;
            return true;
        }

        value = default;
        return false;
    }

    private static bool TryReadBooleanProperty(JsonElement element, string propertyName, out bool value)
    {
        value = default;
        if (!TryReadProperty(element, propertyName, out var propertyValue))
        {
            return false;
        }

        if (propertyValue.ValueKind is JsonValueKind.True or JsonValueKind.False)
        {
            value = propertyValue.GetBoolean();
            return true;
        }

        if (propertyValue.ValueKind == JsonValueKind.String &&
            bool.TryParse(propertyValue.GetString(), out var parsed))
        {
            value = parsed;
            return true;
        }

        return false;
    }

    private static int? TryReadIntProperty(JsonElement element, string propertyName)
    {
        if (!TryReadProperty(element, propertyName, out var propertyValue))
        {
            return null;
        }

        if (propertyValue.ValueKind == JsonValueKind.Number && propertyValue.TryGetInt32(out var number))
        {
            return number;
        }

        if (propertyValue.ValueKind == JsonValueKind.String &&
            int.TryParse(propertyValue.GetString(), out var parsed))
        {
            return parsed;
        }

        return null;
    }

    private static string? TryReadNestedStringProperty(JsonElement element, string objectPropertyName, string nestedPropertyName)
    {
        if (!TryReadProperty(element, objectPropertyName, out var objectElement) ||
            objectElement.ValueKind != JsonValueKind.Object)
        {
            return null;
        }

        return TryReadStringProperty(objectElement, nestedPropertyName);
    }

    private static string? TryReadNestedTranslatableTextProperty(
        JsonElement element,
        string objectPropertyName,
        string nestedTextPropertyName,
        string preferredLanguageCode = "en_US")
    {
        if (!TryReadProperty(element, objectPropertyName, out var objectElement) ||
            objectElement.ValueKind != JsonValueKind.Object)
        {
            return null;
        }

        if (!TryReadProperty(objectElement, nestedTextPropertyName, out var textElement))
        {
            return null;
        }

        return TryReadTranslatedText(textElement, preferredLanguageCode);
    }

    private static string? TryReadTranslatedText(JsonElement textElement, string preferredLanguageCode = "en_US")
    {
        if (textElement.ValueKind == JsonValueKind.String)
        {
            return textElement.GetString();
        }

        if (textElement.ValueKind != JsonValueKind.Object)
        {
            return null;
        }

        if (TryReadProperty(textElement, "translations", out var translationsElement) &&
            translationsElement.ValueKind == JsonValueKind.Array)
        {
            string? fallbackText = null;
            foreach (var translation in translationsElement.EnumerateArray())
            {
                if (translation.ValueKind != JsonValueKind.Object)
                {
                    continue;
                }

                var translationText = TryReadStringProperty(translation, "text");
                if (string.IsNullOrWhiteSpace(translationText))
                {
                    continue;
                }

                fallbackText ??= translationText;
                var languageCode = TryReadStringProperty(translation, "languageCode");
                if (string.Equals(languageCode, preferredLanguageCode, StringComparison.OrdinalIgnoreCase))
                {
                    return translationText;
                }
            }

            return fallbackText;
        }

        return TryReadStringProperty(textElement, "text");
    }

    private sealed class DumpSnapshot
    {
        public Dictionary<string, JsonElement> ObjectsById { get; } = new(StringComparer.OrdinalIgnoreCase);

        public Dictionary<string, string> ParentById { get; } = new(StringComparer.OrdinalIgnoreCase);

        public Dictionary<string, ResourceDescriptor> ResourcesById { get; } = new(StringComparer.OrdinalIgnoreCase);
    }

    private sealed record ResourceDescriptor(
        string ResourceId,
        string ModelType,
        string ElementType,
        string ElementName,
        JsonElement Object);

    private sealed record MutableFlowNode(
        string NodeId,
        string NodeType,
        string Label,
        string? Detail,
        string? LoopOwnerId,
        bool IsExecutable,
        IReadOnlyList<OverviewFlowCall> Calls)
    {
        public OverviewFlowNode ToImmutable() =>
            new(
                NodeId,
                NodeType,
                Label,
                Detail,
                LoopOwnerId,
                IsExecutable,
                Calls);
    }

    private sealed class MutableOverviewModule
    {
        public MutableOverviewModule(string module)
        {
            Module = module;
        }

        public string Module { get; }

        public List<OverviewEntity> Entities { get; } = new();

        public List<OverviewAssociation> Associations { get; } = new();

        public List<OverviewEnumeration> Enumerations { get; } = new();

        public List<OverviewFlow> Flows { get; } = new();

        public OverviewModule ToImmutable() =>
            new(
                Module,
                new OverviewDomainModel(
                    Entities
                        .OrderBy(entity => entity.Name, StringComparer.OrdinalIgnoreCase)
                        .ToArray(),
                    Associations
                        .OrderBy(association => association.Name, StringComparer.OrdinalIgnoreCase)
                        .ToArray(),
                    Enumerations
                        .OrderBy(enumeration => enumeration.Name, StringComparer.OrdinalIgnoreCase)
                        .ToArray()),
                Flows
                    .OrderBy(flow => flow.Kind, StringComparer.OrdinalIgnoreCase)
                    .ThenBy(flow => flow.QualifiedName, StringComparer.OrdinalIgnoreCase)
                    .ToArray());
    }
}

internal sealed record ModelOverviewDocument(
    string SchemaVersion,
    DateTimeOffset GeneratedAtUtc,
    string SourceMprPath,
    string SourceDumpPath,
    OverviewSummary Summary,
    IReadOnlyList<OverviewModule> Modules,
    IReadOnlyList<OverviewCallEdge> FlowCallGraph,
    string AppPseudocode);

internal sealed record OverviewSummary(
    int ModuleCount,
    int EntityCount,
    int AssociationCount,
    int EnumerationCount,
    int FlowCount,
    int MicroflowCount,
    int NanoflowCount,
    int RuleCount,
    int WorkflowCount,
    int FlowNodeCount,
    int FlowEdgeCount,
    int FlowCallEdgeCount);

internal sealed record OverviewModule(
    string Module,
    OverviewDomainModel DomainModel,
    IReadOnlyList<OverviewFlow> Flows);

internal sealed record OverviewDomainModel(
    IReadOnlyList<OverviewEntity> Entities,
    IReadOnlyList<OverviewAssociation> Associations,
    IReadOnlyList<OverviewEnumeration> Enumerations);

internal sealed record OverviewEntity(
    string Name,
    bool IsPersistable,
    string? Generalization,
    IReadOnlyList<OverviewAttribute> Attributes);

internal sealed record OverviewAttribute(
    string Name,
    string? Type);

internal sealed record OverviewAssociation(
    string Name,
    string ParentEntity,
    string ChildEntity,
    string Cardinality,
    string? Type,
    string? Owner,
    string? StorageFormat);

internal sealed record OverviewEnumeration(
    string Name,
    IReadOnlyList<string> Values);

internal sealed record OverviewFlow(
    string FlowId,
    string Kind,
    string QualifiedName,
    string Module,
    IReadOnlyList<OverviewFlowNode> Nodes,
    IReadOnlyList<OverviewFlowEdge> Edges,
    IReadOnlyList<OverviewFlowCall> Calls,
    IReadOnlyList<string> StartNodeIds,
    IReadOnlyList<string> PrimaryExecutionOrderNodeIds,
    string Pseudocode);

internal sealed record OverviewFlowNode(
    string NodeId,
    string NodeType,
    string Label,
    string? Detail,
    string? LoopOwnerId,
    bool IsExecutable,
    IReadOnlyList<OverviewFlowCall> Calls);

internal sealed record OverviewFlowEdge(
    string EdgeId,
    string OriginNodeId,
    string DestinationNodeId,
    string? Condition,
    bool IsErrorHandler,
    int? OriginConnectionIndex,
    int? DestinationConnectionIndex);

internal sealed record OverviewFlowCall(
    string CallKind,
    string TargetFlowName,
    string SourceNodeId);

internal sealed record OverviewCallEdge(
    string CallerModule,
    string CallerFlow,
    string CallerKind,
    string CallKind,
    string SourceNodeId,
    string TargetModule,
    string TargetFlow,
    bool IsInternal);
