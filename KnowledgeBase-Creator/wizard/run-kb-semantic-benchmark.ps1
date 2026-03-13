<#
.SYNOPSIS
    Run structural and optional app-specific semantic benchmark checks on a generated KB.

.DESCRIPTION
    Always runs an app-generic structural benchmark (10 scenarios, 100 points).
    Optionally runs app-specific scenarios from a JSON file using -CustomScenarios.
    Final pass requires structural pass and, when provided, app-specific pass.
#>

param(
    [string]$OutputRoot = "mendix-data/knowledge-base",
    [Parameter(Mandatory = $true)]
    [string]$AppName,
    [int]$MinStructuralScore = 80,
    [int]$MinCustomScore = 85,
    [double]$StructuralWeight = 0.7,
    [double]$CustomWeight = 0.3,
    [string]$CustomScenarios,
    [string]$GeneratedAtUtc,
    [string]$KbRootDisplay
)

$ErrorActionPreference = "Stop"

function Load-Json {
    param([string]$Path)
    if (-not (Test-Path $Path -PathType Leaf)) {
        throw "Missing JSON file: $Path"
    }
    return (Get-Content -Raw $Path | ConvertFrom-Json)
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

function Get-CrossModuleCallEdgeCount {
    param(
        [string]$RunFolder,
        [string[]]$ModuleNames
    )

    $edgeCount = 0
    $flowModuleMap = @{}

    foreach ($module in @($ModuleNames)) {
        $flowsPath = Join-Path $RunFolder "modules/$module/flows.json"
        if (-not (Test-Path $flowsPath -PathType Leaf)) { continue }
        $flows = Load-Json -Path $flowsPath
        foreach ($flow in @($flows.flows)) {
            $flowModuleMap[[string]$flow.qualifiedName] = $module
        }
    }

    foreach ($module in @($ModuleNames)) {
        $flowsPath = Join-Path $RunFolder "modules/$module/flows.json"
        if (-not (Test-Path $flowsPath -PathType Leaf)) { continue }
        $flows = Load-Json -Path $flowsPath
        foreach ($flow in @($flows.flows)) {
            foreach ($call in @($flow.calls)) {
                $target = [string]$call.targetFlowName
                if ([string]::IsNullOrWhiteSpace($target)) { continue }
                if (-not $flowModuleMap.ContainsKey($target)) { continue }
                if ($flowModuleMap[$target] -ne $module) {
                    $edgeCount++
                }
            }
        }
    }

    return $edgeCount
}

function Get-CustomPageEvidenceSet {
    param(
        [string]$RunFolder,
        [string[]]$CustomModules
    )

    $customPages = @{}
    foreach ($module in @($CustomModules)) {
        $pagesPath = Join-Path $RunFolder "modules/$module/pages.json"
        if (-not (Test-Path $pagesPath -PathType Leaf)) { continue }
        $pages = Load-Json -Path $pagesPath
        foreach ($page in @($pages.pages)) {
            $customPages[[string]$page.qualifiedName] = $true
        }
    }

    $expectedPagesWithEvidence = New-Object "System.Collections.Generic.HashSet[string]"
    foreach ($module in @($CustomModules)) {
        $flowsPath = Join-Path $RunFolder "modules/$module/flows.json"
        if (-not (Test-Path $flowsPath -PathType Leaf)) { continue }
        $flows = Load-Json -Path $flowsPath
        foreach ($flow in @($flows.flows)) {
            foreach ($node in @($flow.nodes)) {
                $text = (([string]$node.label) + " " + ([string]$node.detail))
                if ([string]::IsNullOrWhiteSpace($text)) { continue }
                foreach ($pm in [regex]::Matches($text, "show page\s+([A-Za-z0-9_]+\.[A-Za-z0-9_]+)", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
                    $pageName = $pm.Groups[1].Value
                    if ($customPages.ContainsKey($pageName)) {
                        [void]$expectedPagesWithEvidence.Add($pageName)
                    }
                }
            }
        }
    }

    return @($expectedPagesWithEvidence | Sort-Object)
}

function Evaluate-EvidenceItem {
    param(
        [string]$KbRoot,
        [object]$Item
    )

    $path = Join-Path $KbRoot ([string]$Item.file)
    if (-not (Test-Path $path -PathType Leaf)) {
        return [pscustomobject]@{
            File = [string]$Item.file
            Hit = $false
            Reason = "missing file"
        }
    }

    $text = Get-Content -Raw $path
    foreach ($pattern in @($Item.patterns)) {
        $patternText = [string]$pattern
        if ([string]::IsNullOrWhiteSpace($patternText)) { continue }
        if ($text -notmatch [regex]::Escape($patternText)) {
            return [pscustomobject]@{
                File = [string]$Item.file
                Hit = $false
                Reason = "pattern missing: $patternText"
            }
        }
    }

    return [pscustomobject]@{
        File = [string]$Item.file
        Hit = $true
        Reason = "ok"
    }
}

function New-BenchmarkResult {
    param(
        [string]$Id,
        [string]$Question,
        [bool]$Critical,
        [double]$Weight,
        [string]$Status,
        [int]$EvidenceHits,
        [int]$EvidenceTotal,
        [double]$Score,
        [string]$Details
    )

    return [pscustomobject]@{
        Id = $Id
        Question = $Question
        Critical = $Critical
        Weight = $Weight
        Status = $Status
        EvidenceHits = $EvidenceHits
        EvidenceTotal = $EvidenceTotal
        Score = [math]::Round($Score, 2)
        Details = $Details
    }
}

function Get-BenchmarkSummary {
    param(
        [object[]]$Results,
        [int]$MinScore
    )

    $applicable = @($Results | Where-Object { $_.Status -ne "N/A" })
    $maxScore = [double](@($applicable | Measure-Object -Property Weight -Sum).Sum)
    if ($maxScore -le 0) { $maxScore = 0.0 }
    $achieved = [double](@($applicable | Measure-Object -Property Score -Sum).Sum)
    $normalised = if ($maxScore -eq 0) { 100.0 } else { [math]::Round(($achieved / $maxScore) * 100.0, 2) }
    $criticalFailures = @(
        $applicable |
        Where-Object { $_.Critical -and $_.Status -eq "FAIL" } |
        Select-Object -ExpandProperty Id
    )

    return [pscustomobject]@{
        Score = $normalised
        MinScore = $MinScore
        MaxScore = $maxScore
        Achieved = $achieved
        ApplicableCount = $applicable.Count
        CriticalFailures = $criticalFailures
        Passed = ($normalised -ge $MinScore -and $criticalFailures.Count -eq 0)
    }
}

$kbRoot = $OutputRoot
if (-not (Test-Path $kbRoot -PathType Container)) {
    Write-Error "KB root does not exist: $kbRoot"
    exit 1
}
$generatedAtReport = if ([string]::IsNullOrWhiteSpace($GeneratedAtUtc)) {
    (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
} else {
    $GeneratedAtUtc
}
$kbRootReport = if ([string]::IsNullOrWhiteSpace($KbRootDisplay)) { $kbRoot } else { $KbRootDisplay }

$readerFile = Join-Path $kbRoot "READER.md"
$routingFile = Join-Path $kbRoot "ROUTING.md"
$securityFile = Join-Path $kbRoot "app/SECURITY.md"
$crossModuleFile = Join-Path $kbRoot "routes/cross-module.md"
$byPageFile = Join-Path $kbRoot "routes/by-page.md"
$byFlowFile = Join-Path $kbRoot "routes/by-flow.md"
$byEntityFile = Join-Path $kbRoot "routes/by-entity.md"
$sourcesManifestFile = Join-Path $kbRoot "_sources/manifest.json"
$sourcesRefFile = Join-Path $kbRoot "_sources/SOURCE_REF.md"
$unknownTodoFile = Join-Path $kbRoot "_reports/UNKNOWN_TODO.md"

$runFolder = Resolve-RunFolderFromSources -KbRootPath $kbRoot
$customModules = @()
$moduleNames = @()
if ($runFolder) {
    $allModulesPath = Join-Path $runFolder "general/all-modules.json"
    if (Test-Path $allModulesPath -PathType Leaf) {
        $allModules = Load-Json -Path $allModulesPath
        $customModules = @($allModules.modules | Where-Object { $_.category -eq "Custom" } | ForEach-Object { [string]$_.module } | Sort-Object -Unique)
        $moduleNames = @($allModules.modules | ForEach-Object { [string]$_.module } | Sort-Object -Unique)
    }
}

$structuralResults = New-Object "System.Collections.Generic.List[object]"

# S1
$s1Hit = $false
$s1Details = "No custom module with Tier 1 deep narrative detected."
foreach ($module in @($customModules)) {
    $flowsDoc = Join-Path $kbRoot "modules/$module/FLOWS.md"
    if (-not (Test-Path $flowsDoc -PathType Leaf)) { continue }
    $text = Get-Content -Raw $flowsDoc
    if ($text -match "## Tier 1 Deep Narratives" -and $text -notmatch "No Tier 1 narrative required for this module category\." -and $text -match "###\s+[A-Za-z0-9_]+\.[A-Za-z0-9_]") {
        $s1Hit = $true
        $s1Details = "Tier 1 narrative found in module $module."
        break
    }
}
if ($customModules.Count -eq 0) {
    $structuralResults.Add((New-BenchmarkResult -Id "S1" -Question "At least one custom flow has a Tier 1 deep narrative." -Critical $true -Weight 10 -Status "N/A" -EvidenceHits 0 -EvidenceTotal 0 -Score 0 -Details "No custom modules detected.")) | Out-Null
} else {
    $structuralResults.Add((New-BenchmarkResult -Id "S1" -Question "At least one custom flow has a Tier 1 deep narrative." -Critical $true -Weight 10 -Status $(if ($s1Hit) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($s1Hit) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($s1Hit) { 10 } else { 0 }) -Details $s1Details)) | Out-Null
}

# S2
if ($customModules.Count -eq 0) {
    $structuralResults.Add((New-BenchmarkResult -Id "S2" -Question "Entity lifecycle matrix exists and is non-empty for every custom module." -Critical $true -Weight 10 -Status "N/A" -EvidenceHits 0 -EvidenceTotal 0 -Score 0 -Details "No custom modules detected.")) | Out-Null
} else {
    $hits = 0
    foreach ($module in @($customModules)) {
        $domainDoc = Join-Path $kbRoot "modules/$module/DOMAIN.md"
        if (-not (Test-Path $domainDoc -PathType Leaf)) { continue }
        $text = Get-Content -Raw $domainDoc
        $hasEntityLifecycleHeading = $text -match "## Entity Lifecycle Matrix"
        $hasMeaningfulRow = $false
        if ($hasEntityLifecycleHeading) {
            $hasMeaningfulRow = (
                $text -match "\| [A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]* \| (?!none\b|Unknown\b).+\|"
            )
        }
        if ($hasEntityLifecycleHeading -and $hasMeaningfulRow) { $hits++ }
    }
    $ratio = if ($customModules.Count -eq 0) { 1.0 } else { [double]$hits / [double]$customModules.Count }
    $structuralResults.Add((New-BenchmarkResult -Id "S2" -Question "Entity lifecycle matrix exists and is non-empty for every custom module." -Critical $true -Weight 10 -Status $(if ($ratio -eq 1.0) { "PASS" } else { "FAIL" }) -EvidenceHits $hits -EvidenceTotal $customModules.Count -Score (10 * $ratio) -Details "$hits/$($customModules.Count) custom modules contain non-empty lifecycle evidence.")) | Out-Null
}

# S3
$callEdgeCount = 0
if ($runFolder -and $moduleNames.Count -gt 0) {
    $callEdgeCount = Get-CrossModuleCallEdgeCount -RunFolder $runFolder -ModuleNames $moduleNames
}
if ($callEdgeCount -eq 0) {
    $structuralResults.Add((New-BenchmarkResult -Id "S3" -Question "Cross-module dependency table has non-zero rows when callEdges exist." -Critical $true -Weight 10 -Status "N/A" -EvidenceHits 0 -EvidenceTotal 0 -Score 0 -Details "No cross-module call edges in source evidence.")) | Out-Null
} else {
    $hasRows = $false
    if (Test-Path $crossModuleFile -PathType Leaf) {
        $crossText = Get-Content -Raw $crossModuleFile
        $hasRows = (
            $crossText -match "## Dependency matrix" -and
            $crossText -match "\| [A-Za-z_][A-Za-z0-9_]* \| [A-Za-z_][A-Za-z0-9_]* \| [1-9][0-9]* \|"
        )
    }
    $structuralResults.Add((New-BenchmarkResult -Id "S3" -Question "Cross-module dependency table has non-zero rows when callEdges exist." -Critical $true -Weight 10 -Status $(if ($hasRows) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($hasRows) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($hasRows) { 10 } else { 0 }) -Details "Source cross-module edges=$callEdgeCount; index has rows=$hasRows.")) | Out-Null
}

# S4
$expectedPages = @()
if ($runFolder -and $customModules.Count -gt 0) {
    $expectedPages = Get-CustomPageEvidenceSet -RunFolder $runFolder -CustomModules $customModules
}
if ($expectedPages.Count -eq 0) {
    $structuralResults.Add((New-BenchmarkResult -Id "S4" -Question "Page-flow linkage rows are non-Unknown where show-page evidence exists." -Critical $false -Weight 10 -Status "N/A" -EvidenceHits 0 -EvidenceTotal 0 -Score 0 -Details "No show-page evidence found for custom modules.")) | Out-Null
} else {
    $byPageRows = Get-MarkdownTableRows -FilePath $byPageFile
    $byPageMap = @{}
    foreach ($row in @($byPageRows)) {
        if ($row.PSObject.Properties.Name.Contains("Page")) {
            $byPageMap[[string]$row.'Page'] = [string]$row.'Shown by flows'
        }
    }
    $hits = 0
    foreach ($page in @($expectedPages)) {
        if ($byPageMap.ContainsKey($page) -and (Is-MeaningfulCellValue -Value $byPageMap[$page])) { $hits++ }
    }
    $ratio = [double]$hits / [double]$expectedPages.Count
    $structuralResults.Add((New-BenchmarkResult -Id "S4" -Question "Page-flow linkage rows are non-Unknown where show-page evidence exists." -Critical $false -Weight 10 -Status $(if ($ratio -eq 1.0) { "PASS" } else { "FAIL" }) -EvidenceHits $hits -EvidenceTotal $expectedPages.Count -Score (10 * $ratio) -Details "$hits/$($expectedPages.Count) pages linked with non-Unknown flows.")) | Out-Null
}

# S5
$securityRows = Get-MarkdownTableRows -FilePath $securityFile
$securityPopulated = $false
foreach ($row in @($securityRows)) {
    if (-not $row.PSObject.Properties.Name.Contains("Project role")) { continue }
    if (Is-MeaningfulCellValue -Value ([string]$row.'Project role')) {
        $securityPopulated = $true
        break
    }
}
$structuralResults.Add((New-BenchmarkResult -Id "S5" -Question "Security role-to-module-role matrix is populated." -Critical $false -Weight 10 -Status $(if ($securityPopulated) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($securityPopulated) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($securityPopulated) { 10 } else { 0 }) -Details "Role matrix populated=$securityPopulated.")) | Out-Null

# S6
$routingHasKnownGaps = $false
$routingHonest = $false
$unknownTodoCount = 0
if (Test-Path $unknownTodoFile -PathType Leaf) {
    $unknownTodoText = Get-Content -Raw $unknownTodoFile
    $countMatch = [regex]::Match($unknownTodoText, "Total unknown items:\s*(\d+)")
    if ($countMatch.Success) {
        $unknownTodoCount = [int]$countMatch.Groups[1].Value
    }
}
if (Test-Path $routingFile -PathType Leaf) {
    $routingText = Get-Content -Raw $routingFile
    $lineMatch = [regex]::Match($routingText, "- Known gaps:\s*(.+)")
    if ($lineMatch.Success) {
        $routingHasKnownGaps = $true
        $knownGapsValue = $lineMatch.Groups[1].Value.Trim()
        if ($unknownTodoCount -gt 0) {
            $routingHonest = $knownGapsValue -notmatch "^(none|None)\b"
        } else {
            $routingHonest = $true
        }
    }
}
$s6Pass = $routingHasKnownGaps -and $routingHonest
$structuralResults.Add((New-BenchmarkResult -Id "S6" -Question "ROUTING.md known-gaps section exists and is honest." -Critical $false -Weight 10 -Status $(if ($s6Pass) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($s6Pass) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($s6Pass) { 10 } else { 0 }) -Details "HasKnownGaps=$routingHasKnownGaps; UnknownTodoCount=$unknownTodoCount; Honest=$routingHonest.")) | Out-Null

# S7
$readerHasLegend = $false
if (Test-Path $readerFile -PathType Leaf) {
    $readerText = Get-Content -Raw $readerFile
    if ($readerText -match "Export-backed" -and $readerText -match "Inferred" -and $readerText -match "Unknown") {
        $readerHasLegend = $true
    }
}
$structuralResults.Add((New-BenchmarkResult -Id "S7" -Question "READER.md confidence legend is present." -Critical $false -Weight 10 -Status $(if ($readerHasLegend) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($readerHasLegend) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($readerHasLegend) { 10 } else { 0 }) -Details "Confidence legend present=$readerHasLegend.")) | Out-Null

# S8
$routeHasCrossRefs = $false
$entityRows = Get-MarkdownTableRows -FilePath $byEntityFile
foreach ($row in @($entityRows)) {
    $cells = @(
        [string]$row.'Create flows',
        [string]$row.'Update flows',
        [string]$row.'Delete flows',
        [string]$row.'Read flows',
        [string]$row.'Shown on pages'
    )
    $hasMeaningfulCell = $false
    foreach ($cell in @($cells)) {
        if (Is-MeaningfulCellValue -Value ([string]$cell)) {
            $hasMeaningfulCell = $true
            break
        }
    }
    if ($hasMeaningfulCell) {
        $routeHasCrossRefs = $true
        break
    }
}
if (-not $routeHasCrossRefs) {
    $pageRows = Get-MarkdownTableRows -FilePath $byPageFile
    foreach ($row in @($pageRows)) {
        if (Is-MeaningfulCellValue -Value ([string]$row.'Shown by flows')) {
            $routeHasCrossRefs = $true
            break
        }
    }
}
if (-not $routeHasCrossRefs) {
    $flowRows = Get-MarkdownTableRows -FilePath $byFlowFile
    foreach ($row in @($flowRows)) {
        if (
            (Is-MeaningfulCellValue -Value ([string]$row.'Shows Pages')) -or
            (Is-MeaningfulCellValue -Value ([string]$row.'Touches Entities'))
        ) {
            $routeHasCrossRefs = $true
            break
        }
    }
}
$structuralResults.Add((New-BenchmarkResult -Id "S8" -Question "At least one route index has non-Unknown cross-references." -Critical $false -Weight 10 -Status $(if ($routeHasCrossRefs) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($routeHasCrossRefs) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($routeHasCrossRefs) { 10 } else { 0 }) -Details "Route cross-reference evidence present=$routeHasCrossRefs.")) | Out-Null

# S9
$hubLeafOk = $false
if (Test-Path $crossModuleFile -PathType Leaf) {
    $text = Get-Content -Raw $crossModuleFile
    $rows = Get-MarkdownTableRows -FilePath $crossModuleFile
    $hasHeading = $text -match "## Hub/leaf module classification"
    $hasClassificationRow = $false
    foreach ($row in @($rows)) {
        if (-not $row.PSObject.Properties.Name.Contains("Classification")) { continue }
        if (Is-MeaningfulCellValue -Value ([string]$row.'Classification')) {
            $hasClassificationRow = $true
            break
        }
    }
    $hubLeafOk = $hasHeading -and $hasClassificationRow
}
$structuralResults.Add((New-BenchmarkResult -Id "S9" -Question "Hub/leaf classification exists in cross-module.md." -Critical $false -Weight 10 -Status $(if ($hubLeafOk) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($hubLeafOk) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($hubLeafOk) { 10 } else { 0 }) -Details "Hub/leaf section present=$hubLeafOk.")) | Out-Null

# S10
$sourceMetaOk = $false
if ((Test-Path $sourcesManifestFile -PathType Leaf) -and (Test-Path $sourcesRefFile -PathType Leaf)) {
    $manifestLength = (Get-Item $sourcesManifestFile).Length
    $refLength = (Get-Item $sourcesRefFile).Length
    $sourceMetaOk = ($manifestLength -gt 0 -and $refLength -gt 0)
}
$structuralResults.Add((New-BenchmarkResult -Id "S10" -Question "Source metadata files are present and non-empty." -Critical $false -Weight 10 -Status $(if ($sourceMetaOk) { "PASS" } else { "FAIL" }) -EvidenceHits $(if ($sourceMetaOk) { 1 } else { 0 }) -EvidenceTotal 1 -Score $(if ($sourceMetaOk) { 10 } else { 0 }) -Details "Manifest+source-ref populated=$sourceMetaOk.")) | Out-Null

$structuralSummary = Get-BenchmarkSummary -Results $structuralResults.ToArray() -MinScore $MinStructuralScore

# Optional custom benchmark
$customResults = New-Object "System.Collections.Generic.List[object]"
$customSummary = $null
$customRan = $false

if (-not [string]::IsNullOrWhiteSpace($CustomScenarios)) {
    if (-not (Test-Path $CustomScenarios -PathType Leaf)) {
        throw "Custom scenarios file not found: $CustomScenarios"
    }

    $customConfig = Load-Json -Path $CustomScenarios
    foreach ($scenario in @($customConfig.scenarios)) {
        $customRan = $true
        $id = [string]$scenario.id
        $question = [string]$scenario.question
        if ([string]::IsNullOrWhiteSpace($id)) { $id = "CUSTOM" }
        if ([string]::IsNullOrWhiteSpace($question)) { $question = "Custom scenario $id" }
        $weight = if ($scenario.weight) { [double]$scenario.weight } else { 10.0 }
        $critical = [bool]$scenario.critical

        $status = "PASS"
        $details = ""
        $score = 0.0
        $hitCount = 0
        $evidenceCount = 0

        $naFileMissing = $false
        foreach ($naFile in @($scenario.naIfMissingFiles)) {
            $naPath = Join-Path $kbRoot ([string]$naFile)
            if (-not (Test-Path $naPath -PathType Leaf)) {
                $naFileMissing = $true
                break
            }
        }

        if ($naFileMissing) {
            $status = "N/A"
            $details = "Scenario marked N/A because required optional files are missing."
        } else {
            $evidenceResults = @()
            foreach ($item in @($scenario.evidence)) {
                $evidenceResults += (Evaluate-EvidenceItem -KbRoot $kbRoot -Item $item)
            }
            $evidenceCount = @($evidenceResults).Count
            $hitCount = @($evidenceResults | Where-Object { $_.Hit }).Count
            $ratio = if ($evidenceCount -eq 0) { 0.0 } else { [double]$hitCount / [double]$evidenceCount }
            $score = [math]::Round($weight * $ratio, 2)
            if ($hitCount -ne $evidenceCount) { $status = "FAIL" }
            $details = ($evidenceResults | ForEach-Object { "$($_.File): $($_.Reason)" }) -join " ; "
        }

        $customResults.Add((New-BenchmarkResult -Id $id -Question $question -Critical $critical -Weight $weight -Status $status -EvidenceHits $hitCount -EvidenceTotal $evidenceCount -Score $score -Details $details)) | Out-Null
    }
}

if ($customRan) {
    $customSummary = Get-BenchmarkSummary -Results $customResults.ToArray() -MinScore $MinCustomScore
}

$effectiveStructuralWeight = [math]::Max(0.0, [double]$StructuralWeight)
$effectiveCustomWeight = [math]::Max(0.0, [double]$CustomWeight)
if ($effectiveStructuralWeight -eq 0.0 -and $effectiveCustomWeight -eq 0.0) {
    $effectiveStructuralWeight = 1.0
}

$finalScore = $structuralSummary.Score
if ($customRan) {
    $weightSum = $effectiveStructuralWeight + $effectiveCustomWeight
    if ($weightSum -le 0.0) { $weightSum = 1.0 }
    $finalScore = [math]::Round((($structuralSummary.Score * $effectiveStructuralWeight) + ($customSummary.Score * $effectiveCustomWeight)) / $weightSum, 2)
}

$overallPassed = $structuralSummary.Passed
if ($customRan) {
    $overallPassed = $overallPassed -and $customSummary.Passed
}

$reportDir = Join-Path $kbRoot "_reports"
if (-not (Test-Path $reportDir -PathType Container)) {
    New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
}
$reportPath = Join-Path $reportDir "semantic-benchmark.md"

$structRows = New-Object System.Collections.Generic.List[string]
foreach ($r in $structuralResults.ToArray()) {
    $structRows.Add("| $($r.Id) | $($r.Critical) | $($r.Status) | $($r.EvidenceHits)/$($r.EvidenceTotal) | $($r.Score)/$($r.Weight) |") | Out-Null
}

$structDetailRows = New-Object System.Collections.Generic.List[string]
foreach ($r in $structuralResults.ToArray()) {
    $structDetailRows.Add("| $($r.Id) | $($r.Question) | $($r.Details) |") | Out-Null
}

$customSection = "Not run (no -CustomScenarios provided)."
$customRowsText = ""
$customDetailsText = ""
$customSummaryText = "- Custom benchmark: skipped"
if ($customRan) {
    $customRows = New-Object System.Collections.Generic.List[string]
    foreach ($r in $customResults.ToArray()) {
        $customRows.Add("| $($r.Id) | $($r.Critical) | $($r.Status) | $($r.EvidenceHits)/$($r.EvidenceTotal) | $($r.Score)/$($r.Weight) |") | Out-Null
    }
    $customRowsText = @"
| Check | Critical | Status | Evidence hits | Score |
|---|---|---|---|---|
$($customRows -join "`n")
"@

    $customDetailRows = New-Object System.Collections.Generic.List[string]
    foreach ($r in $customResults.ToArray()) {
        $customDetailRows.Add("| $($r.Id) | $($r.Question) | $($r.Details) |") | Out-Null
    }
    $customDetailsText = @"
| Check | Question | Evidence evaluation |
|---|---|---|
$($customDetailRows -join "`n")
"@
    $customSection = "Executed from: $CustomScenarios"
    $customSummaryText = "- Custom score: $($customSummary.Score) / 100 (min $MinCustomScore), critical failures: $($customSummary.CriticalFailures.Count), passed: $($customSummary.Passed)"
}

$report = @"
# Semantic Benchmark Report

## Summary

- App: $AppName
- KB Root: $kbRootReport
- Generated at: $generatedAtReport
- Structural score: $($structuralSummary.Score) / 100 (min $MinStructuralScore), critical failures: $($structuralSummary.CriticalFailures.Count), passed: $($structuralSummary.Passed)
$customSummaryText
- Final weighted score: $finalScore / 100
- Weights: structural=$effectiveStructuralWeight, custom=$effectiveCustomWeight
- Final verdict: $overallPassed

## Structural Benchmark

| Check | Critical | Status | Evidence hits | Score |
|---|---|---|---|---|
$($structRows -join "`n")

### Structural Evidence Details

| Check | Question | Evidence evaluation |
|---|---|---|
$($structDetailRows -join "`n")

## App-Specific Benchmark

$customSection

$customRowsText

### App-Specific Evidence Details

$customDetailsText
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($reportPath, $report.TrimEnd() + "`n", $utf8NoBom)

Write-Host ""
Write-Host "=== Semantic Benchmark: $AppName ==="
Write-Host "Structural score: $($structuralSummary.Score) / 100 (min $MinStructuralScore)"
Write-Host "Structural critical failures: $($structuralSummary.CriticalFailures.Count)"
if ($customRan) {
    Write-Host "Custom score: $($customSummary.Score) / 100 (min $MinCustomScore)"
    Write-Host "Custom critical failures: $($customSummary.CriticalFailures.Count)"
} else {
    Write-Host "Custom benchmark: skipped"
}
Write-Host "Final weighted score: $finalScore / 100"
Write-Host "Report: $reportPath"

if (-not $overallPassed) {
    if ($structuralSummary.CriticalFailures.Count -gt 0) {
        Write-Host "Structural critical failures: $($structuralSummary.CriticalFailures -join ', ')" -ForegroundColor Red
    }
    if ($customRan -and $customSummary.CriticalFailures.Count -gt 0) {
        Write-Host "Custom critical failures: $($customSummary.CriticalFailures -join ', ')" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Semantic benchmark passed." -ForegroundColor Green
exit 0
