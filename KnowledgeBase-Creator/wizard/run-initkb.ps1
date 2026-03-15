[CmdletBinding()]
param(
    [string]$MprPath,
    [string]$AppName,
    [string]$MxPath,
    [string]$DataRoot,
    [string]$KnowledgeBaseRoot,
    [switch]$OpenVsCode
)

$ErrorActionPreference = "Stop"

$wizardRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $wizardRoot
$envPath = Join-Path $packageRoot ".env"
$runDumpParserScript = Join-Path $wizardRoot "run-dump-parser.ps1"
$creatorRunnerPath = $MyInvocation.MyCommand.Path

function Read-DotEnv {
    param([string]$Path)

    $result = @{}
    if (-not (Test-Path $Path -PathType Leaf)) {
        return $result
    }

    foreach ($rawLine in Get-Content -Path $Path) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#")) {
            continue
        }

        $separator = $line.IndexOf("=")
        if ($separator -lt 1) {
            continue
        }

        $key = $line.Substring(0, $separator).Trim()
        $value = $line.Substring($separator + 1).Trim()
        if ([string]::IsNullOrWhiteSpace($key)) {
            continue
        }

        if (
            $value.Length -ge 2 -and (
                ($value.StartsWith('"') -and $value.EndsWith('"')) -or
                ($value.StartsWith("'") -and $value.EndsWith("'"))
            )
        ) {
            $value = $value.Substring(1, $value.Length - 2)
        }

        $result[$key] = $value
    }

    return $result
}

function Get-Setting {
    param(
        [hashtable]$Settings,
        [string]$Key,
        [string]$Default = ""
    )

    if (-not $Settings.ContainsKey($Key)) {
        return $Default
    }

    $value = $Settings[$Key]
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $Default
    }

    return $value.Trim()
}

function Get-SettingAny {
    param(
        [hashtable]$Settings,
        [string[]]$Keys,
        [string]$Default = ""
    )

    foreach ($key in @($Keys)) {
        $value = Get-Setting -Settings $Settings -Key $key
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value
        }
    }

    return $Default
}

function Apply-EnvironmentOverrides {
    param(
        [hashtable]$Settings,
        [string[]]$Keys
    )

    foreach ($key in @($Keys)) {
        $envValue = [Environment]::GetEnvironmentVariable($key)
        if ([string]::IsNullOrWhiteSpace($envValue)) {
            continue
        }

        $Settings[$key] = $envValue.Trim()
    }
}

function Normalize-AbsolutePath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    return [IO.Path]::GetFullPath($Path.Trim().Trim('"'))
}

function Normalize-DataRootPath {
    param([string]$Path)

    $resolved = Normalize-AbsolutePath -Path $Path
    if ([string]::IsNullOrWhiteSpace($resolved)) {
        return $null
    }

    if (Test-Path $resolved -PathType Leaf) {
        throw "DataRoot points to a file, not a folder: $resolved"
    }

    if ([IO.Path]::GetFileName($resolved).Equals("knowledge-base", [StringComparison]::OrdinalIgnoreCase)) {
        $parent = Split-Path -Parent $resolved
        if ([string]::IsNullOrWhiteSpace($parent)) {
            throw "Could not derive mendix-data folder from knowledge-base path: $resolved"
        }

        return $parent
    }

    return $resolved
}

function Normalize-KnowledgeBaseRootPath {
    param([string]$Path)

    $resolved = Normalize-AbsolutePath -Path $Path
    if ([string]::IsNullOrWhiteSpace($resolved)) {
        return $null
    }

    if (Test-Path $resolved -PathType Leaf) {
        throw "KnowledgeBaseRoot points to a file, not a folder: $resolved"
    }

    if (-not [IO.Path]::GetFileName($resolved).Equals("knowledge-base", [StringComparison]::OrdinalIgnoreCase)) {
        throw "KnowledgeBaseRoot must point to a knowledge-base folder: $resolved"
    }

    return $resolved
}

