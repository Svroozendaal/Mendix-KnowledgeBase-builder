<#
.SYNOPSIS
    Shared mxcli resolution, execution, parsing, and catalog-stage helpers.

.DESCRIPTION
    Dot-source this file from creator scripts that need to call mxcli without
    changing the active legacy dump/parser default. The helpers in this file:

    - resolve mxcli from PATH only
    - capture stdout, stderr, exit code, and working directory context
    - separate known warning and status lines from payload data
    - parse validated output categories: table, MDL, and JSON
    - centralise the rule for when REFRESH CATALOG FULL or SOURCE is required

.EXAMPLE
    . "$PSScriptRoot/lib/mxcli-foundation.ps1"
    $result = Invoke-MxCliCommand -Arguments @("--version")
    $text = Get-MxCliTextOutput -Result $result
#>

$script:MxCliWarningPatterns = @(
    '^WARNING:\s',
    '^mxcli(?:\.exe)?\s*:\s*WARNING:\s'
)

$script:MxCliStatusPatterns = @(
    '^Connected to:\s',
    '^Loading cached catalog',
    '^Loading catalog',
    '^Building catalog',
    'Catalog ready',
    '^Generating report',
    '^Linting ',
    '^Refreshing catalog',
    '^Using '
)

$script:MxCliExecutionProfiles = @(
    [pscustomobject]@{
        Name = "Version"
        OutputKind = "Text"
        CatalogStage = "None"
        QuietMode = "NotSupported"
        Example = "mxcli --version"
        Notes = "No project path or catalog access is required."
    },
    [pscustomobject]@{
        Name = "Describe"
        OutputKind = "Mdl"
        CatalogStage = "Fast"
        QuietMode = "NotSupported"
        Example = "mxcli describe microflow Inspection.ACT_Task_Save -p <app.mpr>"
        Notes = "Use for describe entity, enumeration, page, and microflow output."
    },
    [pscustomobject]@{
        Name = "ShowOrCatalogTable"
        OutputKind = "Table"
        CatalogStage = "Fast"
        QuietMode = "NotSupported"
        Example = 'mxcli -p <app.mpr> -c "SELECT Name FROM CATALOG.modules"'
        Notes = "Use for show commands and fast catalog tables."
    },
    [pscustomobject]@{
        Name = "SearchJson"
        OutputKind = "Json"
        CatalogStage = "CommandManagedFull"
        QuietMode = "Preferred"
        Example = "mxcli search -p <app.mpr> Task --format json -q"
        Notes = "Use -q for clean JSON stdout."
    },
    [pscustomobject]@{
        Name = "LintJson"
        OutputKind = "Json"
        CatalogStage = "CommandManagedFull"
        QuietMode = "NotSupported"
        Example = "mxcli lint -p <app.mpr> --format json"
        Notes = "Strip stdout preamble lines before JSON parsing."
    },
    [pscustomobject]@{
        Name = "ReportJson"
        OutputKind = "Json"
        CatalogStage = "CommandManagedFull"
        QuietMode = "NotSupported"
        Example = "mxcli report -p <app.mpr> --format json"
        Notes = "Strip stdout preamble lines before JSON parsing."
    },
    [pscustomobject]@{
        Name = "FullCatalogQuery"
        OutputKind = "Table"
        CatalogStage = "Full"
        QuietMode = "NotSupported"
        Example = 'mxcli -p <app.mpr> -c "REFRESH CATALOG FULL; SELECT SourceName, TargetName FROM CATALOG.refs LIMIT 10"'
        Notes = "Use for refs, widgets, permissions, xpath_expressions, strings, and similar full-mode tables."
    }
)

