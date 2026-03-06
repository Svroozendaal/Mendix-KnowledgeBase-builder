<#
.SYNOPSIS
    Validate Knowledge Base document quality and structure contracts.

.DESCRIPTION
    Complements run-kb-scaffold.ps1 by checking content quality, not only file existence.
    Fails when required headings, sections, links, or semantic completeness thresholds are missing.

.PARAMETER OutputRoot
    Root folder for knowledge bases. Default: mendix-data/knowledge-base

.PARAMETER AppName
    Name of the KB to validate.

.EXAMPLE
    .\run-kb-quality-gate.ps1 -AppName SmartExpenses
#>

param(
    [string]$OutputRoot = "mendix-data/knowledge-base",
    [string]$AppName
)

$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$artifactsRoot = Join-Path $scriptRoot "artifacts"

$thresholdPageCoverage = 95.0
$thresholdFlowCoverage = 90.0
$thresholdEntityCoverage = 90.0

if (-not $AppName) {
    Write-Error "AppName is required."
    exit 1
}

$kbRoot = Join-Path $OutputRoot $AppName
if (-not (Test-Path $kbRoot)) {
    Write-Error "KB root does not exist: $kbRoot"
    exit 1
}

$issues = New-Object System.Collections.Generic.List[object]

function Add-Issue {
    param(
        [string]$Severity,
        [string]$File,
        [string]$Message
    )

    $issues.Add([pscustomobject]@{
        Severity = $Severity
        File = $File
        Message = $Message
    }) | Out-Null
}

function Assert-Headings {
    param(
        [string]$File,
        [string[]]$Headings
    )

    if (-not (Test-Path $File)) {
        Add-Issue -Severity "error" -File $File -Message "Missing file."
        return
    }

    $text = Get-Content -Raw $File
    foreach ($h in $Headings) {
        if ($text -notmatch [regex]::Escape($h)) {
            Add-Issue -Severity "error" -File $File -Message "Missing required heading: $h"
        }
    }
}

function Get-TemplateHeadings {
    param([string]$TemplatePath)

    if (-not (Test-Path $TemplatePath -PathType Leaf)) { return @() }
    $lines = Get-Content $TemplatePath
    $headings = @()
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -match "^#{1,6}\s+") {
            if ($trimmed -match "{{.+}}") { continue }
            $headings += $trimmed
        }
    }
    return @($headings | Sort-Object -Unique)
}

function Assert-TemplateHeadings {
    param(
        [string]$FilePath,
        [string]$TemplatePath
    )

    if (-not (Test-Path $FilePath -PathType Leaf)) {
        Add-Issue -Severity "error" -File $FilePath -Message "Missing file."
        return
    }
    if (-not (Test-Path $TemplatePath -PathType Leaf)) {
        Add-Issue -Severity "error" -File $TemplatePath -Message "Missing template file used for heading contract."
        return
    }

    $requiredHeadings = Get-TemplateHeadings -TemplatePath $TemplatePath
    if ($requiredHeadings.Count -eq 0) { return }

    $text = Get-Content -Raw $FilePath
    foreach ($heading in $requiredHeadings) {
        if ($text -notmatch [regex]::Escape($heading)) {
            Add-Issue -Severity "error" -File $FilePath -Message "Missing template-derived heading: $heading"
        }
    }
}

function Check-Links {
    param([string]$File)

    if (-not (Test-Path $File)) { return }
    $text = Get-Content -Raw $File
    $matches = [regex]::Matches($text, "\[[^\]]+\]\(([^)]+)\)")
    foreach ($m in $matches) {
        $target = $m.Groups[1].Value
        if ($target -match "^(https?|mailto):") { continue }
        if ($target.StartsWith("#")) { continue }

        $clean = $target.Split("#")[0]
        if ([string]::IsNullOrWhiteSpace($clean)) { continue }

        $resolved = Join-Path (Split-Path -Parent $File) $clean
        if (-not (Test-Path $resolved)) {
            Add-Issue -Severity "error" -File $File -Message "Broken relative link: $target"
        }
    }
}

