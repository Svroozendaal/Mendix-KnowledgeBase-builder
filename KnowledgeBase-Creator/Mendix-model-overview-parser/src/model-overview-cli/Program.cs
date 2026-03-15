using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using MendixKnowledgeBaseBuilder;

var jsonOptions = new JsonSerializerOptions
{
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    WriteIndented = true,
};

string? dumpPath = null;
string? outputPath = null;
string? modulesArg = null;
bool listModules = false;

for (int i = 0; i < args.Length; i++)
{
    switch (args[i])
    {
        case "--dump" when i + 1 < args.Length:
            dumpPath = args[++i];
            break;
        case "--output" when i + 1 < args.Length:
            outputPath = args[++i];
            break;
        case "--modules" when i + 1 < args.Length:
            modulesArg = args[++i];
            break;
        case "--list-modules":
            listModules = true;
            break;
    }
}

if (string.IsNullOrWhiteSpace(dumpPath))
{
    Console.Error.WriteLine("Usage:");
    Console.Error.WriteLine("  ModelOverviewCli --dump <path> --list-modules");
    Console.Error.WriteLine("  ModelOverviewCli --dump <path> --output <dir> [--modules \"Mod1,Mod2\"]");
    return 1;
}

if (!File.Exists(dumpPath))
{
    Console.Error.WriteLine($"Dump file not found: {dumpPath}");
    return 1;
}

// --- List modules mode ---
if (listModules)
{
    return ListModules(dumpPath);
}

// --- Generate mode ---
if (string.IsNullOrWhiteSpace(outputPath))
{
    Console.Error.WriteLine("--output <dir> is required for generation mode.");
    return 1;
}

return GenerateOverview(dumpPath, outputPath, modulesArg);

// ---------------------------------------------------------------------------

static int ListModules(string dumpPath)
{
    using var stream = File.OpenRead(dumpPath);
    using var document = JsonDocument.Parse(stream);

    if (!document.RootElement.TryGetProperty("units", out var units) ||
        units.ValueKind != JsonValueKind.Array)
    {
        Console.Error.WriteLine("Dump file does not contain a 'units' array.");
        return 1;
    }

    var modules = new List<(string Name, string Category)>();
    foreach (var unit in units.EnumerateArray())
    {
        if (!TryReadString(unit, "$Type", out var modelType) ||
            !string.Equals(modelType, "Projects$Module", StringComparison.Ordinal))
        {
            continue;
        }

        if (!TryReadString(unit, "name", out var name))
        {
            continue;
        }

        var fromAppStore = TryReadBool(unit, "fromAppStore", out var flag) && flag;
        var category = ResolveCategory(name, fromAppStore);
        modules.Add((name, category));
    }

    modules.Sort((a, b) =>
    {
        int cmp = CategoryOrder(a.Category).CompareTo(CategoryOrder(b.Category));
        return cmp != 0 ? cmp : string.Compare(a.Name, b.Name, StringComparison.OrdinalIgnoreCase);
    });

    // Output as JSON for machine consumption (the PS1 script parses this)
    var output = modules.Select(m => new { module = m.Name, category = m.Category }).ToArray();
    Console.WriteLine(JsonSerializer.Serialize(output, new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = true,
    }));

    return 0;
}

