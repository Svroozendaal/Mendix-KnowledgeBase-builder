[CmdletBinding()]
param(
    [switch]$OpenOutput,
    [switch]$SkipDump,
    [switch]$SkipParser,
    [switch]$SkipScaffold,
    [string]$RunFolder
)

$ErrorActionPreference = "Stop"

$wizardRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $wizardRoot
$envPath = Join-Path $packageRoot ".env"
$artifactsRoot = Join-Path $packageRoot "artifacts/templates"
$agentsArtifactRoot = Join-Path $packageRoot "artifacts/.agents"
$dataRootArtifactsRoot = Join-Path $packageRoot "artifacts/data-root"

function Read-DotEnv {
    param([string]$Path)
    $result = @{}
    if (-not (Test-Path $Path -PathType Leaf)) { return $result }

    foreach ($rawLine in Get-Content -Path $Path) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#")) { continue }

        $separator = $line.IndexOf("=")
        if ($separator -lt 1) { continue }

        $key = $line.Substring(0, $separator).Trim()
        $value = $line.Substring($separator + 1).Trim()
        if ([string]::IsNullOrWhiteSpace($key)) { continue }

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

    if (-not $Settings.ContainsKey($Key)) { return $Default }
    $value = $Settings[$Key]
    if ([string]::IsNullOrWhiteSpace($value)) { return $Default }
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

function Get-RequiredSettingAny {
    param(
        [hashtable]$Settings,
        [string[]]$Keys
    )

    $value = Get-SettingAny -Settings $Settings -Keys $Keys
    if ([string]::IsNullOrWhiteSpace($value)) {
        throw "Missing required setting. Provide one of: $($Keys -join ', ') in $envPath"
    }
    return $value
}

function Get-BoolSettingAny {
    param(
        [hashtable]$Settings,
        [string[]]$Keys,
        [bool]$Default = $false
    )

    $value = Get-SettingAny -Settings $Settings -Keys $Keys
    if ([string]::IsNullOrWhiteSpace($value)) { return $Default }

    switch ($value.ToLowerInvariant()) {
        "1" { return $true }
        "true" { return $true }
        "yes" { return $true }
        "y" { return $true }
        "0" { return $false }
        "false" { return $false }
        "no" { return $false }
        "n" { return $false }
        default { return $Default }
    }
}

function Apply-EnvironmentOverrides {
    param(
        [hashtable]$Settings,
        [string[]]$Keys
    )

    foreach ($key in @($Keys)) {
        $envValue = [Environment]::GetEnvironmentVariable($key)
        if ([string]::IsNullOrWhiteSpace($envValue)) { continue }
        $Settings[$key] = $envValue.Trim()
    }
}

function Resolve-MxExe {
    param([hashtable]$Settings)

    $explicit = Get-Setting -Settings $Settings -Key "MENDIX_MX_EXE"
    if (-not [string]::IsNullOrWhiteSpace($explicit)) {
        if (-not (Test-Path $explicit -PathType Leaf)) {
            throw "MENDIX_MX_EXE does not exist: $explicit"
        }
        return (Resolve-Path $explicit).Path
    }

    $studioPath = Get-RequiredSettingAny -Settings $Settings -Keys @("STUDIO_PRO_PATH", "MENDIX_STUDIO_PRO_PATH")
    if (-not (Test-Path $studioPath -PathType Container)) {
        throw "Studio Pro path does not exist: $studioPath"
    }

    $candidates = @(
        (Join-Path $studioPath "modeler\mx.exe"),
        (Join-Path $studioPath "mx.exe")
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate -PathType Leaf) {
            return (Resolve-Path $candidate).Path
        }
    }

    throw "Could not find mx.exe under Studio Pro path: $studioPath"
}

