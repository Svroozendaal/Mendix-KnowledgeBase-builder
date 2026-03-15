[CmdletBinding()]
param(
    [string]$KnowledgeBaseRoot,
    [string]$AppName,
    [string]$ClaudeCliPath,
    [string]$CreatorRoot
)

$ErrorActionPreference = "Stop"

$wizardRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = if (-not [string]::IsNullOrWhiteSpace($CreatorRoot)) {
    [IO.Path]::GetFullPath($CreatorRoot.Trim().Trim('"'))
} else {
    Split-Path -Parent $wizardRoot
}

# ---------------------------------------------------------------------------
# Helpers (subset reused from run-initkb.ps1)
# ---------------------------------------------------------------------------

function Normalize-AbsolutePath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    return [IO.Path]::GetFullPath($Path.Trim().Trim('"'))
}

function Load-CreatorLink {
    param([string]$ResolvedKnowledgeBaseRoot)

    $linkPath = Join-Path $ResolvedKnowledgeBaseRoot "_sources\creator-link.json"
    if (-not (Test-Path $linkPath -PathType Leaf)) {
        return $null
    }

    return Get-Content -Raw $linkPath | ConvertFrom-Json
}

function Resolve-ClaudeCli {
    param([string]$ExplicitPath)

    if (-not [string]::IsNullOrWhiteSpace($ExplicitPath)) {
        $resolved = Normalize-AbsolutePath -Path $ExplicitPath
        if (Test-Path $resolved -PathType Leaf) {
            # Prefer .cmd shim on Windows — extensionless npm shims are bash
            # scripts that Process.Start cannot execute.
            if (-not ($resolved -match '\.(exe|cmd|bat|ps1)$')) {
                $cmdVariant = "$resolved.cmd"
                if (Test-Path $cmdVariant -PathType Leaf) { return $cmdVariant }
            }
            return $resolved
        }
        Write-Warning "Explicit claude CLI path not found: $resolved"
    }

    $onPath = Get-Command claude -ErrorAction SilentlyContinue
    if ($null -ne $onPath) {
        $src = $onPath.Source
        # Always prefer the .cmd shim on Windows — .ps1 shims cannot be
        # launched via cmd.exe, and extensionless shims are bash scripts.
        if ($src) {
            $basePath = $src -replace '\.(exe|cmd|bat|ps1)$', ''
            $cmdVariant = "$basePath.cmd"
            if (Test-Path $cmdVariant -PathType Leaf) { return $cmdVariant }
        }
        return $src
    }

    $candidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\claude\claude.exe"),
        (Join-Path $env:APPDATA "npm\claude.cmd"),
        (Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Links\claude.exe")
    )

    foreach ($candidate in $candidates) {
        if (-not [string]::IsNullOrWhiteSpace($candidate) -and (Test-Path $candidate -PathType Leaf)) {
            return $candidate
        }
    }

    return $null
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

Write-Host ""
Write-Host "=== enrichkb ===" -ForegroundColor Cyan

# --- Resolve knowledge base root ---
# Priority: 1) -KnowledgeBaseRoot param  2) KNOWLEDGE_BASE_ROOT env var  3) default fallback
$resolvedKbRoot = Normalize-AbsolutePath -Path $KnowledgeBaseRoot
if ([string]::IsNullOrWhiteSpace($resolvedKbRoot)) {
    $envKbRoot = [Environment]::GetEnvironmentVariable("KNOWLEDGE_BASE_ROOT")
    if (-not [string]::IsNullOrWhiteSpace($envKbRoot)) {
        $resolvedKbRoot = Normalize-AbsolutePath -Path $envKbRoot
    }
}
if ([string]::IsNullOrWhiteSpace($resolvedKbRoot)) {
    # Fallback: default location relative to package root
    $defaultKbRoot = Join-Path (Split-Path -Parent $packageRoot) "mendix-data\knowledge-base"
    if (Test-Path $defaultKbRoot -PathType Container) {
        $resolvedKbRoot = $defaultKbRoot
    }
}
if ([string]::IsNullOrWhiteSpace($resolvedKbRoot) -or -not (Test-Path $resolvedKbRoot -PathType Container)) {
    Write-Error "Knowledge base root not found. Provide -KnowledgeBaseRoot or set KNOWLEDGE_BASE_ROOT."
    exit 1
}

Write-Host "Knowledge base root: $resolvedKbRoot"

# --- Load creator-link.json ---
$creatorLink = Load-CreatorLink -ResolvedKnowledgeBaseRoot $resolvedKbRoot
if ($null -eq $creatorLink) {
    Write-Error "creator-link.json not found in $resolvedKbRoot\_sources\. Run the pipeline first."
    exit 1
}

$resolvedAppName = $AppName
if ([string]::IsNullOrWhiteSpace($resolvedAppName)) {
    $envAppName = [Environment]::GetEnvironmentVariable("APP_NAME")
    if (-not [string]::IsNullOrWhiteSpace($envAppName)) {
        $resolvedAppName = $envAppName.Trim()
    }
}
if ([string]::IsNullOrWhiteSpace($resolvedAppName) -and -not [string]::IsNullOrWhiteSpace($creatorLink.appName)) {
    $resolvedAppName = [string]$creatorLink.appName
}
if ([string]::IsNullOrWhiteSpace($resolvedAppName)) {
    Write-Error "App name could not be resolved. Provide -AppName or set APP_NAME."
    exit 1
}

$resolvedRunFolder = $null
if (-not [string]::IsNullOrWhiteSpace($creatorLink.lastRunFolder)) {
    $resolvedRunFolder = Normalize-AbsolutePath -Path $creatorLink.lastRunFolder
}
# If the recorded path doesn't exist, try the "current" alias next to the KB
if ([string]::IsNullOrWhiteSpace($resolvedRunFolder) -or -not (Test-Path $resolvedRunFolder -PathType Container)) {
    # currentAliasPath from creator-link (newer format)
    if (-not [string]::IsNullOrWhiteSpace($creatorLink.currentAliasPath)) {
        $candidate = Normalize-AbsolutePath -Path $creatorLink.currentAliasPath
        if (Test-Path $candidate -PathType Container) { $resolvedRunFolder = $candidate }
    }
    # Fall back: derive from KB root — KB sits at <dataRoot>/knowledge-base,
    # so <dataRoot>/app-overview/current is the sibling.
    if ([string]::IsNullOrWhiteSpace($resolvedRunFolder) -or -not (Test-Path $resolvedRunFolder -PathType Container)) {
        $localDataRoot = Split-Path -Parent $resolvedKbRoot
        $localCurrent  = Join-Path $localDataRoot "app-overview\current"
        if (Test-Path $localCurrent -PathType Container) {
            $resolvedRunFolder = $localCurrent
            Write-Host "Using local run folder: $resolvedRunFolder" -ForegroundColor Yellow
        }
    }
}
if ([string]::IsNullOrWhiteSpace($resolvedRunFolder) -or -not (Test-Path $resolvedRunFolder -PathType Container)) {
    Write-Error "Source run folder not found: $resolvedRunFolder. The pipeline output is missing. Run the pipeline first."
    exit 1
}

Write-Host "App name:            $resolvedAppName"
Write-Host "Source run folder:   $resolvedRunFolder"
Write-Host "Creator root:        $packageRoot"

# --- Validate source data exists ---
$generalFolder = Join-Path $resolvedRunFolder "general"
if (-not (Test-Path $generalFolder -PathType Container)) {
    Write-Error "Source data incomplete: missing $generalFolder. Re-run the pipeline."
    exit 1
}

# --- Resolve AI provider ---
# Primary source: environment variables (set by the wizard C# code).
# Fallback: read directly from config.last.json (handles old wizard exe that
# doesn't pass env vars, or manual script invocations).
$aiProvider       = [Environment]::GetEnvironmentVariable("AI_PROVIDER")
$anthropicKeyEnv  = [Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY")
$apiModel         = [Environment]::GetEnvironmentVariable("CLAUDE_API_MODEL")

$configJsonPath = Join-Path $wizardRoot "config.last.json"
if (Test-Path $configJsonPath -PathType Leaf) {
    try {
        $configJson = Get-Content $configJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $savedAi = $configJson.aiSettings
        if ($null -ne $savedAi) {
            if ([string]::IsNullOrWhiteSpace($aiProvider)) {
                # Map numeric enum values or string names
                $providerRaw = $savedAi.provider
                if ($providerRaw -is [int] -or $providerRaw -match '^\d+$') {
                    $aiProvider = @("ClaudeCli","CodexCli","ClaudeApi")[[int]$providerRaw]
                } elseif (-not [string]::IsNullOrWhiteSpace($providerRaw)) {
                    $aiProvider = [string]$providerRaw
                }
            }
            if ([string]::IsNullOrWhiteSpace($anthropicKeyEnv) -and
                -not [string]::IsNullOrWhiteSpace($savedAi.claudeApiKey)) {
                $anthropicKeyEnv = $savedAi.claudeApiKey
            }
            if ([string]::IsNullOrWhiteSpace($apiModel) -and
                -not [string]::IsNullOrWhiteSpace($savedAi.claudeApiModel)) {
                $apiModel = $savedAi.claudeApiModel
            }
        }
    } catch {
        Write-Host "WARNING: Could not read config.last.json: $_" -ForegroundColor Yellow
    }
}

if ([string]::IsNullOrWhiteSpace($aiProvider)) { $aiProvider = "ClaudeCli" }
Write-Host "AI provider:         $aiProvider" -ForegroundColor Cyan

# --- Resolve claude CLI (needed for all providers as execution engine) ---
$envClaudePath = [Environment]::GetEnvironmentVariable("CLAUDE_CLI_PATH")
$claudeCliResolved = Resolve-ClaudeCli -ExplicitPath $(
    if (-not [string]::IsNullOrWhiteSpace($ClaudeCliPath)) { $ClaudeCliPath }
    elseif (-not [string]::IsNullOrWhiteSpace($envClaudePath)) { $envClaudePath }
    else { "" }
)

if ([string]::IsNullOrWhiteSpace($claudeCliResolved)) {
    Write-Host ""
    Write-Host "ERROR: Claude CLI not found." -ForegroundColor Red
    Write-Host ""
    Write-Host "The enrichKB step requires the Claude CLI to generate AI narratives."
    Write-Host "This applies to all AI providers (the CLI is the execution engine)."
    Write-Host ""
    Write-Host "Install with:"
    Write-Host "  npm install -g @anthropic-ai/claude-code"
    Write-Host ""
    if ($aiProvider -ne "ClaudeApi") {
        Write-Host "Then authenticate with:"
        Write-Host "  claude login"
        Write-Host ""
    }
    Write-Host "Or provide the path explicitly:"
    Write-Host "  -ClaudeCliPath ""C:\path\to\claude.exe"""
    Write-Host ""
    exit 2
}

Write-Host "Claude CLI:          $claudeCliResolved"

# --- Build enrichment prompt ---
$agentsMdPath = Join-Path $packageRoot "AGENTS.md"
$kbCreatorAgentPath = Join-Path $packageRoot ".agents\agents\KNOWLEDGEBASE_CREATOR.md"
$kbBuilderAgentPath = Join-Path $packageRoot ".agents\agents\OVERVIEW_KB_BUILDER.md"
$enrichSkillPath = Join-Path $packageRoot ".agents\skills\enrichkb\SKILL.md"

$enrichPrompt = @"
You are running the enrichKB workflow for the Mendix KnowledgeBase Creator.

Read the following files in order to understand the enrichment procedure:
1. $agentsMdPath
2. $kbCreatorAgentPath
3. $kbBuilderAgentPath
4. $enrichSkillPath

Then execute the enrichment procedure defined in the enrichkb SKILL.md.

Key parameters:
- Knowledge base root: $resolvedKbRoot
- Source run folder: $resolvedRunFolder
- App name: $resolvedAppName
- Creator root: $packageRoot

Follow the SKILL.md procedure exactly:
1. Treat AGENTS/framework docs as session bootstrap, then read the target KB ROUTING.md and _reports/UNKNOWN_TODO.md once.
2. Enrich app-level KB files first.
3. Then enrich custom modules one at a time, loading only that module's collection abstracts, object overviews as needed, and source pseudo exports.
4. Write module narrative only to `modules/<Name>/INTERPRETATION.md`.
5. Resolve Unknown items where evidence exists.
6. Mark all AI-added narratives as Confidence: Inferred.
7. Never remove export-backed data, headings, tables, links, anchors, or pointer/evidence blocks.
8. Prioritise custom modules over marketplace modules.

After enrichment, report which files were enriched and any remaining gaps.
"@

# --- Invoke claude CLI ---
Write-Host ""
Write-Host "Starting AI enrichment..." -ForegroundColor Cyan
Write-Host ""

$promptFile = [IO.Path]::GetTempFileName()
try {
    Set-Content -Path $promptFile -Value $enrichPrompt -Encoding UTF8

    $claudeArgs = "-p --verbose --max-turns 50 --allowedTools Read,Edit,Write,Glob,Grep --output-format stream-json"
    if (-not [string]::IsNullOrWhiteSpace($apiModel)) {
        $claudeArgs += " --model $apiModel"
    }

    $claudeProcess = New-Object System.Diagnostics.ProcessStartInfo
    $claudeProcess.UseShellExecute = $false
    $claudeProcess.RedirectStandardOutput = $true
    $claudeProcess.RedirectStandardError = $true
    $claudeProcess.RedirectStandardInput = $true
    $claudeProcess.CreateNoWindow = $true
    $claudeProcess.WorkingDirectory = $packageRoot

    # When using Claude API provider, explicitly set the API key on the child
    # process and remove any cached OAuth config dir so the CLI is forced to
    # use the key instead of stored login credentials.
    if ($aiProvider -eq "ClaudeApi" -and -not [string]::IsNullOrWhiteSpace($anthropicKeyEnv)) {
        # Access .Environment to get a mutable copy, then set the key explicitly
        $claudeProcess.Environment["ANTHROPIC_API_KEY"] = $anthropicKeyEnv
        # Point config dir to a clean temp folder so stored OAuth is not found
        $tempConfigDir = Join-Path ([IO.Path]::GetTempPath()) "claude-api-session-$([guid]::NewGuid().ToString('N').Substring(0,8))"
        New-Item -ItemType Directory -Path $tempConfigDir -Force | Out-Null
        $claudeProcess.Environment["CLAUDE_CONFIG_DIR"] = $tempConfigDir
        Write-Host "Auth method:         API key (ANTHROPIC_API_KEY)" -ForegroundColor Green
    } else {
        Write-Host "Auth method:         CLI credentials (claude login)" -ForegroundColor Green
    }

    # .cmd/.bat shims need cmd.exe; .ps1 shims need powershell.exe.
    # Extensionless npm shims are bash scripts and cannot be used here.
    if ($claudeCliResolved -match '\.(cmd|bat)$') {
        $claudeProcess.FileName = "cmd.exe"
        $claudeProcess.Arguments = "/c `"`"$claudeCliResolved`" $claudeArgs`""
    } elseif ($claudeCliResolved -match '\.ps1$') {
        $claudeProcess.FileName = "powershell.exe"
        $claudeProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$claudeCliResolved`" $claudeArgs"
    } else {
        $claudeProcess.FileName = $claudeCliResolved
        $claudeProcess.Arguments = $claudeArgs
    }

    $process = [System.Diagnostics.Process]::Start($claudeProcess)

    # Feed the prompt through stdin
    $process.StandardInput.Write($enrichPrompt)
    $process.StandardInput.Close()

    # Read stdout line by line
    while ($null -ne ($line = $process.StandardOutput.ReadLine())) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try {
            $jsonObj = $line | ConvertFrom-Json -ErrorAction SilentlyContinue
            if ($null -ne $jsonObj) {
                if ($jsonObj.type -eq "result" -and -not [string]::IsNullOrWhiteSpace($jsonObj.result)) {
                    Write-Host $jsonObj.result
                }
                elseif ($jsonObj.type -eq "assistant" -and $null -ne $jsonObj.message) {
                    foreach ($block in @($jsonObj.message.content)) {
                        if ($block.type -eq "text" -and -not [string]::IsNullOrWhiteSpace($block.text)) {
                            Write-Host $block.text
                        }
                        elseif ($block.type -eq "tool_use") {
                            Write-Host "[tool] $($block.name)" -ForegroundColor DarkGray
                        }
                    }
                }
                elseif ($jsonObj.type -eq "error") {
                    Write-Host "[ERROR] $($jsonObj.error)" -ForegroundColor Red
                }
            }
            else {
                Write-Host $line
            }
        }
        catch {
            Write-Host $line
        }
    }

    # Also capture stderr
    $stderrOutput = $process.StandardError.ReadToEnd()
    if (-not [string]::IsNullOrWhiteSpace($stderrOutput)) {
        Write-Host $stderrOutput -ForegroundColor Yellow
    }

    $process.WaitForExit()
    $claudeExitCode = $process.ExitCode
    $process.Dispose()
}
finally {
    Remove-Item $promptFile -ErrorAction SilentlyContinue
    if (-not [string]::IsNullOrWhiteSpace($tempConfigDir) -and (Test-Path $tempConfigDir)) {
        Remove-Item $tempConfigDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

if ($claudeExitCode -ne 0) {
    Write-Host ""
    Write-Host "Claude CLI exited with code $claudeExitCode." -ForegroundColor Red

    if ($claudeExitCode -eq 1) {
        Write-Host ""
        Write-Host "This may indicate an authentication issue. Try running:"
        Write-Host "  claude login"
    }

    exit 3
}

# --- Post-enrichment validation ---
Write-Host ""
Write-Host "Running post-enrichment validation..." -ForegroundColor Cyan

$scaffoldValidateScript = Join-Path $wizardRoot "run-kb-scaffold.ps1"
$qualityGateScript = Join-Path $wizardRoot "run-kb-quality-gate.ps1"

$scaffoldStatus = "skipped"
$qualityGateStatus = "skipped"

if (Test-Path $scaffoldValidateScript -PathType Leaf) {
    Write-Host ""
    Write-Host "--- Scaffold validation ---"
    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $scaffoldValidateScript -Validate -OutputRoot $resolvedKbRoot -AppName $resolvedAppName 2>&1 | ForEach-Object {
            Write-Host $_.ToString()
        }
        $scaffoldStatus = if ($LASTEXITCODE -eq 0) { "pass" } else { "fail" }
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
}

if (Test-Path $qualityGateScript -PathType Leaf) {
    Write-Host ""
    Write-Host "--- Quality gate ---"
    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $qualityGateScript -OutputRoot $resolvedKbRoot -AppName $resolvedAppName 2>&1 | ForEach-Object {
            Write-Host $_.ToString()
        }
        $qualityGateStatus = if ($LASTEXITCODE -eq 0) { "pass" } else { "fail" }
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
}

# --- Summary ---
Write-Host ""
Write-Host "=== enrichkb complete ===" -ForegroundColor Green
Write-Host "App name:                    $resolvedAppName"
Write-Host "Knowledge base root:         $resolvedKbRoot"
Write-Host "Source run folder:           $resolvedRunFolder"
Write-Host "Scaffold validation status:  $scaffoldStatus"
Write-Host "Quality gate status:         $qualityGateStatus"

if ($qualityGateStatus -eq "fail") {
    Write-Host ""
    Write-Host "WARNING: Quality gate reported issues. Review the log above for details." -ForegroundColor Yellow
}

exit 0
