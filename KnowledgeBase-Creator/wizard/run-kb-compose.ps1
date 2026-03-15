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
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptRoot "lib/app-overview-resolver.ps1")

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
    $single = (Sanitize-MarkdownText -Content $Value -PreserveNewLines:$false -Replacement " " -PreserveTabs:$false -TrimResult:$true)
    return ($single -replace "\|", "\|")
}

function Sanitize-MarkdownText {
    param(
        [AllowNull()]
        [string]$Content,
        [bool]$PreserveNewLines = $true,
        [bool]$PreserveTabs = $true,
        [string]$Replacement = "",
        [bool]$TrimResult = $false
    )

    if ($null -eq $Content) { return "" }

    $pattern = if ($PreserveNewLines -and $PreserveTabs) {
        "[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]"
    } elseif ($PreserveNewLines) {
        "[\x00-\x09\x0B\x0C\x0E-\x1F\x7F]"
    } elseif ($PreserveTabs) {
        "[\x00-\x08\x0A-\x1F\x7F]"
    } else {
        "[\x00-\x1F\x7F]"
    }

    $sanitised = [regex]::Replace([string]$Content, $pattern, $Replacement)
    if ($TrimResult) {
        return $sanitised.Trim()
    }
    return $sanitised
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
    $sanitisedContent = Sanitize-MarkdownText -Content $Content -PreserveNewLines $true -PreserveTabs $true
    [System.IO.File]::WriteAllText($Path, $sanitisedContent.TrimEnd() + "`n", $utf8NoBom)
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

function Get-MarkdownAnchorId {
    param(
        [string]$Prefix,
        [string]$Value
    )

    $slug = ([string]$Value).ToLowerInvariant() -replace "[^a-z0-9]+", "-"
    $slug = $slug.Trim("-")
    if ([string]::IsNullOrWhiteSpace($slug)) {
        $slug = "item"
    }
    return "$Prefix-$slug"
}

function Get-RelativeMarkdownPath {
    param(
        [string]$FromFilePath,
        [string]$ToPath
    )

    if ([string]::IsNullOrWhiteSpace($FromFilePath) -or [string]::IsNullOrWhiteSpace($ToPath)) {
        return $null
    }

    $fromDir = [System.IO.Path]::GetFullPath((Split-Path -Parent $FromFilePath))
    $targetFull = if ([System.IO.Path]::IsPathRooted($ToPath)) {
        [System.IO.Path]::GetFullPath($ToPath)
    } else {
        [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $ToPath))
    }

    $fromDirWithSeparator = $fromDir.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    $fromUri = [System.Uri]::new($fromDirWithSeparator)
    $targetUri = [System.Uri]::new($targetFull)
    return $fromUri.MakeRelativeUri($targetUri).ToString()
}

function New-MarkdownLink {
    param(
        [string]$Label,
        [string]$TargetPath
    )

    if ([string]::IsNullOrWhiteSpace($TargetPath)) { return "none" }
    $safeLabel = Escape-Md $Label
    $safeTarget = Sanitize-MarkdownText -Content $TargetPath -PreserveNewLines:$false -PreserveTabs:$false -TrimResult:$true
    return "[$safeLabel]($safeTarget)"
}

function New-InlineCode {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return "none" }
    $tick = [string][char]0x60
    $safeText = Sanitize-MarkdownText -Content $Text -PreserveNewLines:$false -PreserveTabs:$false -TrimResult:$true
    return "$tick$safeText$tick"
}

function Join-NaturalList {
    param(
        [object[]]$Items,
        [string]$Default = "none"
    )

    $clean = @($Items | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | ForEach-Object { [string]$_ } | Sort-Object -Unique)
    if ($clean.Count -eq 0) { return $Default }
    if ($clean.Count -eq 1) { return $clean[0] }
    if ($clean.Count -eq 2) { return "$($clean[0]) and $($clean[1])" }
    return ("{0}, and {1}" -f (($clean[0..($clean.Count - 2)] -join ", ")), $clean[$clean.Count - 1])
}

function Convert-IdentifierToReadablePhrase {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return "" }

    $text = [string]$Value
    if ($text.Contains(".")) {
        $text = $text.Split(".")[-1]
    }
    $text = $text -replace '^(ACT|VAL|DS|SUB|NAN|REST|API|SCH|EVT|BTN|WF|MF|NF)[_-]+', ''
    $text = $text -replace 'NewEdit', 'New/Edit'
    $text = $text -creplace '([a-z0-9])([A-Z])', '$1 $2'
    $text = $text -replace '[_\.-]+', ' '
    $text = $text -replace '\s+', ' '
    $text = $text.Trim().ToLowerInvariant()
    return $text
}

function Get-ReadableExamples {
    param(
        [object[]]$Values,
        [int]$MaxItems = 3
    )

    $examples = New-Object System.Collections.Generic.List[string]
    foreach ($value in @($Values)) {
        $phrase = Convert-IdentifierToReadablePhrase -Value ([string]$value)
        if ([string]::IsNullOrWhiteSpace($phrase)) { continue }
        if ($examples.Contains($phrase)) { continue }
        $examples.Add($phrase) | Out-Null
        if ($examples.Count -ge $MaxItems) { break }
    }
    return $examples.ToArray()
}

function Get-ModulePurposeFallback {
    param(
        [string]$Category,
        [object[]]$Entities,
        [object[]]$Pages,
        [object[]]$Flows,
        [object]$Resources
    )

    $segments = New-Object System.Collections.Generic.List[string]
    $entityExamples = @(Get-ReadableExamples -Values @($Entities | ForEach-Object { [string]$_.name }) -MaxItems 3)
    $pageExamples = @(Get-ReadableExamples -Values @($Pages | ForEach-Object {
        if (-not [string]::IsNullOrWhiteSpace([string]$_.title)) { [string]$_.title } else { [string]$_.name }
    }) -MaxItems 2)
    $flowExamples = @(Get-ReadableExamples -Values @($Flows | ForEach-Object { [string]$_.localName }) -MaxItems 3)

    if ($entityExamples.Count -gt 0) {
        $segments.Add("data such as $(Join-NaturalList -Items $entityExamples)") | Out-Null
    }
    if ($pageExamples.Count -gt 0) {
        $segments.Add("pages such as $(Join-NaturalList -Items $pageExamples)") | Out-Null
    }
    if ($flowExamples.Count -gt 0) {
        $segments.Add("flows such as $(Join-NaturalList -Items $flowExamples)") | Out-Null
    }

    $hasResourceSignal = (
        $null -ne $Resources -and (
            @($Resources.constants).Count -gt 0 -or
            @($Resources.scheduledEvents).Count -gt 0 -or
            @($Resources.otherResources).Count -gt 0
        )
    )
    if ($hasResourceSignal) {
        $segments.Add("supporting configuration and runtime resources") | Out-Null
    }

    $lead = switch ($Category) {
        "Custom" { "This module appears to manage " }
        "Marketplace" { "This module appears to provide supporting capability for " }
        "System" { "This module appears to provide platform-level support for " }
        default { "This module appears to cover " }
    }

    if ($segments.Count -eq 0) {
        return "$lead its exported module structure and inventory."
    }

    return "$lead$(Join-NaturalList -Items $segments) based on its exported entities, pages, flows, and resources."
}

function Test-PageEditStyle {
    param([object]$Page)

    $text = @(
        [string]$Page.name
        [string]$Page.title
        [string]$Page.qualifiedName
    ) -join " "
    return ($text -match '(?i)(newedit|new/edit|\bnew\b|\bedit\b|\bcreate\b|\bupdate\b|\bdetail\b|\bmanage\b)')
}

function Get-PageOverviewSummary {
    param(
        [object]$Page,
        [object[]]$ShownByFlows
    )

    $base = if (-not [string]::IsNullOrWhiteSpace([string]$Page.title)) {
        [string]$Page.title
    } elseif (-not [string]::IsNullOrWhiteSpace([string]$Page.name)) {
        [string]$Page.name
    } else {
        "Deterministic page overview derived from exported page structure."
    }

    $paramSummary = @(Get-ReadableExamples -Values @($Page.parameters | ForEach-Object { [string]$_.entityType }) -MaxItems 2)
    if (@($Page.parameters).Count -gt 0 -and (Test-PageEditStyle -Page $Page)) {
        $entityHint = if ($paramSummary.Count -gt 0) { " for $(Join-NaturalList -Items $paramSummary)" } else { "" }
        return "$base. Likely supports create/edit interactions$entityHint because it accepts page parameters."
    }

    if (@($Page.parameters).Count -gt 0) {
        return "$base. Likely renders or updates context passed in through page parameters."
    }

    if ($Page.isPopup) {
        return "$base. Opens as a popup and likely supports a focused task or confirmation step."
    }

    $pageShapeText = @(
        [string]$Page.name
        [string]$Page.title
        [string]$Page.qualifiedName
    ) -join " "
    if ($pageShapeText -match '(?i)(homepage|home|dashboard|landing)') {
        return "$base. Likely serves as a landing or home page for one or more user roles."
    }

    if ($pageShapeText -match '(?i)(masteroverview|overview|list|browse)') {
        return "$base. Likely serves as an overview or browse page for reviewing records and starting related tasks."
    }

    if (@($ShownByFlows).Count -gt 0) {
        return "$base. Likely acts as a user-facing destination reached directly from exported flows."
    }

    return "$base. Use route indexes and L2 JSON if exact entry behaviour matters."
}

function Get-FlowOverviewSummary {
    param([object]$Flow)

    if (@($Flow.shownPages).Count -gt 0) {
        return "Likely acts as a UI entry or navigation handler because it shows $(Join-OrDefault -Items $Flow.shownPages -Default 'none')."
    }

    if (@($Flow.mutationActions).Count -gt 0 -or $Flow.writesPersistent) {
        $entityHint = if (@($Flow.touchesEntities).Count -gt 0) {
            " for $(Join-OrDefault -Items $Flow.touchesEntities -Default 'none')"
        } else {
            ""
        }
        return "Likely acts as a save, process, or background step$entityHint because it mutates data without showing a page."
    }

    if (@($Flow.callsOut).Count -gt 0) {
        return "Likely orchestrates downstream flow calls without direct UI output."
    }

    if ($Flow.localName.StartsWith('DS_', [System.StringComparison]::OrdinalIgnoreCase)) {
        return "Likely supplies data to callers or pages rather than driving user navigation directly."
    }

    if (@($Flow.calledBy).Count -gt 0) {
        return "Likely serves as a helper flow invoked from $(Join-OrDefault -Items $Flow.calledBy -Default 'other flows')."
    }

    if ($Flow.localName.StartsWith('VAL_', [System.StringComparison]::OrdinalIgnoreCase)) {
        return "Likely performs validation or guard checks before allowing later user or data actions."
    }

    return "Deterministic overview derived from exported flow structure."
}