$script:MxCliCatalogStagePlan = @(
    [pscustomobject]@{
        Stage = "None"
        ExplicitRefresh = "Never"
        Usage = "Version and pure CLI metadata"
        Notes = "Use for mxcli --version and PATH diagnostics."
    },
    [pscustomobject]@{
        Stage = "Fast"
        ExplicitRefresh = "Not required"
        Usage = "Describe commands, structure, project-tree, show modules, show associations, show constants, and catalog queries on fast tables"
        Notes = "Fast mode is enough for modules, entities, attributes, microflows, pages, snippets, layouts, enumerations, role_mappings, navigation tables, workflows, java actions, OData, business events, and database connections."
    },
    [pscustomobject]@{
        Stage = "CommandManagedFull"
        ExplicitRefresh = "Command handles it"
        Usage = "search, lint, and report"
        Notes = "These command families build or reuse the required full catalog themselves. Prefer search -q for clean JSON."
    },
    [pscustomobject]@{
        Stage = "Full"
        ExplicitRefresh = "REFRESH CATALOG FULL in the same -c batch"
        Usage = "Catalog queries for refs, activities, widgets, permissions, xpath_expressions, and strings"
        Notes = "Use an explicit refresh before querying full-mode catalog tables from the extraction layer."
    },
    [pscustomobject]@{
        Stage = "Source"
        ExplicitRefresh = "REFRESH CATALOG SOURCE in the same -c batch"
        Usage = "Catalog queries against the source FTS table"
        Notes = "Source mode implies full mode and is only needed for CATALOG.source."
    }
)

$script:MxCliCatalogTableStages = @{
    "modules" = "Fast"
    "entities" = "Fast"
    "attributes" = "Fast"
    "enumerations" = "Fast"
    "microflows" = "Fast"
    "nanoflows" = "Fast"
    "pages" = "Fast"
    "snippets" = "Fast"
    "layouts" = "Fast"
    "java_actions" = "Fast"
    "odata_clients" = "Fast"
    "odata_services" = "Fast"
    "workflows" = "Fast"
    "business_event_services" = "Fast"
    "database_connections" = "Fast"
    "navigation_profiles" = "Fast"
    "navigation_menu_items" = "Fast"
    "navigation_role_homes" = "Fast"
    "role_mappings" = "Fast"
    "objects" = "Fast"
    "activities" = "Full"
    "widgets" = "Full"
    "refs" = "Full"
    "permissions" = "Full"
    "xpath_expressions" = "Full"
    "strings" = "Full"
    "source" = "Source"
}

function Get-MxCliExecutionProfiles {
    return @($script:MxCliExecutionProfiles)
}

function Get-MxCliCatalogStagePlan {
    return @($script:MxCliCatalogStagePlan)
}

function Get-MxCliCatalogTableStages {
    return @(
        $script:MxCliCatalogTableStages.GetEnumerator() |
        Sort-Object Key |
        ForEach-Object {
            [pscustomobject]@{
                Table = $_.Key
                CatalogStage = $_.Value
            }
        }
    )
}

function Get-MxCliCatalogStageForTable {
    param([string]$TableName)

    if ([string]::IsNullOrWhiteSpace($TableName)) {
        throw "TableName is required."
    }

    $normalized = $TableName.Trim().ToLowerInvariant()
    if (-not $script:MxCliCatalogTableStages.ContainsKey($normalized)) {
        throw "Unknown mxcli catalog table: $TableName"
    }

    return [string]$script:MxCliCatalogTableStages[$normalized]
}

function Get-MxCliCatalogStageForTables {
    param([string[]]$TableNames)

    if ($null -eq $TableNames -or @($TableNames).Count -eq 0) {
        return "Fast"
    }

    $highest = "Fast"
    foreach ($tableName in @($TableNames)) {
        $stage = Get-MxCliCatalogStageForTable -TableName $tableName
        switch ($stage) {
            "Source" { return "Source" }
            "Full" { $highest = "Full" }
        }
    }

    return $highest
}

function Get-PreferredMxCliPath {
    param([string]$CandidatePath)

    if ([string]::IsNullOrWhiteSpace($CandidatePath)) {
        return $CandidatePath
    }

    $extension = [IO.Path]::GetExtension($CandidatePath)
    if ([string]::IsNullOrWhiteSpace($extension)) {
        $cmdVariant = $CandidatePath + ".cmd"
        if (Test-Path $cmdVariant -PathType Leaf) {
            return $cmdVariant
        }
    }

    return $CandidatePath
}