static int GenerateOverview(string dumpPath, string outputPath, string? modulesArg)
{
    var jsonOptions = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = true,
    };

    var generatedAtUtc = DateTimeOffset.UtcNow;
    var outputFullPath = Path.GetFullPath(outputPath);
    var appOverviewRoot = Directory.GetParent(outputFullPath)?.FullName
        ?? throw new DirectoryNotFoundException($"Could not resolve app-overview root from: {outputPath}");
    var dataRoot = Directory.GetParent(appOverviewRoot)?.FullName
        ?? throw new DirectoryNotFoundException($"Could not resolve data root from: {outputPath}");
    var runFolderName = Path.GetFileName(outputFullPath.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));

    Console.WriteLine($"Parsing dump: {dumpPath}");
    var document = MendixModelOverviewParser.ParseDump(dumpPath, dumpPath, generatedAtUtc);
    Console.WriteLine($"Parsed {document.Modules.Count} module(s), {document.Summary.FlowCount} flow(s).");

    // Determine which modules to export
    var selectedModules = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
    if (!string.IsNullOrWhiteSpace(modulesArg))
    {
        foreach (var name in modulesArg.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
        {
            selectedModules.Add(name);
        }
    }

    Directory.CreateDirectory(outputPath);
    var exportedPaths = new List<string>();
    var manifestEntries = new List<object>();

    // ===== GENERAL folder =====
    var generalFolder = Path.Combine(outputPath, "general");
    Directory.CreateDirectory(generalFolder);

    // App info
    WriteJsonAndPseudo(generalFolder, "app-info",
        new { document.SchemaVersion, document.GeneratedAtUtc, document.SourceMprPath, document.SourceDumpPath, document.Summary },
        MendixModelOverviewParser.BuildAppInfoPseudocode(document),
        "general-app-info", jsonOptions, exportedPaths, manifestEntries);

    // User roles
    WriteJsonAndPseudo(generalFolder, "user-roles",
        new { document.ProjectSecurity },
        MendixModelOverviewParser.BuildUserRolesPseudocode(document),
        "general-user-roles", jsonOptions, exportedPaths, manifestEntries);

    // All modules overview
    var allModulesSummary = document.Modules.Select(m => new
    {
        module = m.Module,
        category = m.Category,
        fromAppStore = m.FromAppStore,
        moduleRoles = m.ModuleRoles,
        entityCount = m.DomainModel.Entities.Count,
        flowCount = m.Flows.Count,
        pageCount = m.Pages.Count,
        constantCount = m.Constants.Count,
    }).ToArray();
    WriteJsonAndPseudo(generalFolder, "all-modules",
        new { modules = allModulesSummary },
        MendixModelOverviewParser.BuildAllModulesOverviewPseudocode(document),
        "general-all-modules", jsonOptions, exportedPaths, manifestEntries);

    // Marketplace modules
    var marketplaceModules = document.Modules
        .Where(m => string.Equals(m.Category, "Marketplace", StringComparison.OrdinalIgnoreCase))
        .Select(m => new
        {
            module = m.Module,
            moduleRoles = m.ModuleRoles,
            entityCount = m.DomainModel.Entities.Count,
            flowCount = m.Flows.Count,
            pageCount = m.Pages.Count,
        }).ToArray();
    WriteJsonAndPseudo(generalFolder, "marketplace-modules",
        new { modules = marketplaceModules },
        MendixModelOverviewParser.BuildMarketplaceModulesPseudocode(document),
        "general-marketplace-modules", jsonOptions, exportedPaths, manifestEntries);

    Console.WriteLine($"  General: 4 file pairs written");

    // ===== MODULES folders =====
    IReadOnlyList<OverviewModule> modulesToExport = selectedModules.Count == 0
        ? document.Modules
        : document.Modules
            .Where(m => selectedModules.Contains(m.Module))
            .ToArray();

    if (modulesToExport.Count == 0 && selectedModules.Count > 0)
    {
        Console.Error.WriteLine($"None of the selected modules were found: {string.Join(", ", selectedModules)}");
        Console.Error.WriteLine($"Available: {string.Join(", ", document.Modules.Select(m => m.Module))}");
        return 1;
    }

    var modulesFolder = Path.Combine(outputPath, "modules");

    foreach (var module in modulesToExport)
    {
        var moduleFolder = string.Equals(module.Category, "Marketplace", StringComparison.OrdinalIgnoreCase)
            ? Path.Combine(modulesFolder, "marketplace", SanitizeToken(module.Module))
            : Path.Combine(modulesFolder, SanitizeToken(module.Module));
        Directory.CreateDirectory(moduleFolder);

        var moduleCallEdges = document.FlowCallGraph
            .Where(edge =>
                string.Equals(edge.CallerModule, module.Module, StringComparison.OrdinalIgnoreCase) ||
                string.Equals(edge.TargetModule, module.Module, StringComparison.OrdinalIgnoreCase))
            .ToArray();

        // Domain model
        WriteJsonAndPseudo(moduleFolder, "domain-model",
            new { module = module.Module, domainModel = module.DomainModel },
            MendixModelOverviewParser.BuildDomainModelPseudocode(module),
            "module-domain-model", jsonOptions, exportedPaths, manifestEntries);

        // Flows
        WriteJsonAndPseudo(moduleFolder, "flows",
            new { module = module.Module, flows = module.Flows, callEdges = moduleCallEdges },
            MendixModelOverviewParser.BuildFlowsPseudocode(module, document.FlowCallGraph),
            "module-flows", jsonOptions, exportedPaths, manifestEntries);
        WriteFlowDetailArtifacts(moduleFolder, module, moduleCallEdges, dataRoot, runFolderName, jsonOptions, exportedPaths, manifestEntries);

        // Pages
        WriteJsonAndPseudo(moduleFolder, "pages",
            new { module = module.Module, pages = module.Pages, snippets = module.Snippets },
            MendixModelOverviewParser.BuildPagesPseudocode(module),
            "module-pages", jsonOptions, exportedPaths, manifestEntries);
        WritePageDetailArtifacts(moduleFolder, module, dataRoot, runFolderName, jsonOptions, exportedPaths, manifestEntries);

        // Resources
        WriteJsonAndPseudo(moduleFolder, "resources",
            new { module = module.Module, constants = module.Constants, scheduledEvents = module.ScheduledEvents, otherResources = module.OtherResources },
            MendixModelOverviewParser.BuildResourcesPseudocode(module),
            "module-resources", jsonOptions, exportedPaths, manifestEntries);

        Console.WriteLine($"  Module: {module.Module} — {module.Flows.Count} flow(s), {module.Pages.Count} page(s), {module.DomainModel.Entities.Count} entity(ies)");
    }

    // ===== Manifest =====
    var manifest = new
    {
        schemaVersion = "2.0",
        generatedAtUtc = generatedAtUtc.ToString("O"),
        selectedModules = selectedModules.OrderBy(m => m, StringComparer.OrdinalIgnoreCase).ToArray(),
        artifactCount = exportedPaths.Count,
        artifacts = manifestEntries,
    };
    var manifestPath = Path.Combine(outputPath, "manifest.json");
    File.WriteAllText(manifestPath, JsonSerializer.Serialize(manifest, jsonOptions), new UTF8Encoding(false));

    Console.WriteLine();
    Console.WriteLine($"Generated {exportedPaths.Count} files in: {outputPath}");
    return 0;
}