function Get-FlowEntryContextText {
    param([object]$Flow)

    if (@($Flow.calledBy).Count -gt 0) {
        return "Called by $(Join-OrDefault -Items $Flow.calledBy -Default 'none')."
    }

    if (@($Flow.shownPages).Count -gt 0 -or $Flow.localName.StartsWith('ACT_', [System.StringComparison]::OrdinalIgnoreCase)) {
        return "No inbound caller was exported; this likely starts from UI interaction or navigation."
    }

    return "No inbound caller was exported; the entry point may be navigation, background execution, or an export gap."
}

function Get-FlowOutputContextText {
    param([object]$Flow)

    if (@($Flow.shownPages).Count -gt 0) {
        return "Shows $(Join-OrDefault -Items $Flow.shownPages -Default 'none')."
    }

    if (@($Flow.mutationActions).Count -gt 0 -or $Flow.writesPersistent) {
        return "No page output was exported; this likely completes a save, process, or background step."
    }

    if (@($Flow.callsOut).Count -gt 0) {
        return "No page output was exported; this likely delegates work to downstream flows."
    }

    return "No page output was exported; check L2 JSON if the exact user-facing effect matters."
}

function Get-FlowEntitiesTouchedLines {
    param([object]$Flow)

    if (@($Flow.touchesEntities).Count -gt 0) {
        return @("- $(Join-OrDefault -Items $Flow.touchesEntities -Default 'none')")
    }

    if ($Flow.hasBehaviouralAction) {
        return @("- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.")
    }

    return @("- No entity evidence was exported for this flow.")
}

function Get-FlowShownPagesLines {
    param([object]$Flow)

    if (@($Flow.shownPages).Count -gt 0) {
        return @("- $(Join-OrDefault -Items $Flow.shownPages -Default 'none')")
    }

    if (@($Flow.mutationActions).Count -gt 0 -or $Flow.writesPersistent) {
        return @("- No ShowPageAction was exported for this flow; it likely completes work without returning a page.")
    }

    return @("- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.")
}

function Get-FlowActionOverviewLines {
    param([object]$Flow)

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($block in @(
        @(Format-FlowActionEvidence -Actions $Flow.retrieveActions -Kind 'retrieve'),
        @(Format-FlowActionEvidence -Actions $Flow.decisionActions -Kind 'decision'),
        @(Format-FlowActionEvidence -Actions $Flow.mutationActions -Kind 'mutation')
    )) {
        foreach ($line in @($block)) {
            if ([string]$line -eq "- none") { continue }
            $lines.Add([string]$line) | Out-Null
        }
    }

    if ($lines.Count -gt 0) {
        return $lines.ToArray()
    }

    if ($Flow.nodeCount -gt 0) {
        return @("- No retrieve, decision, or mutation metadata was exported for this flow; inspect L2 JSON if node-level evidence matters.")
    }

    return @("- No detailed action evidence was exported for this flow.")
}

function Get-PageDatasourceOverviewLines {
    param([object]$Page)

    $lines = @(Format-PageDataSourceEvidence -DataSources $Page.dataSources | Where-Object { $_ -ne "- none" })
    if ($lines.Count -gt 0) {
        return $lines
    }

    if (@($Page.parameters).Count -gt 0) {
        return @("- No datasource metadata was exported for this page; it may rely on parameter-driven context rather than a standalone datasource. Check L2 JSON if exact binding matters.")
    }

    return @("- No datasource metadata was exported for this page; this likely indicates static UI or an export gap rather than confirmed absence of data binding.")
}

function Get-PageClientActionOverviewLines {
    param(
        [object]$Page,
        [object[]]$ShownByFlows
    )

    $lines = @(Format-PageClientActionEvidence -ClientActions $Page.clientActions | Where-Object { $_ -ne "- none" })
    if ($lines.Count -gt 0) {
        return $lines
    }

    if (@($ShownByFlows).Count -gt 0 -or @($Page.navigationProvenance).Count -gt 0) {
        return @("- No client action metadata was exported; the clearest entry signals come from flow or navigation evidence instead.")
    }

    return @("- No client action metadata was exported; this may be a passive page or a client-side export gap. Check L2 JSON if exact interaction wiring matters.")
}

function Get-PageShownByFlowLines {
    param(
        [object]$Page,
        [object[]]$ShownByFlows
    )

    if (@($ShownByFlows).Count -gt 0) {
        return @("- $(Join-OrDefault -Items $ShownByFlows -Default 'none')")
    }

    return @("- No ShowPageAction was resolved from exported flows; this page may be reached from navigation or a client-side action. Check L2 JSON if exact provenance matters.")
}

function Get-PageNavigationOverviewLines {
    param(
        [object]$Page,
        [object[]]$ShownByFlows
    )

    $lines = @(Format-PageNavigationEvidence -NavigationProvenance $Page.navigationProvenance | Where-Object { $_ -ne "- none" })
    if ($lines.Count -gt 0) {
        return $lines
    }

    if (@($ShownByFlows).Count -gt 0) {
        return @("- No navigation or homepage provenance was exported; the clearest exported evidence is the flow link shown above.")
    }

    return @("- No navigation or homepage provenance was exported; use route indexes and L2 JSON if this page's exact entry path matters.")
}

function Format-FlowActionEvidence {
    param(
        [object[]]$Actions,
        [ValidateSet("retrieve","decision","show-page","mutation")]
        [string]$Kind
    )

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($action in @($Actions)) {
        switch ($Kind) {
            "retrieve" {
                $entity = if ([string]::IsNullOrWhiteSpace([string]$action.entity)) { "" } else { "; entity=$([string]$action.entity)" }
                $association = if ([string]::IsNullOrWhiteSpace([string]$action.association)) { "" } else { "; association=$([string]$action.association)" }
                $xPath = if ([string]::IsNullOrWhiteSpace([string]$action.xPath)) { "" } else { "; xPath=$([string]$action.xPath)" }
                $sourceKind = if ([string]::IsNullOrWhiteSpace([string]$action.sourceKind)) { "Unknown" } else { [string]$action.sourceKind }
                $lines.Add("- nodeId=$([string]$action.nodeId); sourceKind=$sourceKind$entity$association$xPath; summary=$(Escape-Md ([string]$action.summary))") | Out-Null
            }
            "decision" {
                $caption = if ([string]::IsNullOrWhiteSpace([string]$action.caption)) { "none" } else { Escape-Md ([string]$action.caption) }
                $expression = if ([string]::IsNullOrWhiteSpace([string]$action.expression)) { "none" } else { Escape-Md ([string]$action.expression) }
                $lines.Add("- nodeId=$([string]$action.nodeId); caption=$caption; expression=$expression") | Out-Null
            }
            "show-page" {
                $targetPage = if ([string]::IsNullOrWhiteSpace([string]$action.targetPage)) { "none" } else { [string]$action.targetPage }
                $lines.Add("- nodeId=$([string]$action.nodeId); targetPage=$targetPage; summary=$(Escape-Md ([string]$action.summary))") | Out-Null
            }
            "mutation" {
                $entity = if ([string]::IsNullOrWhiteSpace([string]$action.entity)) { "" } else { "; entity=$([string]$action.entity)" }
                $memberSummary = if ([string]::IsNullOrWhiteSpace([string]$action.memberSummary)) { "" } else { "; members=$(Escape-Md ([string]$action.memberSummary))" }
                $actionKind = if ([string]::IsNullOrWhiteSpace([string]$action.actionKind)) { "Unknown" } else { [string]$action.actionKind }
                $lines.Add("- nodeId=$([string]$action.nodeId); actionKind=$actionKind$entity$memberSummary; summary=$(Escape-Md ([string]$action.summary))") | Out-Null
            }
        }
    }

    if ($lines.Count -eq 0) {
        return @("- none")
    }

    return $lines.ToArray()
}

function Format-PageDataSourceEvidence {
    param([object[]]$DataSources)

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($source in @($DataSources)) {
        $entity = if ([string]::IsNullOrWhiteSpace([string]$source.entity)) { "" } else { "; entity=$([string]$source.entity)" }
        $constraint = if ([string]::IsNullOrWhiteSpace([string]$source.constraint)) { "" } else { "; constraint=$(Escape-Md ([string]$source.constraint))" }
        $flowName = if ([string]::IsNullOrWhiteSpace([string]$source.flowName)) { "" } else { "; flow=$([string]$source.flowName)" }
        $sourceType = if ([string]::IsNullOrWhiteSpace([string]$source.sourceType)) { "Unknown" } else { [string]$source.sourceType }
        $lines.Add("- sourceId=$([string]$source.sourceId); sourceType=$sourceType$entity$constraint$flowName; summary=$(Escape-Md ([string]$source.summary))") | Out-Null
    }

    if ($lines.Count -eq 0) {
        return @("- none")
    }

    return $lines.ToArray()
}

function Format-PageClientActionEvidence {
    param([object[]]$ClientActions)

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($action in @($ClientActions)) {
        $targetPage = if ([string]::IsNullOrWhiteSpace([string]$action.targetPage)) { "" } else { "; targetPage=$([string]$action.targetPage)" }
        $flowName = if ([string]::IsNullOrWhiteSpace([string]$action.flowName)) { "" } else { "; flow=$([string]$action.flowName)" }
        $actionType = if ([string]::IsNullOrWhiteSpace([string]$action.actionType)) { "Unknown" } else { [string]$action.actionType }
        $lines.Add("- actionId=$([string]$action.actionId); actionType=$actionType$targetPage$flowName; summary=$(Escape-Md ([string]$action.summary))") | Out-Null
    }

    if ($lines.Count -eq 0) {
        return @("- none")
    }

    return $lines.ToArray()
}

function Format-PageNavigationEvidence {
    param([object[]]$NavigationProvenance)

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($item in @($NavigationProvenance)) {
        $userRole = if ([string]::IsNullOrWhiteSpace([string]$item.userRole)) { "" } else { "; role=$([string]$item.userRole)" }
        $flowName = if ([string]::IsNullOrWhiteSpace([string]$item.flowName)) { "" } else { "; flow=$([string]$item.flowName)" }
        $sourceType = if ([string]::IsNullOrWhiteSpace([string]$item.sourceType)) { "Unknown" } else { [string]$item.sourceType }
        $lines.Add("- provenanceId=$([string]$item.provenanceId); sourceType=$sourceType$userRole$flowName; summary=$(Escape-Md ([string]$item.summary))") | Out-Null
    }

    if ($lines.Count -eq 0) {
        return @("- none")
    }

    return $lines.ToArray()
}

function Get-ComplexityScore {
    param([object]$ModuleMeta)
    if (-not $ModuleMeta) { return 0 }
    return ([int]$ModuleMeta.entityCount * 3) + ([int]$ModuleMeta.flowCount * 2) + ([int]$ModuleMeta.pageCount)
}

function Get-KbModuleRelativeDir {
    param(
        [string]$ModuleName,
        [hashtable]$ModuleMetaByName
    )

    if ($script:overviewModuleCatalogByName -and $script:overviewModuleCatalogByName.ContainsKey($ModuleName)) {
        return Get-OverviewKbModuleRelativeDir -ModuleName $ModuleName -ModuleCatalogByName $script:overviewModuleCatalogByName
    }

    return "modules/$ModuleName"
}

