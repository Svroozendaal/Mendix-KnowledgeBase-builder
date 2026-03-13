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
            return $resolved
        }
        Write-Warning "Explicit claude CLI path not found: $resolved"
    }

    $onPath = Get-Command claude -ErrorAction SilentlyContinue
    if ($null -ne $onPath) {
        return $onPath.Source
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
$resolvedKbRoot = Normalize-AbsolutePath -Path $KnowledgeBaseRoot
if ([string]::IsNullOrWhiteSpace($resolvedKbRoot)) {
    # Try default location relative to package root
    $defaultKbRoot = Join-Path (Split-Path -Parent $packageRoot) "mendix-data\knowledge-base"
    if (Test-Path $defaultKbRoot -PathType Container) {
        $resolvedKbRoot = $defaultKbRoot
    }
}
# Also accept via environment variable
if ([string]::IsNullOrWhiteSpace($resolvedKbRoot)) {
    $envKbRoot = [Environment]::GetEnvironmentVariable("KNOWLEDGE_BASE_ROOT")
    if (-not [string]::IsNullOrWhiteSpace($envKbRoot)) {
        $resolvedKbRoot = Normalize-AbsolutePath -Path $envKbRoot
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

# --- Resolve claude CLI ---
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
    Write-Host ""
    Write-Host "Install options:"
    Write-Host "  npm install -g @anthropic-ai/claude-code"
    Write-Host ""
    Write-Host "After installing, authenticate with:"
    Write-Host "  claude login"
    Write-Host ""
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
1. Read the target KB ROUTING.md and _reports/UNKNOWN_TODO.md
2. Read the source pseudo.txt files from the run folder
3. Enrich app-level KB files conservatively, and enrich module KB files only inside the reserved interpretation headings (`## Interpretation`, `## Domain Interpretation`, `## Flow Interpretation`, `## Page Interpretation`)
4. Resolve Unknown items where evidence exists
5. Mark all AI-added narratives as Confidence: Inferred
6. Never remove export-backed data, headings, tables, links, anchors, or pointer/evidence blocks
7. Prioritise custom modules over marketplace modules

After enrichment, report which files were enriched and any remaining gaps.
"@

# --- Invoke claude CLI ---
Write-Host ""
Write-Host "Starting AI enrichment..." -ForegroundColor Cyan
Write-Host ""

$promptFile = [IO.Path]::GetTempFileName()
try {
    Set-Content -Path $promptFile -Value $enrichPrompt -Encoding UTF8

    $claudeProcess = New-Object System.Diagnostics.ProcessStartInfo
    $claudeProcess.FileName = $claudeCliResolved
    $claudeProcess.UseShellExecute = $false
    $claudeProcess.RedirectStandardOutput = $true
    $claudeProcess.RedirectStandardError = $true
    $claudeProcess.CreateNoWindow = $true
    $claudeProcess.WorkingDirectory = $packageRoot
    $claudeProcess.ArgumentList.Add("-p")
    $claudeProcess.ArgumentList.Add($enrichPrompt)
    $claudeProcess.ArgumentList.Add("--verbose")
    $claudeProcess.ArgumentList.Add("--max-turns")
    $claudeProcess.ArgumentList.Add("50")
    $claudeProcess.ArgumentList.Add("--allowedTools")
    $claudeProcess.ArgumentList.Add("Read,Edit,Write,Glob,Grep")
    $claudeProcess.ArgumentList.Add("--output-format")
    $claudeProcess.ArgumentList.Add("stream-json")

    $process = [System.Diagnostics.Process]::Start($claudeProcess)

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