function Resolve-MxCliExecutable {
    $candidates = @("mxcli.exe", "mxcli.cmd", "mxcli")
    foreach ($candidate in $candidates) {
        $command = Get-Command $candidate -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -eq $command) {
            continue
        }

        $path = Get-PreferredMxCliPath -CandidatePath $command.Source
        if (-not [string]::IsNullOrWhiteSpace($path) -and (Test-Path $path -PathType Leaf)) {
            return (Resolve-Path $path).Path
        }
    }

    throw "mxcli was not found on PATH. Install it and confirm that 'mxcli --version' succeeds."
}

function Format-MxCliDisplayArgument {
    param([string]$Argument)

    if ($null -eq $Argument) { return '""' }
    if ($Argument.Length -eq 0) { return '""' }
    if ($Argument -notmatch '[\s"]') { return $Argument }

    return '"' + ($Argument -replace '"', '\"') + '"'
}

function ConvertTo-ProcessArguments {
    param([string[]]$Arguments)

    $formatted = foreach ($argument in @($Arguments)) {
        if ($null -eq $argument) {
            '""'
            continue
        }

        $value = [string]$argument
        if ($value.Length -eq 0) {
            '""'
            continue
        }

        if ($value -notmatch '[\s"]') {
            $value
            continue
        }

        $escaped = $value -replace '(\\*)"', '$1$1\"'
        $escaped = $escaped -replace '(\\+)$', '$1$1'
        '"' + $escaped + '"'
    }

    return ($formatted -join ' ')
}

function Split-MxCliLines {
    param([string]$Text)

    if ([string]::IsNullOrEmpty($Text)) {
        return @()
    }

    $normalized = $Text -replace "`r`n", "`n" -replace "`r", "`n"
    return @($normalized -split "`n")
}

function Test-MxCliWarningLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) {
        return $false
    }

    foreach ($pattern in $script:MxCliWarningPatterns) {
        if ($Line -match $pattern) {
            return $true
        }
    }

    return $false
}

function Test-MxCliStatusLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) {
        return $false
    }

    foreach ($pattern in $script:MxCliStatusPatterns) {
        if ($Line -match $pattern) {
            return $true
        }
    }

    return $false
}

function Get-MxCliPayloadStdOutLines {
    param(
        [pscustomobject]$Result,
        [switch]$PreserveBlankLines
    )

    $lines = @()
    foreach ($line in @($Result.StdOutLines)) {
        if (Test-MxCliWarningLine -Line $line) { continue }
        if (Test-MxCliStatusLine -Line $line) { continue }
        if (-not $PreserveBlankLines -and [string]::IsNullOrWhiteSpace($line)) { continue }
        $lines += $line
    }

    return $lines
}

function Assert-MxCliSuccess {
    param([pscustomobject]$Result)

    if ($null -eq $Result) {
        throw "MxCli result is required."
    }

    if ($Result.ExitCode -eq 0) {
        return
    }

    $detailLines = @()
    foreach ($line in @($Result.ErrorLines + $Result.StatusLines)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $detailLines += $line.Trim()
    }

    if ($detailLines.Count -eq 0) {
        foreach ($line in @($Result.StdOutLines + $Result.StdErrLines)) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $detailLines += $line.Trim()
        }
    }

    $detail = if ($detailLines.Count -gt 0) {
        ($detailLines | Select-Object -Unique) -join " | "
    } else {
        "No error text was captured."
    }

    throw "mxcli command failed with exit code $($Result.ExitCode). Command: $($Result.CommandLine). Detail: $detail"
}

