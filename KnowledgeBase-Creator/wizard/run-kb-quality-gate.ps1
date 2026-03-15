<#
.SYNOPSIS
    Validate Knowledge Base document quality and structure contracts.

.DESCRIPTION
    Complements run-kb-scaffold.ps1 by checking content quality, not only file existence.
    Fails when required headings, sections, links, or semantic completeness thresholds are missing.

.PARAMETER OutputRoot
    Knowledge base root folder. Default: mendix-data/knowledge-base

.PARAMETER AppName
    Name of the KB to validate.

.EXAMPLE
    .\run-kb-quality-gate.ps1 -AppName SmartExpenses
#>

param(
    [string]$OutputRoot = "mendix-data/knowledge-base",
    [string]$AppName,
    [switch]$ShowAllIssues,
    [string]$GeneratedAtUtc,
    [string]$KbRootDisplay
)

$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $scriptRoot
$artifactsRoot = Join-Path $packageRoot "artifacts/templates"
. (Join-Path $scriptRoot "lib/app-overview-resolver.ps1")

$thresholdPageCoverage = 95.0
$thresholdFlowCoverage = 90.0
$thresholdEntityCoverage = 90.0

if (-not $AppName) {
    Write-Error "AppName is required."
    exit 1
}

$kbRoot = $OutputRoot
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
    $text = [regex]::Replace($text, '(?ms)```.*?```', '')
    $matches = [regex]::Matches($text, "\[[^\]]+\]\(([^)]+)\)")
    foreach ($m in $matches) {
        $target = $m.Groups[1].Value
        if ($target -match "^(https?|mailto):") { continue }
        $parts = $target.Split("#", 2)
        $clean = $parts[0]
        $fragment = if ($parts.Count -gt 1) { [uri]::UnescapeDataString($parts[1]) } else { "" }

        try {
            $resolved = if ([string]::IsNullOrWhiteSpace($clean)) {
                $File
            } elseif ([System.IO.Path]::IsPathRooted($clean)) {
                [System.IO.Path]::GetFullPath($clean)
            } else {
                Join-Path (Split-Path -Parent $File) $clean
            }
        }
        catch {
            Add-Issue -Severity "error" -File $File -Message "Invalid link target: $target"
            continue
        }

        if (-not (Test-Path $resolved)) {
            Add-Issue -Severity "error" -File $File -Message "Broken link target: $target"
            continue
        }

        if (-not [string]::IsNullOrWhiteSpace($fragment)) {
            $resolvedText = Get-Content -Raw $resolved
            $anchorPattern = '<a\s+id="' + [regex]::Escape($fragment) + '"\s*></a>'
            if ($resolvedText -notmatch $anchorPattern) {
                Add-Issue -Severity "error" -File $File -Message "Broken link fragment: $target"
            }
        }
    }
}

function Assert-SectionIsPopulated {
    param(
        [string]$FilePath,
        [string]$Heading,
        [string[]]$PlaceholderPatterns
    )

    if (-not (Test-Path $FilePath -PathType Leaf)) { return }

    $text = Get-Content -Raw $FilePath
    $escapedHeading = [regex]::Escape($Heading)
    $match = [regex]::Match($text, "(?ms)$escapedHeading\s*(?<body>.*?)(^\#|\z)")
    if (-not $match.Success) {
        Add-Issue -Severity "error" -File $FilePath -Message "Missing section body for $Heading"
        return
    }

    $body = $match.Groups["body"].Value.Trim()
    if ([string]::IsNullOrWhiteSpace($body)) {
        Add-Issue -Severity "error" -File $FilePath -Message "Empty section body for $Heading"
        return
    }

    foreach ($pattern in $PlaceholderPatterns) {
        if ($body -match $pattern) {
            Add-Issue -Severity "error" -File $FilePath -Message "Unpopulated section body for $Heading"
            return
        }
    }
}

function Assert-NoFencedCodeBlocks {
    param(
        [string]$FilePath,
        [string]$Reason
    )

    if (-not (Test-Path $FilePath -PathType Leaf)) { return }

    $text = Get-Content -Raw $FilePath
    if ($text -match '(?ms)```.*?```') {
        Add-Issue -Severity "error" -File $FilePath -Message $Reason
    }
}

