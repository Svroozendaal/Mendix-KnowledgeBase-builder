<#
.SYNOPSIS
    Generate a full JSON v2 run folder from mxcli.

.DESCRIPTION
    Builds on the Prompt 03 general/domain generator and adds:

    - all required `.pseudo.txt` companions
    - module `flows.json`, `pages.json`, and `resources.json`
    - `flows/INDEX.json` and `flows/<slug>.json`
    - `pages/INDEX.json` and `pages/<slug>.json`

    The output is designed to remain consumable by the existing composer and
    validation pipeline without changing the downstream `.pseudo.txt` contract.
#>

. (Join-Path $PSScriptRoot "mxcli-json-v2-general-domain.ps1")

function Write-MxCliTextUtf8NoBom {
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [AllowNull()]
        [string]$Content
    )

    $directory = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($directory) -and -not (Test-Path $directory -PathType Container)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $text = if ($null -eq $Content) { "" } else { [string]$Content }
    [System.IO.File]::WriteAllText($Path, $text.TrimEnd() + "`n", $utf8NoBom)
}

function Join-MxCliListOrDefault {
    param(
        [object[]]$Items,
        [string]$Default = "none"
    )

    $clean = @(
        $Items |
        ForEach-Object { [string]$_ } |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Sort-Object -Unique
    )

    if ($clean.Count -eq 0) {
        return $Default
    }

    return ($clean -join ", ")
}

function Get-MxCliStableHash {
    param(
        [string]$Text,
        [int]$Length = 12
    )

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes([string]$Text)
        $hash = $sha.ComputeHash($bytes)
        $hex = ([System.BitConverter]::ToString($hash)).Replace("-", "").ToLowerInvariant()
        if ($Length -ge $hex.Length) {
            return $hex
        }
        return $hex.Substring(0, $Length)
    }
    finally {
        $sha.Dispose()
    }
}

function New-MxCliStableId {
    param(
        [string]$Prefix,
        [string]$Seed
    )

    $safePrefix = if ([string]::IsNullOrWhiteSpace($Prefix)) { "id" } else { $Prefix.Trim() }
    return "$safePrefix-$(Get-MxCliStableHash -Text $Seed -Length 12)"
}

function ConvertTo-MxCliDisplayDate {
    param([string]$UtcText)

    if ([string]::IsNullOrWhiteSpace($UtcText)) {
        return "unknown"
    }

    $parsed = [datetime]::MinValue
    if ([datetime]::TryParse($UtcText, [ref]$parsed)) {
        return $parsed.ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ssZ")
    }

    return $UtcText
}

function Get-MxCliProjectTreeObject {
    param([string]$ProjectPath)

    $result = Invoke-MxCliCommand -Arguments @("project-tree", "-p", $ProjectPath) -ThrowOnError
    $jsonText = Get-MxCliTextOutput -Result $result
    return ($jsonText | ConvertFrom-Json)
}

function Add-MxCliProjectTreeRecord {
    param(
        [Parameter(Mandatory)]
        [object]$Node,
        [object]$Records,
        [string]$ModuleName,
        [string[]]$PathLabels = @()
    )

    $currentModuleName = if ([string]$Node.type -eq "module") {
        [string]$Node.qualifiedName
    } else {
        $ModuleName
    }

    $record = [pscustomobject]@{
        module = $currentModuleName
        label = [string]$Node.label
        type = [string]$Node.type
        qualifiedName = ConvertTo-MxCliNullIfBlank -Value ([string]$Node.qualifiedName)
        path = @($PathLabels)
    }
    $Records.Add($record) | Out-Null

    foreach ($child in @($Node.children)) {
        if ($null -eq $child) { continue }
        Add-MxCliProjectTreeRecord -Node $child -Records $Records -ModuleName $currentModuleName -PathLabels @($PathLabels + @([string]$Node.label))
    }
}

function Get-MxCliProjectTreeRecords {
    param([object[]]$ProjectTree)

    $records = New-Object 'System.Collections.Generic.List[object]'
    foreach ($node in @($ProjectTree)) {
        if ($null -eq $node) { continue }
        Add-MxCliProjectTreeRecord -Node $node -Records $records
    }
    return @($records.ToArray())
}