function Invoke-MxCliCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$Arguments,
        [string]$WorkingDirectory = (Get-Location).Path,
        [switch]$UseQuietMode,
        [switch]$ThrowOnError
    )

    $mxcliPath = Resolve-MxCliExecutable
    $resolvedWorkingDirectory = [IO.Path]::GetFullPath($WorkingDirectory)
    if (-not (Test-Path $resolvedWorkingDirectory -PathType Container)) {
        throw "Working directory does not exist: $resolvedWorkingDirectory"
    }

    $effectiveArguments = New-Object System.Collections.Generic.List[string]
    foreach ($argument in @($Arguments)) {
        $effectiveArguments.Add([string]$argument) | Out-Null
    }

    if ($UseQuietMode -and -not ($effectiveArguments.Contains("-q") -or $effectiveArguments.Contains("--quiet"))) {
        $effectiveArguments.Add("-q") | Out-Null
    }

    $isCmdShim = @(".cmd", ".bat") -contains ([IO.Path]::GetExtension($mxcliPath).ToLowerInvariant())
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = $resolvedWorkingDirectory

    if ($isCmdShim) {
        $commandText = (Format-MxCliDisplayArgument -Argument $mxcliPath)
        if ($effectiveArguments.Count -gt 0) {
            $commandText = $commandText + " " + (ConvertTo-ProcessArguments -Arguments $effectiveArguments)
        }

        $psi.FileName = $env:ComSpec
        if ([string]::IsNullOrWhiteSpace($psi.FileName)) {
            $psi.FileName = "cmd.exe"
        }

        $psi.Arguments = "/d /s /c " + (Format-MxCliDisplayArgument -Argument $commandText)
    } else {
        $psi.FileName = $mxcliPath
        $psi.Arguments = ConvertTo-ProcessArguments -Arguments $effectiveArguments
    }

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi

    $startedAtUtc = (Get-Date).ToUniversalTime()
    if (-not $process.Start()) {
        throw "Failed to start mxcli process."
    }

    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    $finishedAtUtc = (Get-Date).ToUniversalTime()

    $stdoutLines = @(Split-MxCliLines -Text $stdout)
    $stderrLines = @(Split-MxCliLines -Text $stderr)
    $warningLines = @(
        @($stdoutLines + $stderrLines) |
        Where-Object { Test-MxCliWarningLine -Line $_ } |
        Select-Object -Unique
    )
    $statusLines = @(
        $stdoutLines |
        Where-Object { Test-MxCliStatusLine -Line $_ } |
        Select-Object -Unique
    )
    $errorLines = @(
        $stderrLines |
        Where-Object {
            -not [string]::IsNullOrWhiteSpace($_) -and
            -not (Test-MxCliWarningLine -Line $_)
        }
    )

    $result = [pscustomobject]@{
        ExecutablePath = $mxcliPath
        WorkingDirectory = $resolvedWorkingDirectory
        Arguments = @($effectiveArguments)
        CommandLine = "mxcli " + ((@($effectiveArguments) | ForEach-Object { Format-MxCliDisplayArgument -Argument $_ }) -join " ")
        ExitCode = $process.ExitCode
        StartedAtUtc = $startedAtUtc.ToString("o")
        FinishedAtUtc = $finishedAtUtc.ToString("o")
        DurationMs = [int][Math]::Round(($finishedAtUtc - $startedAtUtc).TotalMilliseconds)
        StdOut = $stdout
        StdErr = $stderr
        StdOutLines = $stdoutLines
        StdErrLines = $stderrLines
        WarningLines = $warningLines
        StatusLines = $statusLines
        ErrorLines = $errorLines
    }

    if ($ThrowOnError) {
        Assert-MxCliSuccess -Result $result
    }

    return $result
}

function Get-MxCliTextOutput {
    param([pscustomobject]$Result)

    Assert-MxCliSuccess -Result $Result
    $text = (Get-MxCliPayloadStdOutLines -Result $Result -PreserveBlankLines) -join "`n"
    return $text.Trim()
}

function ConvertFrom-MxCliMdlOutput {
    param([pscustomobject]$Result)

    Assert-MxCliSuccess -Result $Result
    $payloadLines = @(Get-MxCliPayloadStdOutLines -Result $Result -PreserveBlankLines)
    $text = ($payloadLines -join "`n").Trim()

    return [pscustomobject]@{
        Kind = "Mdl"
        Text = $text
        Lines = $payloadLines
        LineCount = @($payloadLines | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count
        WarningLines = @($Result.WarningLines)
        StatusLines = @($Result.StatusLines)
    }
}

function Get-MxCliJsonPayloadText {
    param([pscustomobject]$Result)

    Assert-MxCliSuccess -Result $Result
    $payloadLines = @(Get-MxCliPayloadStdOutLines -Result $Result -PreserveBlankLines)
    if ($payloadLines.Count -eq 0) {
        throw "mxcli JSON output did not contain a payload after filtering status lines."
    }

    return (($payloadLines -join "`n").Trim())
}

function ConvertFrom-MxCliJsonOutput {
    param([pscustomobject]$Result)

    $jsonText = Get-MxCliJsonPayloadText -Result $Result
    $data = $jsonText | ConvertFrom-Json

    return [pscustomobject]@{
        Kind = "Json"
        Text = $jsonText
        Data = $data
        WarningLines = @($Result.WarningLines)
        StatusLines = @($Result.StatusLines)
    }
}

function Test-MxCliTableSeparatorLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) {
        return $false
    }

    return $Line.Trim() -match '^\|\s*:?-{2,}:?\s*(\|\s*:?-{2,}:?\s*)+\|$'
}