function Resolve-MprPathForDefaults {
    param(
        [hashtable]$Settings,
        [string]$PackageRoot
    )

    $mprPath = Get-SettingAny -Settings $Settings -Keys @("MPR_FILE_PATH", "MENDIX_MPR_PATH")
    if (-not [string]::IsNullOrWhiteSpace($mprPath)) {
        $fullPath = Normalize-AbsolutePath -Path $mprPath
        if (-not (Test-Path $fullPath -PathType Leaf)) {
            throw "Configured MPR path does not exist: $fullPath"
        }
        if ([IO.Path]::GetExtension($fullPath).ToLowerInvariant() -ne ".mpr") {
            throw "Configured MPR path is not a .mpr file: $fullPath"
        }
        return $fullPath
    }

    $legacyAppPath = Get-Setting -Settings $Settings -Key "MENDIX_APP_PATH"
    if (-not [string]::IsNullOrWhiteSpace($legacyAppPath)) {
        $fullPath = Normalize-AbsolutePath -Path $legacyAppPath
        if (Test-Path $fullPath -PathType Leaf) {
            if ([IO.Path]::GetExtension($fullPath).ToLowerInvariant() -ne ".mpr") {
                throw "MENDIX_APP_PATH points to a file that is not .mpr: $fullPath"
            }
            return $fullPath
        }

        if (-not (Test-Path $fullPath -PathType Container)) {
            throw "MENDIX_APP_PATH does not exist: $fullPath"
        }

        $mprFiles = Get-ChildItem -Path $fullPath -File -Filter *.mpr | Sort-Object Name
        if ($mprFiles.Count -eq 1) {
            return $mprFiles[0].FullName
        }
        if ($mprFiles.Count -gt 1) {
            $names = $mprFiles | ForEach-Object { $_.Name }
            throw "Multiple .mpr files found in ${fullPath}: $($names -join ', '). Set MPR_FILE_PATH in .env."
        }
    }

    $autoDetectFolders = @(
        (Split-Path -Parent $PackageRoot),
        $PackageRoot
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

    foreach ($folder in @($autoDetectFolders)) {
        if (-not (Test-Path $folder -PathType Container)) {
            continue
        }

        $mprFiles = Get-ChildItem -Path $folder -File -Filter *.mpr | Sort-Object Name
        if ($mprFiles.Count -eq 1) {
            return $mprFiles[0].FullName
        }
        if ($mprFiles.Count -gt 1) {
            $names = $mprFiles | ForEach-Object { $_.Name }
            throw "Multiple .mpr files found in ${folder}: $($names -join ', '). Set MPR_FILE_PATH in .env."
        }
    }

    return $null
}

function Resolve-DataRoot {
    param(
        [string]$ExplicitDataRoot,
        [string]$ResolvedKnowledgeBaseRoot,
        [pscustomobject]$CreatorLink,
        [hashtable]$Settings,
        [string]$ResolvedMprPath,
        [string]$PackageRoot
    )

    if (-not [string]::IsNullOrWhiteSpace($ResolvedKnowledgeBaseRoot)) {
        return Normalize-DataRootPath -Path (Split-Path -Parent $ResolvedKnowledgeBaseRoot)
    }

    if (-not [string]::IsNullOrWhiteSpace($ExplicitDataRoot)) {
        return Normalize-DataRootPath -Path $ExplicitDataRoot
    }

    if ($null -ne $CreatorLink -and -not [string]::IsNullOrWhiteSpace($CreatorLink.dataRoot)) {
        return Normalize-DataRootPath -Path $CreatorLink.dataRoot
    }

    $configuredDataRoot = Get-Setting -Settings $Settings -Key "MENDIX_DATA_ROOT"
    if (-not [string]::IsNullOrWhiteSpace($configuredDataRoot)) {
        return Normalize-DataRootPath -Path $configuredDataRoot
    }

    if (-not [string]::IsNullOrWhiteSpace($ResolvedMprPath)) {
        return Normalize-DataRootPath -Path (Join-Path (Split-Path -Parent $ResolvedMprPath) "mendix-data")
    }

    return Normalize-DataRootPath -Path (Join-Path (Split-Path -Parent $PackageRoot) "mendix-data")
}

function Get-CreatorLinkPath {
    param(
        [string]$ResolvedKnowledgeBaseRoot,
        [string]$ResolvedDataRoot
    )

    $candidates = @()
    if (-not [string]::IsNullOrWhiteSpace($ResolvedKnowledgeBaseRoot)) {
        $candidates += Join-Path $ResolvedKnowledgeBaseRoot "_sources\creator-link.json"
    }
    if (-not [string]::IsNullOrWhiteSpace($ResolvedDataRoot)) {
        $candidates += Join-Path $ResolvedDataRoot "knowledge-base\_sources\creator-link.json"
    }

    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        if (Test-Path $candidate -PathType Leaf) {
            return $candidate
        }
    }

    return $null
}