function Get-KbModuleRelativeFile {
    param(
        [string]$ModuleName,
        [string]$FileName,
        [hashtable]$ModuleMetaByName
    )

    return "$(Get-KbModuleRelativeDir -ModuleName $ModuleName -ModuleMetaByName $ModuleMetaByName)/$FileName"
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

function Extract-RetrieveSummaries {
    param(
        [object]$Flow,
        [object[]]$Nodes
    )

    $summaries = New-Object System.Collections.Generic.List[string]
    $typedRetrieveActions = @()
    if ($null -ne $Flow -and $Flow.PSObject.Properties.Name -contains "retrieveActions") {
        $typedRetrieveActions = @($Flow.retrieveActions)
    }

    foreach ($action in $typedRetrieveActions) {
        $summary = [string]$action.summary
        if ([string]::IsNullOrWhiteSpace($summary)) { continue }
        if (-not $summaries.Contains($summary)) {
            $summaries.Add($summary) | Out-Null
        }
    }

    if ($summaries.Count -gt 0) {
        return @($summaries | Select-Object -First 2)
    }

    foreach ($node in @($Nodes)) {
        $text = if (-not [string]::IsNullOrWhiteSpace([string]$node.detail)) {
            [string]$node.detail
        } else {
            [string]$node.label
        }
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        if ($text -match "RetrieveAction|\bretrieve\b") {
            $summary = $text -replace "^RetrieveAction:\s*", ""
            if (-not [string]::IsNullOrWhiteSpace($summary) -and -not $summaries.Contains($summary)) {
                $summaries.Add($summary) | Out-Null
            }
        }
    }

    return @($summaries | Select-Object -First 2)
}

function Extract-DecisionSummaries {
    param(
        [object]$Flow,
        [object[]]$Nodes
    )

    $summaries = New-Object System.Collections.Generic.List[string]
    $typedDecisionActions = @()
    if ($null -ne $Flow -and $Flow.PSObject.Properties.Name -contains "decisionActions") {
        $typedDecisionActions = @($Flow.decisionActions)
    }

    foreach ($action in $typedDecisionActions) {
        $summary = [string]$action.expression
        if ([string]::IsNullOrWhiteSpace($summary)) {
            $summary = [string]$action.summary
        }
        if (-not [string]::IsNullOrWhiteSpace($summary) -and -not $summaries.Contains($summary)) {
            $summaries.Add($summary) | Out-Null
        }
    }

    if ($summaries.Count -gt 0) {
        return @($summaries | Select-Object -First 2)
    }

    foreach ($node in @($Nodes)) {
        $text = (([string]$node.label) + " " + ([string]$node.detail)).Trim()
        if ([string]::IsNullOrWhiteSpace($text)) { continue }

        $summary = $null
        if ($text -match "expression=([^`r`n]+)") {
            $summary = $matches[1].Trim()
        } elseif ($node.nodeType -match "Split" -or $text -match "^\s*DECISION\b") {
            $summary = $text
        }

        if (-not [string]::IsNullOrWhiteSpace($summary) -and -not $summaries.Contains($summary)) {
            $summaries.Add($summary) | Out-Null
        }
    }

    return @($summaries | Select-Object -First 2)
}

function Get-FlowRetrieveActions {
    param([object]$Flow)

    if ($null -ne $Flow -and $Flow.PSObject.Properties.Name -contains "retrieveActions" -and @($Flow.retrieveActions).Count -gt 0) {
        return @($Flow.retrieveActions)
    }

    $fallback = New-Object System.Collections.Generic.List[object]
    foreach ($node in @($Flow.nodes)) {
        $text = if (-not [string]::IsNullOrWhiteSpace([string]$node.detail)) { [string]$node.detail } else { [string]$node.label }
        if ([string]::IsNullOrWhiteSpace($text) -or $text -notmatch "RetrieveAction|\bretrieve\b") { continue }
        $summary = $text -replace "^RetrieveAction:\s*", ""
        $fallback.Add([pscustomobject]@{
            nodeId = [string]$node.nodeId
            summary = $summary
            sourceKind = $(if ($summary -match "over association") { "Association" } elseif ($summary -match "\bfrom\b") { "Database" } else { "Unknown" })
            entity = $(if ($summary -match "\bfrom\s+([A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*)") { $matches[1] } else { $null })
            association = $(if ($summary -match "\bover association\s+([A-Za-z_][A-Za-z0-9_]*)") { $matches[1] } else { $null })
            xPath = $(if ($summary -match "\bxPath=([^,\r\n)]+)") { $matches[1].Trim() } else { $null })
        }) | Out-Null
    }
    return $fallback.ToArray()
}

function Get-FlowDecisionActions {
    param([object]$Flow)

    if ($null -ne $Flow -and $Flow.PSObject.Properties.Name -contains "decisionActions" -and @($Flow.decisionActions).Count -gt 0) {
        return @($Flow.decisionActions)
    }

    $fallback = New-Object System.Collections.Generic.List[object]
    foreach ($node in @($Flow.nodes)) {
        $text = (([string]$node.label) + " " + ([string]$node.detail)).Trim()
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        if ($text -match "expression=([^`r`n]+)") {
            $expression = $matches[1].Trim()
            $fallback.Add([pscustomobject]@{
                nodeId = [string]$node.nodeId
                summary = $text
                caption = ($text -replace "\s*expression=.*$", "").Trim()
                expression = $expression
            }) | Out-Null
        }
    }
    return $fallback.ToArray()
}

function Get-FlowShowPageActions {
    param([object]$Flow)

    if ($null -ne $Flow -and $Flow.PSObject.Properties.Name -contains "showPageActions" -and @($Flow.showPageActions).Count -gt 0) {
        return @($Flow.showPageActions)
    }

    $fallback = New-Object System.Collections.Generic.List[object]
    foreach ($node in @($Flow.nodes)) {
        $text = (([string]$node.label) + " " + ([string]$node.detail)).Trim()
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        foreach ($m in [regex]::Matches($text, "show page\s+([A-Za-z0-9_]+\.[A-Za-z0-9_]+)", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
            $fallback.Add([pscustomobject]@{
                nodeId = [string]$node.nodeId
                summary = $text
                targetPage = $m.Groups[1].Value
            }) | Out-Null
        }
    }
    return $fallback.ToArray()
}

function Get-FlowMutationActions {
    param([object]$Flow)

    if ($null -ne $Flow -and $Flow.PSObject.Properties.Name -contains "mutationActions" -and @($Flow.mutationActions).Count -gt 0) {
        return @($Flow.mutationActions)
    }

    $fallback = New-Object System.Collections.Generic.List[object]
    foreach ($node in @($Flow.nodes)) {
        $text = (([string]$node.label) + " " + ([string]$node.detail)).Trim()
        if ([string]::IsNullOrWhiteSpace($text)) { continue }

        $actionKind = $null
        if ($text -match "CreateObjectAction|\bcreate\b") { $actionKind = "Create" }
        elseif ($text -match "ChangeObjectAction|ChangeListAction|\bchange\b") { $actionKind = "Change" }
        elseif ($text -match "CommitAction|\bcommit\b") { $actionKind = "Commit" }
        elseif ($text -match "DeleteAction|\bdelete\b") { $actionKind = "Delete" }

        if ($null -eq $actionKind) { continue }

        $fallback.Add([pscustomobject]@{
            nodeId = [string]$node.nodeId
            actionKind = $actionKind
            summary = $text
            entity = $(if ($text -match "\b([A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*)\b") { $matches[1] } else { $null })
            memberSummary = $(if ($text -match "\(([^)]+)\)") { $matches[1] } else { $null })
        }) | Out-Null
    }
    return $fallback.ToArray()
}

function Get-PageDataSources {
    param([object]$Page)

    if ($null -ne $Page -and $Page.PSObject.Properties.Name -contains "dataSources") {
        return @($Page.dataSources)
    }

    return @()
}

function Get-PageClientActions {
    param([object]$Page)

    if ($null -ne $Page -and $Page.PSObject.Properties.Name -contains "clientActions") {
        return @($Page.clientActions)
    }

    return @()
}

function Get-PageNavigationProvenance {
    param([object]$Page)

    if ($null -ne $Page -and $Page.PSObject.Properties.Name -contains "navigationProvenance") {
        return @($Page.navigationProvenance)
    }

    return @()
}

function Get-EntryProvenanceLabel {
    param(
        [object[]]$ShownByFlows,
        [object[]]$NavigationProvenance
    )

    if (@($ShownByFlows).Count -gt 0) {
        return "ShowPageAction"
    }

    $navKinds = @($NavigationProvenance | ForEach-Object { [string]$_.sourceType } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
    if ($navKinds.Count -gt 0) {
        return ($navKinds -join ", ")
    }

    return "Unknown (navigation metadata not exported)"
}

function Get-ModuleArtifactPath {
    param(
        [string]$ModuleName,
        [string]$ArtifactType,
        [hashtable]$ArtifactPathByTypeModule
    )

    $key = "$ArtifactType|$ModuleName"
    if ($ArtifactPathByTypeModule.ContainsKey($key)) {
        return [string]$ArtifactPathByTypeModule[$key]
    }

    return $null
}

function Get-ModuleNameFromArtifactPath {
    param([string]$ArtifactPath)

    if ([string]::IsNullOrWhiteSpace($ArtifactPath)) { return $null }
    if ($ArtifactPath -match "[\\/]modules[\\/]marketplace[\\/]([^\\/]+)[\\/]") { return $matches[1] }
    if ($ArtifactPath -match "[\\/]modules[\\/]([^\\/]+)[\\/]") { return $matches[1] }
    return $null
}

function Build-ObjectSlug {
    param(
        [string]$QualifiedName,
        [string]$StableId,
        [hashtable]$UsedSlugs
    )

    return Build-OverviewObjectSlug -QualifiedName $QualifiedName -StableId $StableId -UsedSlugs $UsedSlugs
}

function Get-ModuleExportRelativeDir {
    param(
        [string]$ModuleName,
        [hashtable]$ModuleMetaByName
    )

    if ($script:overviewModuleCatalogByName -and $script:overviewModuleCatalogByName.ContainsKey($ModuleName)) {
        return Get-OverviewModuleExportRelativeDir -ModuleName $ModuleName -ModuleCatalogByName $script:overviewModuleCatalogByName
    }

    return "modules/$ModuleName"
}

function Sync-CurrentAlias {
    param([string]$RunFolderPath)

    $syncInfo = Sync-AppOverviewCurrentAlias -RunFolder $RunFolderPath -ModuleCatalogByName $script:overviewModuleCatalogByName
    $script:l2ContractDebtRecords = @($syncInfo.DebtRecords)
    return [string]$syncInfo.CurrentAliasPath
}

function New-FrontMatterBlock {
    param($Fields)

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("---") | Out-Null
    foreach ($key in $Fields.Keys) {
        $value = [string]$Fields[$key]
        $escapedValue = $value.Replace("`r", " ").Replace("`n", " ")
        $lines.Add("${key}: $escapedValue") | Out-Null
    }
    $lines.Add("---") | Out-Null
    return ($lines -join "`n")
}

function Write-JsonNoBom {
    param(
        [string]$Path,
        $Value
    )

    $dir = Split-Path -Parent $Path
    if (-not (Test-Path $dir -PathType Container)) {
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
    }

    $json = $Value | ConvertTo-Json -Depth 12
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $json.TrimEnd() + "`n", $utf8NoBom)
}

if (-not (Test-Path $RunFolder -PathType Container)) {
    throw "RunFolder not found: $RunFolder"
}

$manifestPath = Join-Path $RunFolder "manifest.json"
$manifest = Load-Json -Path $manifestPath
if ($manifest.schemaVersion -ne "2.0") {
    throw "Expected schema version 2.0, got $($manifest.schemaVersion)"
}

$artifactPathByTypeModule = @{}
foreach ($artifact in @($manifest.artifacts)) {
    $artifactType = [string]$artifact.type
    if ($artifactType -notlike "module-*") { continue }

    $artifactPath = [string]$artifact.path
    if ([string]::IsNullOrWhiteSpace($artifactPath)) { continue }
    $moduleName = Get-ModuleNameFromArtifactPath -ArtifactPath $artifactPath
    if ([string]::IsNullOrWhiteSpace($moduleName)) { continue }

    $artifactPathByTypeModule["$artifactType|$moduleName"] = $artifactPath
}

$kbRoot = $OutputRoot
if (-not (Test-Path $kbRoot -PathType Container)) {
    throw "KB root does not exist. Run scaffold first: $kbRoot"
}

$kbFormatVersion = "1.0"
$runFolderName = Split-Path $RunFolder -Leaf
$dataRoot = Split-Path -Parent (Split-Path -Parent $RunFolder)

$allModulesPath = Join-Path $RunFolder "general/all-modules.json"
$userRolesPath = Join-Path $RunFolder "general/user-roles.json"
$appInfoPath = Join-Path $RunFolder "general/app-info.json"

$allModules = Load-Json -Path $allModulesPath
$userRoles = Load-Json -Path $userRolesPath
$appInfo = Load-Json -Path $appInfoPath
$generatedAtUtc = if ([string]::IsNullOrWhiteSpace($GeneratedAtUtc)) {
    if ($manifest.PSObject.Properties.Name -contains "generatedAtUtc" -and -not [string]::IsNullOrWhiteSpace([string]$manifest.generatedAtUtc)) {
        [string]$manifest.generatedAtUtc
    } else {
        (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
} else {
    $GeneratedAtUtc
}

$moduleMetaByName = @{}
foreach ($m in @($allModules.modules)) {
    $moduleMetaByName[$m.module] = $m
}

$script:overviewModuleCatalog = @(Get-OverviewModuleCatalog -RunFolder $RunFolder -Manifest $manifest)
$script:overviewModuleCatalogByName = Get-OverviewModuleCatalogMap -ModuleCatalog $script:overviewModuleCatalog
$script:l2ContractDebtRecords = @()
$currentAliasPath = Sync-CurrentAlias -RunFolderPath $RunFolder
$currentAliasDisplayPath = if ([System.IO.Path]::IsPathRooted($RunFolder)) {
    $currentAliasPath
} else {
    Get-OverviewLogicalPath -Path (Join-Path (Split-Path -Parent $RunFolder) "current")
}

$moduleNames = @($moduleMetaByName.Keys | Sort-Object)

$unknownTodos = New-Object "System.Collections.Generic.List[object]"
$unknownTodoKeys = New-Object System.Collections.Generic.HashSet[string]

$domainsByModule = @{}
$flowsByModule = @{}
$pagesByModule = @{}
$resourcesByModule = @{}

foreach ($module in $moduleNames) {
    $domainPath = Get-OverviewModuleFilePath -RootPath $RunFolder -ModuleName $module -FileName "domain-model.json" -ModuleCatalogByName $script:overviewModuleCatalogByName
    $flowsPath = Get-OverviewModuleFilePath -RootPath $RunFolder -ModuleName $module -FileName "flows.json" -ModuleCatalogByName $script:overviewModuleCatalogByName
    $pagesPath = Get-OverviewModuleFilePath -RootPath $RunFolder -ModuleName $module -FileName "pages.json" -ModuleCatalogByName $script:overviewModuleCatalogByName
    $resourcesPath = Get-OverviewModuleFilePath -RootPath $RunFolder -ModuleName $module -FileName "resources.json" -ModuleCatalogByName $script:overviewModuleCatalogByName

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
$usedFlowSlugsByModule = @{}

foreach ($module in $moduleNames) {
    $category = [string]$moduleMetaByName[$module].category
    if (-not $usedFlowSlugsByModule.ContainsKey($module)) {
        $usedFlowSlugsByModule[$module] = @{}
    }
    foreach ($flow in @($flowsByModule[$module].flows)) {
        $qualified = [string]$flow.qualifiedName
        $localName = Get-LocalNameFromQualified -QualifiedName $qualified
        $stableId = if ($flow.PSObject.Properties.Name -contains "flowId" -and -not [string]::IsNullOrWhiteSpace([string]$flow.flowId)) { [string]$flow.flowId } else { $qualified }
        $slug = Build-ObjectSlug -QualifiedName $qualified -StableId $stableId -UsedSlugs $usedFlowSlugsByModule[$module]
        $callsOut = @(@($flow.calls) | ForEach-Object { [string]$_.targetFlowName } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
        $retrieveActions = Get-FlowRetrieveActions -Flow $flow
        $decisionActions = Get-FlowDecisionActions -Flow $flow
        $showPageActions = Get-FlowShowPageActions -Flow $flow
        $mutationActions = Get-FlowMutationActions -Flow $flow
        $shownPages = @(
            @($showPageActions | ForEach-Object { [string]$_.targetPage }) +
            @(Extract-ShownPages -Nodes @($flow.nodes)) |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Sort-Object -Unique
        )
        $retrieveSummaries = Extract-RetrieveSummaries -Flow $flow -Nodes @($flow.nodes)
        $decisionSummaries = Extract-DecisionSummaries -Flow $flow -Nodes @($flow.nodes)
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
            retrieveSummaries = $retrieveSummaries
            decisionSummaries = $decisionSummaries
            retrieveActions = $retrieveActions
            decisionActions = $decisionActions
            showPageActions = $showPageActions
            mutationActions = $mutationActions
            touchesEntities = $touchesEntities
            hasCrossModuleEdge = $false
            writesPersistent = $writesPersistent
            hasBehaviouralAction = [bool]$actionFlags.HasBehaviouralAction
            actionFlags = $actionFlags
            pseudocode = [string]$flow.pseudocode
            flowId = [string]$flow.flowId
            stableId = $stableId
            slug = $slug
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
$usedPageSlugsByModule = @{}
foreach ($module in $moduleNames) {
    if (-not $usedPageSlugsByModule.ContainsKey($module)) {
        $usedPageSlugsByModule[$module] = @{}
    }
    foreach ($page in @($pagesByModule[$module].pages)) {
        $stableId = [string]$page.qualifiedName
        $slug = Build-ObjectSlug -QualifiedName ([string]$page.qualifiedName) -StableId $stableId -UsedSlugs $usedPageSlugsByModule[$module]
        $fact = [pscustomobject]@{
            qualifiedName = [string]$page.qualifiedName
            name = [string]$page.name
            module = $module
            title = [string]$page.title
            layout = [string]$page.layout
            allowedRoles = @($page.allowedRoles)
            parameters = @($page.parameters)
            isPopup = [bool]$page.isPopup
            dataSources = @(Get-PageDataSources -Page $page)
            clientActions = @(Get-PageClientActions -Page $page)
            navigationProvenance = @(Get-PageNavigationProvenance -Page $page)
            stableId = $stableId
            slug = $slug
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

$moduleDocPathsByName = @{}
$appSecurityPath = Join-Path $kbRoot "app/SECURITY.md"
$byEntityPath = Join-Path $kbRoot "routes/by-entity.md"
$byPagePath = Join-Path $kbRoot "routes/by-page.md"
$byFlowPath = Join-Path $kbRoot "routes/by-flow.md"

$readerPath = Join-Path $kbRoot "READER.md"
$readerContent = @"
# How to Read This Knowledge Base

## What is this?

This knowledge base is generated from Mendix model-overview export JSON and is tuned for AI-assisted reasoning.

Confidence: Export-backed

## How to navigate

- Start at [ROUTING.md](ROUTING.md), then open a route index or module collection abstract first.
- Use [app/APP_OVERVIEW.md](app/APP_OVERVIEW.md) for app mission and key behaviours.
- Use ``modules/<Module>/`` for app and system modules, and ``modules/_marktplace/<Module>/`` for marketplace modules.
- Use ``routes/`` files for cross-cut indexes by entity, page, and flow.
- Open collection abstracts first, then object overview files second.
- Open object JSON in ``app-overview/current/...`` only for exact verification.
- If L1 and L2 differ, trust L2.

Confidence: Export-backed

## How to answer questions

- For behaviour questions, trace: trigger -> flow chain -> entity mutations -> shown pages -> role constraints.
- For exact microflow, retrieve, XPath, datasource, or client-action questions, follow route-table L2 links into ``app-overview/current/...``.
- For business interpretation, open ``INTERPRETATION.md`` only after the summary/evidence layers.
- Prefer custom modules for deep app-specific answers.
- Use support modules mainly for dependencies that affect custom behaviour.

Confidence: Inferred

## KB Commands

- This KB remains read-only for normal interpretation.
- ``/enrichkb`` is the explicit in-place AI enrichment command.
- ``/initkb`` remains available as a compatibility entry point and rebuild handoff.
- Both commands use ``_sources/creator-link.json`` to find the linked ``lastRunFolder``.
- If the source run folder is missing, ``/initkb`` should fall back to a creator-side rebuild handoff.

Confidence: Export-backed

## Confidence levels

- ``Export-backed``: direct from JSON export.
- ``Inferred``: deterministic synthesis from export data (for example tier ranking, capability grouping).
- ``Unknown``: source data is absent or non-derivable.

## Source

- Generated at: $generatedAtUtc
- Run folder: $RunFolder
- Current alias: $currentAliasDisplayPath
- KB Format Version: $kbFormatVersion
- Schema version: $($manifest.schemaVersion)
- Unknown TODO backlog: [_reports/UNKNOWN_TODO.md](_reports/UNKNOWN_TODO.md)
- If present, ``_sources/creator-link.json`` links this KB back to its creator workspace.
"@
Write-Utf8NoBom -Path $readerPath -Content $readerContent

$moduleIndexRows = New-Object System.Collections.Generic.List[string]
foreach ($module in $moduleNames) {
    $cat = [string]$moduleMetaByName[$module].category
    $complexity = Get-ComplexityScore -ModuleMeta $moduleMetaByName[$module]
    $moduleIndexRows.Add("| $module | $cat | $complexity | [README]($(Get-KbModuleRelativeFile -ModuleName $module -FileName 'README.md' -ModuleMetaByName $moduleMetaByName)) |") | Out-Null
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
| Exact microflow body | [routes/by-flow.md](routes/by-flow.md) |
| Exact retrieve or XPath evidence | [routes/by-flow.md](routes/by-flow.md) |
| Why a page opens | [routes/by-page.md](routes/by-page.md) |

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

## Deep lookup

- Open a route index or module collection abstract first.
- Open the object overview second.
- Open the stable L2 JSON under ``app-overview/current/...`` only when exact verification is required.
- If L1 and L2 differ, trust L2.

## Source

- Generated at: $generatedAtUtc
- Run folder: $RunFolder
"@
Write-Utf8NoBom -Path $routingPath -Content $routingContent

$capabilityRows = New-Object System.Collections.Generic.List[string]
foreach ($module in $customModules) {
    $moduleFlows = @($flowList | Where-Object { $_.module -eq $module })
    $capabilityRows.Add("| $module | $($moduleFlows.Count) | $(@($moduleFlows | Where-Object { $_.tier -eq 1 }).Count) | [FLOWS](../$(Get-KbModuleRelativeFile -ModuleName $module -FileName 'FLOWS.md' -ModuleMetaByName $moduleMetaByName)) |") | Out-Null
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
    $entryRows.Add("| $($flow.qualifiedName) | Tier $($flow.tier) | $(Join-OrDefault -Items $reason -Default "behavioural action") | [Flow](../$(Get-KbModuleRelativeFile -ModuleName $flow.module -FileName 'FLOWS.md' -ModuleMetaByName $moduleMetaByName)) |") | Out-Null
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
    $moduleDir = Join-Path $kbRoot (Get-KbModuleRelativeDir -ModuleName $module -ModuleMetaByName $moduleMetaByName)
    $readmePath = Join-Path $moduleDir "README.md"
    $domainPath = Join-Path $moduleDir "DOMAIN.md"
    $flowsPath = Join-Path $moduleDir "FLOWS.md"
    $pagesPath = Join-Path $moduleDir "PAGES.md"
    $resourcesPath = Join-Path $moduleDir "RESOURCES.md"
    $interpretationPath = Join-Path $moduleDir "INTERPRETATION.md"
    $moduleFlowsJsonPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-flows-json" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $moduleFlowsPseudoPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-flows-pseudo" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $modulePagesJsonPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-pages-json" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $modulePagesPseudoPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-pages-pseudo" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $moduleDomainJsonPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-domain-model-json" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $moduleDomainPseudoPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-domain-model-pseudo" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $moduleResourcesJsonPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-resources-json" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $moduleResourcesPseudoPath = Get-ModuleArtifactPath -ModuleName $module -ArtifactType "module-resources-pseudo" -ArtifactPathByTypeModule $artifactPathByTypeModule
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
        foreach ($f in @($moduleFlows | Sort-Object tier, @{ Expression = { $_.nodeCount }; Descending = $true }, localName | Select-Object -First 3)) {
            $journeyRows.Add("| $($f.qualifiedName) | $(Join-OrDefault -Items $f.shownPages -Default "none") | $(Join-OrDefault -Items $f.touchesEntities -Default "none") |") | Out-Null
        }
        if ($journeyRows.Count -eq 0) {
            $journeyRows.Add("| module inventory | none | none |") | Out-Null
        }
    }

    $riskRows = @()
    if (@($moduleFlows | Where-Object { $_.touchesEntities.Count -eq 0 -and $_.hasBehaviouralAction }).Count -gt 0) {
        $riskRows += "- Some flows have behavioural actions without explicit entity name tokens (parser gap)."
    }
    if (@($modulePages | Where-Object { -not $shownByPage.ContainsKey($_.qualifiedName) }).Count -gt 0) {
        $riskRows += "- Some pages have no explicit ShowPageAction evidence in exported flows."
    }
    if ($riskRows.Count -eq 0) {
        $riskRows += "- No material export interpretation gaps were detected for this module."
    }
    $modulePurposeFallback = Get-ModulePurposeFallback -Category $category -Entities $moduleEntities -Pages $modulePages -Flows $moduleFlows -Resources $moduleResources

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
- Deterministic fallback: $modulePurposeFallback

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
- [FLOWS.md](FLOWS.md) - module flow overview
- [flows/INDEX.abstract.md](flows/INDEX.abstract.md) - flow routing file
- [PAGES.md](PAGES.md) - module page overview
- [pages/INDEX.abstract.md](pages/INDEX.abstract.md) - page routing file
- [RESOURCES.md](RESOURCES.md)
- [INTERPRETATION.md](INTERPRETATION.md) - AI narrative layer
- Open collection abstracts first, then object overview files, and use stable JSON only when exact export-backed detail is required.

## Source Pointers

- Domain export: $(New-MarkdownLink -Label "domain-model.pseudo.txt" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $moduleDomainPseudoPath)) and $(New-MarkdownLink -Label "domain-model.json" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $moduleDomainJsonPath)).
- Flow export: $(New-MarkdownLink -Label "flows.pseudo.txt" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $moduleFlowsPseudoPath)) and $(New-MarkdownLink -Label "flows.json" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $moduleFlowsJsonPath)).
- Page export: $(New-MarkdownLink -Label "pages.pseudo.txt" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $modulePagesPseudoPath)) and $(New-MarkdownLink -Label "pages.json" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $modulePagesJsonPath)).
- Resource export: $(New-MarkdownLink -Label "resources.pseudo.txt" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $moduleResourcesPseudoPath)) and $(New-MarkdownLink -Label "resources.json" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $readmePath -ToPath $moduleResourcesJsonPath)).
- Use $(New-InlineCode -Text 'DOMAIN.md') for entity shape, lifecycle, access rules, associations, and XPath summaries.
- Use $(New-InlineCode -Text 'FLOWS.md') and $(New-InlineCode -Text 'flows/INDEX.abstract.md') for flow routing and compact module-level flow context.
- Use $(New-InlineCode -Text 'PAGES.md') and $(New-InlineCode -Text 'pages/INDEX.abstract.md') for page routing and compact module-level page context.
- Use $(New-InlineCode -Text 'RESOURCES.md') for constants, scheduled events, and supporting module resources.

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

    $entitySummarySections = New-Object System.Collections.Generic.List[string]
    foreach ($entity in $moduleEntities) {
        $life = $entityLifecycle[$entity.name]
        $entityAnchor = Get-MarkdownAnchorId -Prefix "entity" -Value $entity.name
        $hasXPath = @($entity.accessRules | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.xPathConstraint) }).Count -gt 0
        $securityLink = if ($hasXPath) {
            New-MarkdownLink -Label "app security" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $domainPath -ToPath $appSecurityPath)
        } else {
            "none"
        }
        $entitySummarySection = @(
            ('<a id="{0}"></a>' -f $entityAnchor),
            "### $($entity.name)",
            "",
            "- Generalization: $(if ([string]::IsNullOrWhiteSpace([string]$entity.generalization)) { 'none' } else { [string]$entity.generalization }).",
            "- Lifecycle: create=$(Join-OrDefault -Items @($life.Create) -Default 'none'); update=$(Join-OrDefault -Items @($life.Update) -Default 'none'); delete=$(Join-OrDefault -Items @($life.Delete) -Default 'none'); read=$(Join-OrDefault -Items @($life.Read) -Default 'none').",
            "- Security/XPath summary: $securityLink.",
            "- Source: $(New-MarkdownLink -Label 'domain-model.pseudo.txt' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $domainPath -ToPath $moduleDomainPseudoPath)) / $(New-MarkdownLink -Label 'domain-model.json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $domainPath -ToPath $moduleDomainJsonPath))."
        ) -join "`n"
        $entitySummarySections.Add($entitySummarySection) | Out-Null
    }
    if ($entitySummarySections.Count -eq 0) {
        $entitySummarySections.Add("No entity index entries for this module.") | Out-Null
    }

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

## Entity Index

$($entitySummarySections -join "`n")

## Source

- Domain export pseudo: $(New-MarkdownLink -Label "domain-model.pseudo.txt" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $domainPath -ToPath $moduleDomainPseudoPath))
- Domain export json: $(New-MarkdownLink -Label "domain-model.json" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $domainPath -ToPath $moduleDomainJsonPath))
"@
    Write-Utf8NoBom -Path $domainPath -Content $domainContent

    $moduleDocPathsByName[$module] = @{
        README = $readmePath
        DOMAIN = $domainPath
        FLOWS = $flowsPath
        FLOWS_INDEX = (Join-Path $moduleDir "flows/INDEX.abstract.md")
        FLOWS_DIR = (Join-Path $moduleDir "flows")
        PAGES = $pagesPath
        PAGES_INDEX = (Join-Path $moduleDir "pages/INDEX.abstract.md")
        PAGES_DIR = (Join-Path $moduleDir "pages")
        RESOURCES = $resourcesPath
        INTERPRETATION = $interpretationPath
    }
    $flowsIndexAbstractPath = $moduleDocPathsByName[$module].FLOWS_INDEX
    $pagesIndexAbstractPath = $moduleDocPathsByName[$module].PAGES_INDEX
    $moduleExportRelativeDir = Get-ModuleExportRelativeDir -ModuleName $module -ModuleMetaByName $moduleMetaByName
    $flowCurrentIndexPath = Join-Path $dataRoot "app-overview/current/$moduleExportRelativeDir/flows/INDEX.json"
    $pageCurrentIndexPath = Join-Path $dataRoot "app-overview/current/$moduleExportRelativeDir/pages/INDEX.json"

    $actRows = New-Object System.Collections.Generic.List[string]
    $dsRows = New-Object System.Collections.Generic.List[string]
    $valRows = New-Object System.Collections.Generic.List[string]
    $otherRows = New-Object System.Collections.Generic.List[string]
    $crossCallRows = New-Object System.Collections.Generic.List[string]
    $tier1Rows = New-Object System.Collections.Generic.List[string]
    $flowDetailRows = New-Object System.Collections.Generic.List[string]
    $tier1Narratives = New-Object System.Collections.Generic.List[string]
    $flowRouteRows = New-Object System.Collections.Generic.List[string]
    $flowIndexRows = New-Object System.Collections.Generic.List[string]

    foreach ($f in $moduleFlows) {
        $flowAbstractPath = Join-Path $moduleDir "flows/$($f.slug).abstract.md"
        $flowOverviewPath = Join-Path $moduleDir "flows/$($f.slug).overview.md"
        $flowCurrentJsonPath = Join-Path $dataRoot "app-overview/current/$moduleExportRelativeDir/flows/$($f.slug).json"
        $mainSteps = New-Object System.Collections.Generic.List[string]
        foreach ($line in @(
            @($f.retrieveSummaries | Select-Object -First 2) +
            @($f.decisionSummaries | Select-Object -First 2) +
            @($f.showPageActions | Select-Object -First 1 | ForEach-Object { [string]$_.summary }) +
            @($f.mutationActions | Select-Object -First 2 | ForEach-Object { [string]$_.summary })
        )) {
            if (-not [string]::IsNullOrWhiteSpace([string]$line) -and -not $mainSteps.Contains([string]$line)) {
                $mainSteps.Add([string]$line) | Out-Null
            }
        }
        if ($mainSteps.Count -eq 0) {
            $mainSteps.Add('No compact step summary was derivable from the exported flow actions.') | Out-Null
        }

        $warningItems = New-Object System.Collections.Generic.List[string]
        if ($f.actionFlags.HasRollbackHint) { $warningItems.Add('Rollback hint detected in node detail.') | Out-Null }
        if ($f.touchesEntities.Count -eq 0 -and $f.hasBehaviouralAction) { $warningItems.Add('Behavioural actions exist without explicit entity tags.') | Out-Null }
        if ($warningItems.Count -eq 0) { $warningItems.Add('No material warnings from deterministic export synthesis.') | Out-Null }

        $flowSummary = Get-FlowOverviewSummary -Flow $f
        $flowAbstractFrontMatter = New-FrontMatterBlock ([ordered]@{
            objectType = 'flow'
            module = $module
            qualifiedName = $f.qualifiedName
            stableId = $f.stableId
            slug = $f.slug
            layer = 'L0'
            l1 = (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowOverviewPath)
            l2Path = (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowCurrentJsonPath)
            l2Logical = "flow:$($f.qualifiedName)"
            sourceRun = $runFolderName
            collectionL0 = (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowsIndexAbstractPath)
            collectionL1 = (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowsPath)
        })
        $flowAbstractContent = @"
$flowAbstractFrontMatter
# Flow Abstract: $($f.qualifiedName)
- Summary: $flowSummary
- L1: $(New-MarkdownLink -Label 'overview' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowOverviewPath))
- L2: $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowCurrentJsonPath))
- Collections: $(New-MarkdownLink -Label 'collection L0' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowsIndexAbstractPath)), $(New-MarkdownLink -Label 'collection L1' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowAbstractPath -ToPath $flowsPath))
"@
        Write-Utf8NoBom -Path $flowAbstractPath -Content $flowAbstractContent

        $flowOverviewFrontMatter = New-FrontMatterBlock ([ordered]@{
            objectType = 'flow'
            module = $module
            qualifiedName = $f.qualifiedName
            stableId = $f.stableId
            slug = $f.slug
            layer = 'L1'
            l0 = (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $flowAbstractPath)
            l2Path = (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $flowCurrentJsonPath)
            l2Logical = "flow:$($f.qualifiedName)"
            sourceRun = $runFolderName
            collectionL0 = (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $flowsIndexAbstractPath)
            collectionL1 = (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $flowsPath)
        })
        $flowOverviewContent = @"