function ConvertFrom-MxCliTableRow {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) {
        return @()
    }

    $trimmed = $Line.Trim()
    if (-not ($trimmed.StartsWith("|") -and $trimmed.EndsWith("|"))) {
        return @()
    }

    $inner = $trimmed.Substring(1, $trimmed.Length - 2)
    return @($inner.Split("|") | ForEach-Object { $_.Trim() })
}

function ConvertFrom-MxCliMarkdownTableOutput {
    param([pscustomobject]$Result)

    Assert-MxCliSuccess -Result $Result

    $lines = @($Result.StdOutLines)
    $emptyMessage = $null
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -match '^No .+ found\.$') {
            $emptyMessage = $trimmed
            break
        }
    }

    $tableStart = -1
    for ($index = 0; $index -lt $lines.Count; $index += 1) {
        $trimmed = $lines[$index].Trim()
        if ($trimmed.StartsWith("|") -and $trimmed.EndsWith("|")) {
            $tableStart = $index
            break
        }
    }

    if ($tableStart -lt 0) {
        return [pscustomobject]@{
            Kind = "Table"
            Headers = @()
            Rows = @()
            RowCount = 0
            EmptyResultMessage = $emptyMessage
            WarningLines = @($Result.WarningLines)
            StatusLines = @($Result.StatusLines)
        }
    }

    $headers = @(ConvertFrom-MxCliTableRow -Line $lines[$tableStart])
    $rows = New-Object System.Collections.Generic.List[object]

    $cursor = $tableStart + 1
    if ($cursor -lt $lines.Count -and (Test-MxCliTableSeparatorLine -Line $lines[$cursor])) {
        $cursor += 1
    }

    while ($cursor -lt $lines.Count) {
        $line = $lines[$cursor]
        $trimmed = $line.Trim()
        if (-not ($trimmed.StartsWith("|") -and $trimmed.EndsWith("|"))) {
            break
        }

        $cells = @(ConvertFrom-MxCliTableRow -Line $line)
        $row = [ordered]@{}
        for ($index = 0; $index -lt $headers.Count; $index += 1) {
            $value = if ($index -lt $cells.Count) { $cells[$index] } else { "" }
            $row[$headers[$index]] = $value
        }

        $rows.Add([pscustomobject]$row) | Out-Null
        $cursor += 1
    }

    return [pscustomobject]@{
        Kind = "Table"
        Headers = $headers
        Rows = @($rows.ToArray())
        RowCount = $rows.Count
        EmptyResultMessage = $emptyMessage
        WarningLines = @($Result.WarningLines)
        StatusLines = @($Result.StatusLines)
    }
}

function New-MxCliCatalogQueryText {
    param(
        [Parameter(Mandatory)]
        [string]$Query,
        [ValidateSet("Fast", "Full", "Source")]
        [string]$CatalogStage = "Fast"
    )

    switch ($CatalogStage) {
        "Full" { return "REFRESH CATALOG FULL; $Query" }
        "Source" { return "REFRESH CATALOG SOURCE; $Query" }
        default { return $Query }
    }
}

function Invoke-MxCliCatalogQuery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectPath,
        [Parameter(Mandatory)]
        [string]$Query,
        [ValidateSet("Fast", "Full", "Source")]
        [string]$CatalogStage = "Fast",
        [string]$WorkingDirectory = (Get-Location).Path,
        [switch]$ThrowOnError
    )

    $commandText = New-MxCliCatalogQueryText -Query $Query -CatalogStage $CatalogStage
    return Invoke-MxCliCommand -Arguments @("-p", $ProjectPath, "-c", $commandText) -WorkingDirectory $WorkingDirectory -ThrowOnError:$ThrowOnError
}