function Load-CreatorLink {
    param(
        [string]$ResolvedKnowledgeBaseRoot,
        [string]$ResolvedDataRoot
    )

    $linkPath = Get-CreatorLinkPath -ResolvedKnowledgeBaseRoot $ResolvedKnowledgeBaseRoot -ResolvedDataRoot $ResolvedDataRoot
    if ([string]::IsNullOrWhiteSpace($linkPath)) {
        return $null
    }

    return Get-Content -Raw $linkPath | ConvertFrom-Json
}

function Test-DirectoryHasEntries {
    param([string]$Path)

    if (-not (Test-Path $Path -PathType Container)) {
        return $false
    }

    $items = Get-ChildItem -Path $Path -Force
    return @($items).Count -gt 0
}

function Archive-DataRoot {
    param([string]$ResolvedDataRoot)

    if (-not (Test-Path $ResolvedDataRoot -PathType Container)) {
        return $null
    }

    if (-not (Test-DirectoryHasEntries -Path $ResolvedDataRoot)) {
        return $null
    }

    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
    $archivePath = "${ResolvedDataRoot}.archive.$timestamp"
    $suffix = 1
    while (Test-Path $archivePath) {
        $archivePath = "${ResolvedDataRoot}.archive.$timestamp-$suffix"
        $suffix += 1
    }

    Move-Item -Path $ResolvedDataRoot -Destination $archivePath
    return $archivePath
}

function Set-ScopedEnvironmentValue {
    param(
        [hashtable]$Backup,
        [string]$Name,
        [string]$Value
    )

    if (-not $Backup.ContainsKey($Name)) {
        if (Test-Path "Env:$Name") {
            $Backup[$Name] = (Get-Item "Env:$Name").Value
        } else {
            $Backup[$Name] = $null
        }
    }

    if ([string]::IsNullOrWhiteSpace($Value)) {
        Remove-Item "Env:$Name" -ErrorAction SilentlyContinue
        return
    }

    [Environment]::SetEnvironmentVariable($Name, $Value)
}

function Restore-ScopedEnvironment {
    param([hashtable]$Backup)

    foreach ($key in $Backup.Keys) {
        $value = $Backup[$key]
        [Environment]::SetEnvironmentVariable($key, $value)
    }
}

function Invoke-DumpParser {
    param(
        [string]$ResolvedMprPath,
        [string]$ResolvedAppName,
        [string]$ResolvedMxPath,
        [string]$ResolvedDataRoot
    )

    $backup = @{}
    try {
        if (-not [string]::IsNullOrWhiteSpace($ResolvedAppName)) {
            Set-ScopedEnvironmentValue -Backup $backup -Name "APP_NAME" -Value $ResolvedAppName
        }
        if (-not [string]::IsNullOrWhiteSpace($ResolvedMprPath)) {
            Set-ScopedEnvironmentValue -Backup $backup -Name "MPR_FILE_PATH" -Value $ResolvedMprPath
            Set-ScopedEnvironmentValue -Backup $backup -Name "MENDIX_MPR_PATH" -Value $ResolvedMprPath
            Set-ScopedEnvironmentValue -Backup $backup -Name "MENDIX_APP_PATH" -Value (Split-Path -Parent $ResolvedMprPath)
        }
        if (-not [string]::IsNullOrWhiteSpace($ResolvedMxPath)) {
            Set-ScopedEnvironmentValue -Backup $backup -Name "MENDIX_MX_EXE" -Value $ResolvedMxPath
        }
        if (-not [string]::IsNullOrWhiteSpace($ResolvedDataRoot)) {
            Set-ScopedEnvironmentValue -Backup $backup -Name "MENDIX_DATA_ROOT" -Value $ResolvedDataRoot
        }

        $output = New-Object System.Collections.Generic.List[string]
        $previousErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        try {
            & powershell -NoProfile -ExecutionPolicy Bypass -File $runDumpParserScript 2>&1 | ForEach-Object {
                $line = $_.ToString()
                $output.Add($line)
                Write-Host $line
            }
        }
        finally {
            $ErrorActionPreference = $previousErrorActionPreference
        }
        $exitCode = $LASTEXITCODE

        return [pscustomobject]@{
            ExitCode = $exitCode
            Output = @($output)
        }
    }
    finally {
        Restore-ScopedEnvironment -Backup $backup
    }
}