function Resolve-MprPath {
    param([hashtable]$Settings)

    $mprPath = Get-SettingAny -Settings $Settings -Keys @("MPR_FILE_PATH", "MENDIX_MPR_PATH")
    if (-not [string]::IsNullOrWhiteSpace($mprPath)) {
        if (-not (Test-Path $mprPath -PathType Leaf)) {
            throw "MPR path does not exist: $mprPath"
        }
        if ([IO.Path]::GetExtension($mprPath).ToLowerInvariant() -ne ".mpr") {
            throw "Configured MPR path is not a .mpr file: $mprPath"
        }
        return (Resolve-Path $mprPath).Path
    }

    $legacyAppPath = Get-Setting -Settings $Settings -Key "MENDIX_APP_PATH"
    if (-not [string]::IsNullOrWhiteSpace($legacyAppPath)) {
        if (Test-Path $legacyAppPath -PathType Leaf) {
            if ([IO.Path]::GetExtension($legacyAppPath).ToLowerInvariant() -ne ".mpr") {
                throw "MENDIX_APP_PATH points to a file that is not .mpr: $legacyAppPath"
            }
            return (Resolve-Path $legacyAppPath).Path
        }

        if (-not (Test-Path $legacyAppPath -PathType Container)) {
            throw "MENDIX_APP_PATH does not exist: $legacyAppPath"
        }

        $mprFiles = Get-ChildItem -Path $legacyAppPath -File -Filter *.mpr | Sort-Object Name
        if ($mprFiles.Count -eq 0) {
            throw "No .mpr file found in app folder: $legacyAppPath"
        }
        if ($mprFiles.Count -gt 1) {
            $names = $mprFiles | ForEach-Object { $_.Name }
            throw "Multiple .mpr files found in ${legacyAppPath}: $($names -join ', '). Set MPR_FILE_PATH in .env."
        }

        return $mprFiles[0].FullName
    }

    $autoDetectFolders = @(
        (Split-Path -Parent $packageRoot),
        $packageRoot
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

    foreach ($folder in @($autoDetectFolders)) {
        if (-not (Test-Path $folder -PathType Container)) { continue }
        $mprFiles = Get-ChildItem -Path $folder -File -Filter *.mpr | Sort-Object Name
        if ($mprFiles.Count -eq 1) {
            return $mprFiles[0].FullName
        }
        if ($mprFiles.Count -gt 1) {
            $names = $mprFiles | ForEach-Object { $_.Name }
            throw "Multiple .mpr files found in ${folder}: $($names -join ', '). Set MPR_FILE_PATH in .env."
        }
    }

    throw "Missing required MPR configuration. Set MPR_FILE_PATH/MENDIX_MPR_PATH, MENDIX_APP_PATH, or place one .mpr file in the app folder."
}

function Sanitize-Token {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return "app" }

    $invalid = [IO.Path]::GetInvalidFileNameChars()
    $builder = New-Object System.Text.StringBuilder
    foreach ($char in $Value.ToCharArray()) {
        if ($invalid -contains $char) {
            [void]$builder.Append("_")
        } else {
            [void]$builder.Append($char)
        }
    }

    $token = $builder.ToString().Trim()
    if ([string]::IsNullOrWhiteSpace($token)) { return "app" }
    return $token
}

function Get-ModulesFromManifest {
    param([string]$ManifestPath)

    $manifest = Get-Content -Raw $ManifestPath | ConvertFrom-Json
    $modulesByName = @{}

    foreach ($artifact in @($manifest.artifacts)) {
        if ($artifact.type -ne "module-domain-model-json") { continue }
        $artifactPath = [string]$artifact.path
        if ([string]::IsNullOrWhiteSpace($artifactPath)) { continue }

        if ($artifactPath -match "[\\/]modules[\\/]marketplace[\\/]([^\\/]+)[\\/]domain-model\.json$") {
            $modulesByName[$matches[1]] = [pscustomobject]@{
                Name = $matches[1]
                Category = "Marketplace"
            }
            continue
        }

        if ($artifactPath -match "[\\/]modules[\\/]([^\\/]+)[\\/]domain-model\.json$") {
            $modulesByName[$matches[1]] = [pscustomobject]@{
                Name = $matches[1]
                Category = "Unknown"
            }
        }
    }

    return @($modulesByName.Values | Sort-Object Name)
}

function Get-ModuleRelativePath {
    param(
        [object]$Module,
        [string]$FileName = ""
    )

    $base = if ([string]$Module.Category -eq "Marketplace") {
        "modules/_marktplace/$($Module.Name)"
    } else {
        "modules/$($Module.Name)"
    }

    if ([string]::IsNullOrWhiteSpace($FileName)) {
        return $base
    }

    return "$base/$FileName"
}