function Resolve-RunFolderFromSources {
    param([string]$KbRootPath)

    $sourcesManifest = Join-Path $KbRootPath "_sources/manifest.json"
    if (-not (Test-Path $sourcesManifest -PathType Leaf)) { return $null }

    $manifest = Get-Content -Raw $sourcesManifest | ConvertFrom-Json
    $artifactPath = $null
    $preferred = @($manifest.artifacts | Where-Object { $_.type -eq "general-all-modules-json" } | Select-Object -First 1)
    if ($preferred.Count -gt 0) {
        $artifactPath = [string]$preferred[0].path
    } else {
        $first = @($manifest.artifacts | Select-Object -First 1)
        if ($first.Count -gt 0) {
            $artifactPath = [string]$first[0].path
        }
    }

    if ([string]::IsNullOrWhiteSpace($artifactPath)) { return $null }
    if (-not (Test-Path $artifactPath -PathType Leaf)) { return $null }

    $artifactParent = Split-Path -Parent $artifactPath
    $folderName = Split-Path -Leaf $artifactParent
    if ($folderName -eq "general") {
        return (Split-Path -Parent $artifactParent)
    }
    if ($folderName -eq "modules") {
        return (Split-Path -Parent $artifactParent)
    }
    $parentName = Split-Path -Leaf (Split-Path -Parent $artifactParent)
    if ($parentName -eq "modules") {
        return (Split-Path -Parent (Split-Path -Parent $artifactParent))
    }
    return $null
}

function Get-MarkdownTableRows {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath -PathType Leaf)) { return @() }
    $lines = Get-Content $FilePath
    $rows = New-Object "System.Collections.Generic.List[psobject]"
    $headers = @()
    $inTable = $false
    $separatorSeen = $false

    foreach ($raw in $lines) {
        $line = $raw.Trim()
        if (-not $line.StartsWith("|") -or -not $line.EndsWith("|")) {
            if ($inTable -and $separatorSeen) { break }
            continue
        }

        $cells = @($line.Trim("|").Split("|") | ForEach-Object { $_.Trim() })
        if (-not $inTable) {
            $headers = $cells
            $inTable = $true
            continue
        }

        if (-not $separatorSeen) {
            $separatorSeen = $true
            continue
        }

        if ($cells.Count -ne $headers.Count) { continue }
        $obj = [ordered]@{}
        for ($i = 0; $i -lt $headers.Count; $i++) {
            $obj[$headers[$i]] = $cells[$i]
        }
        $rows.Add([pscustomobject]$obj) | Out-Null
    }

    return $rows.ToArray()
}

function Is-MeaningfulCellValue {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    $trimmed = $Value.Trim()
    if ($trimmed -match "^(Unknown|unknown)$") { return $false }
    if ($trimmed -match "^none(\b|\s|\()") { return $false }
    if ($trimmed -match "^n/a$") { return $false }
    return $true
}

# Root and app-level files
$readerFile = Join-Path $kbRoot "READER.md"
$routingFile = Join-Path $kbRoot "ROUTING.md"
$appFolder = Join-Path $kbRoot "app"

Assert-Headings -File $readerFile -Headings @(
    "# How to Read This Knowledge Base",
    "## What is this?",
    "## How to navigate",
    "## How to answer questions",
    "## Confidence levels",
    "## Source"
)

if (Test-Path $readerFile -PathType Leaf) {
    $readerText = Get-Content -Raw $readerFile
    if ($readerText -notmatch "KB Format Version:\s*\d+\.\d+") {
        Add-Issue -Severity "error" -File $readerFile -Message "Missing KB Format Version field (for example: KB Format Version: 1.0)."
    }
}

Assert-Headings -File $routingFile -Headings @(
    "# Knowledge Base Routing",
    "## Quick lookup",
    "## Module index",
    "## Completeness",
    "## Source"
)

if (Test-Path $routingFile) {
    $routing = Get-Content -Raw $routingFile
    $placeholderLinkMatches = [regex]::Matches($routing, "\[[^\]]+\]\((modules/(X|<[^>]+>)/[^)]+)\)")
    foreach ($pm in $placeholderLinkMatches) {
        Add-Issue -Severity "error" -File $routingFile -Message "Placeholder module link found: $($pm.Groups[1].Value)"
    }

    if ($routing -match "modules/(X|<[^>]+>)/") {
        Add-Issue -Severity "error" -File $routingFile -Message "Placeholder module path token found (X or <...>)."
    }
}