function Get-FrontMatterMap {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath -PathType Leaf)) { return @{} }
    $text = Get-Content -Raw $FilePath
    $match = [regex]::Match($text, '(?ms)\A---\s*(?<body>.*?)\s*---')
    if (-not $match.Success) { return @{} }

    $map = @{}
    foreach ($line in ($match.Groups['body'].Value -split "`r?`n")) {
        if ($line -notmatch '^\s*([^:]+):\s*(.*)$') { continue }
        $map[$matches[1].Trim()] = $matches[2].Trim()
    }
    return $map
}

function Assert-LayeredPointers {
    param([string]$FilePath)

    $frontMatter = Get-FrontMatterMap -FilePath $FilePath
    if ($frontMatter.Count -eq 0) {
        Add-Issue -Severity "error" -File $FilePath -Message "Missing front matter."
        return
    }

    foreach ($key in @('layer', 'slug', 'sourceRun', 'l2Path', 'l2Logical')) {
        if (-not $frontMatter.ContainsKey($key) -or [string]::IsNullOrWhiteSpace([string]$frontMatter[$key])) {
            Add-Issue -Severity "error" -File $FilePath -Message "Missing front matter field: $key"
        }
    }

    foreach ($pointer in @('l0', 'l1', 'l2Path', 'collectionL0', 'collectionL1')) {
        if (-not $frontMatter.ContainsKey($pointer)) { continue }
        $value = [string]$frontMatter[$pointer]
        if ([string]::IsNullOrWhiteSpace($value) -or $value -eq '.') { continue }
        $resolved = Join-Path (Split-Path -Parent $FilePath) $value
        if (-not (Test-Path $resolved)) {
            Add-Issue -Severity "error" -File $FilePath -Message "Front matter pointer does not resolve: $pointer -> $value"
        }
    }

    if ($script:expectedSourceRunName -and $frontMatter.ContainsKey('sourceRun')) {
        $actualSourceRun = [string]$frontMatter['sourceRun']
        if (-not [string]::IsNullOrWhiteSpace($actualSourceRun) -and $actualSourceRun -ne $script:expectedSourceRunName) {
            Add-Issue -Severity "error" -File $FilePath -Message "sourceRun does not match resolved run folder: $actualSourceRun != $($script:expectedSourceRunName)"
        }
    }
}

function Write-QualityReports {
    param(
        [string]$KbRootPath,
        [string]$ApplicationName,
        [System.Collections.Generic.List[object]]$IssueList,
        [hashtable]$SemanticMetrics,
        [bool]$OverallPass,
        [int]$FilesChecked,
        [string]$GeneratedAtUtc,
        [string]$KbRootDisplay
    )

    $reportsDir = Join-Path $KbRootPath "_reports"
    if (-not (Test-Path $reportsDir -PathType Container)) {
        New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
    }

    $jsonPath = Join-Path $reportsDir "quality-gate-latest.json"
    $mdPath = Join-Path $reportsDir "quality-gate-latest.md"
    $generatedAtUtc = if ([string]::IsNullOrWhiteSpace($GeneratedAtUtc)) { [DateTime]::UtcNow.ToString("o") } else { $GeneratedAtUtc }
    $kbRootForReport = if ([string]::IsNullOrWhiteSpace($KbRootDisplay)) { [System.IO.Path]::GetFullPath($KbRootPath) } else { $KbRootDisplay }
    $issueArray = @($IssueList)

    $jsonPayload = [ordered]@{
        appName = $ApplicationName
        kbRoot = $kbRootForReport
        generatedAtUtc = $generatedAtUtc
        overallPass = $OverallPass
        filesChecked = $FilesChecked
        issueCount = $issueArray.Count
        issues = $issueArray
        semanticMetrics = $SemanticMetrics
    }
    $jsonPayload | ConvertTo-Json -Depth 8 | Set-Content -Path $jsonPath -Encoding UTF8

    $mdLines = New-Object System.Collections.Generic.List[string]
    $mdLines.Add("# KB Quality Gate Report") | Out-Null
    $mdLines.Add("") | Out-Null
    $mdLines.Add("- App: $ApplicationName") | Out-Null
    $mdLines.Add("- KB root: $kbRootForReport") | Out-Null
    $mdLines.Add("- Generated at (UTC): $generatedAtUtc") | Out-Null
    $mdLines.Add("- Files checked: $FilesChecked") | Out-Null
    $mdLines.Add("- Issue count: $($issueArray.Count)") | Out-Null
    $mdLines.Add("- Final verdict: $(if ($OverallPass) { 'PASS' } else { 'FAIL' })") | Out-Null
    $mdLines.Add("") | Out-Null
    $mdLines.Add("## Semantic Metrics") | Out-Null
    $mdLines.Add("") | Out-Null
    $mdLines.Add("| Metric | Value | Threshold | Status |") | Out-Null
    $mdLines.Add("|---|---:|---:|---|") | Out-Null
    $mdLines.Add("| Page-flow linkage | $($SemanticMetrics['PageCoveragePercent']) | $($SemanticMetrics['PageThreshold']) | $(if ($SemanticMetrics['PagePass']) { 'PASS' } else { 'FAIL' }) |") | Out-Null
    $mdLines.Add("| Flow entity coverage | $($SemanticMetrics['FlowCoveragePercent']) | $($SemanticMetrics['FlowThreshold']) | $(if ($SemanticMetrics['FlowPass']) { 'PASS' } else { 'FAIL' }) |") | Out-Null
    $mdLines.Add("| Entity lifecycle mapping | $($SemanticMetrics['EntityCoveragePercent']) | $($SemanticMetrics['EntityThreshold']) | $(if ($SemanticMetrics['EntityPass']) { 'PASS' } else { 'FAIL' }) |") | Out-Null
    $mdLines.Add("") | Out-Null
    $mdLines.Add("## Issues") | Out-Null
    $mdLines.Add("") | Out-Null
    if ($issueArray.Count -eq 0) {
        $mdLines.Add("No issues.") | Out-Null
    }
    else {
        foreach ($issue in $issueArray) {
            $mdLines.Add("- [$($issue.Severity)] $($issue.File) :: $($issue.Message)") | Out-Null
        }
    }

    Set-Content -Path $mdPath -Value ($mdLines -join "`r`n") -Encoding UTF8

    return @{
        Json = $jsonPath
        Markdown = $mdPath
    }
}