function Apply-Template {
    param(
        [string]$TemplatePath,
        [string]$TargetPath,
        [hashtable]$Tokens
    )

    $content = Get-Content -Raw $TemplatePath
    foreach ($key in $Tokens.Keys) {
        $content = $content.Replace("{{${key}}}", [string]$Tokens[$key])
    }

    $directory = Split-Path -Parent $TargetPath
    if (-not (Test-Path $directory)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }

    Set-Content -Path $TargetPath -Value $content -Encoding UTF8
}

function Get-DisplayPath {
    param(
        [string]$BasePath,
        [string]$TargetPath
    )

    if ([string]::IsNullOrWhiteSpace($TargetPath)) { return "" }
    if ([string]::IsNullOrWhiteSpace($BasePath)) { return $TargetPath }

    try {
        $resolvedBase = (Resolve-Path $BasePath -ErrorAction Stop).Path
        $resolvedTarget = (Resolve-Path $TargetPath -ErrorAction Stop).Path
        $relative = [System.IO.Path]::GetRelativePath($resolvedBase, $resolvedTarget)
        if (-not [string]::IsNullOrWhiteSpace($relative) -and -not $relative.StartsWith("..")) {
            return ($relative -replace "\\", "/")
        }
    }
    catch {
        # Fall back to the original path when relative resolution is not possible.
    }

    return $TargetPath
}

function Get-ModuleIndexRows {
    param([object[]]$Modules)

    if ($Modules.Count -eq 0) {
        return "| none | Unknown | none |"
    }

    $rows = @()
    foreach ($module in $Modules) {
        $rows += "| $($module.Name) | $($module.Category) | [README]($(Get-ModuleRelativePath -Module $module -FileName 'README.md')) |"
    }

    return ($rows -join "`n")
}

function Resolve-ExistingRunFolder {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
    if (-not (Test-Path $Path -PathType Container)) {
        throw "RunFolder does not exist: $Path"
    }
    $resolved = (Resolve-Path $Path).Path
    $manifestPath = Join-Path $resolved "manifest.json"
    if (-not (Test-Path $manifestPath -PathType Leaf)) {
        throw "RunFolder manifest.json missing: $manifestPath"
    }
    return $resolved
}

function Get-LatestRunFolder {
    param([string]$Root)

    if (-not (Test-Path $Root -PathType Container)) { return $null }
    $latest = Get-ChildItem -Path $Root -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $latest) { return $null }
    $manifestPath = Join-Path $latest.FullName "manifest.json"
    if (-not (Test-Path $manifestPath -PathType Leaf)) { return $null }
    return $latest.FullName
}

function Invoke-PwshScript {
    param(
        [string]$ScriptPath,
        [string[]]$Arguments,
        [string]$ErrorPrefix
    )

    & powershell -NoProfile -ExecutionPolicy Bypass -File $ScriptPath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$ErrorPrefix failed with exit code $LASTEXITCODE"
    }
}