$appFiles = @(
    (Join-Path $appFolder "APP_OVERVIEW.md"),
    (Join-Path $appFolder "MODULE_LANDSCAPE.md"),
    (Join-Path $appFolder "SECURITY.md"),
    (Join-Path $appFolder "CALL_GRAPH.md")
)

foreach ($af in $appFiles) {
    if (-not (Test-Path $af)) {
        Add-Issue -Severity "error" -File $af -Message "Missing app-level file."
        continue
    }

    $t = Get-Content -Raw $af
    if ($t -notmatch "Export-backed|Inferred|Unknown") {
        Add-Issue -Severity "error" -File $af -Message "Missing confidence markers (Export-backed/Inferred/Unknown)."
    }
}

# Module-level contracts
$modulesDir = Join-Path $kbRoot "modules"
if (-not (Test-Path $modulesDir)) {
    Add-Issue -Severity "error" -File $modulesDir -Message "Missing modules directory."
}
else {
    $moduleDirs = Get-ChildItem $modulesDir -Directory | Sort-Object Name
    foreach ($mod in $moduleDirs) {
        $readme = Join-Path $mod.FullName "README.md"
        $domain = Join-Path $mod.FullName "DOMAIN.md"
        $flows = Join-Path $mod.FullName "FLOWS.md"
        $pages = Join-Path $mod.FullName "PAGES.md"
        $resources = Join-Path $mod.FullName "RESOURCES.md"

        Assert-Headings -File $readme -Headings @(
            "## Summary",
            "## Purpose",
            "## Navigation",
            "## Cross-Module Dependencies",
            "## Source"
        )

        if (Test-Path $readme) {
            $rt = Get-Content -Raw $readme
            if ($rt -notmatch "Shared entities via associations:") {
                Add-Issue -Severity "error" -File $readme -Message "Missing shared-entities dependency line."
            }
        }

        Assert-Headings -File $domain -Headings @(
            "## Entities",
            "## Associations",
            "## Enumerations"
        )

        Assert-Headings -File $flows -Headings @(
            "## Flow Catalogue",
            "### Action Flows (ACT_*)",
            "### Data Sources (DS_*)",
            "### Validation Flows (VAL_*)",
            "### Other Flows",
            "## Cross-Module Calls",
            "## Flow Details"
        )

        Assert-Headings -File $pages -Headings @(
            "## Page Inventory",
            "## Page-Flow Links",
            "## Snippets"
        )

        Assert-Headings -File $resources -Headings @(
            "## Constants",
            "## Scheduled Events",
            "## Other Resources"
        )
    }
}

# Routing index contracts
$routesDir = Join-Path $kbRoot "routes"
Assert-Headings -File (Join-Path $routesDir "by-entity.md") -Headings @("# Entity Index")
Assert-Headings -File (Join-Path $routesDir "by-page.md") -Headings @("# Page Index")
Assert-Headings -File (Join-Path $routesDir "by-flow.md") -Headings @("# Flow Index")
Assert-Headings -File (Join-Path $routesDir "cross-module.md") -Headings @("# Cross-Module Dependencies")

# Template-derived heading contract (single source of truth in artifacts/)
Assert-TemplateHeadings -FilePath $readerFile -TemplatePath (Join-Path $artifactsRoot "KNOWLEDGEBASE_READER.md")
Assert-TemplateHeadings -FilePath $routingFile -TemplatePath (Join-Path $artifactsRoot "ROUTING_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $appFolder "APP_OVERVIEW.md") -TemplatePath (Join-Path $artifactsRoot "APP_OVERVIEW_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $appFolder "MODULE_LANDSCAPE.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_LANDSCAPE_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $appFolder "SECURITY.md") -TemplatePath (Join-Path $artifactsRoot "SECURITY_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $appFolder "CALL_GRAPH.md") -TemplatePath (Join-Path $artifactsRoot "CALL_GRAPH_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $routesDir "by-entity.md") -TemplatePath (Join-Path $artifactsRoot "ROUTE_BY_ENTITY_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $routesDir "by-page.md") -TemplatePath (Join-Path $artifactsRoot "ROUTE_BY_PAGE_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $routesDir "by-flow.md") -TemplatePath (Join-Path $artifactsRoot "ROUTE_BY_FLOW_TEMPLATE.md")
Assert-TemplateHeadings -FilePath (Join-Path $routesDir "cross-module.md") -TemplatePath (Join-Path $artifactsRoot "ROUTE_CROSS_MODULE_TEMPLATE.md")

if (Test-Path $modulesDir -PathType Container) {
    foreach ($mod in @(Get-ChildItem $modulesDir -Directory | Sort-Object Name)) {
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "README.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_README_TEMPLATE.md")
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "DOMAIN.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_DOMAIN_TEMPLATE.md")
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "FLOWS.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_FLOWS_TEMPLATE.md")
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "PAGES.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_PAGES_TEMPLATE.md")
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "RESOURCES.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_RESOURCES_TEMPLATE.md")
    }
}