function Get-MxCliNavigationProvenanceByPage {
    param([object[]]$ProjectTree)

    $result = @{}
    $navigationRoot = @($ProjectTree | Where-Object { [string]$_.type -eq "navigation" } | Select-Object -First 1)[0]
    if ($null -eq $navigationRoot) {
        return $result
    }

    foreach ($profile in @($navigationRoot.children | Where-Object { [string]$_.type -eq "navprofile" })) {
        $profileName = [string]$profile.label
        foreach ($child in @($profile.children)) {
            $type = [string]$child.type
            $label = [string]$child.label

            if ($type -eq "navhome" -and $label -match '^Home:\s+(?<page>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
                $pageName = $matches.page
                if (-not $result.ContainsKey($pageName)) { $result[$pageName] = New-Object 'System.Collections.Generic.List[object]' }
                $result[$pageName].Add([ordered]@{
                    provenanceId = New-MxCliStableId -Prefix "nav" -Seed "$profileName|home|$pageName"
                    sourceType = "HomePage"
                    summary = "Homepage in profile $profileName"
                    page = $pageName
                    userRole = $null
                    flowName = $null
                }) | Out-Null
                continue
            }

            if ($type -eq "navhome" -and $label -match '^Home \((?<role>[^)]+)\):\s+(?<page>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
                $pageName = $matches.page
                $roleName = $matches.role
                if (-not $result.ContainsKey($pageName)) { $result[$pageName] = New-Object 'System.Collections.Generic.List[object]' }
                $result[$pageName].Add([ordered]@{
                    provenanceId = New-MxCliStableId -Prefix "nav" -Seed "$profileName|rolehome|$roleName|$pageName"
                    sourceType = "RoleBasedHomePage"
                    summary = "Role-based homepage in profile $profileName for role $roleName"
                    page = $pageName
                    userRole = $roleName
                    flowName = $null
                }) | Out-Null
                continue
            }

            if ($type -eq "navmenu") {
                foreach ($menuItem in @($child.children | Where-Object { [string]$_.type -eq "navmenuitem" })) {
                    $menuLabel = [string]$menuItem.label
                    $arrowSeparator = " " + [char]0x2192 + " "
                    if ($menuLabel.IndexOf($arrowSeparator) -lt 0) {
                        continue
                    }

                    $parts = $menuLabel.Split(@($arrowSeparator), 2, [System.StringSplitOptions]::None)
                    if ($parts.Count -ne 2) {
                        continue
                    }

                    $caption = $parts[0].Trim()
                    $pageName = $parts[1].Trim()
                    if ($pageName -notmatch '^[A-Za-z0-9_]+\.[A-Za-z0-9_]+$') {
                        continue
                    }
                    if (-not $result.ContainsKey($pageName)) { $result[$pageName] = New-Object 'System.Collections.Generic.List[object]' }
                    $result[$pageName].Add([ordered]@{
                        provenanceId = New-MxCliStableId -Prefix "nav" -Seed "$profileName|menu|$caption|$pageName"
                        sourceType = "MenuItem"
                        summary = "Menu item `"$caption`" in profile $profileName"
                        page = $pageName
                        userRole = $null
                        flowName = $null
                    }) | Out-Null
                }
            }
        }
    }

    return $result
}

function Get-MxCliMdlHeaderText {
    param([string[]]$Lines)

    $headerLines = New-Object 'System.Collections.Generic.List[string]'
    foreach ($line in @($Lines)) {
        if ($line.Trim() -eq "BEGIN" -or $line.Trim().EndsWith("{")) {
            break
        }
        $headerLines.Add($line) | Out-Null
    }
    return (($headerLines.ToArray()) -join " ")
}

function Get-MxCliQualifiedNameHeaderParams {
    param([string]$HeaderText)

    if ([string]::IsNullOrWhiteSpace($HeaderText)) {
        return @()
    }

    if ($HeaderText -notmatch 'Params:\s*\{(?<params>[^}]*)\}') {
        return @()
    }

    $items = New-Object 'System.Collections.Generic.List[object]'
    foreach ($part in @($matches.params.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
        if ($part -match '^\$(?<name>[A-Za-z0-9_]+)\s*:\s*(?<entity>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
            $items.Add([ordered]@{
                name = $matches.name
                entityType = $matches.entity
            }) | Out-Null
        }
    }
    return @($items.ToArray())
}

function Get-MxCliMicroflowHeaderParams {
    param([string[]]$Lines)

    $params = New-Object 'System.Collections.Generic.List[object]'
    $headerMode = $false
    foreach ($line in @($Lines)) {
        $trimmed = $line.Trim()
        if ($trimmed -match '^CREATE MICROFLOW ') {
            $headerMode = $true
            continue
        }
        if (-not $headerMode) {
            continue
        }
        if ($trimmed -eq "BEGIN" -or $trimmed -eq ")") {
            break
        }
        if ($trimmed -match '^\$(?<name>[A-Za-z0-9_]+):\s*(?<entity>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
            $params.Add([ordered]@{
                variableName = '$' + $matches.name
                entityType = $matches.entity
            }) | Out-Null
        }
    }
    return @($params.ToArray())
}

function Get-MxCliMicroflowTokens {
    param([string[]]$Lines)

    $tokens = New-Object 'System.Collections.Generic.List[object]'
    $inBody = $false
    $buffer = New-Object System.Text.StringBuilder

    function Flush-MxCliMicroflowTokenBuffer {
        param(
            [System.Text.StringBuilder]$Builder,
            [System.Collections.Generic.List[object]]$TokenList
        )

        if ($Builder.Length -le 0) {
            return
        }

        $text = $Builder.ToString().Trim()
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            $TokenList.Add([pscustomobject]@{
                kind = "statement"
                text = $text
            }) | Out-Null
        }
        $Builder.Clear() | Out-Null
    }

    foreach ($line in @($Lines)) {
        $trimmed = $line.Trim()
        if ($trimmed -eq "BEGIN") {
            $inBody = $true
            continue
        }
        if (-not $inBody) {
            continue
        }
        if ($trimmed -eq "END;") {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
            break
        }
        if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed -match '^@position' -or $trimmed -match '^GRANT ' -or $trimmed -eq '/') {
            continue
        }

        if ($trimmed -match '^IF .+ THEN$') {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
            $tokens.Add([pscustomobject]@{ kind = "if"; text = $trimmed }) | Out-Null
            continue
        }
        if ($trimmed -eq "ELSE") {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
            $tokens.Add([pscustomobject]@{ kind = "else"; text = $trimmed }) | Out-Null
            continue
        }
        if ($trimmed -eq "END IF;") {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
            $tokens.Add([pscustomobject]@{ kind = "endif"; text = $trimmed }) | Out-Null
            continue
        }
        if ($trimmed -match '^LOOP ') {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
            $tokens.Add([pscustomobject]@{ kind = "loop"; text = $trimmed }) | Out-Null
            continue
        }
        if ($trimmed -eq "END LOOP;") {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
            $tokens.Add([pscustomobject]@{ kind = "endloop"; text = $trimmed }) | Out-Null
            continue
        }
        if ($trimmed -match '^-- ') {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
            $tokens.Add([pscustomobject]@{ kind = "statement"; text = $trimmed }) | Out-Null
            continue
        }

        if ($buffer.Length -gt 0) {
            [void]$buffer.Append(" ")
        }
        [void]$buffer.Append($trimmed)

        if ($trimmed.EndsWith(";")) {
            Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
        }
    }

    Flush-MxCliMicroflowTokenBuffer -Builder $buffer -TokenList $tokens
    return @($tokens.ToArray())
}

function ConvertTo-MxCliFlowKind {
    param([string]$RawType)

    $normalized = if ($null -eq $RawType) { "" } else { $RawType.ToUpperInvariant() }
    switch ($normalized) {
        "NANOFLOW" { return "Nanoflow" }
        "WORKFLOW" { return "Workflow" }
        default { return "Microflow" }
    }
}

function Get-MxCliVariableTypeMap {
    param([object[]]$Parameters)

    $map = @{}
    foreach ($parameter in @($Parameters)) {
        $variableName = [string]$parameter.variableName
        if ([string]::IsNullOrWhiteSpace($variableName)) { continue }
        $map[$variableName] = [string]$parameter.entityType
    }
    return $map
}

function Get-MxCliFlowStatementInfo {
    param(
        [string]$StatementText,
        [hashtable]$VariableTypeMap
    )

    $statementValue = if ($null -eq $StatementText) { "" } else { [string]$StatementText }
    $normalized = ($statementValue -replace '\s+', ' ').Trim().TrimEnd(";")
    $summary = $normalized
    $detail = $normalized
    $nodeType = "ActionActivity"
    $callInfo = @()
    $retrieveAction = $null
    $showPageAction = $null
    $mutationAction = $null

    if ($normalized -match '^\$[^=]+\s*=\s*CALL MICROFLOW (?<target>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)') {
        $target = $matches.target
        $returnName = $null
        if ($normalized -match '^\$(?<var>[A-Za-z0-9_]+)\s*=') {
            $returnName = $matches.var
        }
        $summary = "call microflow $target"
        if (-not [string]::IsNullOrWhiteSpace($returnName)) {
            $summary += " -> $returnName"
        }
        $callInfo = @([ordered]@{
            callKind = "Microflow"
            targetFlowName = $target
        })
    }
    elseif ($normalized -match '^CALL MICROFLOW (?<target>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)') {
        $target = $matches.target
        $summary = "call microflow $target"
        $callInfo = @([ordered]@{
            callKind = "Microflow"
            targetFlowName = $target
        })
    }
    elseif ($normalized -match '^\$?(?<var>[A-Za-z0-9_]+)\s*=\s*CREATE LIST of (?<entity>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)') {
        $entity = $matches.entity
        $variableTypeMap['$' + $matches.var] = $entity
        $summary = "create list of $entity"
        $mutationAction = [ordered]@{
            actionKind = "Create"
            entity = $entity
            memberSummary = $null
        }
    }
    elseif ($normalized -match '^\$?(?<var>[A-Za-z0-9_]+)\s*=\s*CREATE (?<entity>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)(?<rest>.*)$') {
        $entity = $matches.entity
        $rest = $matches.rest.Trim()
        $variableTypeMap['$' + $matches.var] = $entity
        $summary = "create $entity"
        if (-not [string]::IsNullOrWhiteSpace($rest)) {
            $summary += " $rest"
        }
        $mutationAction = [ordered]@{
            actionKind = "Create"
            entity = $entity
            memberSummary = ConvertTo-MxCliNullIfBlank -Value $rest
        }
    }
    elseif ($normalized -match '^RETRIEVE \$(?<var>[A-Za-z0-9_]+) FROM ASSOCIATION (?<association>[^;]+)$') {
        $association = $matches.association.Trim()
        $summary = "retrieve over association $association"
        $retrieveAction = [ordered]@{
            sourceKind = "Association"
            entity = $null
            association = $association
            xPath = $null
        }
    }
    elseif ($normalized -match '^RETRIEVE \$(?<var>[A-Za-z0-9_]+) FROM (?<entity>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)(?<rest>.*)$') {
        $entity = $matches.entity
        $rest = $matches.rest.Trim()
        $variableTypeMap['$' + $matches.var] = $entity
        $summary = "retrieve from $entity"
        if (-not [string]::IsNullOrWhiteSpace($rest)) {
            $summary += " $rest"
        }
        $xPath = $null
        if ($rest -match '\bWHERE\s+(?<where>.+?)(?:\s+LIMIT\s+\d+)?$') {
            $xPath = $matches.where.Trim()
        }
        $retrieveAction = [ordered]@{
            sourceKind = "Database"
            entity = $entity
            association = $null
            xPath = $xPath
        }
    }
    elseif ($normalized -match '^SHOW PAGE (?<page>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)') {
        $targetPage = $matches.page
        $summary = "show page $targetPage"
        $showPageAction = [ordered]@{
            targetPage = $targetPage
        }
    }
    elseif ($normalized -match "^SHOW MESSAGE '(?<message>.*)' TYPE (?<type>[A-Za-z0-9_]+)") {
        $summary = "show message ($($matches.message), type=$($matches.type))"
    }
    elseif ($normalized -match '^COMMIT (?<target>[^;]+)$') {
        $target = $matches.target.Trim()
        $summary = "commit $target"
        $entity = $null
        foreach ($candidate in @($VariableTypeMap.Keys)) {
            if ($target -match [regex]::Escape($candidate)) {
                $entity = $VariableTypeMap[$candidate]
                break
            }
        }
        $mutationAction = [ordered]@{
            actionKind = "Commit"
            entity = $entity
            memberSummary = $null
        }
    }
    elseif ($normalized -match '^DELETE (?<target>[^;]+)$') {
        $target = $matches.target.Trim()
        $summary = "delete $target"
        $entity = $null
        foreach ($candidate in @($VariableTypeMap.Keys)) {
            if ($target -match [regex]::Escape($candidate)) {
                $entity = $VariableTypeMap[$candidate]
                break
            }
        }
        $mutationAction = [ordered]@{
            actionKind = "Delete"
            entity = $entity
            memberSummary = $null
        }
    }
    elseif ($normalized -match '^CHANGE (?<target>[^;]+)$') {
        $target = $matches.target.Trim()
        $summary = "change $target"
        $entity = $null
        foreach ($candidate in @($VariableTypeMap.Keys)) {
            if ($target -match [regex]::Escape($candidate)) {
                $entity = $VariableTypeMap[$candidate]
                break
            }
        }
        $memberSummary = $null
        if ($target -match '\((?<members>[^)]*)\)') {
            $memberSummary = $matches.members.Trim()
        }
        $mutationAction = [ordered]@{
            actionKind = "Change"
            entity = $entity
            memberSummary = $memberSummary
        }
    }
    elseif ($normalized -match '^CLOSE PAGE$') {
        $summary = "close page"
    }
    elseif ($normalized -match '^RETURN (?<result>.+)$') {
        $summary = "return $($matches.result.Trim())"
    }
    elseif ($normalized -match '^-- Unsupported action type:\s*(?<name>.+)$') {
        $summary = $matches.name.Trim()
    }
    elseif ($normalized -match '^-- Unknown action:\s*(?<name>.+)$') {
        $summary = $matches.name.Trim()
    }

    return [pscustomobject]@{
        nodeType = $nodeType
        summary = $summary
        detail = $detail
        calls = @($callInfo)
        retrieveAction = $retrieveAction
        showPageAction = $showPageAction
        mutationAction = $mutationAction
    }
}

function New-MxCliNodeId {
    param(
        [int]$Index,
        [string]$Hint
    )

    $hintValue = if ([string]::IsNullOrWhiteSpace($Hint)) { "node" } else { $Hint }
    $safeHint = ($hintValue.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
    if ([string]::IsNullOrWhiteSpace($safeHint)) {
        $safeHint = "node"
    }
    return ("n{0:D3}-{1}" -f $Index, $safeHint)
}

function Test-MxCliQualifiedName {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    return ($Value.Trim() -match '^[A-Za-z0-9_]+\.[A-Za-z0-9_]+$')
}

function Resolve-MxCliCatalogQualifiedName {
    param(
        [string]$QualifiedName,
        [string]$ModuleName,
        [string]$Name
    )

    $candidate = ConvertTo-MxCliNullIfBlank -Value $QualifiedName
    if (-not [string]::IsNullOrWhiteSpace($candidate)) {
        if ($candidate.IndexOf("...") -ge 0 -or $candidate.IndexOf([char]0x2026) -ge 0) {
            $candidate = $null
        }
    }

    if (Test-MxCliQualifiedName -Value $candidate) {
        return $candidate
    }

    $module = ConvertTo-MxCliNullIfBlank -Value $ModuleName
    $localName = ConvertTo-MxCliNullIfBlank -Value $Name
    if (-not [string]::IsNullOrWhiteSpace($module) -and -not [string]::IsNullOrWhiteSpace($localName)) {
        $rebuilt = "$module.$localName"
        if (Test-MxCliQualifiedName -Value $rebuilt) {
            return $rebuilt
        }
    }

    return $candidate
}

function Get-MxCliDescribeCandidates {
    param(
        [string]$PrimaryQualifiedName,
        [string]$RawQualifiedName,
        [string]$ModuleName,
        [string]$Name
    )

    $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $list = New-Object 'System.Collections.Generic.List[string]'

    foreach ($value in @(
            $PrimaryQualifiedName,
            $RawQualifiedName,
            $(if (-not [string]::IsNullOrWhiteSpace($ModuleName) -and -not [string]::IsNullOrWhiteSpace($Name)) { "$ModuleName.$Name" } else { $null })
        )) {
        $clean = ConvertTo-MxCliNullIfBlank -Value $value
        if ([string]::IsNullOrWhiteSpace($clean)) {
            continue
        }
        if (-not (Test-MxCliQualifiedName -Value $clean)) {
            continue
        }
        if ($set.Add($clean)) {
            $list.Add($clean) | Out-Null
        }
    }

    return @($list.ToArray())
}

function Get-MxCliFlowDefinition {
    param(
        [string]$ProjectPath,
        [object]$FlowRow
    )

    $moduleName = Get-MxCliJsonRowValue -Row $FlowRow -ColumnName "ModuleName"
    $localName = Get-MxCliJsonRowValue -Row $FlowRow -ColumnName "Name"
    $rawQualifiedName = Get-MxCliJsonRowValue -Row $FlowRow -ColumnName "QualifiedName"
    $qualifiedName = Resolve-MxCliCatalogQualifiedName -QualifiedName $rawQualifiedName -ModuleName $moduleName -Name $localName
    if ([string]::IsNullOrWhiteSpace($qualifiedName)) {
        throw "Flow row could not be resolved to a valid qualified name (Module='$moduleName', Name='$localName', QualifiedName='$rawQualifiedName')."
    }
    $flowId = Get-MxCliJsonRowValue -Row $FlowRow -ColumnName "Id"
    $kind = ConvertTo-MxCliFlowKind -RawType (Get-MxCliJsonRowValue -Row $FlowRow -ColumnName "MicroflowType")

    $result = $null
    $lastDescribeError = $null
    $describeCandidates = @(Get-MxCliDescribeCandidates -PrimaryQualifiedName $qualifiedName -RawQualifiedName $rawQualifiedName -ModuleName $moduleName -Name $localName)
    foreach ($candidate in @($describeCandidates)) {
        try {
            $result = Invoke-MxCliCommand -Arguments @("describe", "microflow", $candidate, "-p", $ProjectPath) -ThrowOnError
            $qualifiedName = $candidate
            break
        }
        catch {
            $lastDescribeError = $_
        }
    }

    if ($null -eq $result) {
        if ($kind -ne "Nanoflow") {
            if ($null -ne $lastDescribeError) {
                throw $lastDescribeError
            }
            throw "mxcli describe microflow failed for $qualifiedName."
        }

        $startNodeId = New-MxCliNodeId -Index 1 -Hint "start"
        $endNodeId = New-MxCliNodeId -Index 2 -Hint "end"
        return [ordered]@{
            flowId = $flowId
            kind = $kind
            qualifiedName = $qualifiedName
            module = $moduleName
            nodes = @(
                [ordered]@{
                    nodeId = $startNodeId
                    nodeType = "StartEvent"
                    label = "StartEvent"
                    detail = $null
                    loopOwnerId = $null
                    isExecutable = $true
                    calls = @()
                },
                [ordered]@{
                    nodeId = $endNodeId
                    nodeType = "EndEvent"
                    label = "EndEvent"
                    detail = $null
                    loopOwnerId = $null
                    isExecutable = $true
                    calls = @()
                }
            )
            edges = @(
                [ordered]@{
                    edgeId = New-MxCliStableId -Prefix "edge" -Seed "$startNodeId->$endNodeId"
                    originNodeId = $startNodeId
                    destinationNodeId = $endNodeId
                    condition = $null
                    isErrorHandler = $false
                    originConnectionIndex = $null
                    destinationConnectionIndex = $null
                }
            )
            calls = @()
            startNodeIds = @($startNodeId)
            primaryExecutionOrderNodeIds = @($startNodeId, $endNodeId)
            pseudocode = @(
                "FLOW ${kind}: $qualifiedName",
                "Installed mxcli cannot describe nanoflows directly on this machine.",
                "1. START",
                "2. END"
            ) -join "`r`n"
            retrieveActions = @()
            decisionActions = @()
            showPageActions = @()
            mutationActions = @()
        }
    }

    $mdl = ConvertFrom-MxCliMdlOutput -Result $result
    $tokens = @(Get-MxCliMicroflowTokens -Lines @($mdl.Lines))
    $parameterMap = Get-MxCliVariableTypeMap -Parameters (Get-MxCliMicroflowHeaderParams -Lines @($mdl.Lines))

    $nodes = New-Object 'System.Collections.Generic.List[object]'
    $edges = New-Object 'System.Collections.Generic.List[object]'
    $calls = New-Object 'System.Collections.Generic.List[object]'
    $retrieveActions = New-Object 'System.Collections.Generic.List[object]'
    $decisionActions = New-Object 'System.Collections.Generic.List[object]'
    $showPageActions = New-Object 'System.Collections.Generic.List[object]'
    $mutationActions = New-Object 'System.Collections.Generic.List[object]'
    $pseudoLines = New-Object 'System.Collections.Generic.List[string]'

    $nodeIndex = 1
    $previousNodeId = $null
    $primaryOrder = New-Object 'System.Collections.Generic.List[string]'

    $startNodeId = New-MxCliNodeId -Index $nodeIndex -Hint "start"
    $startNode = [ordered]@{
        nodeId = $startNodeId
        nodeType = "StartEvent"
        label = "StartEvent"
        detail = $null
        loopOwnerId = $null
        isExecutable = $true
        calls = @()
    }
    $nodes.Add($startNode) | Out-Null
    $primaryOrder.Add($startNodeId) | Out-Null
    $pseudoLines.Add("1. START") | Out-Null
    $previousNodeId = $startNodeId
    $nodeIndex += 1
    $pseudoLineIndex = 2
    $pseudoDepth = 0

    foreach ($token in @($tokens)) {
        $kindToken = [string]$token.kind
        $text = [string]$token.text

        if ($kindToken -eq "endif") {
            if ($pseudoDepth -gt 0) { $pseudoDepth -= 1 }
            continue
        }
        if ($kindToken -eq "endloop") {
            if ($pseudoDepth -gt 0) { $pseudoDepth -= 1 }
            continue
        }
        if ($kindToken -eq "else") {
            if ($pseudoDepth -gt 0) { $pseudoDepth -= 1 }
            $indent = ("  " * $pseudoDepth)
            $pseudoLines.Add("$indent$($pseudoLineIndex). BRANCH else") | Out-Null
            $pseudoLineIndex += 1
            $pseudoDepth += 1
            continue
        }

        if ($kindToken -eq "if") {
            $expression = ($text -replace '^IF\s+', '' -replace '\s+THEN$', '').Trim()
            $nodeId = New-MxCliNodeId -Index $nodeIndex -Hint "decision"
            $node = [ordered]@{
                nodeId = $nodeId
                nodeType = "ExclusiveSplit"
                label = "IF expression=$expression"
                detail = "IF expression=$expression"
                loopOwnerId = $null
                isExecutable = $true
                calls = @()
            }
            $nodes.Add($node) | Out-Null
            $primaryOrder.Add($nodeId) | Out-Null
            if (-not [string]::IsNullOrWhiteSpace($previousNodeId)) {
                $edges.Add([ordered]@{
                    edgeId = New-MxCliStableId -Prefix "edge" -Seed "$previousNodeId->$nodeId"
                    originNodeId = $previousNodeId
                    destinationNodeId = $nodeId
                    condition = $null
                    isErrorHandler = $false
                    originConnectionIndex = $null
                    destinationConnectionIndex = $null
                }) | Out-Null
            }
            $previousNodeId = $nodeId
            $decisionActions.Add([ordered]@{
                nodeId = $nodeId
                summary = "IF $expression"
                caption = "IF"
                expression = $expression
            }) | Out-Null
            $indent = ("  " * $pseudoDepth)
            $pseudoLines.Add("$indent$($pseudoLineIndex). DECISION $expression") | Out-Null
            $pseudoLineIndex += 1
            $pseudoDepth += 1
            $nodeIndex += 1
            continue
        }

        if ($kindToken -eq "loop") {
            $loopText = $text.Trim()
            $nodeId = New-MxCliNodeId -Index $nodeIndex -Hint "loop"
            $node = [ordered]@{
                nodeId = $nodeId
                nodeType = "LoopedActivity"
                label = $loopText
                detail = $loopText
                loopOwnerId = $null
                isExecutable = $true
                calls = @()
            }
            $nodes.Add($node) | Out-Null
            $primaryOrder.Add($nodeId) | Out-Null
            if (-not [string]::IsNullOrWhiteSpace($previousNodeId)) {
                $edges.Add([ordered]@{
                    edgeId = New-MxCliStableId -Prefix "edge" -Seed "$previousNodeId->$nodeId"
                    originNodeId = $previousNodeId
                    destinationNodeId = $nodeId
                    condition = $null
                    isErrorHandler = $false
                    originConnectionIndex = $null
                    destinationConnectionIndex = $null
                }) | Out-Null
            }
            $previousNodeId = $nodeId
            $indent = ("  " * $pseudoDepth)
            $pseudoLines.Add("$indent$($pseudoLineIndex). LOOP $($loopText -replace '^LOOP\s+', '')") | Out-Null
            $pseudoLineIndex += 1
            $pseudoDepth += 1
            $nodeIndex += 1
            continue
        }

        $statement = Get-MxCliFlowStatementInfo -StatementText $text -VariableTypeMap $parameterMap
        $hint = if ($statement.summary -match '^([A-Za-z]+)') { $matches[1] } else { "action" }
        $nodeId = New-MxCliNodeId -Index $nodeIndex -Hint $hint
        $nodeCalls = New-Object 'System.Collections.Generic.List[object]'
        foreach ($call in @($statement.calls)) {
            $nodeCall = [ordered]@{
                callKind = [string]$call.callKind
                targetFlowName = [string]$call.targetFlowName
                sourceNodeId = $nodeId
            }
            $nodeCalls.Add($nodeCall) | Out-Null
            $calls.Add($nodeCall) | Out-Null
        }

        $node = [ordered]@{
            nodeId = $nodeId
            nodeType = [string]$statement.nodeType
            label = $statement.summary
            detail = $statement.detail
            loopOwnerId = $null
            isExecutable = $true
            calls = @($nodeCalls.ToArray())
        }
        $nodes.Add($node) | Out-Null
        $primaryOrder.Add($nodeId) | Out-Null
        if (-not [string]::IsNullOrWhiteSpace($previousNodeId)) {
            $edges.Add([ordered]@{
                edgeId = New-MxCliStableId -Prefix "edge" -Seed "$previousNodeId->$nodeId"
                originNodeId = $previousNodeId
                destinationNodeId = $nodeId
                condition = $null
                isErrorHandler = $false
                originConnectionIndex = $null
                destinationConnectionIndex = $null
            }) | Out-Null
        }
        $previousNodeId = $nodeId

        if ($null -ne $statement.retrieveAction) {
            $retrieveActions.Add([ordered]@{
                nodeId = $nodeId
                summary = $statement.summary
                sourceKind = $statement.retrieveAction.sourceKind
                entity = $statement.retrieveAction.entity
                association = $statement.retrieveAction.association
                xPath = $statement.retrieveAction.xPath
            }) | Out-Null
        }

        if ($null -ne $statement.showPageAction) {
            $showPageActions.Add([ordered]@{
                nodeId = $nodeId
                summary = $statement.summary
                targetPage = $statement.showPageAction.targetPage
            }) | Out-Null
        }

        if ($null -ne $statement.mutationAction) {
            $mutationActions.Add([ordered]@{
                nodeId = $nodeId
                actionKind = $statement.mutationAction.actionKind
                summary = $statement.summary
                entity = $statement.mutationAction.entity
                memberSummary = $statement.mutationAction.memberSummary
            }) | Out-Null
        }

        $indent = ("  " * $pseudoDepth)
        $pseudoLines.Add("$indent$($pseudoLineIndex). ACTION $($statement.summary)") | Out-Null
        $pseudoLineIndex += 1
        $nodeIndex += 1
    }

    $endNodeId = New-MxCliNodeId -Index $nodeIndex -Hint "end"
    $endNode = [ordered]@{
        nodeId = $endNodeId
        nodeType = "EndEvent"
        label = "EndEvent"
        detail = $null
        loopOwnerId = $null
        isExecutable = $true
        calls = @()
    }
    $nodes.Add($endNode) | Out-Null
    $primaryOrder.Add($endNodeId) | Out-Null
    if (-not [string]::IsNullOrWhiteSpace($previousNodeId)) {
        $edges.Add([ordered]@{
            edgeId = New-MxCliStableId -Prefix "edge" -Seed "$previousNodeId->$endNodeId"
            originNodeId = $previousNodeId
            destinationNodeId = $endNodeId
            condition = $null
            isErrorHandler = $false
            originConnectionIndex = $null
            destinationConnectionIndex = $null
        }) | Out-Null
    }
    $pseudoLines.Add("$($pseudoLineIndex). END") | Out-Null

    $pseudocode = @(
        "FLOW ${kind}: $qualifiedName",
        "Linearised execution evidence from mxcli describe output",
        $pseudoLines.ToArray()
    ) -join "`r`n"

    return [ordered]@{
        flowId = $flowId
        kind = $kind
        qualifiedName = $qualifiedName
        module = $moduleName
        nodes = @($nodes.ToArray())
        edges = @($edges.ToArray())
        calls = @($calls.ToArray())
        startNodeIds = @($startNodeId)
        primaryExecutionOrderNodeIds = @($primaryOrder.ToArray())
        pseudocode = $pseudocode
        retrieveActions = @($retrieveActions.ToArray())
        decisionActions = @($decisionActions.ToArray())
        showPageActions = @($showPageActions.ToArray())
        mutationActions = @($mutationActions.ToArray())
    }
}

function Get-MxCliPageClientActions {
    param([string[]]$Lines)

    $actions = New-Object 'System.Collections.Generic.List[object]'
    $currentWidgetId = $null

    foreach ($line in @($Lines)) {
        $trimmed = $line.Trim()
        if ($trimmed -match '^[A-Z][A-Z0-9_]*\s+(?<id>[A-Za-z0-9_]+)\s*\(') {
            $currentWidgetId = $matches.id
        }
        if ($trimmed -notmatch '^Action:\s*(?<action>.+?)(?:,\s*)?$') {
            continue
        }

        $actionText = $matches.action.Trim().TrimEnd(",")
        $actionId = if ([string]::IsNullOrWhiteSpace($currentWidgetId)) {
            New-MxCliStableId -Prefix "action" -Seed $actionText
        } else {
            $currentWidgetId
        }

        $actionType = $null
        $targetPage = $null
        $flowName = $null
        $summary = $actionText

        if ($actionText -match '^CREATE_OBJECT\s+(?<entity>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)\s+THEN\s+SHOW_PAGE\s+(?<page>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
            $actionType = "CreateObjectClientAction"
            $targetPage = $matches.page
            $summary = "CreateObjectClientAction, page=$targetPage"
        }
        elseif ($actionText -match '^SHOW_PAGE\s+(?<page>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
            $actionType = "PageClientAction"
            $targetPage = $matches.page
            $summary = "PageClientAction, page=$targetPage"
        }
        elseif ($actionText -match '^CALL_MICROFLOW\s+(?<flow>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
            $actionType = "MicroflowClientAction"
            $flowName = $matches.flow
            $summary = "MicroflowClientAction, flow=$flowName"
        }
        elseif ($actionText -eq "SAVE_CHANGES CLOSE_PAGE" -or $actionText -eq "SAVE_CHANGES") {
            $actionType = "SaveChangesClientAction"
            $summary = "SaveChangesClientAction"
        }
        elseif ($actionText -eq "CANCEL_CHANGES CLOSE_PAGE" -or $actionText -eq "CANCEL_CHANGES") {
            $actionType = "CancelChangesClientAction"
            $summary = "CancelChangesClientAction"
        }
        elseif ($actionText -eq "DELETE_OBJECT CLOSE_PAGE" -or $actionText -eq "DELETE_OBJECT") {
            $actionType = "DeleteClientAction"
            $summary = "DeleteClientAction"
        }

        if ([string]::IsNullOrWhiteSpace($actionType)) {
            continue
        }

        $actions.Add([ordered]@{
            actionId = $actionId
            actionType = $actionType
            summary = $summary
            targetPage = $targetPage
            flowName = $flowName
        }) | Out-Null
    }

    return @($actions.ToArray())
}

function Get-MxCliPageDataSources {
    param(
        [string[]]$Lines,
        [object[]]$Parameters
    )

    $parameterMap = @{}
    foreach ($parameter in @($Parameters)) {
        $parameterMap['$' + [string]$parameter.name] = [string]$parameter.entityType
    }

    $sources = New-Object 'System.Collections.Generic.List[object]'
    foreach ($line in @($Lines)) {
        $trimmed = $line.Trim()
        if ($trimmed -notmatch '^[A-Z][A-Z0-9_]*\s+(?<id>[A-Za-z0-9_]+)\s*\((?<rest>.*DataSource:\s*(?<ds>[^,)]+(?:\s+FROM\s+[A-Za-z0-9_]+\.[A-Za-z0-9_]+)?))') {
            continue
        }

        $sourceId = $matches.id
        $rawSource = $matches.ds.Trim()
        $summary = $rawSource
        $sourceType = "Unknown"
        $entity = $null
        $constraint = $null
        $flowName = $null

        if ($rawSource -match '^MICROFLOW\s+(?<flow>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
            $sourceType = "Microflow"
            $flowName = $matches.flow
            $summary = "Microflow datasource: $flowName"
        }
        elseif ($rawSource -match '^DATABASE\s+FROM\s+(?<entity>[A-Za-z0-9_]+\.[A-Za-z0-9_]+)$') {
            $sourceType = "Database"
            $entity = $matches.entity
            $summary = "Database datasource: $entity"
        }
        elseif ($rawSource -match '^\$(?<param>[A-Za-z0-9_]+)$') {
            $parameterName = '$' + $matches.param
            $sourceType = "Parameter"
            if ($parameterMap.ContainsKey($parameterName)) {
                $entity = $parameterMap[$parameterName]
            }
            $summary = "Parameter datasource: $parameterName"
        }

        $sources.Add([ordered]@{
            sourceId = $sourceId
            sourceType = $sourceType
            entity = $entity
            constraint = $constraint
            flowName = $flowName
            summary = $summary
        }) | Out-Null
    }

    return @($sources.ToArray())
}

function Get-MxCliPageAllowedRoles {
    param([string[]]$Lines)

    $grantLine = @($Lines | Where-Object { $_ -match '^GRANT VIEW ON PAGE ' } | Select-Object -First 1)[0]
    if ([string]::IsNullOrWhiteSpace($grantLine)) {
        return @()
    }

    if ($grantLine -notmatch ' TO (?<roles>.+);$') {
        return @()
    }

    return @(Split-MxCliCommaSeparatedList -Text $matches.roles)
}

function Get-MxCliPageDefinition {
    param(
        [string]$ProjectPath,
        [object]$PageRow,
        [hashtable]$NavigationProvenanceByPage
    )

    $moduleName = Get-MxCliJsonRowValue -Row $PageRow -ColumnName "ModuleName"
    $rawQualifiedName = Get-MxCliJsonRowValue -Row $PageRow -ColumnName "QualifiedName"
    $localName = Get-MxCliJsonRowValue -Row $PageRow -ColumnName "Name"
    $qualifiedName = Resolve-MxCliCatalogQualifiedName -QualifiedName $rawQualifiedName -ModuleName $moduleName -Name $localName
    if ([string]::IsNullOrWhiteSpace($qualifiedName)) {
        throw "Page row could not be resolved to a valid qualified name (Module='$moduleName', Name='$localName', QualifiedName='$rawQualifiedName')."
    }
    $title = ConvertTo-MxCliNullIfBlank -Value (Get-MxCliJsonRowValue -Row $PageRow -ColumnName "Title")
    $layout = ConvertTo-MxCliNullIfBlank -Value (Get-MxCliJsonRowValue -Row $PageRow -ColumnName "LayoutRef")
    $url = ConvertTo-MxCliNullIfBlank -Value (Get-MxCliJsonRowValue -Row $PageRow -ColumnName "URL")

    $mdl = $null
    $lastDescribeError = $null
    $describeCandidates = @(Get-MxCliDescribeCandidates -PrimaryQualifiedName $qualifiedName -RawQualifiedName $rawQualifiedName -ModuleName $moduleName -Name $localName)
    foreach ($candidate in @($describeCandidates)) {
        try {
            $result = Invoke-MxCliCommand -Arguments @("describe", "page", $candidate, "-p", $ProjectPath) -ThrowOnError
            $mdl = ConvertFrom-MxCliMdlOutput -Result $result
            $qualifiedName = $candidate
            break
        }
        catch {
            $lastDescribeError = $_
        }
    }

    $parameters = @()
    $allowedRoles = @()
    $dataSources = @()
    $clientActions = @()
    if ($null -ne $mdl) {
        $headerText = Get-MxCliMdlHeaderText -Lines @($mdl.Lines)
        $parameters = @(Get-MxCliQualifiedNameHeaderParams -HeaderText $headerText)
        $allowedRoles = @(Get-MxCliPageAllowedRoles -Lines @($mdl.Lines))
        $dataSources = @(Get-MxCliPageDataSources -Lines @($mdl.Lines) -Parameters $parameters)
        $clientActions = @(Get-MxCliPageClientActions -Lines @($mdl.Lines))
    }
    elseif ($null -ne $lastDescribeError) {
        Write-Warning ("mxcli describe page failed for '{0}'. Continuing with catalog-only fallback. Detail: {1}" -f $qualifiedName, $lastDescribeError.Exception.Message)
    }

    $navigation = @()
    if ($null -ne $NavigationProvenanceByPage) {
        $seenProvenance = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($candidate in @($qualifiedName, $rawQualifiedName)) {
            if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
            if (-not $NavigationProvenanceByPage.ContainsKey($candidate)) { continue }
            foreach ($item in @($NavigationProvenanceByPage[$candidate].ToArray())) {
                $provenanceId = [string]$item.provenanceId
                if ([string]::IsNullOrWhiteSpace($provenanceId)) {
                    $provenanceId = New-MxCliStableId -Prefix "nav" -Seed ($candidate + "|" + [string]$item.summary)
                    $item.provenanceId = $provenanceId
                }
                if ($seenProvenance.Add($provenanceId)) {
                    $navigation += $item
                }
            }
        }
        $navigation = @($navigation | Sort-Object sourceType, summary)
    }

    $isPopup = $false
    if (-not [string]::IsNullOrWhiteSpace($layout) -and $layout -match 'PopupLayout$') {
        $isPopup = $true
    }

    if ([string]::IsNullOrWhiteSpace($localName) -and $qualifiedName.IndexOf(".") -gt 0) {
        $localName = $qualifiedName.Substring($qualifiedName.IndexOf(".") + 1)
    }
    if ([string]::IsNullOrWhiteSpace($title)) {
        $title = $localName
    }

    return [ordered]@{
        qualifiedName = $qualifiedName
        name = $localName
        title = $title
        layout = $layout
        allowedRoles = @($allowedRoles)
        parameters = @($parameters)
        isPopup = $isPopup
        popupWidth = 0
        popupHeight = 0
        popupResizable = $true
        url = $url
        excluded = $false
        dataSources = @($dataSources)
        clientActions = @($clientActions)
        navigationProvenance = @($navigation)
    }
}

function Get-MxCliSnippetDefinition {
    param(
        [string]$ProjectPath,
        [string]$QualifiedName
    )

    $result = $null
    $parameters = @()
    try {
        $result = Invoke-MxCliCommand -Arguments @("describe", "snippet", $QualifiedName, "-p", $ProjectPath) -ThrowOnError
    }
    catch {
        Write-Warning ("mxcli describe snippet failed for '{0}'. Continuing with metadata-only fallback. Detail: {1}" -f $QualifiedName, $_.Exception.Message)
    }

    if ($null -ne $result) {
        $mdl = ConvertFrom-MxCliMdlOutput -Result $result
        $headerText = Get-MxCliMdlHeaderText -Lines @($mdl.Lines)
        $parameters = @(Get-MxCliQualifiedNameHeaderParams -HeaderText $headerText)
    }

    $localName = if ($QualifiedName.IndexOf(".") -gt 0) { $QualifiedName.Substring($QualifiedName.IndexOf(".") + 1) } else { $QualifiedName }

    return [ordered]@{
        qualifiedName = $QualifiedName
        name = $localName
        type = "Web"
        parameters = @($parameters)
    }
}

function Get-MxCliConstantObjects {
    param(
        [string]$ProjectPath,
        [string]$ModuleName
    )

    $result = Invoke-MxCliCommand -Arguments @("show", "constants", $ModuleName, "-p", $ProjectPath) -ThrowOnError
    $table = ConvertFrom-MxCliMarkdownTableOutput -Result $result
    if ($table.RowCount -eq 0) {
        return @()
    }

    $constants = New-Object 'System.Collections.Generic.List[object]'
    foreach ($row in @($table.Rows)) {
        $name = Get-MxCliJsonRowValue -Row $row -ColumnName "Name"
        if ([string]::IsNullOrWhiteSpace($name)) {
            $name = Get-MxCliJsonRowValue -Row $row -ColumnName "Constant"
        }
        $type = Get-MxCliJsonRowValue -Row $row -ColumnName "Type"
        $value = Get-MxCliJsonRowValue -Row $row -ColumnName "Value"

        $constants.Add([ordered]@{
            name = $name
            type = ConvertTo-MxCliNullIfBlank -Value $type
            value = ConvertTo-MxCliNullIfBlank -Value $value
        }) | Out-Null
    }

    return @($constants.ToArray() | Sort-Object name)
}

function Get-MxCliScheduledEventObjects {
    param(
        [object[]]$ProjectTreeRecords,
        [string]$ModuleName
    )

    $events = New-Object 'System.Collections.Generic.List[object]'
    foreach ($record in @($ProjectTreeRecords | Where-Object { $_.module -eq $ModuleName -and $_.type -eq "scheduledevent" } | Sort-Object qualifiedName)) {
        $qualifiedName = [string]$record.qualifiedName
        $localName = if ([string]::IsNullOrWhiteSpace($qualifiedName) -or $qualifiedName.IndexOf(".") -lt 0) {
            [string]$record.label
        } else {
            $qualifiedName.Substring($qualifiedName.IndexOf(".") + 1)
        }
        $events.Add([ordered]@{
            qualifiedName = $qualifiedName
            name = $localName
            documentation = $null
            schedule = $null
            microflow = $qualifiedName
            nanoflow = $null
        }) | Out-Null
    }
    return @($events.ToArray())
}

function Get-MxCliAppInfoPseudoText {
    param(
        [object]$AppInfo,
        [object]$UserRoles
    )

    $security = $null
    if ($null -ne $UserRoles -and $UserRoles.PSObject.Properties.Name -contains "projectSecurity") {
        $security = $UserRoles.projectSecurity
    }

    return @"
# Application Info
Schema version: $([string]$AppInfo.schemaVersion)
Generated: $(ConvertTo-MxCliDisplayDate -UtcText ([string]$AppInfo.generatedAtUtc))
Source MPR: $([string]$AppInfo.sourceMprPath)
Source dump: none (mxcli)

## Summary
Modules: $([int]$AppInfo.summary.moduleCount)
Entities: $([int]$AppInfo.summary.entityCount)
Associations: $([int]$AppInfo.summary.associationCount)
Enumerations: $([int]$AppInfo.summary.enumerationCount)
Flows: $([int]$AppInfo.summary.flowCount) (Microflows: $([int]$AppInfo.summary.microflowCount), Nanoflows: $([int]$AppInfo.summary.nanoflowCount), Rules: $($AppInfo.summary.ruleCount), Workflows: $([int]$AppInfo.summary.workflowCount))

## Security
Security level: $([string]$security.securityLevel)
Admin user: $([string]$security.adminUserName)
Guest access: $(if ($security.enableGuestAccess) { 'yes' } else { 'no' })
Guest role: $([string]$security.guestUserRoleName)
"@
}

function Get-MxCliUserRolesPseudoText {
    param([object]$UserRoles)

    $lines = New-Object 'System.Collections.Generic.List[string]'
    $roles = @($UserRoles.projectSecurity.userRoles | Sort-Object name)
    $lines.Add("# User Roles") | Out-Null
    $lines.Add("Roles: $($roles.Count)") | Out-Null
    $lines.Add("") | Out-Null

    foreach ($role in @($roles)) {
        $lines.Add("USER_ROLE $([string]$role.name)") | Out-Null
        $lines.Add("  Module roles: $(Join-MxCliListOrDefault -Items @($role.moduleRoles))") | Out-Null
        $lines.Add("  Manage all roles: $(if ($role.manageAllRoles) { 'yes' } else { 'no' })") | Out-Null
        $lines.Add("  Check security: $(if ($role.checkSecurity) { 'yes' } else { 'no' })") | Out-Null
        $lines.Add("") | Out-Null
    }

    return (($lines.ToArray()) -join "`r`n").TrimEnd()
}

function Get-MxCliModuleSummaryPseudoText {
    param(
        [string]$Title,
        [object[]]$Modules
    )

    $lines = New-Object 'System.Collections.Generic.List[string]'
    $lines.Add("# $Title") | Out-Null
    $lines.Add("Total modules: $(@($Modules).Count)") | Out-Null
    $lines.Add("") | Out-Null

    foreach ($module in @($Modules | Sort-Object module)) {
        $category = if ($module.PSObject.Properties.Name -contains "category") { [string]$module.category } else { "Marketplace" }
        $lines.Add("MODULE $([string]$module.module) ($category)") | Out-Null
        if ($module.PSObject.Properties.Name -contains "moduleRoles" -and @($module.moduleRoles).Count -gt 0) {
            $lines.Add("  Roles: $(Join-MxCliListOrDefault -Items @($module.moduleRoles | ForEach-Object { [string]$_.name }))") | Out-Null
        }
        $constantCount = if ($module.PSObject.Properties.Name -contains "constantCount") { [int]$module.constantCount } else { 0 }
        $lines.Add("  Entities: $([int]$module.entityCount), Flows: $([int]$module.flowCount), Pages: $([int]$module.pageCount), Constants: $constantCount") | Out-Null
        $lines.Add("") | Out-Null
    }

    return (($lines.ToArray()) -join "`r`n").TrimEnd()
}

function Get-MxCliMarketplaceModulesPseudoText {
    param([object[]]$Modules)

    $lines = New-Object 'System.Collections.Generic.List[string]'
    $lines.Add("# Marketplace Modules") | Out-Null
    $lines.Add("Total: $(@($Modules).Count)") | Out-Null
    $lines.Add("") | Out-Null

    foreach ($module in @($Modules | Sort-Object module)) {
        $lines.Add("MODULE $([string]$module.module)") | Out-Null
        if (@($module.moduleRoles).Count -gt 0) {
            $lines.Add("  Roles: $(Join-MxCliListOrDefault -Items @($module.moduleRoles | ForEach-Object { [string]$_.name }))") | Out-Null
        }
        $lines.Add("  Entities: $([int]$module.entityCount), Flows: $([int]$module.flowCount), Pages: $([int]$module.pageCount)") | Out-Null
        $lines.Add("") | Out-Null
    }

    return (($lines.ToArray()) -join "`r`n").TrimEnd()
}

function Get-MxCliDomainModelPseudoText {
    param([object]$DomainModelObject)

    $entities = @($DomainModelObject.domainModel.entities | Sort-Object name)
    $associations = @($DomainModelObject.domainModel.associations | Sort-Object name)
    $enumerations = @($DomainModelObject.domainModel.enumerations | Sort-Object name)

    $lines = New-Object 'System.Collections.Generic.List[string]'
    $lines.Add("# Domain Model: $([string]$DomainModelObject.module)") | Out-Null
    $lines.Add("Entities: $($entities.Count), Associations: $($associations.Count), Enumerations: $($enumerations.Count)") | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add("## Entities") | Out-Null

    foreach ($entity in @($entities)) {
        $persistable = if ($entity.isPersistable) { "persistent" } else { "non-persistent" }
        $generalization = if ([string]::IsNullOrWhiteSpace([string]$entity.generalization)) { "" } else { ", generalization=$([string]$entity.generalization)" }
        $lines.Add("- ENTITY $([string]$entity.name) ($persistable$generalization)") | Out-Null
        foreach ($attribute in @($entity.attributes | Sort-Object name)) {
            $lines.Add("  - ATTR $([string]$attribute.name): $([string]$attribute.type)") | Out-Null
        }
        foreach ($rule in @($entity.accessRules)) {
            $defaultAccess = if ($null -eq $rule.defaultMemberAccessRights) { "Unknown" } else { [string]$rule.defaultMemberAccessRights }
            $lines.Add("  - ACCESS_RULE $([string]$rule.ruleKey) [$((@($rule.moduleRoles) -join ', '))] Create=$(if ($rule.allowCreate) { 'yes' } else { 'no' }), Delete=$(if ($rule.allowDelete) { 'yes' } else { 'no' }), Default=$defaultAccess") | Out-Null
            if (-not [string]::IsNullOrWhiteSpace([string]$rule.xPathConstraint)) {
                $lines.Add("    XPath: $([string]$rule.xPathConstraint)") | Out-Null
            }
            foreach ($member in @($rule.memberAccesses)) {
                $lines.Add("    - MEMBER $([string]$member.memberName): $([string]$member.accessRights)") | Out-Null
            }
        }
    }

    $lines.Add("") | Out-Null
    $lines.Add("## Associations") | Out-Null
    foreach ($association in @($associations)) {
        $lines.Add("- ASSOC $([string]$association.name): $([string]$association.parentEntity) [$([string]$association.cardinality)] $([string]$association.childEntity)") | Out-Null
    }

    $lines.Add("") | Out-Null
    $lines.Add("## Enumerations") | Out-Null
    foreach ($enumeration in @($enumerations)) {
        $lines.Add("- ENUM $([string]$enumeration.name): $(Join-MxCliListOrDefault -Items @($enumeration.values))") | Out-Null
    }

    return (($lines.ToArray()) -join "`r`n").TrimEnd()
}

function Get-MxCliFlowsPseudoText {
    param([object]$FlowsObject)

    $flows = @($FlowsObject.flows | Sort-Object qualifiedName)
    $lines = New-Object 'System.Collections.Generic.List[string]'
    $lines.Add("# Flows: $([string]$FlowsObject.module)") | Out-Null
    $lines.Add("Flows: $($flows.Count)") | Out-Null
    $lines.Add("") | Out-Null

    foreach ($flow in @($flows)) {
        $lines.Add([string]$flow.pseudocode) | Out-Null
        $lines.Add("") | Out-Null
    }

    return (($lines.ToArray()) -join "`r`n").TrimEnd()
}

function Get-MxCliPagesPseudoText {
    param([object]$PagesObject)

    $pages = @($PagesObject.pages | Sort-Object qualifiedName)
    $snippets = @($PagesObject.snippets | Sort-Object qualifiedName)
    $lines = New-Object 'System.Collections.Generic.List[string]'

    $lines.Add("# Pages: $([string]$PagesObject.module)") | Out-Null
    $lines.Add("Pages: $($pages.Count), Snippets: $($snippets.Count)") | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add("## Pages") | Out-Null
    $lines.Add("") | Out-Null

    foreach ($page in @($pages)) {
        $lines.Add("PAGE $([string]$page.qualifiedName)") | Out-Null
        $lines.Add("  Title: `"$([string]$page.title)`"") | Out-Null
        $layoutText = [string]$page.layout
        if ($page.isPopup) {
            $layoutText += " (popup $([int]$page.popupWidth)x$([int]$page.popupHeight), resizable=$(if ($page.popupResizable) { 'yes' } else { 'no' }))"
        }
        $lines.Add("  Layout: $layoutText") | Out-Null
        if (@($page.allowedRoles).Count -gt 0) {
            $lines.Add("  Allowed roles: $(Join-MxCliListOrDefault -Items @($page.allowedRoles))") | Out-Null
        }
        if (@($page.parameters).Count -gt 0) {
            $parameterText = @($page.parameters | ForEach-Object { "$([string]$_.name) ($([string]$_.entityType))" }) -join ", "
            $lines.Add("  Parameters: $parameterText") | Out-Null
        }
        if (@($page.dataSources).Count -gt 0) {
            $lines.Add("  Data sources: $(@($page.dataSources | ForEach-Object { [string]$_.summary }) -join ' | ')") | Out-Null
        }
        if (@($page.clientActions).Count -gt 0) {
            $lines.Add("  Client actions: $(@($page.clientActions | ForEach-Object { [string]$_.summary }) -join ' | ')") | Out-Null
        }
        if (@($page.navigationProvenance).Count -gt 0) {
            $lines.Add("  Navigation provenance: $(@($page.navigationProvenance | ForEach-Object { [string]$_.summary }) -join ' | ')") | Out-Null
        }
        if (-not [string]::IsNullOrWhiteSpace([string]$page.url)) {
            $lines.Add("  URL: $([string]$page.url)") | Out-Null
        }
        $lines.Add("") | Out-Null
    }

    $lines.Add("## Snippets") | Out-Null
    foreach ($snippet in @($snippets)) {
        $lines.Add("- SNIPPET $([string]$snippet.qualifiedName) ($([string]$snippet.type))") | Out-Null
        if (@($snippet.parameters).Count -gt 0) {
            $parameterText = @($snippet.parameters | ForEach-Object { "$([string]$_.name) ($([string]$_.entityType))" }) -join ", "
            $lines.Add("  Parameters: $parameterText") | Out-Null
        }
    }

    return (($lines.ToArray()) -join "`r`n").TrimEnd()
}

function Get-MxCliResourcesPseudoText {
    param([object]$ResourcesObject)

    $lines = New-Object 'System.Collections.Generic.List[string]'
    $lines.Add("# Resources: $([string]$ResourcesObject.module)") | Out-Null
    $lines.Add("Constants: $(@($ResourcesObject.constants).Count), Scheduled Events: $(@($ResourcesObject.scheduledEvents).Count)") | Out-Null
    $lines.Add("") | Out-Null

    if (@($ResourcesObject.constants).Count -gt 0) {
        $lines.Add("## Constants") | Out-Null
        foreach ($constant in @($ResourcesObject.constants)) {
            $lines.Add("CONSTANT $([string]$constant.name): $([string]$constant.type) = $([string]$constant.value)") | Out-Null
        }
        $lines.Add("") | Out-Null
    }

    if (@($ResourcesObject.scheduledEvents).Count -gt 0) {
        $lines.Add("## Scheduled Events") | Out-Null
        foreach ($event in @($ResourcesObject.scheduledEvents)) {
            $lines.Add("SCHEDULED_EVENT $([string]$event.qualifiedName)") | Out-Null
        }
        $lines.Add("") | Out-Null
    }

    if (@($ResourcesObject.otherResources).Count -gt 0) {
        $lines.Add("## Other Resources") | Out-Null
        foreach ($item in @($ResourcesObject.otherResources)) {
            $lines.Add("RESOURCE $([string]$item.kind): $([string]$item.name)") | Out-Null
        }
    }

    return (($lines.ToArray()) -join "`r`n").TrimEnd()
}

function Update-MxCliManifestFromArtifacts {
    param(
        [string]$ManifestPath,
        [object]$CurrentManifest,
        [System.Collections.Generic.List[object]]$Artifacts
    )

    $selectedModules = @()
    if ($null -ne $CurrentManifest.selectedModules) {
        $selectedModules = @($CurrentManifest.selectedModules | ForEach-Object { [string]$_ })
    }
    $artifactArray = @($Artifacts.ToArray())
    $manifestObject = [ordered]@{
        schemaVersion = [string]$CurrentManifest.schemaVersion
        generatedAtUtc = [string]$CurrentManifest.generatedAtUtc
        selectedModules = $selectedModules
        generator = "mxcli"
        artifactCount = $artifactArray.Count
        artifacts = $artifactArray
    }

    Write-JsonUtf8NoBom -Path $ManifestPath -Value $manifestObject
    return $manifestObject
}

function New-MxCliJsonV2FullRun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectPath,
        [Parameter(Mandatory)]
        [string]$AppOverviewRoot,
        [string]$RunId,
        [string[]]$SelectedModules,
        [switch]$SyncCurrent,
        [string]$CurrentAliasPath
    )

    $baseRun = New-MxCliJsonV2GeneralDomainRun `
        -ProjectPath $ProjectPath `
        -AppOverviewRoot $AppOverviewRoot `
        -RunId $RunId `
        -SelectedModules $SelectedModules

    $runFolder = $baseRun.RunFolder
    $manifestPath = $baseRun.ManifestPath
    $manifest = Get-Content -Raw $manifestPath | ConvertFrom-Json

    $artifacts = New-Object 'System.Collections.Generic.List[object]'
    $seenArtifactKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($artifact in @($manifest.artifacts)) {
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type ([string]$artifact.type) -Path ([string]$artifact.path)
    }

    $projectTree = @(Get-MxCliProjectTreeObject -ProjectPath $ProjectPath)
    $projectTreeRecords = @(Get-MxCliProjectTreeRecords -ProjectTree $projectTree)
    $navigationByPage = Get-MxCliNavigationProvenanceByPage -ProjectTree $projectTree

    $pageRows = @(Get-MxCliCatalogRows -ProjectPath $ProjectPath -Query "SELECT * FROM CATALOG.pages")
    $flowRows = @(Get-MxCliCatalogRows -ProjectPath $ProjectPath -Query "SELECT * FROM CATALOG.microflows")

    $generalDir = Join-Path $runFolder "general"
    $appInfoPath = Join-Path $generalDir "app-info.json"
    $userRolesPath = Join-Path $generalDir "user-roles.json"
    $allModulesPath = Join-Path $generalDir "all-modules.json"
    $marketplaceModulesPath = Join-Path $generalDir "marketplace-modules.json"

    $appInfo = Get-Content -Raw $appInfoPath | ConvertFrom-Json
    $userRoles = Get-Content -Raw $userRolesPath | ConvertFrom-Json
    $allModules = Get-Content -Raw $allModulesPath | ConvertFrom-Json
    $marketplaceModules = Get-Content -Raw $marketplaceModulesPath | ConvertFrom-Json

    $appInfoPseudoPath = Join-Path $generalDir "app-info.pseudo.txt"
    $userRolesPseudoPath = Join-Path $generalDir "user-roles.pseudo.txt"
    $allModulesPseudoPath = Join-Path $generalDir "all-modules.pseudo.txt"
    $marketplacePseudoPath = Join-Path $generalDir "marketplace-modules.pseudo.txt"

    Write-MxCliTextUtf8NoBom -Path $appInfoPseudoPath -Content (Get-MxCliAppInfoPseudoText -AppInfo $appInfo -UserRoles $userRoles)
    Write-MxCliTextUtf8NoBom -Path $userRolesPseudoPath -Content (Get-MxCliUserRolesPseudoText -UserRoles $userRoles)
    Write-MxCliTextUtf8NoBom -Path $allModulesPseudoPath -Content (Get-MxCliModuleSummaryPseudoText -Title "All Modules Overview" -Modules @($allModules.modules))
    Write-MxCliTextUtf8NoBom -Path $marketplacePseudoPath -Content (Get-MxCliMarketplaceModulesPseudoText -Modules @($marketplaceModules.modules))

    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-app-info-pseudo" -Path $appInfoPseudoPath
    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-user-roles-pseudo" -Path $userRolesPseudoPath
    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-all-modules-pseudo" -Path $allModulesPseudoPath
    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-marketplace-modules-pseudo" -Path $marketplacePseudoPath

    $selectedModuleNames = @($baseRun.Modules | ForEach-Object { [string]$_.Name })
    $moduleRecordByName = @{}
    foreach ($moduleRecord in @($baseRun.Modules)) {
        $moduleRecordByName[[string]$moduleRecord.Name] = $moduleRecord
    }
    $moduleCatalog = @(Get-OverviewModuleCatalog -RunFolder $runFolder -Manifest $manifest)
    $moduleCatalogByName = Get-OverviewModuleCatalogMap -ModuleCatalog $moduleCatalog

    foreach ($moduleName in @($selectedModuleNames | Sort-Object)) {
        $moduleRoot = Get-OverviewModuleFilePath -RootPath $runFolder -ModuleName $moduleName -FileName "" -ModuleCatalogByName $moduleCatalogByName
        if (-not (Test-Path $moduleRoot -PathType Container)) {
            New-Item -Path $moduleRoot -ItemType Directory -Force | Out-Null
        }

        $domainModelPath = Join-Path $moduleRoot "domain-model.json"
        $domainModelObject = Get-Content -Raw $domainModelPath | ConvertFrom-Json
        $domainPseudoPath = Join-Path $moduleRoot "domain-model.pseudo.txt"
        Write-MxCliTextUtf8NoBom -Path $domainPseudoPath -Content (Get-MxCliDomainModelPseudoText -DomainModelObject $domainModelObject)
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-domain-model-pseudo" -Path $domainPseudoPath

        $moduleFlowRows = @($flowRows | Where-Object { (Get-MxCliJsonRowValue -Row $_ -ColumnName "ModuleName") -eq $moduleName } | Sort-Object { Get-MxCliJsonRowValue -Row $_ -ColumnName "QualifiedName" })
        $moduleFlows = New-Object 'System.Collections.Generic.List[object]'
        foreach ($flowRow in @($moduleFlowRows)) {
            $moduleFlows.Add((Get-MxCliFlowDefinition -ProjectPath $ProjectPath -FlowRow $flowRow)) | Out-Null
        }

        $flowsObject = [ordered]@{
            module = $moduleName
            flows = @($moduleFlows.ToArray())
            callEdges = @(
                $moduleFlows |
                ForEach-Object {
                    $callerFlow = $_
                    foreach ($call in @($callerFlow.calls)) {
                        $targetFlow = [string]$call.targetFlowName
                        [ordered]@{
                            callerModule = $moduleName
                            callerFlow = [string]$callerFlow.qualifiedName
                            callerKind = [string]$callerFlow.kind
                            callKind = [string]$call.callKind
                            sourceNodeId = [string]$call.sourceNodeId
                            targetModule = $(if ($targetFlow.Contains(".")) { $targetFlow.Substring(0, $targetFlow.IndexOf(".")) } else { $null })
                            targetFlow = $targetFlow
                            isInternal = $(if ($targetFlow.Contains(".")) { $targetFlow.Substring(0, $targetFlow.IndexOf(".")) -eq $moduleName } else { $false })
                        }
                    }
                }
            )
        }

        $flowsPath = Join-Path $moduleRoot "flows.json"
        $flowsPseudoPath = Join-Path $moduleRoot "flows.pseudo.txt"
        Write-JsonUtf8NoBom -Path $flowsPath -Value $flowsObject
        Write-MxCliTextUtf8NoBom -Path $flowsPseudoPath -Content (Get-MxCliFlowsPseudoText -FlowsObject $flowsObject)
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-flows-json" -Path $flowsPath
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-flows-pseudo" -Path $flowsPseudoPath

        $modulePageRows = @()
        if ($moduleRecordByName.ContainsKey($moduleName) -and [int]$moduleRecordByName[$moduleName].PageCount -gt 0) {
            $modulePageRows = @($pageRows | Where-Object { (Get-MxCliJsonRowValue -Row $_ -ColumnName "ModuleName") -eq $moduleName } | Sort-Object { Get-MxCliJsonRowValue -Row $_ -ColumnName "QualifiedName" })
        }
        $modulePages = New-Object 'System.Collections.Generic.List[object]'
        foreach ($pageRow in @($modulePageRows)) {
            $modulePages.Add((Get-MxCliPageDefinition -ProjectPath $ProjectPath -PageRow $pageRow -NavigationProvenanceByPage $navigationByPage)) | Out-Null
        }

        $moduleSnippets = New-Object 'System.Collections.Generic.List[object]'
        foreach ($snippetRecord in @($projectTreeRecords | Where-Object { $_.module -eq $moduleName -and $_.type -eq "snippet" } | Sort-Object qualifiedName)) {
            $qualifiedName = [string]$snippetRecord.qualifiedName
            if ([string]::IsNullOrWhiteSpace($qualifiedName)) {
                continue
            }
            $moduleSnippets.Add((Get-MxCliSnippetDefinition -ProjectPath $ProjectPath -QualifiedName $qualifiedName)) | Out-Null
        }

        $pagesObject = [ordered]@{
            module = $moduleName
            pages = @($modulePages.ToArray())
            snippets = @($moduleSnippets.ToArray())
        }

        $pagesPath = Join-Path $moduleRoot "pages.json"
        $pagesPseudoPath = Join-Path $moduleRoot "pages.pseudo.txt"
        Write-JsonUtf8NoBom -Path $pagesPath -Value $pagesObject
        Write-MxCliTextUtf8NoBom -Path $pagesPseudoPath -Content (Get-MxCliPagesPseudoText -PagesObject $pagesObject)
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-pages-json" -Path $pagesPath
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-pages-pseudo" -Path $pagesPseudoPath

        $resourcesObject = [ordered]@{
            module = $moduleName
            constants = @(Get-MxCliConstantObjects -ProjectPath $ProjectPath -ModuleName $moduleName)
            scheduledEvents = @(Get-MxCliScheduledEventObjects -ProjectTreeRecords $projectTreeRecords -ModuleName $moduleName)
            otherResources = @()
        }

        $resourcesPath = Join-Path $moduleRoot "resources.json"
        $resourcesPseudoPath = Join-Path $moduleRoot "resources.pseudo.txt"
        Write-JsonUtf8NoBom -Path $resourcesPath -Value $resourcesObject
        Write-MxCliTextUtf8NoBom -Path $resourcesPseudoPath -Content (Get-MxCliResourcesPseudoText -ResourcesObject $resourcesObject)
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-resources-json" -Path $resourcesPath
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-resources-pseudo" -Path $resourcesPseudoPath
    }

    $debtRecords = New-Object 'System.Collections.Generic.List[object]'
    foreach ($moduleEntry in @($moduleCatalog | Where-Object { $_.Name -in $selectedModuleNames } | Sort-Object Name)) {
        Ensure-OverviewModuleSplitArtifacts `
            -TargetRunFolder $runFolder `
            -ModuleEntry $moduleEntry `
            -DebtRecords $debtRecords `
            -Artifacts $artifacts `
            -SeenArtifactKeys $seenArtifactKeys `
            -RunFolderName (Split-Path $runFolder -Leaf)
    }

    $updatedManifest = Update-MxCliManifestFromArtifacts -ManifestPath $manifestPath -CurrentManifest $manifest -Artifacts $artifacts

    if ($SyncCurrent) {
        Sync-AppOverviewCurrentAlias -RunFolder $runFolder -CurrentAliasPath $CurrentAliasPath -Manifest $updatedManifest -ModuleCatalogByName $moduleCatalogByName | Out-Null
    }

    return [pscustomobject]@{
        RunFolder = $runFolder
        ManifestPath = $manifestPath
        GeneratedAtUtc = [string]$updatedManifest.generatedAtUtc
        Modules = @($baseRun.Modules)
    }
}