$flowOverviewFrontMatter
# Flow Overview: $($f.qualifiedName)

## Summary

- $flowSummary
- L0: $(New-MarkdownLink -Label 'abstract' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $flowAbstractPath))
- L2: $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $flowCurrentJsonPath))

## Main Steps

$((@($mainSteps | ForEach-Object { "- $(Escape-Md $_)" })) -join "`n")

## Trigger/Input/Output Context

- Kind: $($f.kind)
- Entry/call context: $(Get-FlowEntryContextText -Flow $f)
- Output/UI context: $(Get-FlowOutputContextText -Flow $f)

## Key Entities Touched

$((@(Get-FlowEntitiesTouchedLines -Flow $f)) -join "`n")

## Called / Called By

- Calls: $(Join-OrDefault -Items $f.callsOut -Default 'none')
- Called by: $(Join-OrDefault -Items $f.calledBy -Default 'none')

## Shown Pages

$((@(Get-FlowShownPagesLines -Flow $f)) -join "`n")

## Important Retrieves/Decisions/Mutations

$((@(Get-FlowActionOverviewLines -Flow $f | Select-Object -First 8)) -join "`n")

## Warnings/Unknowns

$((@($warningItems | ForEach-Object { "- $(Escape-Md $_)" })) -join "`n")