function Resolve-SourceArtifactPath {
    param(
        [string]$KbRootPath,
        [string]$ArtifactPath
    )

    if ([string]::IsNullOrWhiteSpace($ArtifactPath)) { return $null }
    if ([System.IO.Path]::IsPathRooted($ArtifactPath)) {
        return $ArtifactPath
    }

    $dataRoot = Split-Path -Parent $KbRootPath
    $candidate = Join-Path $dataRoot $ArtifactPath
    if (Test-Path $candidate -PathType Leaf) {
        return $candidate
    }

    return [System.IO.Path]::GetFullPath($ArtifactPath)
}

function Resolve-RunFolderFromSources {
    param([string]$KbRootPath)

    return Resolve-OverviewRunFolderFromKnowledgeBase -KbRootPath $KbRootPath
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

function Get-KbModuleDirectories {
    param([string]$KbRootPath)

    $result = New-Object System.Collections.Generic.List[object]
    $modulesDir = Join-Path $KbRootPath "modules"
    if (-not (Test-Path $modulesDir -PathType Container)) {
        return @()
    }

    foreach ($dir in @(Get-ChildItem $modulesDir -Directory | Where-Object { $_.Name -ne "_marktplace" } | Sort-Object Name)) {
        $result.Add([pscustomobject]@{
            Name = $dir.Name
            FullName = $dir.FullName
            Category = "Direct"
        }) | Out-Null
    }

    $marketplaceDir = Join-Path $modulesDir "_marktplace"
    if (Test-Path $marketplaceDir -PathType Container) {
        foreach ($dir in @(Get-ChildItem $marketplaceDir -Directory | Sort-Object Name)) {
            $result.Add([pscustomobject]@{
                Name = $dir.Name
                FullName = $dir.FullName
                Category = "Marketplace"
            }) | Out-Null
        }
    }

    return @($result | Sort-Object Name)
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
    $moduleDirs = Get-KbModuleDirectories -KbRootPath $kbRoot
    foreach ($mod in $moduleDirs) {
        $readme = Join-Path $mod.FullName "README.md"
        $domain = Join-Path $mod.FullName "DOMAIN.md"
        $flows = Join-Path $mod.FullName "FLOWS.md"
        $flowsDir = Join-Path $mod.FullName "flows"
        $flowsIndex = Join-Path $flowsDir "INDEX.abstract.md"
        $pages = Join-Path $mod.FullName "PAGES.md"
        $pagesDir = Join-Path $mod.FullName "pages"
        $pagesIndex = Join-Path $pagesDir "INDEX.abstract.md"
        $interpretation = Join-Path $mod.FullName "INTERPRETATION.md"
        $resources = Join-Path $mod.FullName "RESOURCES.md"
        $flowsEvidence = Join-Path $mod.FullName "FLOWS_EVIDENCE.md"
        $pagesEvidence = Join-Path $mod.FullName "PAGES_EVIDENCE.md"

        if (Test-Path $flowsEvidence -PathType Leaf) {
            Add-Issue -Severity "error" -File $flowsEvidence -Message "Legacy evidence file is stale-contract output; use flows/*.abstract.md and flows/*.overview.md instead."
        }
        if (Test-Path $pagesEvidence -PathType Leaf) {
            Add-Issue -Severity "error" -File $pagesEvidence -Message "Legacy evidence file is stale-contract output; use pages/*.abstract.md and pages/*.overview.md instead."
        }

        Assert-Headings -File $readme -Headings @(
            "## Summary",
            "## Purpose",
            "## Capability Map",
            "## Primary User Journeys",
            "## Top risks/unknowns in model understanding",
            "## Navigation",
            "## Source Pointers",
            "## Cross-Module Dependencies",
            "## Source"
        )

        if (Test-Path $readme) {
            $rt = Get-Content -Raw $readme
            if ($rt -notmatch "Shared entities via associations:") {
                Add-Issue -Severity "error" -File $readme -Message "Missing shared-entities dependency line."
            }
        }
        Assert-SectionIsPopulated -FilePath $readme -Heading "## Source Pointers" -PlaceholderPatterns @(
            "Export overview:\s*none"
        )

        Assert-Headings -File $domain -Headings @(
            "## Entities",
            "## Entity Lifecycle Matrix",
            "## Role impacts per sensitive entity",
            "## Associations",
            "## Enumerations",
            "## Entity Index",
            "## Source"
        )

        Assert-Headings -File $flows -Headings @(
            "## Flow Catalogue",
            "### Action Flows (ACT_*)",
            "### Data Sources (DS_*)",
            "### Validation Flows (VAL_*)",
            "### Other Flows",
            "## Cross-Module Calls",
            "## Tier 1 Shortlist",
            "## Flow Links"
        )

        Assert-Headings -File $pages -Headings @(
            "## Page Inventory",
            "## Page-Flow Links",
            "## Journey Groups",
            "## Page Links"
        )

        Assert-Headings -File $flowsIndex -Headings @("# Flow Collection Abstract")
        Assert-Headings -File $pagesIndex -Headings @("# Page Collection Abstract")

        Assert-Headings -File $interpretation -Headings @(
            "## Module Purpose",
            "## Domain Narrative",
            "## Flow Narrative",
            "## Page Narrative"
        )

        Assert-Headings -File $resources -Headings @(
            "## Constants",
            "## Scheduled Events",
            "## Other Resources"
        )

        foreach ($summaryFile in @($readme, $domain, $flows, $pages)) {
            Assert-NoFencedCodeBlocks -FilePath $summaryFile -Reason "Summary file contains fenced code blocks; keep layered summaries compact."
        }

        foreach ($collectionFile in @($flowsIndex, $pagesIndex)) {
            Assert-NoFencedCodeBlocks -FilePath $collectionFile -Reason "Collection abstract contains fenced code blocks; keep routing files compact."
            Assert-LayeredPointers -FilePath $collectionFile
        }

        foreach ($pattern in @('*.abstract.md', '*.overview.md')) {
            foreach ($file in @(Get-ChildItem -Path $flowsDir -Filter $pattern -File -ErrorAction SilentlyContinue)) {
                Assert-NoFencedCodeBlocks -FilePath $file.FullName -Reason "Layered object markdown contains fenced code blocks; keep object files compact."
                Assert-LayeredPointers -FilePath $file.FullName
            }
            foreach ($file in @(Get-ChildItem -Path $pagesDir -Filter $pattern -File -ErrorAction SilentlyContinue)) {
                Assert-NoFencedCodeBlocks -FilePath $file.FullName -Reason "Layered object markdown contains fenced code blocks; keep object files compact."
                Assert-LayeredPointers -FilePath $file.FullName
            }
        }
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
    foreach ($mod in @(Get-KbModuleDirectories -KbRootPath $kbRoot)) {
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "README.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_README_TEMPLATE.md")
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "DOMAIN.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_DOMAIN_TEMPLATE.md")
        Assert-TemplateHeadings -FilePath (Join-Path $mod.FullName "INTERPRETATION.md") -TemplatePath (Join-Path $artifactsRoot "MODULE_INTERPRETATION_TEMPLATE.md")
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

$script:expectedSourceRunName = $null
$runFolder = Resolve-RunFolderFromSources -KbRootPath $kbRoot
if (-not $runFolder) {
    Add-Issue -Severity "error" -File $kbRoot -Message "Semantic checks failed: could not resolve source run folder from _sources/manifest.json."
}
else {
    $runFolder = (Resolve-Path $runFolder).Path
    $script:expectedSourceRunName = Split-Path $runFolder -Leaf
    $runManifest = Load-OverviewManifest -RunFolder $runFolder
    $moduleCatalog = @(Get-OverviewModuleCatalog -RunFolder $runFolder -Manifest $runManifest)
    $moduleCatalogByName = Get-OverviewModuleCatalogMap -ModuleCatalog $moduleCatalog
    $currentAliasInfo = Sync-AppOverviewCurrentAlias -RunFolder $runFolder -ModuleCatalogByName $moduleCatalogByName
    $currentAliasPath = [string]$currentAliasInfo.CurrentAliasPath

    $creatorLinkPath = Join-Path $kbRoot "_sources/creator-link.json"
    if (Test-Path $creatorLinkPath -PathType Leaf) {
        $creatorLink = Get-Content -Raw $creatorLinkPath | ConvertFrom-Json
        if ([string]::IsNullOrWhiteSpace([string]$creatorLink.lastRunFolder)) {
            Add-Issue -Severity "error" -File $creatorLinkPath -Message "creator-link.json is missing lastRunFolder."
        } elseif (-not (Test-Path ([string]$creatorLink.lastRunFolder) -PathType Container)) {
            Add-Issue -Severity "error" -File $creatorLinkPath -Message "creator-link.json lastRunFolder does not exist: $([string]$creatorLink.lastRunFolder)"
        } elseif ((Resolve-Path ([string]$creatorLink.lastRunFolder)).Path -ne $runFolder) {
            Add-Issue -Severity "error" -File $creatorLinkPath -Message "creator-link.json lastRunFolder does not match the resolved immutable run folder."
        }

        if ($creatorLink.PSObject.Properties.Name -notcontains "currentAliasPath") {
            Add-Issue -Severity "error" -File $creatorLinkPath -Message "creator-link.json is missing currentAliasPath."
        } elseif ([string]::IsNullOrWhiteSpace([string]$creatorLink.currentAliasPath)) {
            Add-Issue -Severity "error" -File $creatorLinkPath -Message "creator-link.json currentAliasPath is empty."
        } elseif (-not (Test-Path ([string]$creatorLink.currentAliasPath) -PathType Container)) {
            Add-Issue -Severity "error" -File $creatorLinkPath -Message "creator-link.json currentAliasPath does not exist: $([string]$creatorLink.currentAliasPath)"
        } elseif ((Resolve-Path ([string]$creatorLink.currentAliasPath)).Path -ne $currentAliasPath) {
            Add-Issue -Severity "error" -File $creatorLinkPath -Message "creator-link.json currentAliasPath does not match the rebuilt app-overview/current alias."
        }
    }

    $currentManifestPath = Join-Path $currentAliasPath "manifest.json"
    if (-not (Test-Path $currentManifestPath -PathType Leaf)) {
        Add-Issue -Severity "error" -File $currentAliasPath -Message "app-overview/current is missing manifest.json."
    } else {
        $currentManifest = Get-Content -Raw $currentManifestPath | ConvertFrom-Json
        if ([string]$currentManifest.schemaVersion -ne [string]$runManifest.schemaVersion) {
            Add-Issue -Severity "error" -File $currentManifestPath -Message "app-overview/current manifest schemaVersion does not match the immutable run manifest."
        }
        $currentSelectedModules = @($currentManifest.selectedModules | ForEach-Object { [string]$_ } | Sort-Object)
        $runSelectedModules = @($runManifest.selectedModules | ForEach-Object { [string]$_ } | Sort-Object)
        if (($currentSelectedModules -join "|") -ne ($runSelectedModules -join "|")) {
            Add-Issue -Severity "error" -File $currentManifestPath -Message "app-overview/current manifest selectedModules does not match the immutable run manifest."
        }
    }

    $allModulesPath = Join-Path $runFolder "general/all-modules.json"
    if (-not (Test-Path $allModulesPath -PathType Leaf)) {
        Add-Issue -Severity "error" -File $allModulesPath -Message "Semantic checks failed: missing general/all-modules.json."
    }
    else {
        $allModules = Get-Content -Raw $allModulesPath | ConvertFrom-Json
        $moduleCategoryByName = @{}
        foreach ($moduleInfo in @($allModules.modules)) {
            $moduleCategoryByName[[string]$moduleInfo.module] = [string]$moduleInfo.category
        }
        $customModules = @($allModules.modules | Where-Object { $_.category -eq "Custom" } | ForEach-Object { $_.module } | Sort-Object -Unique)
        foreach ($moduleName in @($moduleCategoryByName.Keys | Sort-Object)) {
            $relativeModuleDir = Get-OverviewKbModuleRelativeDir -ModuleName $moduleName -ModuleCatalogByName $moduleCatalogByName
            $moduleDir = Join-Path $kbRoot $relativeModuleDir
            if (-not (Test-Path $moduleDir -PathType Container)) { continue }

            $domainJsonPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "domain-model.json" -ModuleCatalogByName $moduleCatalogByName
            if (Test-Path $domainJsonPath -PathType Leaf) {
                $domainJson = Get-Content -Raw $domainJsonPath | ConvertFrom-Json
                if (@($domainJson.domainModel.entities).Count -gt 0) {
                    Assert-SectionIsPopulated -FilePath (Join-Path $moduleDir "DOMAIN.md") -Heading "## Entity Index" -PlaceholderPatterns @(
                        "No entity index entries",
                        "No entity index documented yet"
                    )
                }
            }

            $flowsJsonPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "flows.json" -ModuleCatalogByName $moduleCatalogByName
            if (Test-Path $flowsJsonPath -PathType Leaf) {
                $flowsJson = Get-Content -Raw $flowsJsonPath | ConvertFrom-Json
                if (@($flowsJson.flows).Count -gt 0) {
                    Assert-SectionIsPopulated -FilePath (Join-Path $moduleDir "FLOWS.md") -Heading "## Flow Links" -PlaceholderPatterns @(
                        "\| none \| none \| 3 \| none \| none \| none \|"
                    )
                    Assert-Headings -File (Join-Path $moduleDir "flows/INDEX.abstract.md") -Headings @("# Flow Collection Abstract")
                }
            }

            $pagesJsonPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "pages.json" -ModuleCatalogByName $moduleCatalogByName
            if (Test-Path $pagesJsonPath -PathType Leaf) {
                $pagesJson = Get-Content -Raw $pagesJsonPath | ConvertFrom-Json
                if (@($pagesJson.pages).Count -gt 0) {
                    Assert-SectionIsPopulated -FilePath (Join-Path $moduleDir "PAGES.md") -Heading "## Page Links" -PlaceholderPatterns @(
                        "\| none \| none \| none \| none \| none \|"
                    )
                    Assert-Headings -File (Join-Path $moduleDir "pages/INDEX.abstract.md") -Headings @("# Page Collection Abstract")
                }
            }
        }

        $customEntities = @{}
        $customPages = @{}
        foreach ($module in $customModules) {
            $domainPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $module -FileName "domain-model.json" -ModuleCatalogByName $moduleCatalogByName
            if (Test-Path $domainPath -PathType Leaf) {
                $domain = Get-Content -Raw $domainPath | ConvertFrom-Json
                foreach ($entity in @($domain.domainModel.entities)) {
                    $customEntities[$entity.name] = $module
                }
            }

            $pagesPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $module -FileName "pages.json" -ModuleCatalogByName $moduleCatalogByName
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
            $flowsPath = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $module -FileName "flows.json" -ModuleCatalogByName $moduleCatalogByName
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
$reportPaths = Write-QualityReports `
    -KbRootPath $kbRoot `
    -ApplicationName $AppName `
    -IssueList $issues `
    -SemanticMetrics $semanticMetrics `
    -OverallPass $overallPass `
    -FilesChecked $allMd.Count `
    -GeneratedAtUtc $GeneratedAtUtc `
    -KbRootDisplay $KbRootDisplay
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
Write-Host "Detailed report (JSON): $($reportPaths.Json)"
Write-Host "Detailed report (MD):   $($reportPaths.Markdown)"

if ($issues.Count -gt 0) {
    if ($ShowAllIssues) {
        Write-Host ""
        Write-Host "QUALITY ISSUES:" -ForegroundColor Red
        foreach ($i in $issues) {
            Write-Host "[$($i.Severity)] $($i.File) :: $($i.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host ""
        Write-Host "Detailed issues were written to the report files above. Re-run with -ShowAllIssues to print them here." -ForegroundColor Yellow
    }
    exit 1
}
else {
    Write-Host ""
    Write-Host "Quality gate passed." -ForegroundColor Green
    exit 0
}