static void WriteJsonAndPseudo(
    string folder, string baseName, object jsonContent, string pseudoContent,
    string artifactType, JsonSerializerOptions jsonOptions,
    List<string> exportedPaths, List<object> manifestEntries)
{
    var jsonPath = Path.Combine(folder, $"{baseName}.json");
    File.WriteAllText(jsonPath, JsonSerializer.Serialize(jsonContent, jsonOptions), new UTF8Encoding(false));
    exportedPaths.Add(jsonPath);
    manifestEntries.Add(new { type = $"{artifactType}-json", path = jsonPath });

    var pseudoPath = Path.Combine(folder, $"{baseName}.pseudo.txt");
    File.WriteAllText(pseudoPath, pseudoContent, new UTF8Encoding(false));
    exportedPaths.Add(pseudoPath);
    manifestEntries.Add(new { type = $"{artifactType}-pseudo", path = pseudoPath });
}

static void WriteFlowDetailArtifacts(
    string moduleFolder,
    OverviewModule module,
    IReadOnlyList<OverviewCallEdge> moduleCallEdges,
    string dataRoot,
    string runFolderName,
    JsonSerializerOptions jsonOptions,
    List<string> exportedPaths,
    List<object> manifestEntries)
{
    var flowsFolder = Path.Combine(moduleFolder, "flows");
    Directory.CreateDirectory(flowsFolder);

    var moduleExportRelative = GetModuleExportRelativePath(module);
    var moduleKbRelative = GetModuleKnowledgeBaseRelativePath(module);
    var items = new List<object>();
    var usedSlugs = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

    foreach (var flow in module.Flows)
    {
        var slug = EnsureUniqueObjectSlug(BuildObjectSlug(flow.QualifiedName, flow.FlowId), flow.FlowId, usedSlugs);
        var jsonPath = Path.Combine(flowsFolder, $"{slug}.json");
        var l0Logical = ToLogicalPath(Path.Combine(moduleKbRelative, "flows", $"{slug}.abstract.md"));
        var l1Logical = ToLogicalPath(Path.Combine(moduleKbRelative, "flows", $"{slug}.overview.md"));
        var l2LogicalPath = ToLogicalPath(Path.Combine("app-overview", "current", moduleExportRelative, "flows", $"{slug}.json"));
        var aggregateJson = ToLogicalPath(Path.Combine("app-overview", runFolderName, moduleExportRelative, "flows.json"));
        var aggregatePseudo = ToLogicalPath(Path.Combine("app-overview", runFolderName, moduleExportRelative, "flows.pseudo.txt"));
        var collectionIndex = ToLogicalPath(Path.Combine("app-overview", "current", moduleExportRelative, "flows", "INDEX.json"));
        var flowCallEdges = moduleCallEdges
            .Where(edge =>
                string.Equals(edge.CallerFlow, flow.QualifiedName, StringComparison.OrdinalIgnoreCase) ||
                string.Equals(edge.TargetFlow, flow.QualifiedName, StringComparison.OrdinalIgnoreCase))
            .ToArray();

        var flowObject = new
        {
            _meta = new
            {
                objectType = "flow",
                module = module.Module,
                qualifiedName = flow.QualifiedName,
                stableId = flow.FlowId,
                slug,
                l0Path = l0Logical,
                l1Path = l1Logical,
                l2Path = l2LogicalPath,
                l2Logical = $"flow:{flow.QualifiedName}",
                sourceRun = runFolderName,
                aggregateJson,
                aggregatePseudo,
                collectionIndex,
            },
            flowId = flow.FlowId,
            kind = flow.Kind,
            qualifiedName = flow.QualifiedName,
            module = flow.Module,
            nodes = flow.Nodes,
            edges = flow.Edges,
            calls = flow.Calls,
            startNodeIds = flow.StartNodeIds,
            primaryExecutionOrderNodeIds = flow.PrimaryExecutionOrderNodeIds,
            pseudocode = flow.Pseudocode,
            retrieveActions = flow.RetrieveActions,
            decisionActions = flow.DecisionActions,
            showPageActions = flow.ShowPageActions,
            mutationActions = flow.MutationActions,
            callEdges = flowCallEdges,
        };

        File.WriteAllText(jsonPath, JsonSerializer.Serialize(flowObject, jsonOptions), new UTF8Encoding(false));
        exportedPaths.Add(jsonPath);
        manifestEntries.Add(new { type = "module-flow-object-json", path = jsonPath });
        manifestEntries.Add(new { type = "module-flow-detail-json", path = jsonPath });

        items.Add(new
        {
            objectType = "flow",
            qualifiedName = flow.QualifiedName,
            stableId = flow.FlowId,
            slug,
            kind = flow.Kind,
            nodeCount = flow.Nodes.Count,
            l0Path = l0Logical,
            l1Path = l1Logical,
            l2Path = l2LogicalPath,
            l2Logical = $"flow:{flow.QualifiedName}",
            sourceRun = runFolderName,
        });
    }

    var indexPath = Path.Combine(flowsFolder, "INDEX.json");
    var indexObject = new
    {
        objectType = "flow-collection",
        module = module.Module,
        sourceRun = runFolderName,
        l0Path = ToLogicalPath(Path.Combine(moduleKbRelative, "flows", "INDEX.abstract.md")),
        l1Path = ToLogicalPath(Path.Combine(moduleKbRelative, "FLOWS.md")),
        l2Path = ToLogicalPath(Path.Combine("app-overview", "current", moduleExportRelative, "flows", "INDEX.json")),
        items,
    };
    File.WriteAllText(indexPath, JsonSerializer.Serialize(indexObject, jsonOptions), new UTF8Encoding(false));
    exportedPaths.Add(indexPath);
    manifestEntries.Add(new { type = "module-flow-index-json", path = indexPath });
}