function Seed-KbTemplates {
    param(
        [string]$ArtifactsRoot,
        [string]$AgentsRoot,
        [string]$DataRoot,
        [string]$KbRoot,
        [string]$AppName,
        [string]$RunFolder,
        [string[]]$Modules
    )

    $generatedAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $runFolderDisplay = Get-DisplayPath -BasePath $DataRoot -TargetPath $RunFolder
    $commonTokens = @{
        APP_NAME = $AppName
        GENERATED_AT_UTC = $generatedAt
        RUN_FOLDER = $runFolderDisplay
        KB_FORMAT_VERSION = "1.0"
        MODULE_COUNT = [string]$Modules.Count
        MODULE_INDEX_ROWS = (Get-ModuleIndexRows -Modules $Modules)
    }

    $artifactDrop = Join-Path $KbRoot "_artifacts"
    New-Item -ItemType Directory -Path $artifactDrop -Force | Out-Null
    Get-ChildItem -Path $ArtifactsRoot -File -Filter *.md | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination (Join-Path $artifactDrop $_.Name) -Force
    }

    if (Test-Path $AgentsRoot -PathType Container) {
        $agentsDrop = Join-Path $KbRoot ".agents"
        if (Test-Path $agentsDrop) {
            Remove-Item -Path $agentsDrop -Recurse -Force
        }
        Copy-Item -Path $AgentsRoot -Destination $agentsDrop -Recurse -Force
    }

    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "CLAUDE_MD_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "CLAUDE.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "KNOWLEDGEBASE_READER.md") -TargetPath (Join-Path $KbRoot "READER.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "ROUTING_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "ROUTING.md") -Tokens $commonTokens

    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "APP_OVERVIEW_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "app/APP_OVERVIEW.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "MODULE_LANDSCAPE_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "app/MODULE_LANDSCAPE.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "SECURITY_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "app/SECURITY.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "CALL_GRAPH_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "app/CALL_GRAPH.md") -Tokens $commonTokens

    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "ROUTE_BY_ENTITY_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "routes/by-entity.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "ROUTE_BY_PAGE_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "routes/by-page.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "ROUTE_BY_FLOW_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "routes/by-flow.md") -Tokens $commonTokens
    Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "ROUTE_CROSS_MODULE_TEMPLATE.md") -TargetPath (Join-Path $KbRoot "routes/cross-module.md") -Tokens $commonTokens

    foreach ($module in @($Modules)) {
        $moduleTokens = @{}
        foreach ($k in $commonTokens.Keys) { $moduleTokens[$k] = $commonTokens[$k] }
        $moduleTokens["MODULE_NAME"] = $module.Name

        $moduleDir = Join-Path $KbRoot (Get-ModuleRelativePath -Module $module)
        New-Item -ItemType Directory -Path $moduleDir -Force | Out-Null

        Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "MODULE_README_TEMPLATE.md") -TargetPath (Join-Path $moduleDir "README.md") -Tokens $moduleTokens
        Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "MODULE_DOMAIN_TEMPLATE.md") -TargetPath (Join-Path $moduleDir "DOMAIN.md") -Tokens $moduleTokens
        Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "MODULE_FLOWS_TEMPLATE.md") -TargetPath (Join-Path $moduleDir "FLOWS.md") -Tokens $moduleTokens
        Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "MODULE_PAGES_TEMPLATE.md") -TargetPath (Join-Path $moduleDir "PAGES.md") -Tokens $moduleTokens
        Apply-Template -TemplatePath (Join-Path $ArtifactsRoot "MODULE_RESOURCES_TEMPLATE.md") -TargetPath (Join-Path $moduleDir "RESOURCES.md") -Tokens $moduleTokens
    }
}

function Seed-DataRootGuides {
    param(
        [string]$TemplatesRoot,
        [string]$DataRoot,
        [string]$KbRoot,
        [string]$RunFolder,
        [string]$AppName,
        [string]$DumpPath
    )

    if (-not (Test-Path $TemplatesRoot -PathType Container)) {
        return
    }

    $generatedAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $runFolderDisplay = Get-DisplayPath -BasePath $DataRoot -TargetPath $RunFolder
    $kbRootDisplay = Get-DisplayPath -BasePath $DataRoot -TargetPath $KbRoot
    $dumpDisplay = Get-DisplayPath -BasePath $DataRoot -TargetPath $DumpPath
    $dumpGuidance = if ([string]::IsNullOrWhiteSpace($dumpDisplay)) { "dumps/" } else { $dumpDisplay }

    $tokens = @{
        APP_NAME = $AppName
        GENERATED_AT_UTC = $generatedAt
        DATA_ROOT = (Split-Path $DataRoot -Leaf)
        KB_ROOT = $kbRootDisplay
        KB_READER = "$kbRootDisplay/READER.md"
        KB_ROUTING = "$kbRootDisplay/ROUTING.md"
        KB_AGENTS = "$kbRootDisplay/.agents/AGENTS.md"
        RUN_FOLDER = $runFolderDisplay
        RUN_NAME = (Split-Path $RunFolder -Leaf)
        APP_OVERVIEW_ROOT = "app-overview/"
        DUMPS_ROOT = "dumps/"
        DUMP_GUIDANCE = $dumpGuidance
    }

    Apply-Template -TemplatePath (Join-Path $TemplatesRoot "README_TEMPLATE.md") -TargetPath (Join-Path $DataRoot "README.md") -Tokens $tokens
    Apply-Template -TemplatePath (Join-Path $TemplatesRoot "CURRENT_RUN_TEMPLATE.md") -TargetPath (Join-Path $DataRoot "CURRENT_RUN.md") -Tokens $tokens
    Apply-Template -TemplatePath (Join-Path $TemplatesRoot ".agents/AGENTS.md") -TargetPath (Join-Path $DataRoot ".agents/AGENTS.md") -Tokens $tokens
    Apply-Template -TemplatePath (Join-Path $TemplatesRoot ".agents/FRAMEWORK.md") -TargetPath (Join-Path $DataRoot ".agents/FRAMEWORK.md") -Tokens $tokens
    Apply-Template -TemplatePath (Join-Path $TemplatesRoot ".agents/AI_WORKFLOW.md") -TargetPath (Join-Path $DataRoot ".agents/AI_WORKFLOW.md") -Tokens $tokens
}