# ROUTING known-gaps honesty check
if (Test-Path $routingFile -PathType Leaf) {
    $routingText = Get-Content -Raw $routingFile
    $knownGapsMatch = [regex]::Match($routingText, "- Known gaps:\s*(.+)")
    if (-not $knownGapsMatch.Success) {
        Add-Issue -Severity "error" -File $routingFile -Message "Missing 'Known gaps' line in ROUTING completeness section."
    } else {
        $knownGapsValue = $knownGapsMatch.Groups[1].Value.Trim()
        $unknownTodoPath = Join-Path $kbRoot "_reports/UNKNOWN_TODO.md"
        if (Test-Path $unknownTodoPath -PathType Leaf) {
            $unknownTodoText = Get-Content -Raw $unknownTodoPath
            $countMatch = [regex]::Match($unknownTodoText, "Total unknown items:\s*(\d+)")
            if ($countMatch.Success) {
                $unknownCount = [int]$countMatch.Groups[1].Value
                if ($unknownCount -gt 0 -and $knownGapsValue -match "^(none|None)\b") {
                    Add-Issue -Severity "error" -File $routingFile -Message "Known gaps says 'none' while UNKNOWN_TODO reports $unknownCount unresolved items."
                }
            }
        }
    }
}

# Semantic completeness checks for custom modules
$semanticMetrics = [ordered]@{
    PageCoveragePercent = 100.0
    FlowCoveragePercent = 100.0
    EntityCoveragePercent = 100.0
    ExpectedCustomPages = 0
    ExpectedCustomFlows = 0
    ExpectedCustomEntities = 0
    PageThreshold = $thresholdPageCoverage
    FlowThreshold = $thresholdFlowCoverage
    EntityThreshold = $thresholdEntityCoverage
    PagePass = $true
    FlowPass = $true
    EntityPass = $true
}