static void WritePageDetailArtifacts(
    string moduleFolder,
    OverviewModule module,
    string dataRoot,
    string runFolderName,
    JsonSerializerOptions jsonOptions,
    List<string> exportedPaths,
    List<object> manifestEntries)
{
    var pagesFolder = Path.Combine(moduleFolder, "pages");
    Directory.CreateDirectory(pagesFolder);

    var moduleExportRelative = GetModuleExportRelativePath(module);
    var moduleKbRelative = GetModuleKnowledgeBaseRelativePath(module);
    var items = new List<object>();
    var usedSlugs = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

    foreach (var page in module.Pages)
    {
        var stableId = page.QualifiedName;
        var slug = EnsureUniqueObjectSlug(BuildObjectSlug(page.QualifiedName, stableId), stableId, usedSlugs);
        var jsonPath = Path.Combine(pagesFolder, $"{slug}.json");
        var l0Logical = ToLogicalPath(Path.Combine(moduleKbRelative, "pages", $"{slug}.abstract.md"));
        var l1Logical = ToLogicalPath(Path.Combine(moduleKbRelative, "pages", $"{slug}.overview.md"));
        var l2LogicalPath = ToLogicalPath(Path.Combine("app-overview", "current", moduleExportRelative, "pages", $"{slug}.json"));
        var aggregateJson = ToLogicalPath(Path.Combine("app-overview", runFolderName, moduleExportRelative, "pages.json"));
        var aggregatePseudo = ToLogicalPath(Path.Combine("app-overview", runFolderName, moduleExportRelative, "pages.pseudo.txt"));
        var collectionIndex = ToLogicalPath(Path.Combine("app-overview", "current", moduleExportRelative, "pages", "INDEX.json"));

        var pageObject = new
        {
            _meta = new
            {
                objectType = "page",
                module = module.Module,
                qualifiedName = page.QualifiedName,
                stableId,
                slug,
                l0Path = l0Logical,
                l1Path = l1Logical,
                l2Path = l2LogicalPath,
                l2Logical = $"page:{page.QualifiedName}",
                sourceRun = runFolderName,
                aggregateJson,
                aggregatePseudo,
                collectionIndex,
            },
            qualifiedName = page.QualifiedName,
            name = page.Name,
            title = page.Title,
            layout = page.Layout,
            allowedRoles = page.AllowedRoles,
            parameters = page.Parameters,
            isPopup = page.IsPopup,
            popupWidth = page.PopupWidth,
            popupHeight = page.PopupHeight,
            popupResizable = page.PopupResizable,
            url = page.Url,
            excluded = page.Excluded,
            dataSources = page.DataSources,
            clientActions = page.ClientActions,
            navigationProvenance = page.NavigationProvenance,
        };

        File.WriteAllText(jsonPath, JsonSerializer.Serialize(pageObject, jsonOptions), new UTF8Encoding(false));
        exportedPaths.Add(jsonPath);
        manifestEntries.Add(new { type = "module-page-object-json", path = jsonPath });
        manifestEntries.Add(new { type = "module-page-detail-json", path = jsonPath });

        items.Add(new
        {
            objectType = "page",
            qualifiedName = page.QualifiedName,
            stableId,
            slug,
            title = page.Title,
            roleCount = page.AllowedRoles.Count,
            l0Path = l0Logical,
            l1Path = l1Logical,
            l2Path = l2LogicalPath,
            l2Logical = $"page:{page.QualifiedName}",
            sourceRun = runFolderName,
        });
    }

    var indexPath = Path.Combine(pagesFolder, "INDEX.json");
    var indexObject = new
    {
        objectType = "page-collection",
        module = module.Module,
        sourceRun = runFolderName,
        l0Path = ToLogicalPath(Path.Combine(moduleKbRelative, "pages", "INDEX.abstract.md")),
        l1Path = ToLogicalPath(Path.Combine(moduleKbRelative, "PAGES.md")),
        l2Path = ToLogicalPath(Path.Combine("app-overview", "current", moduleExportRelative, "pages", "INDEX.json")),
        items,
    };
    File.WriteAllText(indexPath, JsonSerializer.Serialize(indexObject, jsonOptions), new UTF8Encoding(false));
    exportedPaths.Add(indexPath);
    manifestEntries.Add(new { type = "module-page-index-json", path = indexPath });
}