## Source

- Stable JSON: $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $flowCurrentJsonPath))
- Aggregate export: $(New-MarkdownLink -Label 'flows.json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $moduleFlowsJsonPath))
- Aggregate pseudo: $(New-MarkdownLink -Label 'flows.pseudo.txt' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowOverviewPath -ToPath $moduleFlowsPseudoPath))
- Traceability: sourceRun=$runFolderName
"@
        Write-Utf8NoBom -Path $flowOverviewPath -Content $flowOverviewContent

        $keyActions = if ($f.touchesEntities.Count -gt 0) { Join-OrDefault -Items $f.touchesEntities -Default 'none' } else { 'none' }
        if ($f.localName.StartsWith('ACT_', [System.StringComparison]::OrdinalIgnoreCase)) {
            $actRows.Add("| $($f.localName) | $($f.nodeCount) | $keyActions | $(Join-OrDefault -Items $f.shownPages -Default 'none') |") | Out-Null
        } elseif ($f.localName.StartsWith('DS_', [System.StringComparison]::OrdinalIgnoreCase)) {
            $dsRows.Add("| $($f.localName) | $($f.nodeCount) | $keyActions | inferred from node actions |") | Out-Null
        } elseif ($f.localName.StartsWith('VAL_', [System.StringComparison]::OrdinalIgnoreCase)) {
            $valRows.Add("| $($f.localName) | $($f.nodeCount) | $keyActions |") | Out-Null
        } else {
            $otherRows.Add("| $($f.localName) | $($f.kind) | $($f.nodeCount) | $keyActions |") | Out-Null
        }

        foreach ($target in @($f.callsOut | Where-Object { (Get-ModuleNameFromQualified -QualifiedName $_) -ne $module })) {
            $crossCallRows.Add("| $($f.localName) | $target | $(Get-ModuleNameFromQualified -QualifiedName $target) |") | Out-Null
        }
        $flowDetailRows.Add("| $($f.localName) | $($f.kind) | $($f.nodeCount) | $($f.tier) | $(@($f.callsOut).Count) | $(@($f.calledBy).Count) |") | Out-Null
        if ($f.tier -eq 1) {
            $tier1Rows.Add("| $($f.qualifiedName) | $(Join-OrDefault -Items $f.shownPages -Default 'none') | $(Join-OrDefault -Items $f.touchesEntities -Default 'none') |") | Out-Null
            $intent = if ($f.localName.StartsWith('ACT_', [System.StringComparison]::OrdinalIgnoreCase)) {
                'User action flow.'
            } elseif ($f.localName.StartsWith('VAL_', [System.StringComparison]::OrdinalIgnoreCase)) {
                'Validation flow.'
            } elseif ($f.localName.StartsWith('DS_', [System.StringComparison]::OrdinalIgnoreCase)) {
                'Datasource flow.'
            } else {
                'General behavioural flow.'
            }
            $rollbackNote = if ($f.actionFlags.HasRollbackHint) {
                'Rollback hint detected in flow node detail.'
            } else {
                'No rollback behaviour was explicitly indicated in exported node detail.'
            }
            $tier1Narratives.Add(@"
### $($f.qualifiedName)

- Intent: $intent
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: $(Join-OrDefault -Items $f.touchesEntities -Default 'none').
- UI interactions (shown pages): $(Join-OrDefault -Items $f.shownPages -Default 'none').
- Calls/called-by: out=$(@($f.callsOut).Count), in=$(@($f.calledBy).Count).
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: $rollbackNote
"@.Trim()) | Out-Null
        }
        $flowRouteRows.Add("| $($f.qualifiedName) | $($f.kind) | $($f.tier) | $(New-MarkdownLink -Label 'L0' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowsPath -ToPath $flowAbstractPath)) | $(New-MarkdownLink -Label 'L1' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowsPath -ToPath $flowOverviewPath)) | $(New-MarkdownLink -Label 'L2' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowsPath -ToPath $flowCurrentJsonPath)) |") | Out-Null
        $flowIndexRows.Add("| $($f.qualifiedName) | tier $($f.tier) | $(New-MarkdownLink -Label 'abstract' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowsIndexAbstractPath -ToPath $flowAbstractPath)) | $(New-MarkdownLink -Label 'overview' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowsIndexAbstractPath -ToPath $flowOverviewPath)) | $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $flowsIndexAbstractPath -ToPath $flowCurrentJsonPath)) |") | Out-Null
    }

    if ($actRows.Count -eq 0) { $actRows.Add('| none | 0 | none | none |') | Out-Null }
    if ($dsRows.Count -eq 0) { $dsRows.Add('| none | 0 | none | none |') | Out-Null }
    if ($valRows.Count -eq 0) { $valRows.Add('| none | 0 | none |') | Out-Null }
    if ($otherRows.Count -eq 0) { $otherRows.Add('| none | none | 0 | none |') | Out-Null }
    if ($crossCallRows.Count -eq 0) { $crossCallRows.Add('| none | none | none |') | Out-Null }
    if ($tier1Rows.Count -eq 0) { $tier1Rows.Add('| none | none | none |') | Out-Null }
    if ($flowDetailRows.Count -eq 0) { $flowDetailRows.Add('| none | none | 0 | 3 | 0 | 0 |') | Out-Null }
    if ($flowRouteRows.Count -eq 0) { $flowRouteRows.Add('| none | none | 3 | none | none | none |') | Out-Null }
    if ($flowIndexRows.Count -eq 0) { $flowIndexRows.Add('| none | none | none | none | none |') | Out-Null }
    $tier1NarrativesContent = if ($tier1Narratives.Count -gt 0) {
        $tier1Narratives -join "`n`n"
    } elseif ($category -ne "Custom") {
        'Tier 1 deep narratives are only generated for custom modules; use the flow catalogue and L0/L1 flow files for this module.'
    } elseif ($moduleFlows.Count -eq 0) {
        'No flow exports were present for this module.'
    } else {
        'No Tier 1 flows were identified from the exported structure for this module.'
    }

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

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
$($tier1Rows -join "`n")

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
$($flowDetailRows -join "`n")

