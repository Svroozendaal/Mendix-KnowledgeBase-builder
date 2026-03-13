<#
.SYNOPSIS
    Compose behaviour-rich Knowledge Base markdown from an app-overview export.

.DESCRIPTION
    Reads model-overview export JSON files and fills KB markdown files in place.
    Keeps the existing KB file/folder contract while improving semantic density,
    especially for custom modules.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$RunFolder,
    [string]$OutputRoot = "mendix-data/knowledge-base",
    [Parameter(Mandatory = $true)]
    [string]$AppName,
    [switch]$SkipScaffold,
    [string]$GeneratedAtUtc
)

$ErrorActionPreference = "Stop"

function Load-Json {
    param([string]$Path)
    if (-not (Test-Path $Path -PathType Leaf)) {
        throw "Missing JSON file: $Path"
    }
    return (Get-Content -Raw $Path | ConvertFrom-Json)
}

function Escape-Md {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return "" }
    $single = ($Value -replace "`r?`n", " ").Trim()
    return ($single -replace "\|", "\|")
}

function Join-OrDefault {
    param(
        [object[]]$Items,
        [string]$Default = "none"
    )
    $clean = @($Items | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Sort-Object -Unique)
    if ($clean.Count -eq 0) { return $Default }
    return ($clean -join ", ")
}

function Join-OrUnknown {
    param(
        [object[]]$Items,
        [string]$UnknownScope,
        [string]$UnknownField,
        [string]$Reason,
        [string]$FixHint
    )

    $clean = @($Items | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Sort-Object -Unique)
    if ($clean.Count -gt 0) {
        return ($clean -join ", ")
    }

    Add-UnknownTodo -Scope $UnknownScope -Field $UnknownField -Reason $Reason -FixHint $FixHint
    return "Unknown"
}

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )
    $dir = Split-Path -Parent $Path
    if (-not (Test-Path $dir -PathType Container)) {
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
    }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content.TrimEnd() + "`n", $utf8NoBom)
}

function Add-UnknownTodo {
    param(
        [string]$Scope,
        [string]$Field,
        [string]$Reason,
        [string]$FixHint
    )

    if ([string]::IsNullOrWhiteSpace($Scope)) { $Scope = "global" }
    if ([string]::IsNullOrWhiteSpace($Field)) { $Field = "unknown-field" }

    $key = "$Scope|$Field|$Reason"
    if ($unknownTodoKeys.Contains($key)) { return }
    [void]$unknownTodoKeys.Add($key)

    $unknownTodos.Add([pscustomobject]@{
        Scope = $Scope
        Field = $Field
        Reason = $Reason
        FixHint = $FixHint
    }) | Out-Null
}

function Get-ModuleNameFromQualified {
    param([string]$QualifiedName)
    if ([string]::IsNullOrWhiteSpace($QualifiedName)) { return "" }
    $parts = $QualifiedName.Split(".")
    if ($parts.Length -lt 2) { return "" }
    return $parts[0]
}

function Get-LocalNameFromQualified {
    param([string]$QualifiedName)
    if ([string]::IsNullOrWhiteSpace($QualifiedName)) { return "" }
    $parts = $QualifiedName.Split(".")
    return $parts[$parts.Length - 1]
}

function Get-ComplexityScore {
    param([object]$ModuleMeta)
    if (-not $ModuleMeta) { return 0 }
    return ([int]$ModuleMeta.entityCount * 3) + ([int]$ModuleMeta.flowCount * 2) + ([int]$ModuleMeta.pageCount)
}

function Get-FlowTier {
    param(
        [object]$FlowFact,
        [string]$Category
    )

    if ($Category -ne "Custom") { return 3 }

    $local = $FlowFact.localName
    $prefixTier1 = @("ACT_", "VAL_", "ACR_")
    $startsTier1 = $false
    foreach ($p in $prefixTier1) {
        if ($local.StartsWith($p, [System.StringComparison]::OrdinalIgnoreCase)) {
            $startsTier1 = $true
            break
        }
    }

    if (
        $startsTier1 -or
        $FlowFact.hasCrossModuleEdge -or
        $FlowFact.shownPages.Count -gt 0 -or
        $FlowFact.writesPersistent -or
        $FlowFact.fanIn -ge 2 -or
        $FlowFact.fanOut -ge 2
    ) {
        return 1
    }

    if ($FlowFact.hasBehaviouralAction) {
        return 2
    }

    return 3
}

function Get-ActionFlags {
    param([object[]]$Nodes)

    $flags = [ordered]@{
        HasCreate = $false
        HasRead = $false
        HasUpdate = $false
        HasDelete = $false
        HasCommit = $false
        HasRollbackHint = $false
        HasBehaviouralAction = $false
    }

    foreach ($node in @($Nodes)) {
        $text = (([string]$node.label) + " " + ([string]$node.detail))
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        if ($node.nodeType -eq "ActionActivity" -or @($node.calls).Count -gt 0) {
            $flags.HasBehaviouralAction = $true
        }
        if ($text -match "CreateObjectAction|CreateListAction|create\s+[A-Za-z0-9_]+\.[A-Za-z0-9_]+") { $flags.HasCreate = $true }
        if ($text -match "RetrieveAction|AggregateListAction|\bretrieve\b") { $flags.HasRead = $true }
        if ($text -match "ChangeObjectAction|ChangeListAction|\bchange\b") { $flags.HasUpdate = $true }
        if ($text -match "DeleteAction|\bdelete\b") { $flags.HasDelete = $true }
        if ($text -match "CommitAction|\bcommit\b") { $flags.HasCommit = $true }
        if ($text -match "errorHandlingType=Rollback|Rollback") { $flags.HasRollbackHint = $true }
    }

    return [pscustomobject]$flags
}

function Get-TextEntityMentions {
    param(
        [string]$Text,
        [hashtable]$EntityLookup
    )

    $result = New-Object System.Collections.Generic.HashSet[string]
    if ([string]::IsNullOrWhiteSpace($Text)) { return $result }

    $tokenMatches = [regex]::Matches($Text, "\b([A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*)\b")
    foreach ($m in $tokenMatches) {
        $candidate = $m.Groups[1].Value
        if ($EntityLookup.ContainsKey($candidate)) {
            [void]$result.Add($candidate)
        }
    }
    return $result
}