static string BuildObjectSlug(string qualifiedName, string? stableId)
{
    var baseSlug = Regex.Replace(qualifiedName.ToLowerInvariant(), "[^a-z0-9]+", "-").Trim('-');
    if (string.IsNullOrWhiteSpace(baseSlug))
        baseSlug = "object";

    return baseSlug;
}

static string EnsureUniqueObjectSlug(string baseSlug, string? stableId, ISet<string> usedSlugs)
{
    if (usedSlugs.Add(baseSlug))
        return baseSlug;

    var stableSuffix = Regex.Replace(stableId?.ToLowerInvariant() ?? string.Empty, "[^a-z0-9]+", "");
    if (stableSuffix.Length < 8)
        stableSuffix = stableSuffix.PadRight(8, '0');

    var resolvedSlug = $"{baseSlug}-{stableSuffix[..8]}";
    var counter = 2;
    while (!usedSlugs.Add(resolvedSlug))
    {
        resolvedSlug = $"{baseSlug}-{stableSuffix[..8]}-{counter}";
        counter++;
    }

    return resolvedSlug;
}

static string GetModuleExportRelativePath(OverviewModule module)
{
    return string.Equals(module.Category, "Marketplace", StringComparison.OrdinalIgnoreCase)
        ? Path.Combine("modules", "marketplace", SanitizeToken(module.Module))
        : Path.Combine("modules", SanitizeToken(module.Module));
}