## Tier 1 Deep Narratives

$tier1NarrativesContent

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
$($flowRouteRows -join "`n")
"@
    Write-Utf8NoBom -Path $flowsPath -Content $flowsContent

    $flowsIndexFrontMatter = New-FrontMatterBlock ([ordered]@{
        objectType = 'flow-collection'
        module = $module
        stableId = "$module:flows"
        slug = 'index'
        layer = 'L0'
        l1 = (Get-RelativeMarkdownPath -FromFilePath $flowsIndexAbstractPath -ToPath $flowsPath)
        l2Path = (Get-RelativeMarkdownPath -FromFilePath $flowsIndexAbstractPath -ToPath $flowCurrentIndexPath)
        l2Logical = "flow-collection:$module"
        sourceRun = $runFolderName
        collectionL0 = '.'
        collectionL1 = (Get-RelativeMarkdownPath -FromFilePath $flowsIndexAbstractPath -ToPath $flowsPath)
    })
    $flowsIndexContent = @"
$flowsIndexFrontMatter
# Flow Collection Abstract: $module
- Count: $($moduleFlows.Count) flow(s); Tier 1: $(@($moduleFlows | Where-Object { $_.tier -eq 1 }).Count)
- Ranked focus: $(Join-OrDefault -Items @($moduleFlows | Sort-Object tier, localName | Select-Object -First 5 | ForEach-Object { $_.qualifiedName }) -Default 'none')