function Test-DirectoryHasEntries {
    param([string]$Path)

    if (-not (Test-Path $Path -PathType Container)) {
        return $false
    }

    $items = Get-ChildItem -Path $Path -Force
    return @($items).Count -gt 0
}

function Resolve-MprPathIfAvailable {
    param([hashtable]$Settings)

    try {
        return Resolve-MprPath -Settings $Settings
    }
    catch {
        return $null
    }
}

function Write-CreatorLinkFile {
    param(
        [string]$KbRoot,
        [string]$DataRoot,
        [string]$AppName,
        [string]$RunFolder,
        [string]$MprPath
    )

    if (-not (Test-Path $KbRoot -PathType Container)) {
        return $null
    }

    $sourcesRoot = Join-Path $KbRoot "_sources"
    New-Item -Path $sourcesRoot -ItemType Directory -Force | Out-Null

    $payload = [ordered]@{
        schemaVersion = "1.0"
        creatorRoot = $packageRoot
        creatorInitkbRunner = (Join-Path $wizardRoot "run-initkb.ps1")
        appName = $AppName
        mprPath = $MprPath
        dataRoot = $DataRoot
        knowledgeBaseRoot = $KbRoot
        lastRunFolder = $RunFolder
        updatedAtUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    $linkPath = Join-Path $sourcesRoot "creator-link.json"
    $payload | ConvertTo-Json -Depth 5 | Set-Content -Path $linkPath -Encoding UTF8
    return $linkPath
}

function Write-InitKbHandoffFile {
    param(
        [string]$KbRoot,
        [string]$DataRoot,
        [string]$AppName,
        [string]$RunFolder,
        [string]$CreatorLinkPath
    )

    if (-not (Test-Path $KbRoot -PathType Container)) {
        return $null
    }

    $sourcesRoot = Join-Path $KbRoot "_sources"
    New-Item -Path $sourcesRoot -ItemType Directory -Force | Out-Null

    $handoffPath = Join-Path $sourcesRoot "INITKB_HANDOFF.md"
    $contentLines = @(
        "# Init KB Handoff",
        "",
        "## Resolved paths",
        "",
        "- Creator root: $packageRoot",
        "- Creator runner: $(Join-Path $wizardRoot 'run-initkb.ps1')",
        "- Data root: $DataRoot",
        "- Knowledge base root: $KbRoot",
        "- Source run folder: $RunFolder",
        "- Creator link: $CreatorLinkPath",
        "",
        "## Purpose",
        "",
        "- Use `/enrichkb` inside this KB to add the AI narrative layer in place.",
        "- `/initkb` remains available as a compatibility entry point and rebuild handoff.",
        "- Do not rerun dump, parser, scaffold, or compose from this KB.",
        "- Rebuild from source only through the creator package.",
        "",
        "## Enrichment focus",
        "",
        "- Read `ROUTING.md` and `_reports/UNKNOWN_TODO.md` first.",
        "- Prioritise custom modules over marketplace and system modules.",
        "- Use pseudo source files from the run folder as evidence for inferred narratives.",
        "- Never remove export-backed data or change required headings, tables, or links.",
        "",
        "## Revalidation",
        "",
        'Run from the creator package after enrichment:',
        "",
        '```powershell',
        ".\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot `"$KbRoot`" -AppName `"$AppName`"",
        ".\wizard\run-kb-quality-gate.ps1 -OutputRoot `"$KbRoot`" -AppName `"$AppName`"",
        '```'
    )

    $contentLines | Set-Content -Path $handoffPath -Encoding UTF8
    return $handoffPath
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

$configuredDataRoot = Get-Setting -Settings $settings -Key "MENDIX_DATA_ROOT"
$dataRoot = if ([string]::IsNullOrWhiteSpace($configuredDataRoot)) {
    Join-Path (Split-Path -Parent $packageRoot) "mendix-data"
} else {
    $configuredDataRoot
}

$appName = Get-RequiredSettingAny -Settings $settings -Keys @("APP_NAME")
$moduleFilter = Get-Setting -Settings $settings -Key "MENDIX_MODULES" -Default "*"
$strictMode = Get-BoolSettingAny -Settings $settings -Keys @("STRICT_MODE", "STRICT_QUALITY_GATE") -Default $false
$customScenariosPath = Get-SettingAny -Settings $settings -Keys @("CUSTOM_SCENARIOS_PATH", "CUSTOM_SCENARIOS")

$parserExe = Join-Path $packageRoot "Mendix-model-overview-parser\bin\win-x64\ModelOverviewCli.exe"
$parserSourceProject = Join-Path $packageRoot "Mendix-model-overview-parser\src\model-overview-cli\ModelOverviewCli.csproj"
$scaffoldScript = Join-Path $wizardRoot "run-kb-scaffold.ps1"
$composeScript = Join-Path $wizardRoot "run-kb-compose.ps1"
$qualityGateScript = Join-Path $wizardRoot "run-kb-quality-gate.ps1"
$semanticBenchmarkScript = Join-Path $wizardRoot "run-kb-semantic-benchmark.ps1"

if (-not (Test-Path $scaffoldScript -PathType Leaf)) { throw "Missing scaffold script: $scaffoldScript" }
if (-not (Test-Path $composeScript -PathType Leaf)) { throw "Missing composer script: $composeScript" }
if (-not (Test-Path $qualityGateScript -PathType Leaf)) { throw "Missing quality gate script: $qualityGateScript" }
if (-not (Test-Path $semanticBenchmarkScript -PathType Leaf)) { throw "Missing semantic benchmark script: $semanticBenchmarkScript" }

$dumpsRoot = Join-Path $dataRoot "dumps"
$appOverviewRoot = Join-Path $dataRoot "app-overview"
$knowledgeBaseRoot = Join-Path $dataRoot "knowledge-base"

if (-not $SkipParser -and (Test-DirectoryHasEntries -Path $dataRoot)) {
    throw "mendix-data already exists and is not empty: $dataRoot. Remove or move the existing mendix-data folder before running the parser again."
}

New-Item -ItemType Directory -Path $dumpsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $appOverviewRoot -Force | Out-Null
New-Item -ItemType Directory -Path $knowledgeBaseRoot -Force | Out-Null

$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH-mm-ss.fffZ")
$appToken = Sanitize-Token -Value $appName
$dumpFolder = Join-Path $dumpsRoot "${timestamp}_$appToken"
$dumpPath = Join-Path $dumpFolder "working-dump.json"
$resolvedRunFolder = $null

if (-not [string]::IsNullOrWhiteSpace($RunFolder)) {
    $resolvedRunFolder = Resolve-ExistingRunFolder -Path $RunFolder
} elseif ($SkipParser -or $SkipDump) {
    $resolvedRunFolder = Get-LatestRunFolder -Root $appOverviewRoot
    if (-not $resolvedRunFolder) {
        throw "No existing run folder found in $appOverviewRoot. Provide -RunFolder explicitly."
    }
} else {
    $resolvedRunFolder = Join-Path $appOverviewRoot "cli_$timestamp"
}

$mxExe = $null
$mprPath = $null
if (-not $SkipDump) {
    $mxExe = Resolve-MxExe -Settings $settings
    $mprPath = Resolve-MprPath -Settings $settings
    New-Item -ItemType Directory -Path $dumpFolder -Force | Out-Null
} else {
    $dumpPath = Get-SettingAny -Settings $settings -Keys @("DUMP_FILE_PATH", "DUMP_PATH")
}

Write-Host ""
Write-Host "=== KnowledgeBase Creator ===" -ForegroundColor Cyan
Write-Host "App name:      $appName"
Write-Host "Data root:     $dataRoot"
Write-Host "Run folder:    $resolvedRunFolder"
Write-Host "Skip dump:     $SkipDump"
Write-Host "Skip parser:   $SkipParser"
Write-Host "Skip scaffold: $SkipScaffold"
if (-not $SkipDump) {
    Write-Host "mx.exe:        $mxExe"
    Write-Host "mpr:           $mprPath"
    Write-Host "dump:          $dumpPath"
}
if (-not [string]::IsNullOrWhiteSpace($customScenariosPath)) {
    Write-Host "Custom bench:  $customScenariosPath"
}

if (-not $SkipDump) {
    Write-Host ""
    Write-Host "[1/8] Dumping .mpr..." -ForegroundColor Yellow
    & $mxExe dump-mpr $mprPath --output-file $dumpPath
    if ($LASTEXITCODE -ne 0) {
        throw "mx dump-mpr failed with exit code $LASTEXITCODE"
    }
} else {
    Write-Host ""
    Write-Host "[1/8] Dump step skipped." -ForegroundColor DarkYellow
}

if (-not $SkipParser) {
    Write-Host "[2/8] Building app-overview export..." -ForegroundColor Yellow
    if ($SkipDump) {
        if ([string]::IsNullOrWhiteSpace($dumpPath)) {
            throw "SkipDump was used without SkipParser. Set DUMP_FILE_PATH in .env."
        }
        if (-not (Test-Path $dumpPath -PathType Leaf)) {
            throw "Configured dump file does not exist: $dumpPath"
        }
    }

    if (-not (Test-Path $resolvedRunFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $resolvedRunFolder -Force | Out-Null
    }

    if (Test-Path $parserExe -PathType Leaf) {
        $args = @("--dump", $dumpPath, "--output", $resolvedRunFolder)
        if (-not [string]::IsNullOrWhiteSpace($moduleFilter) -and $moduleFilter -ne "*") {
            $args += @("--modules", $moduleFilter)
        }
        & $parserExe @args
        if ($LASTEXITCODE -ne 0) {
            throw "Parser executable failed with exit code $LASTEXITCODE"
        }
    }
    elseif (Test-Path $parserSourceProject -PathType Leaf) {
        $args = @("run", "--project", $parserSourceProject, "--configuration", "Release", "--", "--dump", $dumpPath, "--output", $resolvedRunFolder)
        if (-not [string]::IsNullOrWhiteSpace($moduleFilter) -and $moduleFilter -ne "*") {
            $args += @("--modules", $moduleFilter)
        }
        & dotnet @args
        if ($LASTEXITCODE -ne 0) {
            throw "Parser fallback (dotnet run) failed with exit code $LASTEXITCODE"
        }
    }
    else {
        throw "No parser binary or source project found in package."
    }
} else {
    Write-Host "[2/8] Parser step skipped." -ForegroundColor DarkYellow
}

$manifestPath = Join-Path $resolvedRunFolder "manifest.json"
if (-not (Test-Path $manifestPath -PathType Leaf)) {
    throw "Parser output manifest missing: $manifestPath"
}

$manifest = Get-Content -Raw $manifestPath | ConvertFrom-Json
if ($manifest.schemaVersion -ne "2.0") {
    throw "Expected parser schemaVersion 2.0, got $($manifest.schemaVersion)"
}

$modules = Get-ModulesFromManifest -ManifestPath $manifestPath
$kbRoot = $knowledgeBaseRoot

if (-not $SkipScaffold) {
    Write-Host "[3/8] Scaffolding knowledge-base..." -ForegroundColor Yellow
    Invoke-PwshScript -ScriptPath $scaffoldScript -Arguments @("-RunFolder", $resolvedRunFolder, "-OutputRoot", $knowledgeBaseRoot, "-AppName", $appName) -ErrorPrefix "run-kb-scaffold.ps1"

    Write-Host "[4/8] Seeding KB templates..." -ForegroundColor Yellow
    Seed-KbTemplates -ArtifactsRoot $artifactsRoot -AgentsRoot $agentsArtifactRoot -DataRoot $dataRoot -KbRoot $kbRoot -AppName $appName -RunFolder $resolvedRunFolder -Modules $modules
} else {
    Write-Host "[3/8] Scaffold step skipped." -ForegroundColor DarkYellow
    Write-Host "[4/8] Template seeding skipped." -ForegroundColor DarkYellow
    if (-not (Test-Path $kbRoot -PathType Container)) {
        throw "SkipScaffold was used but KB root does not exist: $kbRoot"
    }
}

Write-Host "[4b/8] Seeding standalone mendix-data guides..." -ForegroundColor Yellow
Seed-DataRootGuides -TemplatesRoot $dataRootArtifactsRoot -DataRoot $dataRoot -KbRoot $kbRoot -RunFolder $resolvedRunFolder -AppName $appName -DumpPath $dumpPath

Write-Host "[5/8] Composing behaviour-rich KB content..." -ForegroundColor Yellow
$composeArgs = @("-RunFolder", $resolvedRunFolder, "-OutputRoot", $knowledgeBaseRoot, "-AppName", $appName)
if ($SkipScaffold) { $composeArgs += "-SkipScaffold" }
Invoke-PwshScript -ScriptPath $composeScript -Arguments $composeArgs -ErrorPrefix "run-kb-compose.ps1"

$creatorLinkMprPath = if (-not [string]::IsNullOrWhiteSpace($mprPath)) {
    $mprPath
} else {
    Resolve-MprPathIfAvailable -Settings $settings
}
$creatorLinkPath = Write-CreatorLinkFile -KbRoot $kbRoot -DataRoot $dataRoot -AppName $appName -RunFolder $resolvedRunFolder -MprPath $creatorLinkMprPath
$initKbHandoffPath = Write-InitKbHandoffFile -KbRoot $kbRoot -DataRoot $dataRoot -AppName $appName -RunFolder $resolvedRunFolder -CreatorLinkPath $creatorLinkPath

Write-Host "[6/8] Running scaffold validation..." -ForegroundColor Yellow
Invoke-PwshScript -ScriptPath $scaffoldScript -Arguments @("-Validate", "-OutputRoot", $knowledgeBaseRoot, "-AppName", $appName) -ErrorPrefix "Scaffold validation"
$structuralValidationStatus = "pass"

$qualityGateStatus = "pass"
Write-Host "[7/8] Running hybrid quality gate..." -ForegroundColor Yellow
try {
    Invoke-PwshScript -ScriptPath $qualityGateScript -Arguments @("-OutputRoot", $knowledgeBaseRoot, "-AppName", $appName) -ErrorPrefix "Quality gate"
} catch {
    $qualityGateStatus = "fail"
    if ($strictMode) {
        throw $_
    }
    Write-Warning "Quality gate failed in non-strict mode."
}

$benchmarkStatus = "pass"
Write-Host "[8/8] Running semantic benchmark..." -ForegroundColor Yellow
$benchmarkArgs = @("-OutputRoot", $knowledgeBaseRoot, "-AppName", $appName)
if (-not [string]::IsNullOrWhiteSpace($customScenariosPath)) {
    if (-not (Test-Path $customScenariosPath -PathType Leaf)) {
        throw "Custom scenarios file configured but not found: $customScenariosPath"
    }
    $benchmarkArgs += @("-CustomScenarios", $customScenariosPath)
}
try {
    Invoke-PwshScript -ScriptPath $semanticBenchmarkScript -Arguments $benchmarkArgs -ErrorPrefix "Semantic benchmark"
} catch {
    $benchmarkStatus = "fail"
    if ($strictMode) {
        throw $_
    }
    Write-Warning "Semantic benchmark failed in non-strict mode."
}

Write-Host ""
Write-Host "Completed." -ForegroundColor Green
Write-Host "App name:                    $appName"
Write-Host "Run folder:                  $resolvedRunFolder"
Write-Host "Module count:                $($modules.Count)"
Write-Host "Structural validation status: $structuralValidationStatus"
Write-Host "Quality gate status:         $qualityGateStatus"
Write-Host "Benchmark status:            $benchmarkStatus"
Write-Host "KB folder:                   $kbRoot"
if (-not [string]::IsNullOrWhiteSpace($creatorLinkPath)) {
    Write-Host "Creator link:                $creatorLinkPath"
}
if (-not [string]::IsNullOrWhiteSpace($initKbHandoffPath)) {
    Write-Host "Init KB handoff:             $initKbHandoffPath"
}
Write-Host "Start AI with:               AGENTS.md"

if ($OpenOutput -and (Test-Path $kbRoot -PathType Container)) {
    explorer.exe $kbRoot
}