static string GetModuleKnowledgeBaseRelativePath(OverviewModule module)
{
    return string.Equals(module.Category, "Marketplace", StringComparison.OrdinalIgnoreCase)
        ? Path.Combine("knowledge-base", "modules", "_marktplace", SanitizeToken(module.Module))
        : Path.Combine("knowledge-base", "modules", SanitizeToken(module.Module));
}

static string ToLogicalPath(string path) => path.Replace('\\', '/');

static string SanitizeToken(string? value)
{
    if (string.IsNullOrWhiteSpace(value)) return "overview";
    var invalidChars = Path.GetInvalidFileNameChars();
    var builder = new StringBuilder(value.Length);
    foreach (var c in value.Trim())
    {
        builder.Append(invalidChars.Contains(c) ? '_' : c);
    }
    return builder.Length == 0 ? "overview" : builder.ToString();
}

static string ResolveCategory(string moduleName, bool fromAppStore)
{
    if (string.Equals(moduleName, "System", StringComparison.OrdinalIgnoreCase)) return "System";
    return fromAppStore ? "Marketplace" : "Custom";
}

static int CategoryOrder(string category) => category switch
{
    "System" => 0,
    "Marketplace" => 1,
    _ => 2,
};

static bool TryReadString(JsonElement element, string property, out string value)
{
    value = string.Empty;
    if (element.ValueKind != JsonValueKind.Object ||
        !element.TryGetProperty(property, out var prop) ||
        prop.ValueKind != JsonValueKind.String)
        return false;
    var candidate = prop.GetString();
    if (string.IsNullOrWhiteSpace(candidate)) return false;
    value = candidate.Trim();
    return value.Length > 0;
}

static bool TryReadBool(JsonElement element, string property, out bool value)
{
    value = false;
    if (element.ValueKind != JsonValueKind.Object ||
        !element.TryGetProperty(property, out var prop) ||
        (prop.ValueKind != JsonValueKind.True && prop.ValueKind != JsonValueKind.False))
        return false;
    value = prop.GetBoolean();
    return true;
}