| Flow | Rank | L0 | L1 | L2 |
|---|---|---|---|---|
$($flowIndexRows -join "`n")
"@
    Write-Utf8NoBom -Path $flowsIndexAbstractPath -Content $flowsIndexContent

    $pageRows = New-Object System.Collections.Generic.List[string]
    $pageFlowRows = New-Object System.Collections.Generic.List[string]
    $journeyGroups = @{}
    $pageRouteRows = New-Object System.Collections.Generic.List[string]
    $pageIndexRows = New-Object System.Collections.Generic.List[string]
    foreach ($p in $modulePages) {
        $shownBy = if ($shownByPage.ContainsKey($p.qualifiedName)) { @($shownByPage[$p.qualifiedName] | Sort-Object -Unique) } else { @() }
        $paramSummary = @($p.parameters | ForEach-Object { "$($_.name):$($_.entityType)" })
        $pageRows.Add("| $($p.qualifiedName) | $(Escape-Md $p.title) | $(Join-OrDefault -Items $p.allowedRoles -Default 'none') | $(Join-OrDefault -Items $paramSummary -Default 'none') | $($p.isPopup) |") | Out-Null
        $pageFlowRows.Add("| $($p.qualifiedName) | $(Join-OrDefault -Items $shownBy -Default 'none') |") | Out-Null
        $intent = if ($p.name -match '^([A-Za-z]+)_') { $matches[1] } else { 'General' }
        if (-not $journeyGroups.ContainsKey($intent)) { $journeyGroups[$intent] = New-Object System.Collections.Generic.List[string] }
        $journeyGroups[$intent].Add($p.qualifiedName) | Out-Null

        $pageAbstractPath = Join-Path $moduleDir "pages/$($p.slug).abstract.md"
        $pageOverviewPath = Join-Path $moduleDir "pages/$($p.slug).overview.md"
        $pageCurrentJsonPath = Join-Path $dataRoot "app-overview/current/$moduleExportRelativeDir/pages/$($p.slug).json"
        $pageWarnings = New-Object System.Collections.Generic.List[string]
        if (@($shownBy).Count -eq 0 -and @($p.navigationProvenance).Count -eq 0) { $pageWarnings.Add('No direct flow or navigation provenance was exported for this page; rely on page structure and route indexes.') | Out-Null }
        if ($pageWarnings.Count -eq 0) { $pageWarnings.Add('No material warnings from deterministic export synthesis.') | Out-Null }
        $pageSummary = Get-PageOverviewSummary -Page $p -ShownByFlows $shownBy

        $pageAbstractFrontMatter = New-FrontMatterBlock ([ordered]@{
            objectType = 'page'
            module = $module
            qualifiedName = $p.qualifiedName
            stableId = $p.stableId
            slug = $p.slug
            layer = 'L0'
            l1 = (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pageOverviewPath)
            l2Path = (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pageCurrentJsonPath)
            l2Logical = "page:$($p.qualifiedName)"
            sourceRun = $runFolderName
            collectionL0 = (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pagesIndexAbstractPath)
            collectionL1 = (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pagesPath)
        })
        $pageAbstractContent = @"
$pageAbstractFrontMatter
# Page Abstract: $($p.qualifiedName)
- Summary: $(Escape-Md $pageSummary)
- L1: $(New-MarkdownLink -Label 'overview' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pageOverviewPath))
- L2: $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pageCurrentJsonPath))
- Collections: $(New-MarkdownLink -Label 'collection L0' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pagesIndexAbstractPath)), $(New-MarkdownLink -Label 'collection L1' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageAbstractPath -ToPath $pagesPath))
"@
        Write-Utf8NoBom -Path $pageAbstractPath -Content $pageAbstractContent

        $pageOverviewFrontMatter = New-FrontMatterBlock ([ordered]@{
            objectType = 'page'
            module = $module
            qualifiedName = $p.qualifiedName
            stableId = $p.stableId
            slug = $p.slug
            layer = 'L1'
            l0 = (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $pageAbstractPath)
            l2Path = (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $pageCurrentJsonPath)
            l2Logical = "page:$($p.qualifiedName)"
            sourceRun = $runFolderName
            collectionL0 = (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $pagesIndexAbstractPath)
            collectionL1 = (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $pagesPath)
        })
        $pageOverviewContent = @"
$pageOverviewFrontMatter
# Page Overview: $($p.qualifiedName)

## Summary

- $(Escape-Md $pageSummary)
- L0: $(New-MarkdownLink -Label 'abstract' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $pageAbstractPath))
- L2: $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $pageCurrentJsonPath))

## Roles and Entry Provenance

- Roles: $(Join-OrDefault -Items $p.allowedRoles -Default 'none')
- Entry provenance: $(Get-EntryProvenanceLabel -ShownByFlows $shownBy -NavigationProvenance $p.navigationProvenance)

## Parameters

- $(Join-OrDefault -Items $paramSummary -Default 'none')

## Datasource Summary

$((@(Get-PageDatasourceOverviewLines -Page $p | Select-Object -First 5)) -join "`n")

## Client Actions

$((@(Get-PageClientActionOverviewLines -Page $p -ShownByFlows $shownBy | Select-Object -First 5)) -join "`n")

## Shown by Flows

$((@(Get-PageShownByFlowLines -Page $p -ShownByFlows $shownBy)) -join "`n")

## Navigation/Homepage Provenance

$((@(Get-PageNavigationOverviewLines -Page $p -ShownByFlows $shownBy | Select-Object -First 5)) -join "`n")

## Warnings/Unknowns

$((@($pageWarnings | ForEach-Object { "- $(Escape-Md $_)" })) -join "`n")

## Source

- Stable JSON: $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $pageCurrentJsonPath))
- Aggregate export: $(New-MarkdownLink -Label 'pages.json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $modulePagesJsonPath))
- Aggregate pseudo: $(New-MarkdownLink -Label 'pages.pseudo.txt' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pageOverviewPath -ToPath $modulePagesPseudoPath))
- Traceability: sourceRun=$runFolderName
"@
        Write-Utf8NoBom -Path $pageOverviewPath -Content $pageOverviewContent

        $pageRouteRows.Add("| $($p.qualifiedName) | $(Escape-Md (Get-EntryProvenanceLabel -ShownByFlows $shownBy -NavigationProvenance $p.navigationProvenance)) | $(New-MarkdownLink -Label 'L0' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pagesPath -ToPath $pageAbstractPath)) | $(New-MarkdownLink -Label 'L1' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pagesPath -ToPath $pageOverviewPath)) | $(New-MarkdownLink -Label 'L2' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pagesPath -ToPath $pageCurrentJsonPath)) |") | Out-Null
        $pageIndexRows.Add("| $($p.qualifiedName) | $(Escape-Md (Get-EntryProvenanceLabel -ShownByFlows $shownBy -NavigationProvenance $p.navigationProvenance)) | $(New-MarkdownLink -Label 'abstract' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pagesIndexAbstractPath -ToPath $pageAbstractPath)) | $(New-MarkdownLink -Label 'overview' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pagesIndexAbstractPath -ToPath $pageOverviewPath)) | $(New-MarkdownLink -Label 'json' -TargetPath (Get-RelativeMarkdownPath -FromFilePath $pagesIndexAbstractPath -ToPath $pageCurrentJsonPath)) |") | Out-Null
    }

    if ($pageRows.Count -eq 0) { $pageRows.Add('| none | none | none | none | false |') | Out-Null }
    if ($pageFlowRows.Count -eq 0) { $pageFlowRows.Add('| none | none |') | Out-Null }
    $journeyRowsByPage = New-Object System.Collections.Generic.List[string]
    foreach ($intent in @($journeyGroups.Keys | Sort-Object)) {
        $journeyRowsByPage.Add("| $intent | $(Join-OrDefault -Items @($journeyGroups[$intent]) -Default 'none') |") | Out-Null
    }
    if ($journeyRowsByPage.Count -eq 0) { $journeyRowsByPage.Add('| none | none |') | Out-Null }
    if ($pageRouteRows.Count -eq 0) { $pageRouteRows.Add('| none | none | none | none | none |') | Out-Null }
    if ($pageIndexRows.Count -eq 0) { $pageIndexRows.Add('| none | none | none | none | none |') | Out-Null }

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

## Journey Groups

| User intent group | Pages |
|---|---|
$($journeyRowsByPage -join "`n")

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
$($pageRouteRows -join "`n")
"@
    Write-Utf8NoBom -Path $pagesPath -Content $pagesContent

    $pagesIndexFrontMatter = New-FrontMatterBlock ([ordered]@{
        objectType = 'page-collection'
        module = $module
        stableId = "$module:pages"
        slug = 'index'
        layer = 'L0'
        l1 = (Get-RelativeMarkdownPath -FromFilePath $pagesIndexAbstractPath -ToPath $pagesPath)
        l2Path = (Get-RelativeMarkdownPath -FromFilePath $pagesIndexAbstractPath -ToPath $pageCurrentIndexPath)
        l2Logical = "page-collection:$module"
        sourceRun = $runFolderName
        collectionL0 = '.'
        collectionL1 = (Get-RelativeMarkdownPath -FromFilePath $pagesIndexAbstractPath -ToPath $pagesPath)
    })
    $pagesIndexContent = @"
$pagesIndexFrontMatter
# Page Collection Abstract: $module
- Count: $($modulePages.Count) page(s)
- Ranked focus: $(Join-OrDefault -Items @($modulePages | Select-Object -First 5 | ForEach-Object { $_.qualifiedName }) -Default 'none')

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
$($pageIndexRows -join "`n")
"@
    Write-Utf8NoBom -Path $pagesIndexAbstractPath -Content $pagesIndexContent

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

    $interpretationContent = @"
# Interpretation: $module

## Module Purpose

Reserved for `/enrichkb`. Add AI narrative only in this section.

## Domain Narrative

Reserved for `/enrichkb`. Add AI narrative only in this section.

## Flow Narrative

Reserved for `/enrichkb`. Add AI narrative only in this section.

## Page Narrative

Reserved for `/enrichkb`. Add AI narrative only in this section.
"@
    Write-Utf8NoBom -Path $interpretationPath -Content $interpretationContent
}