function Get-PipelineSummaryValue {
    param(
        [string[]]$Output,
        [string]$Label
    )

    $pattern = "^{0}\s+(.+)$" -f [regex]::Escape($Label)
    for ($index = @($Output).Count - 1; $index -ge 0; $index -= 1) {
        $line = $Output[$index]
        if ($line -match $pattern) {
            return $matches[1].Trim()
        }
    }

    return $null
}

function Get-LatestRunFolder {
    param([string]$ResolvedDataRoot)

    $appOverviewRoot = Join-Path $ResolvedDataRoot "app-overview"
    if (-not (Test-Path $appOverviewRoot -PathType Container)) {
        return $null
    }

    $latest = Get-ChildItem -Path $appOverviewRoot -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName "manifest.json") -PathType Leaf } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    return $latest.FullName
}

function Write-CreatorLinkFile {
    param(
        [string]$ResolvedKnowledgeBaseRoot,
        [string]$ResolvedDataRoot,
        [string]$ResolvedAppName,
        [string]$ResolvedMprPath,
        [string]$ResolvedRunFolder
    )

    $sourcesRoot = Join-Path $ResolvedKnowledgeBaseRoot "_sources"
    New-Item -Path $sourcesRoot -ItemType Directory -Force | Out-Null

    $payload = [ordered]@{
        schemaVersion = "1.0"
        creatorRoot = $packageRoot
        creatorInitkbRunner = $creatorRunnerPath
        appName = $ResolvedAppName
        mprPath = $ResolvedMprPath
        dataRoot = $ResolvedDataRoot
        knowledgeBaseRoot = $ResolvedKnowledgeBaseRoot
        lastRunFolder = $ResolvedRunFolder
        currentAliasPath = (Join-Path (Split-Path -Parent $ResolvedRunFolder) "current")
        updatedAtUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    $linkPath = Join-Path $sourcesRoot "creator-link.json"
    $payload | ConvertTo-Json -Depth 5 | Set-Content -Path $linkPath -Encoding UTF8
    return $linkPath
}

function Write-HandoffFile {
    param(
        [string]$ResolvedKnowledgeBaseRoot,
        [string]$ResolvedDataRoot,
        [string]$ResolvedAppName,
        [string]$ResolvedRunFolder,
        [string]$ArchivePath,
        [string]$StructuralValidationStatus,
        [string]$QualityGateStatus,
        [string]$BenchmarkStatus
    )

    $sourcesRoot = Join-Path $ResolvedKnowledgeBaseRoot "_sources"
    New-Item -Path $sourcesRoot -ItemType Directory -Force | Out-Null

    $archiveSummary = if ([string]::IsNullOrWhiteSpace($ArchivePath)) { "none" } else { $ArchivePath }
    $handoffPath = Join-Path $sourcesRoot "INITKB_HANDOFF.md"

    $contentLines = @(
        "# Init KB Handoff",
        "",
        "## Resolved paths",
        "",
        "- Creator root: $packageRoot",
        "- Creator runner: $creatorRunnerPath",
        "- Data root: $ResolvedDataRoot",
        "- Knowledge base root: $ResolvedKnowledgeBaseRoot",
        "- Run folder: $ResolvedRunFolder",
        "- Archived previous data root: $archiveSummary",
        "",
        "## Pipeline summary",
        "",
        "- App name: $ResolvedAppName",
        "- Structural validation status: $StructuralValidationStatus",
        "- Quality gate status: $QualityGateStatus",
        "- Benchmark status: $BenchmarkStatus",
        "",
        "## Continue with AI enrichment",
        "",
        "Read these files in order from the creator package:",
        "",
        '1. `AGENTS.md`',
        '2. `.agents/agents/KNOWLEDGEBASE_CREATOR.md`',
        '3. `.agents/agents/OVERVIEW_KB_BUILDER.md`',
        "",
        "Then enrich the generated KB at `"$ResolvedKnowledgeBaseRoot`" using source data from `"$ResolvedRunFolder`".",
        'Prioritise custom modules, resolve `_reports/UNKNOWN_TODO.md`, and keep required headings, tables, and links intact.',
        "",
        "## Revalidation commands",
        "",
        'Run these commands from `KnowledgeBase-Creator` after enrichment:',
        "",
        '```powershell',
        ".\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot `"$ResolvedKnowledgeBaseRoot`" -AppName `"$ResolvedAppName`"",
        ".\wizard\run-kb-quality-gate.ps1 -OutputRoot `"$ResolvedKnowledgeBaseRoot`" -AppName `"$ResolvedAppName`"",
        '```',
        "",
        "## Ready prompt",
        "",
        '```text',
        "Use the KnowledgeBase Creator enrichment workflow for the generated Mendix KB.",
        "",
        "Read:",
        "1. $packageRoot\AGENTS.md",
        "2. $packageRoot\.agents\agents\KNOWLEDGEBASE_CREATOR.md",
        "3. $packageRoot\.agents\agents\OVERVIEW_KB_BUILDER.md",
        "",
        "Then enrich the KB at:",
        $ResolvedKnowledgeBaseRoot,
        "",
        "Use source data from:",
        $ResolvedRunFolder,
        "",
        "Prioritise custom modules, resolve UNKNOWN_TODO items, and rerun:",
        ".\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot `"$ResolvedKnowledgeBaseRoot`" -AppName `"$ResolvedAppName`"",
        ".\wizard\run-kb-quality-gate.ps1 -OutputRoot `"$ResolvedKnowledgeBaseRoot`" -AppName `"$ResolvedAppName`"",
        '```'
    )
    $content = $contentLines -join [Environment]::NewLine

    Set-Content -Path $handoffPath -Value $content -Encoding UTF8
    return $handoffPath
}

function Open-DataRootInVsCode {
    param([string]$ResolvedDataRoot)

    $codeCommand = Get-Command code -ErrorAction SilentlyContinue
    if ($null -eq $codeCommand) {
        Write-Warning "OpenVsCode was requested, but the 'code' CLI was not found on PATH."
        return
    }

    Start-Process -FilePath $codeCommand.Source -ArgumentList @($ResolvedDataRoot) | Out-Null
}

function Invoke-Phase2Handoff {
    param(
        [string]$ResolvedKnowledgeBaseRoot,
        [string]$ResolvedDataRoot,
        [string]$ResolvedAppName,
        [string]$ResolvedMprPath,
        [string]$ResolvedRunFolder,
        [string]$ArchivePath,
        [string]$StructuralValidationStatus,
        [string]$QualityGateStatus,
        [string]$BenchmarkStatus,
        [bool]$ShouldOpenVsCode
    )

    $creatorLinkPath = Write-CreatorLinkFile `
        -ResolvedKnowledgeBaseRoot $ResolvedKnowledgeBaseRoot `
        -ResolvedDataRoot $ResolvedDataRoot `
        -ResolvedAppName $ResolvedAppName `
        -ResolvedMprPath $ResolvedMprPath `
        -ResolvedRunFolder $ResolvedRunFolder

    $handoffPath = Write-HandoffFile `
        -ResolvedKnowledgeBaseRoot $ResolvedKnowledgeBaseRoot `
        -ResolvedDataRoot $ResolvedDataRoot `
        -ResolvedAppName $ResolvedAppName `
        -ResolvedRunFolder $ResolvedRunFolder `
        -ArchivePath $ArchivePath `
        -StructuralValidationStatus $StructuralValidationStatus `
        -QualityGateStatus $QualityGateStatus `
        -BenchmarkStatus $BenchmarkStatus

    Write-Host ""
    Write-Host "Phase 2 handoff ready." -ForegroundColor Green
    Write-Host "Creator link:              $creatorLinkPath"
    Write-Host "Handoff file:              $handoffPath"

    if ($ShouldOpenVsCode) {
        Write-Host "Opening VS Code at:        $ResolvedDataRoot"
        Open-DataRootInVsCode -ResolvedDataRoot $ResolvedDataRoot
    }
}

if (-not (Test-Path $runDumpParserScript -PathType Leaf)) {
    throw "Missing pipeline script: $runDumpParserScript"
}

$settings = Read-DotEnv -Path $envPath
Apply-EnvironmentOverrides -Settings $settings -Keys @(
    "STUDIO_PRO_PATH",
    "MENDIX_STUDIO_PRO_PATH",
    "MPR_FILE_PATH",
    "MENDIX_MPR_PATH",
    "MENDIX_APP_PATH",
    "APP_NAME",
    "MENDIX_MX_EXE",
    "MENDIX_DATA_ROOT",
    "MENDIX_MODULES",
    "STRICT_MODE",
    "STRICT_QUALITY_GATE",
    "CUSTOM_SCENARIOS_PATH",
    "CUSTOM_SCENARIOS",
    "DUMP_FILE_PATH",
    "DUMP_PATH"
)

$resolvedKnowledgeBaseRoot = Normalize-KnowledgeBaseRootPath -Path $KnowledgeBaseRoot
$resolvedExplicitDataRoot = Normalize-DataRootPath -Path $DataRoot
$creatorLink = Load-CreatorLink -ResolvedKnowledgeBaseRoot $resolvedKnowledgeBaseRoot -ResolvedDataRoot $resolvedExplicitDataRoot
$settingsMprPath = Resolve-MprPathForDefaults -Settings $settings -PackageRoot $packageRoot
$resolvedMprPath = Normalize-AbsolutePath -Path $MprPath
if ([string]::IsNullOrWhiteSpace($resolvedMprPath) -and $null -ne $creatorLink -and -not [string]::IsNullOrWhiteSpace($creatorLink.mprPath)) {
    $resolvedMprPath = Normalize-AbsolutePath -Path $creatorLink.mprPath
}
if ([string]::IsNullOrWhiteSpace($resolvedMprPath)) {
    $resolvedMprPath = $settingsMprPath
}

$resolvedAppName = $AppName
if ([string]::IsNullOrWhiteSpace($resolvedAppName) -and $null -ne $creatorLink -and -not [string]::IsNullOrWhiteSpace($creatorLink.appName)) {
    $resolvedAppName = [string]$creatorLink.appName
}
if ([string]::IsNullOrWhiteSpace($resolvedAppName)) {
    $resolvedAppName = Get-Setting -Settings $settings -Key "APP_NAME"
}
if ([string]::IsNullOrWhiteSpace($resolvedAppName) -and -not [string]::IsNullOrWhiteSpace($resolvedMprPath)) {
    $resolvedAppName = [IO.Path]::GetFileNameWithoutExtension($resolvedMprPath)
}

$resolvedMxPath = Normalize-AbsolutePath -Path $MxPath
if (-not [string]::IsNullOrWhiteSpace($resolvedMxPath) -and -not (Test-Path $resolvedMxPath -PathType Leaf)) {
    throw "Configured mx.exe path does not exist: $resolvedMxPath"
}

$resolvedDataRoot = Resolve-DataRoot `
    -ExplicitDataRoot $resolvedExplicitDataRoot `
    -ResolvedKnowledgeBaseRoot $resolvedKnowledgeBaseRoot `
    -CreatorLink $creatorLink `
    -Settings $settings `
    -ResolvedMprPath $resolvedMprPath `
    -PackageRoot $packageRoot

if ([string]::IsNullOrWhiteSpace($resolvedDataRoot)) {
    throw "Could not resolve a target mendix-data folder."
}

$resolvedKnowledgeBaseRoot = if (-not [string]::IsNullOrWhiteSpace($resolvedKnowledgeBaseRoot)) {
    $resolvedKnowledgeBaseRoot
} else {
    Join-Path $resolvedDataRoot "knowledge-base"
}

Write-Host ""
Write-Host "=== initkb ===" -ForegroundColor Cyan
Write-Host "Creator root:                $packageRoot"
Write-Host "Target data root:            $resolvedDataRoot"
Write-Host "Target knowledge base root:  $resolvedKnowledgeBaseRoot"
if (-not [string]::IsNullOrWhiteSpace($resolvedMprPath)) {
    Write-Host "Resolved .mpr:               $resolvedMprPath"
}
if (-not [string]::IsNullOrWhiteSpace($resolvedAppName)) {
    Write-Host "Resolved app name:           $resolvedAppName"
}
if (-not [string]::IsNullOrWhiteSpace($resolvedMxPath)) {
    Write-Host "Resolved mx.exe:             $resolvedMxPath"
}

$archivePath = Archive-DataRoot -ResolvedDataRoot $resolvedDataRoot
if (-not [string]::IsNullOrWhiteSpace($archivePath)) {
    Write-Host "Archived previous data root: $archivePath" -ForegroundColor Yellow
}

$pipelineResult = Invoke-DumpParser `
    -ResolvedMprPath $resolvedMprPath `
    -ResolvedAppName $resolvedAppName `
    -ResolvedMxPath $resolvedMxPath `
    -ResolvedDataRoot $resolvedDataRoot

if ($pipelineResult.ExitCode -ne 0) {
    Write-Error "initkb failed because the pipeline exited with code $($pipelineResult.ExitCode)."
    exit $pipelineResult.ExitCode
}

$resolvedRunFolder = Get-PipelineSummaryValue -Output $pipelineResult.Output -Label "Run folder:"
if ([string]::IsNullOrWhiteSpace($resolvedRunFolder)) {
    $resolvedRunFolder = Get-LatestRunFolder -ResolvedDataRoot $resolvedDataRoot
}
$resolvedKnowledgeBaseRoot = Get-PipelineSummaryValue -Output $pipelineResult.Output -Label "KB folder:"
if ([string]::IsNullOrWhiteSpace($resolvedKnowledgeBaseRoot)) {
    $resolvedKnowledgeBaseRoot = Join-Path $resolvedDataRoot "knowledge-base"
}

$structuralValidationStatus = Get-PipelineSummaryValue -Output $pipelineResult.Output -Label "Structural validation status:"
if ([string]::IsNullOrWhiteSpace($structuralValidationStatus)) {
    $structuralValidationStatus = "pass"
}
$qualityGateStatus = Get-PipelineSummaryValue -Output $pipelineResult.Output -Label "Quality gate status:"
if ([string]::IsNullOrWhiteSpace($qualityGateStatus)) {
    $qualityGateStatus = "unknown"
}
$benchmarkStatus = Get-PipelineSummaryValue -Output $pipelineResult.Output -Label "Benchmark status:"
if ([string]::IsNullOrWhiteSpace($benchmarkStatus)) {
    $benchmarkStatus = "unknown"
}

Invoke-Phase2Handoff `
    -ResolvedKnowledgeBaseRoot $resolvedKnowledgeBaseRoot `
    -ResolvedDataRoot $resolvedDataRoot `
    -ResolvedAppName $resolvedAppName `
    -ResolvedMprPath $resolvedMprPath `
    -ResolvedRunFolder $resolvedRunFolder `
    -ArchivePath $archivePath `
    -StructuralValidationStatus $structuralValidationStatus `
    -QualityGateStatus $qualityGateStatus `
    -BenchmarkStatus $benchmarkStatus `
    -ShouldOpenVsCode:$OpenVsCode.IsPresent