$runFolder = Resolve-RunFolderFromSources -KbRootPath $kbRoot
if (-not $runFolder) {
    Add-Issue -Severity "error" -File $kbRoot -Message "Semantic checks failed: could not resolve source run folder from _sources/manifest.json."
}
else {
    $allModulesPath = Join-Path $runFolder "general/all-modules.json"
    if (-not (Test-Path $allModulesPath -PathType Leaf)) {
        Add-Issue -Severity "error" -File $allModulesPath -Message "Semantic checks failed: missing general/all-modules.json."
    }
    else {
        $allModules = Get-Content -Raw $allModulesPath | ConvertFrom-Json
        $customModules = @($allModules.modules | Where-Object { $_.category -eq "Custom" } | ForEach-Object { $_.module } | Sort-Object -Unique)

        $customEntities = @{}
        $customPages = @{}
        foreach ($module in $customModules) {
            $domainPath = Join-Path $runFolder "modules/$module/domain-model.json"
            if (Test-Path $domainPath -PathType Leaf) {
                $domain = Get-Content -Raw $domainPath | ConvertFrom-Json
                foreach ($entity in @($domain.domainModel.entities)) {
                    $customEntities[$entity.name] = $module
                }
            }

            $pagesPath = Join-Path $runFolder "modules/$module/pages.json"
            if (Test-Path $pagesPath -PathType Leaf) {
                $pages = Get-Content -Raw $pagesPath | ConvertFrom-Json
                foreach ($page in @($pages.pages)) {
                    $customPages[[string]$page.qualifiedName] = $module
                }
            }
        }

        $expectedPagesWithEvidence = New-Object "System.Collections.Generic.HashSet[string]"
        $expectedFlowsWithEntityActions = New-Object "System.Collections.Generic.HashSet[string]"
        $expectedEntitiesReferenced = New-Object "System.Collections.Generic.HashSet[string]"

        foreach ($module in $customModules) {
            $flowsPath = Join-Path $runFolder "modules/$module/flows.json"
            if (-not (Test-Path $flowsPath -PathType Leaf)) { continue }
            $flows = Get-Content -Raw $flowsPath | ConvertFrom-Json

            foreach ($flow in @($flows.flows)) {
                $flowName = [string]$flow.qualifiedName
                $hasEntityActionKeyword = $false
                $touchedEntities = New-Object "System.Collections.Generic.HashSet[string]"

                foreach ($node in @($flow.nodes)) {
                    $text = (([string]$node.label) + " " + ([string]$node.detail))
                    if ([string]::IsNullOrWhiteSpace($text)) { continue }

                    if ($text -match "CreateObjectAction|CreateListAction|RetrieveAction|ChangeObjectAction|ChangeListAction|CommitAction|DeleteAction|AggregateListAction") {
                        $hasEntityActionKeyword = $true
                    }

                    foreach ($pm in [regex]::Matches($text, "show page\s+([A-Za-z0-9_]+\.[A-Za-z0-9_]+)", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
                        $pageName = $pm.Groups[1].Value
                        if ($customPages.ContainsKey($pageName)) {
                            [void]$expectedPagesWithEvidence.Add($pageName)
                        }
                    }

                    foreach ($tm in [regex]::Matches($text, "\b([A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*)\b")) {
                        $candidate = $tm.Groups[1].Value
                        if ($customEntities.ContainsKey($candidate)) {
                            [void]$touchedEntities.Add($candidate)
                        }
                    }
                }

                if ($hasEntityActionKeyword -and $touchedEntities.Count -gt 0) {
                    [void]$expectedFlowsWithEntityActions.Add($flowName)
                }
                foreach ($entityName in $touchedEntities) {
                    [void]$expectedEntitiesReferenced.Add($entityName)
                }
            }
        }

        $byPageRows = Get-MarkdownTableRows -FilePath (Join-Path $routesDir "by-page.md")
        $byFlowRows = Get-MarkdownTableRows -FilePath (Join-Path $routesDir "by-flow.md")
        $byEntityRows = Get-MarkdownTableRows -FilePath (Join-Path $routesDir "by-entity.md")

        $byPageMap = @{}
        foreach ($row in $byPageRows) {
            $byPageMap[[string]$row.'Page'] = [string]$row.'Shown by flows'
        }
        $byFlowMap = @{}
        foreach ($row in $byFlowRows) {
            $byFlowMap[[string]$row.'Flow'] = [string]$row.'Touches Entities'
        }
        $byEntityMap = @{}
        foreach ($row in $byEntityRows) {
            $byEntityMap[[string]$row.'Entity'] = $row
        }

        $expectedPageCount = $expectedPagesWithEvidence.Count
        $coveredPages = 0
        foreach ($pageName in $expectedPagesWithEvidence) {
            if ($byPageMap.ContainsKey($pageName) -and (Is-MeaningfulCellValue -Value $byPageMap[$pageName])) {
                $coveredPages++
            }
        }
        $pageCoverage = if ($expectedPageCount -eq 0) { 100.0 } else { [math]::Round((100.0 * $coveredPages) / $expectedPageCount, 2) }

        $expectedFlowCount = $expectedFlowsWithEntityActions.Count
        $coveredFlows = 0
        foreach ($flowName in $expectedFlowsWithEntityActions) {
            if ($byFlowMap.ContainsKey($flowName) -and (Is-MeaningfulCellValue -Value $byFlowMap[$flowName])) {
                $coveredFlows++
            }
        }
        $flowCoverage = if ($expectedFlowCount -eq 0) { 100.0 } else { [math]::Round((100.0 * $coveredFlows) / $expectedFlowCount, 2) }

        $expectedEntityCount = $expectedEntitiesReferenced.Count
        $coveredEntities = 0
        foreach ($entityName in $expectedEntitiesReferenced) {
            if (-not $byEntityMap.ContainsKey($entityName)) { continue }
            $row = $byEntityMap[$entityName]
            $cells = @(
                [string]$row.'Create flows',
                [string]$row.'Update flows',
                [string]$row.'Delete flows',
                [string]$row.'Read flows'
            )
            if (@($cells | Where-Object { Is-MeaningfulCellValue -Value $_ }).Count -gt 0) {
                $coveredEntities++
            }
        }
        $entityCoverage = if ($expectedEntityCount -eq 0) { 100.0 } else { [math]::Round((100.0 * $coveredEntities) / $expectedEntityCount, 2) }

        $semanticMetrics["PageCoveragePercent"] = $pageCoverage
        $semanticMetrics["FlowCoveragePercent"] = $flowCoverage
        $semanticMetrics["EntityCoveragePercent"] = $entityCoverage
        $semanticMetrics["ExpectedCustomPages"] = $expectedPageCount
        $semanticMetrics["ExpectedCustomFlows"] = $expectedFlowCount
        $semanticMetrics["ExpectedCustomEntities"] = $expectedEntityCount

        if ($pageCoverage -lt $thresholdPageCoverage) {
            $semanticMetrics["PagePass"] = $false
            Add-Issue -Severity "error" -File (Join-Path $routesDir "by-page.md") -Message "Semantic completeness below threshold: custom page shown-by coverage $pageCoverage% (expected >=$thresholdPageCoverage%, evidence pages=$expectedPageCount)."
        }
        if ($flowCoverage -lt $thresholdFlowCoverage) {
            $semanticMetrics["FlowPass"] = $false
            Add-Issue -Severity "error" -File (Join-Path $routesDir "by-flow.md") -Message "Semantic completeness below threshold: custom flow touches-entities coverage $flowCoverage% (expected >=$thresholdFlowCoverage%, evidence flows=$expectedFlowCount)."
        }
        if ($entityCoverage -lt $thresholdEntityCoverage) {
            $semanticMetrics["EntityPass"] = $false
            Add-Issue -Severity "error" -File (Join-Path $routesDir "by-entity.md") -Message "Semantic completeness below threshold: custom entity lifecycle coverage $entityCoverage% (expected >=$thresholdEntityCoverage%, evidence entities=$expectedEntityCount)."
        }
    }
}

# Link validation on all markdown files
$allMd = Get-ChildItem -Recurse -File $kbRoot -Filter *.md | Where-Object { $_.FullName -notmatch "[\\/]_artifacts[\\/]" }
foreach ($f in $allMd) {
    Check-Links -File $f.FullName
}

Write-Host ""
Write-Host "=== KB Quality Gate: $AppName ==="
Write-Host "Root: $kbRoot"
Write-Host "Files checked: $($allMd.Count)"
Write-Host "Issues: $($issues.Count)"
$structuralIssueCount = @($issues | Where-Object { $_.Severity -eq "error" }).Count
$overallPass = ($issues.Count -eq 0)
Write-Host "Structural issue count: $structuralIssueCount"
Write-Host ("Metric A (Page-flow linkage): {0}% (threshold >= {1}%, n={2}) -> {3}" -f `
    $semanticMetrics["PageCoveragePercent"], $semanticMetrics["PageThreshold"], $semanticMetrics["ExpectedCustomPages"], `
    $(if ($semanticMetrics["PagePass"]) { "PASS" } else { "FAIL" }))
Write-Host ("Metric B (Flow entity coverage): {0}% (threshold >= {1}%, n={2}) -> {3}" -f `
    $semanticMetrics["FlowCoveragePercent"], $semanticMetrics["FlowThreshold"], $semanticMetrics["ExpectedCustomFlows"], `
    $(if ($semanticMetrics["FlowPass"]) { "PASS" } else { "FAIL" }))
Write-Host ("Metric C (Entity lifecycle mapping): {0}% (threshold >= {1}%, n={2}) -> {3}" -f `
    $semanticMetrics["EntityCoveragePercent"], $semanticMetrics["EntityThreshold"], $semanticMetrics["ExpectedCustomEntities"], `
    $(if ($semanticMetrics["EntityPass"]) { "PASS" } else { "FAIL" }))
Write-Host "Final verdict: $(if ($overallPass) { "PASS" } else { "FAIL" })"

if ($issues.Count -gt 0) {
    Write-Host ""
    Write-Host "QUALITY ISSUES:" -ForegroundColor Red
    foreach ($i in $issues) {
        Write-Host "[$($i.Severity)] $($i.File) :: $($i.Message)" -ForegroundColor Red
    }
    exit 1
}
else {
    Write-Host ""
    Write-Host "Quality gate passed." -ForegroundColor Green
    exit 0
}