$entityRouteRows = New-Object System.Collections.Generic.List[string]
foreach ($entityName in @($entityLookup.Keys | Sort-Object)) {
    $life = $entityLifecycle[$entityName]
    $entityModuleName = $entityModule[$entityName]
    $domainDocPath = $moduleDocPathsByName[$entityModuleName].DOMAIN
    $entityAnchor = Get-MarkdownAnchorId -Prefix "entity" -Value $entityName
    $kbDetailLink = New-MarkdownLink -Label "detail" -TargetPath ((Get-RelativeMarkdownPath -FromFilePath $byEntityPath -ToPath $domainDocPath) + "#$entityAnchor")
    $shownPagesForEntity = New-Object System.Collections.Generic.HashSet[string]
    foreach ($page in $pageFacts) {
        foreach ($param in @($page.parameters)) {
            if ([string]$param.entityType -eq $entityName) {
                [void]$shownPagesForEntity.Add($page.qualifiedName)
            }
        }
    }

    $readEvidenceFlow = @($life.Read | Sort-Object | Select-Object -First 1)
    $writeEvidenceFlow = @(
        @($life.Create) + @($life.Update) + @($life.Delete) |
        Sort-Object -Unique |
        Select-Object -First 1
    )

    $readEvidenceLink = if ($readEvidenceFlow.Count -gt 0) {
            $qualified = [string]$readEvidenceFlow[0]
            $flow = $flowFacts[$qualified]
            $flowModuleName = [string]$flow.module
            $flowOverviewPath = Join-Path $moduleDocPathsByName[$flowModuleName].FLOWS_DIR "$($flow.slug).overview.md"
            New-MarkdownLink -Label $qualified -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byEntityPath -ToPath $flowOverviewPath)
    } else {
        "none"
    }
    $writeEvidenceLink = if ($writeEvidenceFlow.Count -gt 0) {
            $qualified = [string]$writeEvidenceFlow[0]
            $flow = $flowFacts[$qualified]
            $flowModuleName = [string]$flow.module
            $flowOverviewPath = Join-Path $moduleDocPathsByName[$flowModuleName].FLOWS_DIR "$($flow.slug).overview.md"
            New-MarkdownLink -Label $qualified -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byEntityPath -ToPath $flowOverviewPath)
    } else {
        "none"
    }
    $securityEvidenceLink = if (@($domainsByModule[$entityModuleName].domainModel.entities | Where-Object { $_.name -eq $entityName } | ForEach-Object { $_.accessRules } | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.xPathConstraint) }).Count -gt 0) {
        New-MarkdownLink -Label "security" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byEntityPath -ToPath $appSecurityPath)
    } else {
        "none"
    }

    $entityRouteRows.Add("| $entityName | [$entityModuleName]($(Get-RelativeMarkdownPath -FromFilePath $byEntityPath -ToPath $domainDocPath)) | $kbDetailLink | $(Join-OrDefault -Items @($life.Create) -Default "none") | $(Join-OrDefault -Items @($life.Update) -Default "none") | $(Join-OrDefault -Items @($life.Delete) -Default "none") | $(Join-OrDefault -Items @($life.Read) -Default "none") | $readEvidenceLink | $writeEvidenceLink | $securityEvidenceLink | $(Join-OrDefault -Items @($shownPagesForEntity) -Default "none") |") | Out-Null
}

$byEntityContent = @"
# Entity Index

| Entity | Module | KB detail | Create flows | Update flows | Delete flows | Read flows | Read evidence | Write evidence | Security/XPath evidence | Shown on pages |
|---|---|---|---|---|---|---|---|---|---|---|
$($entityRouteRows -join "`n")
"@
Write-Utf8NoBom -Path $byEntityPath -Content $byEntityContent

$byPageRows = New-Object System.Collections.Generic.List[string]
foreach ($page in @($pageFacts | Sort-Object qualifiedName)) {
    $pagesDocPath = $moduleDocPathsByName[$page.module].PAGES
    $pageAbstractPath = Join-Path $moduleDocPathsByName[$page.module].PAGES_DIR "$($page.slug).abstract.md"
    $pageOverviewPath = Join-Path $moduleDocPathsByName[$page.module].PAGES_DIR "$($page.slug).overview.md"
    $pageCurrentJsonPath = Join-Path $dataRoot "app-overview/current/$(Get-ModuleExportRelativeDir -ModuleName $page.module -ModuleMetaByName $moduleMetaByName)/pages/$($page.slug).json"
    $pagesPseudoArtifactPath = Get-ModuleArtifactPath -ModuleName $page.module -ArtifactType "module-pages-pseudo" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $pagesJsonArtifactPath = Get-ModuleArtifactPath -ModuleName $page.module -ArtifactType "module-pages-json" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $shownBy = if ($shownByPage.ContainsKey($page.qualifiedName)) { @($shownByPage[$page.qualifiedName] | Sort-Object -Unique) } else { @() }
    $shownByText = Join-OrUnknown -Items $shownBy `
        -UnknownScope "$($page.module).$([string]$page.name)" `
        -UnknownField "routes/by-page.Shown by flows" `
        -Reason "Page appears in model, but no ShowPageAction evidence was derived from flows." `
        -FixHint "Improve show-page extraction or enrich parser output with resolved page-route links."
    $kbSummaryLink = New-MarkdownLink -Label "collection" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byPagePath -ToPath $pagesDocPath)
    $kbL0Link = New-MarkdownLink -Label "L0" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byPagePath -ToPath $pageAbstractPath)
    $kbL1Link = New-MarkdownLink -Label "L1" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byPagePath -ToPath $pageOverviewPath)
    $pseudoLink = New-MarkdownLink -Label "pages.pseudo.txt" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byPagePath -ToPath $pagesPseudoArtifactPath)
    $jsonLink = New-MarkdownLink -Label "pages.json" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byPagePath -ToPath $pagesJsonArtifactPath)
    $stableL2Link = New-MarkdownLink -Label "L2" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byPagePath -ToPath $pageCurrentJsonPath)
    $entryProvenance = Get-EntryProvenanceLabel -ShownByFlows $shownBy -NavigationProvenance $page.navigationProvenance
    $primaryDatasourceOrAction = if (@($page.dataSources).Count -gt 0) {
        [string]$page.dataSources[0].summary
    } elseif (@($page.clientActions).Count -gt 0) {
        [string]$page.clientActions[0].summary
    } elseif (@($page.navigationProvenance).Count -gt 0) {
        [string]$page.navigationProvenance[0].summary
    } else {
        "none"
    }
    $byPageRows.Add("| $($page.qualifiedName) | [$($page.module)]($(Get-RelativeMarkdownPath -FromFilePath $byPagePath -ToPath $pagesDocPath)) | $(Join-OrDefault -Items $page.allowedRoles -Default "none") | $(Escape-Md $entryProvenance) | $kbSummaryLink | $kbL0Link | $kbL1Link | $stableL2Link | $pseudoLink | $jsonLink | $(Escape-Md $primaryDatasourceOrAction) | $shownByText |") | Out-Null
}

$byPageContent = @"
# Page Index

| Page | Module | Roles | Entry provenance | Collection | L0 | L1 | L2 | Aggregate pseudo | Aggregate json | Primary datasource/action | Shown by flows |
|---|---|---|---|---|---|---|---|---|---|---|---|
$($byPageRows -join "`n")
"@
Write-Utf8NoBom -Path $byPagePath -Content $byPageContent

$byFlowRows = New-Object System.Collections.Generic.List[string]
foreach ($flow in @($flowList | Sort-Object qualifiedName)) {
    $flowsDocPath = $moduleDocPathsByName[$flow.module].FLOWS
    $flowAbstractPath = Join-Path $moduleDocPathsByName[$flow.module].FLOWS_DIR "$($flow.slug).abstract.md"
    $flowOverviewPath = Join-Path $moduleDocPathsByName[$flow.module].FLOWS_DIR "$($flow.slug).overview.md"
    $flowCurrentJsonPath = Join-Path $dataRoot "app-overview/current/$(Get-ModuleExportRelativeDir -ModuleName $flow.module -ModuleMetaByName $moduleMetaByName)/flows/$($flow.slug).json"
    $flowPseudoArtifactPath = Get-ModuleArtifactPath -ModuleName $flow.module -ArtifactType "module-flows-pseudo" -ArtifactPathByTypeModule $artifactPathByTypeModule
    $flowJsonArtifactPath = Get-ModuleArtifactPath -ModuleName $flow.module -ArtifactType "module-flows-json" -ArtifactPathByTypeModule $artifactPathByTypeModule
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

    $kbSummaryLink = New-MarkdownLink -Label "collection" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byFlowPath -ToPath $flowsDocPath)
    $kbL0Link = New-MarkdownLink -Label "L0" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byFlowPath -ToPath $flowAbstractPath)
    $kbL1Link = New-MarkdownLink -Label "L1" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byFlowPath -ToPath $flowOverviewPath)
    $pseudoLink = New-MarkdownLink -Label "flows.pseudo.txt" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byFlowPath -ToPath $flowPseudoArtifactPath)
    $jsonLink = New-MarkdownLink -Label "flows.json" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byFlowPath -ToPath $flowJsonArtifactPath)
    $stableL2Link = New-MarkdownLink -Label "L2" -TargetPath (Get-RelativeMarkdownPath -FromFilePath $byFlowPath -ToPath $flowCurrentJsonPath)
    $retrieveSummary = Escape-Md (Join-OrDefault -Items $flow.retrieveSummaries -Default "none")
    $decisionSummary = Escape-Md (Join-OrDefault -Items $flow.decisionSummaries -Default "none")

    $byFlowRows.Add("| $($flow.qualifiedName) | $($flow.kind) | [$($flow.module)]($(Get-RelativeMarkdownPath -FromFilePath $byFlowPath -ToPath $flowsDocPath)) | $($flow.tier) | $kbSummaryLink | $kbL0Link | $kbL1Link | $stableL2Link | $pseudoLink | $jsonLink | $retrieveSummary | $decisionSummary | $($flow.fanOut) | $($flow.fanIn) | $(Join-OrDefault -Items $flow.shownPages -Default "none") | $touchesEntitiesText |") | Out-Null
}

$byFlowContent = @"
# Flow Index

| Flow | Type | Module | Tier | Collection | L0 | L1 | L2 | Aggregate pseudo | Aggregate json | Retrieve summary | Decision summary | Calls | Called by | Shows Pages | Touches Entities |
|---|---|---|---:|---|---|---|---|---|---|---|---|---:|---:|---|---|
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

$l2DebtReport = Write-L2ContractDebtReport `
    -KbRoot $kbRoot `
    -RunFolder $RunFolder `
    -CurrentAliasPath $currentAliasDisplayPath `
    -DebtRecords $script:l2ContractDebtRecords `
    -GeneratedAtUtc $generatedAtUtc

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
Write-Host "L2 contract debt report: $($l2DebtReport.MarkdownPath)"