function Extract-ShownPages {
    param([object[]]$Nodes)
    $pages = New-Object System.Collections.Generic.HashSet[string]
    foreach ($node in @($Nodes)) {
        $text = (([string]$node.label) + " " + ([string]$node.detail))
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        foreach ($m in [regex]::Matches($text, "show page\s+([A-Za-z0-9_]+\.[A-Za-z0-9_]+)", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
            [void]$pages.Add($m.Groups[1].Value)
        }
    }
    return @($pages | Sort-Object)
}

if (-not (Test-Path $RunFolder -PathType Container)) {
    throw "RunFolder not found: $RunFolder"
}

$manifestPath = Join-Path $RunFolder "manifest.json"
$manifest = Load-Json -Path $manifestPath
if ($manifest.schemaVersion -ne "2.0") {
    throw "Expected schema version 2.0, got $($manifest.schemaVersion)"
}

$kbRoot = $OutputRoot
if (-not (Test-Path $kbRoot -PathType Container)) {
    throw "KB root does not exist. Run scaffold first: $kbRoot"
}

$generatedAtUtc = if ([string]::IsNullOrWhiteSpace($GeneratedAtUtc)) {
    (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
} else {
    $GeneratedAtUtc
}
$kbFormatVersion = "1.0"
$runFolderName = Split-Path $RunFolder -Leaf

$allModulesPath = Join-Path $RunFolder "general/all-modules.json"
$userRolesPath = Join-Path $RunFolder "general/user-roles.json"
$appInfoPath = Join-Path $RunFolder "general/app-info.json"

$allModules = Load-Json -Path $allModulesPath
$userRoles = Load-Json -Path $userRolesPath
$appInfo = Load-Json -Path $appInfoPath

$moduleMetaByName = @{}
foreach ($m in @($allModules.modules)) {
    $moduleMetaByName[$m.module] = $m
}

$moduleNames = @($moduleMetaByName.Keys | Sort-Object)

$unknownTodos = New-Object "System.Collections.Generic.List[object]"
$unknownTodoKeys = New-Object System.Collections.Generic.HashSet[string]

$domainsByModule = @{}
$flowsByModule = @{}
$pagesByModule = @{}
$resourcesByModule = @{}

foreach ($module in $moduleNames) {
    $base = Join-Path $RunFolder "modules/$module"
    $domainPath = Join-Path $base "domain-model.json"
    $flowsPath = Join-Path $base "flows.json"
    $pagesPath = Join-Path $base "pages.json"
    $resourcesPath = Join-Path $base "resources.json"

    $domainsByModule[$module] = if (Test-Path $domainPath) { Load-Json -Path $domainPath } else { @{ module = $module; domainModel = @{ entities = @(); associations = @(); enumerations = @() } } }
    $flowsByModule[$module] = if (Test-Path $flowsPath) { Load-Json -Path $flowsPath } else { @{ module = $module; flows = @() } }
    $pagesByModule[$module] = if (Test-Path $pagesPath) { Load-Json -Path $pagesPath } else { @{ module = $module; pages = @() } }
    $resourcesByModule[$module] = if (Test-Path $resourcesPath) { Load-Json -Path $resourcesPath } else { @{ module = $module; constants = @(); scheduledEvents = @(); otherResources = @() } }
}

$entityLookup = @{}
$entityPersistable = @{}
$entityModule = @{}
$associationRows = @()

foreach ($module in $moduleNames) {
    $dm = $domainsByModule[$module].domainModel
    foreach ($entity in @($dm.entities)) {
        $entityLookup[$entity.name] = $true
        $entityPersistable[$entity.name] = [bool]$entity.isPersistable
        $entityModule[$entity.name] = $module
    }
    foreach ($assoc in @($dm.associations)) {
        $associationRows += [pscustomobject]@{
            module = $module
            name = [string]$assoc.name
            parentEntity = [string]$assoc.parentEntity
            childEntity = [string]$assoc.childEntity
            cardinality = [string]$assoc.cardinality
            type = [string]$assoc.type
            owner = [string]$assoc.owner
        }
    }
}

$flowFacts = @{}
$flowList = @()

foreach ($module in $moduleNames) {
    $category = [string]$moduleMetaByName[$module].category
    foreach ($flow in @($flowsByModule[$module].flows)) {
        $qualified = [string]$flow.qualifiedName
        $localName = Get-LocalNameFromQualified -QualifiedName $qualified
        $callsOut = @(@($flow.calls) | ForEach-Object { [string]$_.targetFlowName } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
        $shownPages = Extract-ShownPages -Nodes @($flow.nodes)
        $actionFlags = Get-ActionFlags -Nodes @($flow.nodes)

        $mentions = New-Object System.Collections.Generic.HashSet[string]
        foreach ($node in @($flow.nodes)) {
            $text = (([string]$node.label) + " " + ([string]$node.detail))
            foreach ($entityName in (Get-TextEntityMentions -Text $text -EntityLookup $entityLookup)) {
                [void]$mentions.Add($entityName)
            }
        }
        $touchesEntities = @($mentions | Sort-Object)
        $writesPersistent = $false
        if (
            ($actionFlags.HasCreate -or $actionFlags.HasUpdate -or $actionFlags.HasDelete -or $actionFlags.HasCommit) -and
            ($touchesEntities | Where-Object { $entityPersistable[$_] }).Count -gt 0
        ) {
            $writesPersistent = $true
        }

        $fact = [pscustomobject]@{
            qualifiedName = $qualified
            localName = $localName
            module = $module
            category = $category
            kind = [string]$flow.kind
            nodeCount = @($flow.nodes).Count
            callsOut = $callsOut
            calledBy = @()
            fanIn = 0
            fanOut = @($callsOut).Count
            shownPages = $shownPages
            touchesEntities = $touchesEntities
            hasCrossModuleEdge = $false
            writesPersistent = $writesPersistent
            hasBehaviouralAction = [bool]$actionFlags.HasBehaviouralAction
            actionFlags = $actionFlags
        }

        $flowFacts[$qualified] = $fact
        $flowList += $fact
    }
}

foreach ($flow in $flowList) {
    $callers = New-Object System.Collections.Generic.List[string]
    foreach ($candidate in $flowList) {
        if ($candidate.callsOut -contains $flow.qualifiedName) {
            [void]$callers.Add($candidate.qualifiedName)
        }
    }
    $flow.calledBy = @($callers | Sort-Object -Unique)
    $flow.fanIn = @($flow.calledBy).Count
}

$crossModuleEdges = New-Object "System.Collections.Generic.List[psobject]"
foreach ($flow in $flowList) {
    foreach ($target in @($flow.callsOut)) {
        if (-not $flowFacts.ContainsKey($target)) { continue }
        $targetFact = $flowFacts[$target]
        if ($targetFact.module -ne $flow.module) {
            $flow.hasCrossModuleEdge = $true
            $targetFact.hasCrossModuleEdge = $true
            $crossModuleEdges.Add([pscustomobject]@{
                sourceFlow = $flow.qualifiedName
                sourceModule = $flow.module
                targetFlow = $targetFact.qualifiedName
                targetModule = $targetFact.module
            }) | Out-Null
        }
    }
}

foreach ($flow in $flowList) {
    $tier = Get-FlowTier -FlowFact $flow -Category $flow.category
    Add-Member -InputObject $flow -NotePropertyName tier -NotePropertyValue $tier -Force
}

$pageByQualified = @{}
$pageFacts = @()
foreach ($module in $moduleNames) {
    foreach ($page in @($pagesByModule[$module].pages)) {
        $fact = [pscustomobject]@{
            qualifiedName = [string]$page.qualifiedName
            name = [string]$page.name
            module = $module
            title = [string]$page.title
            layout = [string]$page.layout
            allowedRoles = @($page.allowedRoles)
            parameters = @($page.parameters)
            isPopup = [bool]$page.isPopup
        }
        $pageByQualified[$fact.qualifiedName] = $fact
        $pageFacts += $fact
    }
}

$shownByPage = @{}
foreach ($flow in $flowList) {
    foreach ($page in @($flow.shownPages)) {
        if (-not $shownByPage.ContainsKey($page)) {
            $shownByPage[$page] = New-Object System.Collections.Generic.List[string]
        }
        $shownByPage[$page].Add($flow.qualifiedName) | Out-Null
    }
}

$entityLifecycle = @{}
foreach ($entity in $entityLookup.Keys) {
    $entityLifecycle[$entity] = [ordered]@{
        Create = New-Object System.Collections.Generic.HashSet[string]
        Read = New-Object System.Collections.Generic.HashSet[string]
        Update = New-Object System.Collections.Generic.HashSet[string]
        Delete = New-Object System.Collections.Generic.HashSet[string]
    }
}

foreach ($flow in $flowList) {
    foreach ($entity in @($flow.touchesEntities)) {
        $entry = $entityLifecycle[$entity]
        if ($flow.actionFlags.HasCreate) { [void]$entry.Create.Add($flow.qualifiedName) }
        if ($flow.actionFlags.HasRead) { [void]$entry.Read.Add($flow.qualifiedName) }
        if ($flow.actionFlags.HasUpdate -or $flow.actionFlags.HasCommit) { [void]$entry.Update.Add($flow.qualifiedName) }
        if ($flow.actionFlags.HasDelete) { [void]$entry.Delete.Add($flow.qualifiedName) }
    }
}

$moduleDependencies = @{}
foreach ($module in $moduleNames) {
    $moduleDependencies[$module] = [ordered]@{
        CallsTo = New-Object System.Collections.Generic.HashSet[string]
        CalledBy = New-Object System.Collections.Generic.HashSet[string]
        SharedEntitiesWith = New-Object System.Collections.Generic.HashSet[string]
    }
}

foreach ($edge in $crossModuleEdges) {
    [void]$moduleDependencies[$edge.sourceModule].CallsTo.Add($edge.targetModule)
    [void]$moduleDependencies[$edge.targetModule].CalledBy.Add($edge.sourceModule)
}

foreach ($assoc in $associationRows) {
    $parentModule = Get-ModuleNameFromQualified -QualifiedName $assoc.parentEntity
    $childModule = Get-ModuleNameFromQualified -QualifiedName $assoc.childEntity
    if ($parentModule -and $childModule -and $parentModule -ne $childModule) {
        [void]$moduleDependencies[$parentModule].SharedEntitiesWith.Add($childModule)
        [void]$moduleDependencies[$childModule].SharedEntitiesWith.Add($parentModule)
    }
}

$customModules = @($moduleNames | Where-Object { [string]$moduleMetaByName[$_].category -eq "Custom" })
$supportModules = @($moduleNames | Where-Object { [string]$moduleMetaByName[$_].category -ne "Custom" })

$topEntryPoints = @(
    $flowList |
    Where-Object { $_.category -eq "Custom" } |
    Sort-Object @{ Expression = { $_.tier }; Descending = $false }, @{ Expression = { $_.fanIn + $_.fanOut + $_.shownPages.Count + $_.touchesEntities.Count }; Descending = $true } |
    Select-Object -First 10
)

$customFlowCount = 0
$customTier1Count = 0
foreach ($f in $flowList) {
    if ([string]$f.category -eq "Custom") {
        $customFlowCount++
        if ([int]$f.tier -eq 1) {
            $customTier1Count++
        }
    }
}

$qualityMetrics = @{}
$qualityMetrics["CustomFlowCount"] = [int]$customFlowCount
$qualityMetrics["CustomTier1Count"] = [int]$customTier1Count
$qualityMetrics["CrossModuleEdgeCount"] = [int]$crossModuleEdges.Count
$qualityMetrics["PageLinksDerived"] = [int](@($shownByPage.Keys).Count)

$readerPath = Join-Path $kbRoot "READER.md"
$readerContent = @"
# How to Read This Knowledge Base

## What is this?

This knowledge base is generated from Mendix model-overview export JSON and is tuned for AI-assisted reasoning.

Confidence: Export-backed

## How to navigate

- Start at [ROUTING.md](ROUTING.md) for index-style lookup.
- Use [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) for app mission and key behaviours.
- Use ``modules/<Module>/`` files for module-level behaviour, domain, pages, and resources.
- Use ``routes/`` files for cross-cut indexes by entity, page, and flow.

Confidence: Export-backed

## How to answer questions

- For behaviour questions, trace: trigger -> flow chain -> entity mutations -> shown pages -> role constraints.
- Prefer custom modules for deep app-specific answers.
- Use support modules mainly for dependencies that affect custom behaviour.

Confidence: Inferred

## Confidence levels

- ``Export-backed``: direct from JSON export.
- ``Inferred``: deterministic synthesis from export data (for example tier ranking, capability grouping).
- ``Unknown``: source data is absent or non-derivable.

## Source

- Generated at: $generatedAtUtc
- Run folder: $RunFolder
- KB Format Version: $kbFormatVersion
- Schema version: $($manifest.schemaVersion)
- Unknown TODO backlog: [_reports/UNKNOWN_TODO.md](_reports/UNKNOWN_TODO.md)
"@
Write-Utf8NoBom -Path $readerPath -Content $readerContent

$moduleIndexRows = New-Object System.Collections.Generic.List[string]
foreach ($module in $moduleNames) {
    $cat = [string]$moduleMetaByName[$module].category
    $complexity = Get-ComplexityScore -ModuleMeta $moduleMetaByName[$module]
    $moduleIndexRows.Add("| $module | $cat | $complexity | [README](modules/$module/README.md) |") | Out-Null
}

$routingPath = Join-Path $kbRoot "ROUTING.md"
$routingContent = @"
# Knowledge Base Routing

## Quick lookup

| Question type | Start here |
|---|---|
| What does the app do? | [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) |
| Which modules matter most? | [app/MODULE_LANDSCAPE.md](app/MODULE_LANDSCAPE.md) |
| Who can access what? | [app/SECURITY.md](app/SECURITY.md) |
| How modules connect | [app/CALL_GRAPH.md](app/CALL_GRAPH.md) |
| Entity-level lookup | [routes/by-entity.md](routes/by-entity.md) |
| Page-level lookup | [routes/by-page.md](routes/by-page.md) |
| Flow-level lookup | [routes/by-flow.md](routes/by-flow.md) |
| Cross-module dependencies | [routes/cross-module.md](routes/cross-module.md) |

## Module index

| Module | Category | Complexity | Quick link |
|---|---|---:|---|
$($moduleIndexRows -join "`n")

## Completeness

- App-level status: generated
- Module count: $($moduleNames.Count)
- Custom module flows: $($qualityMetrics.CustomFlowCount)
- Tier 1 custom flows: $($qualityMetrics.CustomTier1Count)
- Cross-module call edges: $($qualityMetrics.CrossModuleEdgeCount)
- Derived page-flow links: $($qualityMetrics.PageLinksDerived)
- Known gaps: pending (computed after composition)

## Source

- Generated at: $generatedAtUtc
- Run folder: $RunFolder
"@
Write-Utf8NoBom -Path $routingPath -Content $routingContent

$capabilityRows = New-Object System.Collections.Generic.List[string]
foreach ($module in $customModules) {
    $moduleFlows = @($flowList | Where-Object { $_.module -eq $module })
    $capabilityRows.Add("| $module | $($moduleFlows.Count) | $(@($moduleFlows | Where-Object { $_.tier -eq 1 }).Count) | [FLOWS](../modules/$module/FLOWS.md) |") | Out-Null
}

$entryRows = New-Object System.Collections.Generic.List[string]
foreach ($flow in $topEntryPoints) {
    $reason = @()
    if ($flow.shownPages.Count -gt 0) { $reason += "shows UI" }
    if ($flow.writesPersistent) { $reason += "writes data" }
    if ($flow.hasCrossModuleEdge) { $reason += "cross-module" }
    if ($flow.fanIn -ge 2) { $reason += "fan-in $($flow.fanIn)" }
    if ($flow.fanOut -ge 2) { $reason += "fan-out $($flow.fanOut)" }
    if ($reason.Count -eq 0) { $reason += "behavioural action" }
    $entryRows.Add("| $($flow.qualifiedName) | Tier $($flow.tier) | $(Join-OrDefault -Items $reason -Default "behavioural action") | [Flow](../modules/$($flow.module)/FLOWS.md) |") | Out-Null
}

$appOverviewPath = Join-Path $kbRoot "app/APP_OVERVIEW.md"
$appOverviewContent = @"
# App Overview

## Mission Summary

The application centres on the custom modules $((Join-OrDefault -Items $customModules -Default "none")) and orchestrates data and UI behaviour through model-driven flows and pages.

Confidence: Inferred

## Core Business Capabilities

| Module | Flow Count | Tier 1 Flows | Detail |
|---|---:|---:|---|
$($capabilityRows -join "`n")

Confidence: Export-backed

## Top Behavioural Entry Points (Top 10)

| Flow | Tier | Impact reason | Link |
|---|---:|---|---|
$($entryRows -join "`n")

Confidence: Inferred

## Source

- Export summary: modules=$($appInfo.summary.moduleCount), flows=$($appInfo.summary.flowCount), entities=$($appInfo.summary.entityCount)
- Generated at: $generatedAtUtc
"@
Write-Utf8NoBom -Path $appOverviewPath -Content $appOverviewContent

$moduleLandscapeRows = New-Object System.Collections.Generic.List[string]
foreach ($module in $moduleNames) {
    $meta = $moduleMetaByName[$module]
    $complexity = Get-ComplexityScore -ModuleMeta $meta
    $why = if ($meta.category -eq "Custom") { "Implements app-specific behaviour" } elseif ($meta.category -eq "System") { "Platform/runtime baseline" } else { "Support capability from marketplace or shared library" }
    $moduleLandscapeRows.Add("| $module | $($meta.category) | $complexity | $why |") | Out-Null
}

$priorityRows = New-Object System.Collections.Generic.List[string]
$rankedCustom = @(
    $customModules |
    Sort-Object -Descending { Get-ComplexityScore -ModuleMeta $moduleMetaByName[$_] }
)
$rank = 1
foreach ($module in $rankedCustom) {
    $score = Get-ComplexityScore -ModuleMeta $moduleMetaByName[$module]
    $priorityRows.Add("| $rank | $module | $score | flow/entity/page density |") | Out-Null
    $rank++
}

$moduleLandscapePath = Join-Path $kbRoot "app/MODULE_LANDSCAPE.md"
$moduleLandscapeContent = @"
# Module Landscape

## Module Categories

| Module | Category | Complexity | Why this module exists |
|---|---|---:|---|
$($moduleLandscapeRows -join "`n")

Confidence: Export-backed

## Custom Module Priority Ranking

| Rank | Module | Score | Rationale |
|---|---|---:|---|
$($priorityRows -join "`n")

Confidence: Inferred

## Source

- Generated at: $generatedAtUtc
- Run folder: $RunFolder
"@
Write-Utf8NoBom -Path $moduleLandscapePath -Content $moduleLandscapeContent

$securityMatrixRows = New-Object System.Collections.Generic.List[string]
foreach ($projectRole in @($userRoles.projectSecurity.userRoles)) {
    $moduleRoles = @($projectRole.moduleRoles)
    $customRoleSet = @($moduleRoles | Where-Object { ($_.Split(".")[0]) -in $customModules } | Sort-Object -Unique)
    $securityMatrixRows.Add("| $([string]$projectRole.name) | $(Join-OrDefault -Items $customRoleSet -Default "none") | $(Join-OrDefault -Items $moduleRoles -Default "none") |") | Out-Null
}

$accessRows = New-Object System.Collections.Generic.List[string]
$xpathRows = New-Object System.Collections.Generic.List[string]
foreach ($module in $customModules) {
    foreach ($entity in @($domainsByModule[$module].domainModel.entities)) {
        foreach ($rule in @($entity.accessRules)) {
            $roles = Join-OrDefault -Items @($rule.moduleRoles) -Default "none"
            $constraint = if ([string]::IsNullOrWhiteSpace([string]$rule.xPathConstraint)) { "none" } else { [string]$rule.xPathConstraint }
            $accessRows.Add("| $($entity.name) | $roles | $($rule.allowCreate) | $($rule.allowDelete) | $(Escape-Md $constraint) |") | Out-Null

            if (-not [string]::IsNullOrWhiteSpace([string]$rule.xPathConstraint)) {
                $meaning = $rule.xPathConstraint -replace "\[%CurrentUser%\]", "current user"
                $xpathRows.Add("| $($entity.name) | $roles | $(Escape-Md $rule.xPathConstraint) | $(Escape-Md $meaning) |") | Out-Null
            }
        }
    }
}
if ($xpathRows.Count -eq 0) {
    $xpathRows.Add("| none | none | none | No XPath constraints in custom module entities |") | Out-Null
}

$securityPath = Join-Path $kbRoot "app/SECURITY.md"
$securityContent = @"
# Security

## Role-to-Module-Role Matrix

| Project role | Custom module roles | All module roles |
|---|---|---|
$($securityMatrixRows -join "`n")

Confidence: Export-backed

## Entity Access Summary (Custom Entities)

| Entity | Rule module roles | Allow create | Allow delete | XPath constraint |
|---|---|---|---|---|
$($accessRows -join "`n")

Confidence: Export-backed

## XPath Constraints (Plain Language)

| Entity | Module roles | XPath | Access meaning |
|---|---|---|---|
$($xpathRows -join "`n")

Confidence: Inferred

## Source

- Security level: $($userRoles.projectSecurity.securityLevel)
- Guest access: $($userRoles.projectSecurity.enableGuestAccess)
"@
Write-Utf8NoBom -Path $securityPath -Content $securityContent

$edgeGroups = @(
    $crossModuleEdges |
    Group-Object sourceModule, targetModule |
    Sort-Object Count -Descending
)
$edgeRows = New-Object System.Collections.Generic.List[string]
foreach ($group in $edgeGroups) {
    $source = $group.Group[0].sourceModule
    $target = $group.Group[0].targetModule
    $sample = @($group.Group | Select-Object -First 3 | ForEach-Object { $_.sourceFlow + " -> " + $_.targetFlow })
    $edgeRows.Add("| $source | $target | $($group.Count) | $(Join-OrDefault -Items $sample -Default "none") |") | Out-Null
}
if ($edgeRows.Count -eq 0) {
    $edgeRows.Add("| none | none | 0 | none |") | Out-Null
}

$boundaryRows = New-Object System.Collections.Generic.List[string]
foreach ($module in $customModules) {
    $outbound = @($crossModuleEdges | Where-Object { $_.sourceModule -eq $module } | ForEach-Object { $_.targetModule } | Sort-Object -Unique)
    $inbound = @($crossModuleEdges | Where-Object { $_.targetModule -eq $module } | ForEach-Object { $_.sourceModule } | Sort-Object -Unique)
    $boundaryRows.Add("| $module | $(Join-OrDefault -Items $outbound -Default "none") | $(Join-OrDefault -Items $inbound -Default "none") |") | Out-Null
}

$callGraphPath = Join-Path $kbRoot "app/CALL_GRAPH.md"
$callGraphContent = @"
# Call Graph

## Cross-Module Dependency Table

| Source module | Target module | Call edges | Key flows |
|---|---|---:|---|
$($edgeRows -join "`n")

Confidence: Export-backed

## Custom Module Boundary

| Custom module | Outbound dependencies | Inbound dependencies |
|---|---|---|
$($boundaryRows -join "`n")

Confidence: Export-backed

## Source

- Export flow call edges: $($appInfo.summary.flowCallEdgeCount)
- Derived cross-module edges: $($crossModuleEdges.Count)
"@
Write-Utf8NoBom -Path $callGraphPath -Content $callGraphContent

foreach ($module in $moduleNames) {
    $meta = $moduleMetaByName[$module]
    $category = [string]$meta.category
    $moduleDir = Join-Path $kbRoot "modules/$module"
    $moduleFlows = @($flowList | Where-Object { $_.module -eq $module } | Sort-Object localName)
    $modulePages = @($pageFacts | Where-Object { $_.module -eq $module } | Sort-Object name)
    $moduleEntities = @($domainsByModule[$module].domainModel.entities)
    $moduleAssociations = @($domainsByModule[$module].domainModel.associations)
    $moduleEnums = @($domainsByModule[$module].domainModel.enumerations)
    $moduleResources = $resourcesByModule[$module]

    $roleNames = @($meta.moduleRoles | ForEach-Object { $_.name })
    $callsTo = @($moduleDependencies[$module].CallsTo | Sort-Object)
    $calledBy = @($moduleDependencies[$module].CalledBy | Sort-Object)
    $shared = @($moduleDependencies[$module].SharedEntitiesWith | Sort-Object)

    $capabilityBuckets = @{}
    foreach ($f in $moduleFlows) {
        $prefix = if ($f.localName -match "^([A-Za-z]+)_") { $matches[1].ToUpperInvariant() } else { "OTHER" }
        if (-not $capabilityBuckets.ContainsKey($prefix)) {
            $capabilityBuckets[$prefix] = New-Object System.Collections.Generic.List[string]
        }
        $capabilityBuckets[$prefix].Add($f.qualifiedName) | Out-Null
    }

    $capabilityRows = New-Object System.Collections.Generic.List[string]
    foreach ($prefix in @($capabilityBuckets.Keys | Sort-Object)) {
        $flows = @($capabilityBuckets[$prefix] | Sort-Object)
        $capabilityRows.Add("| $prefix | $($flows.Count) | $($flows[0]) |") | Out-Null
    }
    if ($capabilityRows.Count -eq 0) {
        $capabilityRows.Add("| none | 0 | none |") | Out-Null
    }

    $journeyRows = New-Object System.Collections.Generic.List[string]
    if ($category -eq "Custom") {
        $tier1 = @($moduleFlows | Where-Object { $_.tier -eq 1 } | Select-Object -First 8)
        foreach ($f in $tier1) {
            $entitiesTouched = Join-OrUnknown -Items $f.touchesEntities `
                -UnknownScope "$module.$($f.localName)" `
                -UnknownField "Primary User Journeys.Entities touched" `
                -Reason "Tier 1 flow has no explicit entity evidence in exported nodes." `
                -FixHint "Improve extraction rules or add parser entityMentions metadata."
            $journeyRows.Add("| $($f.qualifiedName) | $(Join-OrDefault -Items $f.shownPages -Default "none") | $entitiesTouched |") | Out-Null
        }
        if ($journeyRows.Count -eq 0) {
            $journeyRows.Add("| none | none | none |") | Out-Null
        }
    } else {
        $journeyRows.Add("| support module | n/a | dependency-focused summary |") | Out-Null
    }

    $riskRows = @()
    if (@($moduleFlows | Where-Object { $_.touchesEntities.Count -eq 0 -and $_.hasBehaviouralAction }).Count -gt 0) {
        $riskRows += "- Some flows have behavioural actions without explicit entity name tokens (parser gap)."
    }
    if (@($modulePages | Where-Object { -not $shownByPage.ContainsKey($_.qualifiedName) }).Count -gt 0) {
        $riskRows += "- Some pages have no explicit ShowPageAction evidence in exported flows."
    }
    if ($riskRows.Count -eq 0) {
        $riskRows += "- No major derivation gaps detected for this module."
    }

    $readmePath = Join-Path $moduleDir "README.md"
    $readmeContent = @"
# Module: $module

Category: $category
Module roles: $(Join-OrDefault -Items $roleNames -Default "none")

## Summary

- Entities: $($meta.entityCount)
- Flows: $($meta.flowCount)
- Pages: $($meta.pageCount)
- Constants: $($meta.constantCount)

## Purpose

- Export-backed: module category and inventory from overview export.
- Inferred: module role is $(if ($category -eq "Custom") { "app-specific business behaviour" } elseif ($category -eq "System") { "platform baseline" } else { "support capability" }).
- Unknown: product-owner intent text is not included in export.

## Capability Map

| Capability prefix | Flow count | Representative flow |
|---|---:|---|
$($capabilityRows -join "`n")

## Primary User Journeys

| Entry flow | UI result | Entities touched |
|---|---|---|
$($journeyRows -join "`n")

## Top risks/unknowns in model understanding
$($riskRows -join "`n")

## Navigation

- [DOMAIN.md](DOMAIN.md)
- [FLOWS.md](FLOWS.md)
- [PAGES.md](PAGES.md)
- [RESOURCES.md](RESOURCES.md)

## Cross-Module Dependencies

- Calls to: $(Join-OrDefault -Items $callsTo -Default "none")
- Called by: $(Join-OrDefault -Items $calledBy -Default "none")
- Shared entities via associations: $(Join-OrDefault -Items $shared -Default "none")

## Source

- Export module: $module
- Run folder: $runFolderName
"@
    Write-Utf8NoBom -Path $readmePath -Content $readmeContent

    $entityRows = New-Object System.Collections.Generic.List[string]
    foreach ($entity in $moduleEntities) {
        $attrCount = @($entity.attributes).Count
        $ruleCount = @($entity.accessRules).Count
        $entityRows.Add("| $($entity.name) | $($entity.isPersistable) | $attrCount | $ruleCount |") | Out-Null
    }
    if ($entityRows.Count -eq 0) {
        $entityRows.Add("| none | false | 0 | 0 |") | Out-Null
    }

    $lifecycleRows = New-Object System.Collections.Generic.List[string]
    foreach ($entity in $moduleEntities) {
        $life = $entityLifecycle[$entity.name]
        $lifecycleRows.Add("| $($entity.name) | $(Join-OrDefault -Items @($life.Create) -Default "none") | $(Join-OrDefault -Items @($life.Update) -Default "none") | $(Join-OrDefault -Items @($life.Delete) -Default "none") | $(Join-OrDefault -Items @($life.Read) -Default "none") |") | Out-Null
    }
    if ($lifecycleRows.Count -eq 0) {
        $lifecycleRows.Add("| none | none | none | none | none |") | Out-Null
    }

    $roleImpactRows = New-Object System.Collections.Generic.List[string]
    foreach ($entity in $moduleEntities) {
        foreach ($rule in @($entity.accessRules)) {
            $roles = Join-OrDefault -Items @($rule.moduleRoles) -Default "none"
            $constraint = if ([string]::IsNullOrWhiteSpace([string]$rule.xPathConstraint)) { "none" } else { [string]$rule.xPathConstraint }
            $roleImpactRows.Add("| $($entity.name) | $roles | $($rule.defaultMemberAccessRights) | $(Escape-Md $constraint) |") | Out-Null
        }
    }
    if ($roleImpactRows.Count -eq 0) {
        $roleImpactRows.Add("| none | none | none | none |") | Out-Null
    }

    $assocRows = New-Object System.Collections.Generic.List[string]
    foreach ($assoc in $moduleAssociations) {
        $assocRows.Add("| $($assoc.name) | $($assoc.parentEntity) | $($assoc.childEntity) | $($assoc.cardinality) | $($assoc.type) | $($assoc.owner) |") | Out-Null
    }
    if ($assocRows.Count -eq 0) {
        $assocRows.Add("| none | none | none | none | none | none |") | Out-Null
    }

    $enumRows = New-Object System.Collections.Generic.List[string]
    foreach ($enum in $moduleEnums) {
        $values = @($enum.values)
        $sample = @($values | Select-Object -First 4)
        $enumRows.Add("| $($enum.name) | $($values.Count) | $(Join-OrDefault -Items $sample -Default "none") |") | Out-Null
    }
    if ($enumRows.Count -eq 0) {
        $enumRows.Add("| none | 0 | none |") | Out-Null
    }

    $domainPath = Join-Path $moduleDir "DOMAIN.md"
    $domainContent = @"
# Domain: $module

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
$($entityRows -join "`n")

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
$($lifecycleRows -join "`n")

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
$($roleImpactRows -join "`n")

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
$($assocRows -join "`n")

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
$($enumRows -join "`n")
"@
    Write-Utf8NoBom -Path $domainPath -Content $domainContent

    $actRows = New-Object System.Collections.Generic.List[string]
    $dsRows = New-Object System.Collections.Generic.List[string]
    $valRows = New-Object System.Collections.Generic.List[string]
    $otherRows = New-Object System.Collections.Generic.List[string]

    foreach ($f in $moduleFlows) {
        $keyActions = if ($f.touchesEntities.Count -gt 0) { Join-OrDefault -Items $f.touchesEntities -Default "none" } else { "none" }
        if ($f.localName.StartsWith("ACT_", [System.StringComparison]::OrdinalIgnoreCase)) {
            $actRows.Add("| $($f.localName) | $($f.nodeCount) | $keyActions | $(Join-OrDefault -Items $f.shownPages -Default "none") |") | Out-Null
        }
        elseif ($f.localName.StartsWith("DS_", [System.StringComparison]::OrdinalIgnoreCase)) {
            $dsRows.Add("| $($f.localName) | $($f.nodeCount) | $keyActions | inferred from node actions |") | Out-Null
        }
        elseif ($f.localName.StartsWith("VAL_", [System.StringComparison]::OrdinalIgnoreCase)) {
            $valRows.Add("| $($f.localName) | $($f.nodeCount) | $keyActions |") | Out-Null
        }
        else {
            $otherRows.Add("| $($f.localName) | $($f.kind) | $($f.nodeCount) | $keyActions |") | Out-Null
        }
    }
    if ($actRows.Count -eq 0) { $actRows.Add("| none | 0 | none | none |") | Out-Null }
    if ($dsRows.Count -eq 0) { $dsRows.Add("| none | 0 | none | none |") | Out-Null }
    if ($valRows.Count -eq 0) { $valRows.Add("| none | 0 | none |") | Out-Null }
    if ($otherRows.Count -eq 0) { $otherRows.Add("| none | none | 0 | none |") | Out-Null }

    $crossCallRows = New-Object System.Collections.Generic.List[string]
    foreach ($f in $moduleFlows) {
        $targets = @($f.callsOut | Where-Object { (Get-ModuleNameFromQualified -QualifiedName $_) -ne $module })
        foreach ($target in $targets) {
            $crossCallRows.Add("| $($f.localName) | $target | $(Get-ModuleNameFromQualified -QualifiedName $target) |") | Out-Null
        }
    }
    if ($crossCallRows.Count -eq 0) { $crossCallRows.Add("| none | none | none |") | Out-Null }

    $flowDetailRows = New-Object System.Collections.Generic.List[string]
    foreach ($f in $moduleFlows) {
        $flowDetailRows.Add("| $($f.localName) | $($f.kind) | $($f.nodeCount) | $($f.tier) | $($f.fanOut) | $($f.fanIn) |") | Out-Null
    }
    if ($flowDetailRows.Count -eq 0) { $flowDetailRows.Add("| none | none | 0 | 3 | 0 | 0 |") | Out-Null }

    $tier1Sections = New-Object System.Collections.Generic.List[string]
    if ($category -eq "Custom") {
        foreach ($f in @($moduleFlows | Where-Object { $_.tier -eq 1 } | Sort-Object localName)) {
            $intent = if ($f.localName.StartsWith("ACT_")) { "User action flow" } elseif ($f.localName.StartsWith("VAL_")) { "Validation flow" } elseif ($f.localName.StartsWith("ACR_")) { "Access/creation orchestration flow" } else { "Behaviour-critical flow" }
            $tier1Entities = Join-OrUnknown -Items $f.touchesEntities `
                -UnknownScope "$module.$($f.localName)" `
                -UnknownField "Tier 1 Deep Narratives.Read/write entities" `
                -Reason "Tier 1 narrative has no explicit entity touch evidence." `
                -FixHint "Improve regex extraction or add parser actionTags/entityMentions metadata."
            $tier1Sections.Add(@"
### $($f.qualifiedName)

- Intent: $intent.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: $tier1Entities.
- UI interactions (shown pages): $(Join-OrDefault -Items $f.shownPages -Default "none").
- Calls/called-by: out=$($f.fanOut), in=$($f.fanIn).
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: $(if ($f.actionFlags.HasRollbackHint) { "Rollback hints detected in node detail." } else { "No explicit rollback hint in flow node detail." })
"@) | Out-Null
        }
    }
    if ($tier1Sections.Count -eq 0) {
        $tier1Sections.Add("No Tier 1 narrative required for this module category.") | Out-Null
    }

    $flowsPath = Join-Path $moduleDir "FLOWS.md"
    $flowsContent = @"
# Flows: $module

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
$($actRows -join "`n")

### Data Sources (DS_*)

| Flow | Nodes | Key Actions | Returns |
|---|---:|---|---|
$($dsRows -join "`n")

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|---|---:|---|
$($valRows -join "`n")

### Other Flows

| Flow | Type | Nodes | Key Actions |
|---|---|---:|---|
$($otherRows -join "`n")

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
$($crossCallRows -join "`n")

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
$($flowDetailRows -join "`n")

## Tier 1 Deep Narratives

$($tier1Sections -join "`n")
"@
    Write-Utf8NoBom -Path $flowsPath -Content $flowsContent

    $pageRows = New-Object System.Collections.Generic.List[string]
    foreach ($p in $modulePages) {
        $paramSummary = @($p.parameters | ForEach-Object { "$($_.name):$($_.entityType)" })
        $pageRows.Add("| $($p.qualifiedName) | $(Escape-Md $p.title) | $(Join-OrDefault -Items $p.allowedRoles -Default "none") | $(Join-OrDefault -Items $paramSummary -Default "none") | $($p.isPopup) |") | Out-Null
    }
    if ($pageRows.Count -eq 0) { $pageRows.Add("| none | none | none | none | false |") | Out-Null }

    $pageFlowRows = New-Object System.Collections.Generic.List[string]
    foreach ($p in $modulePages) {
        $shownBy = if ($shownByPage.ContainsKey($p.qualifiedName)) { @($shownByPage[$p.qualifiedName] | Sort-Object -Unique) } else { @() }
        $shownByText = Join-OrUnknown -Items $shownBy `
            -UnknownScope "$module.$([string]$p.name)" `
            -UnknownField "PAGES.Page-Flow Links.Shown by flows" `
            -Reason "No explicit ShowPageAction evidence found for page routing." `
            -FixHint "Add parser page navigation metadata or extend show-page extraction patterns."
        $pageFlowRows.Add("| $($p.qualifiedName) | $shownByText |") | Out-Null
    }
    if ($pageFlowRows.Count -eq 0) { $pageFlowRows.Add("| none | none |") | Out-Null }

    $journeyGroups = @{}
    foreach ($p in $modulePages) {
        $intent = if ($p.name -match "^([A-Za-z]+)_") { $matches[1] } else { "General" }
        if (-not $journeyGroups.ContainsKey($intent)) { $journeyGroups[$intent] = New-Object System.Collections.Generic.List[string] }
        $journeyGroups[$intent].Add($p.qualifiedName) | Out-Null
    }
    $journeyRowsByPage = New-Object System.Collections.Generic.List[string]
    foreach ($intent in @($journeyGroups.Keys | Sort-Object)) {
        $journeyRowsByPage.Add("| $intent | $(Join-OrDefault -Items @($journeyGroups[$intent]) -Default "none") |") | Out-Null
    }
    if ($journeyRowsByPage.Count -eq 0) { $journeyRowsByPage.Add("| none | none |") | Out-Null }

    $pagesPath = Join-Path $moduleDir "PAGES.md"
    $pagesContent = @"
# Pages: $module

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
$($pageRows -join "`n")

## Page-Flow Links

| Page | Shown by flows |
|---|---|
$($pageFlowRows -join "`n")

## Journey Fragments

| User intent group | Pages |
|---|---|
$($journeyRowsByPage -join "`n")

## Snippets

Snippet-level page widget behaviour is not exported in current overview contract.
"@
    Write-Utf8NoBom -Path $pagesPath -Content $pagesContent

    $constantRows = New-Object System.Collections.Generic.List[string]
    foreach ($c in @($moduleResources.constants)) {
        $constantRows.Add("| $([string]$c.name) | $([string]$c.type) | $(Escape-Md ([string]$c.value)) |") | Out-Null
    }
    if ($constantRows.Count -eq 0) { $constantRows.Add("| none | none | none |") | Out-Null }

    $scheduleRows = New-Object System.Collections.Generic.List[string]
    foreach ($s in @($moduleResources.scheduledEvents)) {
        $target = [string]$s.microflow
        if ([string]::IsNullOrWhiteSpace($target)) { $target = [string]$s.nanoflow }
        if ([string]::IsNullOrWhiteSpace($target)) {
            Add-UnknownTodo -Scope "$module.$([string]$s.name)" `
                -Field "RESOURCES.Scheduled Events.Target flow" `
                -Reason "Scheduled event target flow is missing in export payload." `
                -FixHint "Add parser enrichment for scheduled event target flow."
            $target = "Unknown"
        }
        $scheduleRows.Add("| $([string]$s.name) | $(Escape-Md ([string]$s.schedule)) | $target |") | Out-Null
    }
    if ($scheduleRows.Count -eq 0) { $scheduleRows.Add("| none | none | none |") | Out-Null }

    $otherRowsResource = New-Object System.Collections.Generic.List[string]
    foreach ($r in @($moduleResources.otherResources)) {
        $otherRowsResource.Add("| $([string]$r.kind) | $([string]$r.name) |") | Out-Null
    }
    if ($otherRowsResource.Count -eq 0) { $otherRowsResource.Add("| none | none |") | Out-Null }

    $resourcesPath = Join-Path $moduleDir "RESOURCES.md"
    $resourcesContent = @"
# Resources: $module

## Constants

| Name | Type | Value |
|---|---|---|
$($constantRows -join "`n")

## Scheduled Events

| Event | Schedule | Target flow |
|---|---|---|
$($scheduleRows -join "`n")

## Other Resources

| Kind | Name |
|---|---|
$($otherRowsResource -join "`n")
"@
    Write-Utf8NoBom -Path $resourcesPath -Content $resourcesContent
}

$entityRouteRows = New-Object System.Collections.Generic.List[string]
foreach ($entityName in @($entityLookup.Keys | Sort-Object)) {
    $life = $entityLifecycle[$entityName]
    $shownPagesForEntity = New-Object System.Collections.Generic.HashSet[string]
    foreach ($page in $pageFacts) {
        foreach ($param in @($page.parameters)) {
            if ([string]$param.entityType -eq $entityName) {
                [void]$shownPagesForEntity.Add($page.qualifiedName)
            }
        }
    }
    $entityRouteRows.Add("| $entityName | [$($entityModule[$entityName])](../modules/$($entityModule[$entityName])/DOMAIN.md) | $(Join-OrDefault -Items @($life.Create) -Default "none") | $(Join-OrDefault -Items @($life.Update) -Default "none") | $(Join-OrDefault -Items @($life.Delete) -Default "none") | $(Join-OrDefault -Items @($life.Read) -Default "none") | $(Join-OrDefault -Items @($shownPagesForEntity) -Default "none") |") | Out-Null
}

$byEntityPath = Join-Path $kbRoot "routes/by-entity.md"
$byEntityContent = @"
# Entity Index

| Entity | Module | Create flows | Update flows | Delete flows | Read flows | Shown on pages |
|---|---|---|---|---|---|---|
$($entityRouteRows -join "`n")
"@
Write-Utf8NoBom -Path $byEntityPath -Content $byEntityContent

$byPageRows = New-Object System.Collections.Generic.List[string]
foreach ($page in @($pageFacts | Sort-Object qualifiedName)) {
    $shownBy = if ($shownByPage.ContainsKey($page.qualifiedName)) { @($shownByPage[$page.qualifiedName] | Sort-Object -Unique) } else { @() }
    $shownByText = Join-OrUnknown -Items $shownBy `
        -UnknownScope "$($page.module).$([string]$page.name)" `
        -UnknownField "routes/by-page.Shown by flows" `
        -Reason "Page appears in model, but no ShowPageAction evidence was derived from flows." `
        -FixHint "Improve show-page extraction or enrich parser output with resolved page-route links."
    $byPageRows.Add("| $($page.qualifiedName) | [$($page.module)](../modules/$($page.module)/PAGES.md) | $(Join-OrDefault -Items $page.allowedRoles -Default "none") | $shownByText |") | Out-Null
}

$byPagePath = Join-Path $kbRoot "routes/by-page.md"
$byPageContent = @"
# Page Index

| Page | Module | Roles | Shown by flows |
|---|---|---|---|
$($byPageRows -join "`n")
"@
Write-Utf8NoBom -Path $byPagePath -Content $byPageContent

$byFlowRows = New-Object System.Collections.Generic.List[string]
foreach ($flow in @($flowList | Sort-Object qualifiedName)) {
    $touchesEntitiesText = if (@($flow.touchesEntities).Count -gt 0) {
        Join-OrDefault -Items $flow.touchesEntities -Default "none"
    } elseif ($flow.hasBehaviouralAction) {
        Join-OrUnknown -Items @() `
            -UnknownScope "$($flow.module).$($flow.localName)" `
            -UnknownField "routes/by-flow.Touches Entities" `
            -Reason "Flow has behavioural actions but no explicit entity mention evidence." `
            -FixHint "Improve entity extraction patterns or add parser action/entity tags."
    } else {
        "none"
    }

    $byFlowRows.Add("| $($flow.qualifiedName) | $($flow.kind) | [$($flow.module)](../modules/$($flow.module)/FLOWS.md) | $($flow.tier) | $($flow.fanOut) | $($flow.fanIn) | $(Join-OrDefault -Items $flow.shownPages -Default "none") | $touchesEntitiesText |") | Out-Null
}

$byFlowPath = Join-Path $kbRoot "routes/by-flow.md"
$byFlowContent = @"
# Flow Index

| Flow | Type | Module | Tier | Calls | Called by | Shows Pages | Touches Entities |
|---|---|---|---:|---:|---:|---|---|
$($byFlowRows -join "`n")
"@
Write-Utf8NoBom -Path $byFlowPath -Content $byFlowContent

$edgeRowsDetailed = New-Object System.Collections.Generic.List[string]
foreach ($edge in @($crossModuleEdges | Sort-Object sourceModule, sourceFlow, targetModule, targetFlow)) {
    $edgeRowsDetailed.Add("| $($edge.sourceFlow) | $($edge.targetFlow) | $($edge.sourceModule) | $($edge.targetModule) |") | Out-Null
}
if ($edgeRowsDetailed.Count -eq 0) {
    $edgeRowsDetailed.Add("| none | none | none | none |") | Out-Null
}

$dependencyMatrixMap = @{}
foreach ($edge in @($crossModuleEdges)) {
    $key = "$($edge.sourceModule)|$($edge.targetModule)"
    if (-not $dependencyMatrixMap.ContainsKey($key)) {
        $dependencyMatrixMap[$key] = [ordered]@{
            Source = $edge.sourceModule
            Target = $edge.targetModule
            FlowCallCount = 0
            AssociationLinkCount = 0
        }
    }
    $dependencyMatrixMap[$key].FlowCallCount++
}

$associationLinkRows = New-Object System.Collections.Generic.List[string]
foreach ($assoc in @($associationRows | Sort-Object module, name)) {
    $parentModule = Get-ModuleNameFromQualified -QualifiedName $assoc.parentEntity
    $childModule = Get-ModuleNameFromQualified -QualifiedName $assoc.childEntity
    if ([string]::IsNullOrWhiteSpace($parentModule) -or [string]::IsNullOrWhiteSpace($childModule)) { continue }
    if ($parentModule -eq $childModule) { continue }

    $associationLinkRows.Add("| $($assoc.name) | $parentModule | $childModule | $($assoc.parentEntity) | $($assoc.childEntity) |") | Out-Null

    $key = "$parentModule|$childModule"
    if (-not $dependencyMatrixMap.ContainsKey($key)) {
        $dependencyMatrixMap[$key] = [ordered]@{
            Source = $parentModule
            Target = $childModule
            FlowCallCount = 0
            AssociationLinkCount = 0
        }
    }
    $dependencyMatrixMap[$key].AssociationLinkCount++
}
if ($associationLinkRows.Count -eq 0) {
    $associationLinkRows.Add("| none | none | none | none | none |") | Out-Null
}

$dependencyMatrixRows = New-Object System.Collections.Generic.List[string]
foreach ($entry in @($dependencyMatrixMap.Values | Sort-Object Source, Target)) {
    $dependencyMatrixRows.Add("| $($entry.Source) | $($entry.Target) | $($entry.FlowCallCount) | $($entry.AssociationLinkCount) |") | Out-Null
}
if ($dependencyMatrixRows.Count -eq 0) {
    $dependencyMatrixRows.Add("| none | none | 0 | 0 |") | Out-Null
}

$hubRows = New-Object System.Collections.Generic.List[string]
$hubModules = New-Object System.Collections.Generic.List[string]
$leafModules = New-Object System.Collections.Generic.List[string]
foreach ($module in $moduleNames) {
    $out = @($crossModuleEdges | Where-Object { $_.sourceModule -eq $module }).Count
    $in = @($crossModuleEdges | Where-Object { $_.targetModule -eq $module }).Count
    $role = if ($out -gt 0 -and $in -gt 0) { "hub" } elseif ($out -gt 0) { "source-leaf" } elseif ($in -gt 0) { "sink-leaf" } else { "isolated" }
    $hubRows.Add("| $module | $out | $in | $role |") | Out-Null
    if ($role -eq "hub") {
        $hubModules.Add($module) | Out-Null
    }
    if ($role -eq "source-leaf" -or $role -eq "sink-leaf") {
        $leafModules.Add("$module ($role)") | Out-Null
    }
}

$boundaryRowsRoute = New-Object System.Collections.Generic.List[string]
foreach ($module in $customModules) {
    $outModules = @($crossModuleEdges | Where-Object { $_.sourceModule -eq $module } | ForEach-Object { $_.targetModule } | Sort-Object -Unique)
    $inModules = @($crossModuleEdges | Where-Object { $_.targetModule -eq $module } | ForEach-Object { $_.sourceModule } | Sort-Object -Unique)
    $boundaryRowsRoute.Add("| $module | $(Join-OrDefault -Items $outModules -Default "none") | $(Join-OrDefault -Items $inModules -Default "none") |") | Out-Null
}
if ($boundaryRowsRoute.Count -eq 0) {
    $boundaryRowsRoute.Add("| none | none | none |") | Out-Null
}

$crossModulePath = Join-Path $kbRoot "routes/cross-module.md"
$crossModuleContent = @"
# Cross-Module Dependencies

## Dependency matrix

| Source module | Target module | Flow call count | Association link count |
|---|---|---:|---:|
$($dependencyMatrixRows -join "`n")

## Flow-call edges

| Source flow | Target flow | Source module | Target module |
|---|---|---|---|
$($edgeRowsDetailed -join "`n")

## Hub/leaf module classification

| Module | Outbound edges | Inbound edges | Classification |
|---|---:|---:|---|
$($hubRows -join "`n")

## Hub Modules

- $(Join-OrDefault -Items @($hubModules) -Default "none")

## Leaf Modules

- $(Join-OrDefault -Items @($leafModules) -Default "none")

## Association Links

| Association | From module | To module | Parent entity | Child entity |
|---|---|---|---|---|
$($associationLinkRows -join "`n")

## Custom-boundary dependency lens

| Custom module | Depends on | Used by |
|---|---|---|
$($boundaryRowsRoute -join "`n")
"@
Write-Utf8NoBom -Path $crossModulePath -Content $crossModuleContent

$todoRows = New-Object System.Collections.Generic.List[string]
foreach ($todo in @($unknownTodos | Sort-Object Scope, Field, Reason)) {
    $todoRows.Add("| $(Escape-Md $todo.Scope) | $(Escape-Md $todo.Field) | $(Escape-Md $todo.Reason) | $(Escape-Md $todo.FixHint) |") | Out-Null
}
if ($todoRows.Count -eq 0) {
    $todoRows.Add("| none | none | No unknown evidence gaps recorded by the composer. | none |") | Out-Null
}

$unknownTodoReportPath = Join-Path $kbRoot "_reports/UNKNOWN_TODO.md"
$unknownTodoContent = @"
# Unknown Evidence TODO Backlog

## Summary

- Total unknown items: $($unknownTodos.Count)
- Generated at: $generatedAtUtc
- Run folder: $RunFolder

## TODO Items

| Scope | Field | Reason | Suggested fix |
|---|---|---|---|
$($todoRows -join "`n")
"@
Write-Utf8NoBom -Path $unknownTodoReportPath -Content $unknownTodoContent

$knownGapsSummary = if ($unknownTodos.Count -eq 0) {
    "none"
} else {
    "$($unknownTodos.Count) unresolved Unknown items (see [_reports/UNKNOWN_TODO.md](_reports/UNKNOWN_TODO.md))"
}

if (Test-Path $routingPath -PathType Leaf) {
    $routingText = Get-Content -Raw $routingPath
    if ($routingText -match "- Known gaps:") {
        $routingText = [regex]::Replace($routingText, "- Known gaps:.*", "- Known gaps: $knownGapsSummary")
    } else {
        $routingText = $routingText.TrimEnd() + "`n`n- Known gaps: $knownGapsSummary`n"
    }
    Write-Utf8NoBom -Path $routingPath -Content $routingText
}

Write-Host ""
Write-Host "KB composition complete." -ForegroundColor Green
Write-Host "App: $AppName"
Write-Host "Run folder: $RunFolder"
Write-Host "Output: $kbRoot"
Write-Host "Unknown TODO report: $unknownTodoReportPath"
