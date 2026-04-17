[CmdletBinding()]
param(
    [string]$KnowledgeBaseRoot,
    [string]$AppName,
    [string]$ClaudeCliPath,
    [string]$CreatorRoot
)

$ErrorActionPreference = "Stop"

$cliRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = if (-not [string]::IsNullOrWhiteSpace($CreatorRoot)) {
    [IO.Path]::GetFullPath($CreatorRoot.Trim().Trim('"'))
} else {
    Split-Path -Parent $cliRoot
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

function Write-Utf8ToProcessStdin {
    param(
        [Parameter(Mandatory)]
        [System.Diagnostics.Process]$Process,
        [Parameter(Mandatory)]
        [string]$Text
    )

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    $bytes = $utf8.GetBytes($Text)
    $Process.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
    $Process.StandardInput.BaseStream.Flush()
    $Process.StandardInput.Close()
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

function Resolve-CodexCli {
    param([string]$ExplicitPath)

    if (-not [string]::IsNullOrWhiteSpace($ExplicitPath)) {
        $resolved = Normalize-AbsolutePath -Path $ExplicitPath
        if (Test-Path $resolved -PathType Leaf) {
            # Prefer .cmd shim on Windows.
            if (-not ($resolved -match '\.(exe|cmd|bat|ps1)$')) {
                $cmdVariant = "$resolved.cmd"
                if (Test-Path $cmdVariant -PathType Leaf) { return $cmdVariant }
            }
            return $resolved
        }
        Write-Warning "Explicit codex CLI path not found: $resolved"
    }

    $onPath = Get-Command codex -ErrorAction SilentlyContinue
    if ($null -ne $onPath) {
        $src = $onPath.Source
        if ($src) {
            $basePath = $src -replace '\.(exe|cmd|bat|ps1)$', ''
            $cmdVariant = "$basePath.cmd"
            if (Test-Path $cmdVariant -PathType Leaf) { return $cmdVariant }
        }
        return $src
    }

    $candidates = @(
        (Join-Path $env:APPDATA "npm\codex.cmd")
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
# Primary source: environment variables set by the caller or local shell.
$aiProvider       = [Environment]::GetEnvironmentVariable("AI_PROVIDER")
$anthropicKeyEnv  = [Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY")
$apiModel         = [Environment]::GetEnvironmentVariable("CLAUDE_API_MODEL")

if ([string]::IsNullOrWhiteSpace($aiProvider)) { $aiProvider = "ClaudeCli" }
Write-Host "AI provider:         $aiProvider" -ForegroundColor Cyan

# --- Resolve selected AI CLI ---
$envClaudePath = [Environment]::GetEnvironmentVariable("CLAUDE_CLI_PATH")
$envCodexPath = [Environment]::GetEnvironmentVariable("CODEX_CLI_PATH")
$resolvedAiCliPath = $null

switch ($aiProvider) {
    "CodexCli" {
        $codexPathCandidate = if (-not [string]::IsNullOrWhiteSpace($envCodexPath)) {
            $envCodexPath
        } elseif (-not [string]::IsNullOrWhiteSpace($ClaudeCliPath)) {
            # Backward compatibility: older callers only pass -ClaudeCliPath.
            $ClaudeCliPath
        } else {
            ""
        }

        $resolvedAiCliPath = Resolve-CodexCli -ExplicitPath $codexPathCandidate
        if ([string]::IsNullOrWhiteSpace($resolvedAiCliPath)) {
            Write-Host ""
            Write-Host "ERROR: Codex CLI not found." -ForegroundColor Red
            Write-Host ""
            Write-Host "Install with:"
            Write-Host "  npm install -g @openai/codex"
            Write-Host ""
            Write-Host "Or set CODEX_CLI_PATH to a valid executable."
            Write-Host ""
            exit 2
        }

        Write-Host "Codex CLI:           $resolvedAiCliPath"
    }
    default {
        $claudePathCandidate = if (-not [string]::IsNullOrWhiteSpace($ClaudeCliPath)) {
            $ClaudeCliPath
        } elseif (-not [string]::IsNullOrWhiteSpace($envClaudePath)) {
            $envClaudePath
        } else {
            ""
        }

        $resolvedAiCliPath = Resolve-ClaudeCli -ExplicitPath $claudePathCandidate
        if ([string]::IsNullOrWhiteSpace($resolvedAiCliPath)) {
            Write-Host ""
            Write-Host "ERROR: Claude CLI not found." -ForegroundColor Red
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

        Write-Host "Claude CLI:          $resolvedAiCliPath"
    }
}

# --- Resolve module filter ---
$enrichModulesEnv = [Environment]::GetEnvironmentVariable("ENRICH_MODULES")
$moduleFilterList = @()
$moduleFilterPrompt = ""
if (-not [string]::IsNullOrWhiteSpace($enrichModulesEnv)) {
    $moduleFilterList = @($enrichModulesEnv.Split(',', [System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })
    if ($moduleFilterList.Count -gt 0) {
        $moduleNames = ($moduleFilterList | ForEach-Object { "- $_" }) -join "`n"
        $moduleFilterPrompt = @"

IMPORTANT — MODULE SCOPE RESTRICTION:
Only enrich the following modules (skip all others):
$moduleNames

Do NOT enrich app-level files (APP_OVERVIEW.md, MODULE_LANDSCAPE.md, SECURITY.md, CALL_GRAPH.md).
Do NOT resolve Unknown items outside the listed modules.
Only process the modules listed above, one at a time.
"@
        Write-Host "Module filter:       $($moduleFilterList.Count) module(s)" -ForegroundColor Cyan
        foreach ($m in $moduleFilterList) {
            Write-Host "  - $m"
        }
    }
} else {
    Write-Host "Module filter:       all (no filter)" -ForegroundColor Cyan
}

# --- Build enrichment prompt ---
$enrichSkillPath = Join-Path $packageRoot ".agents\skills\enrichkb\SKILL.md"
$generalSkillPath = Join-Path $packageRoot ".agents\skills\mendix-overview-general-interpretation\SKILL.md"
$moduleSkillPath = Join-Path $packageRoot ".agents\skills\mendix-overview-module-interpretation\SKILL.md"

$enrichPrompt = @"
You are running the enrichKB workflow for the Mendix KnowledgeBase Creator.

Read ONLY these three files for the enrichment procedure and guidance:
1. $enrichSkillPath — the master procedure (follow this exactly)
2. $generalSkillPath — guidance for app-level file enrichment
3. $moduleSkillPath — guidance for per-module file enrichment

IMPORTANT: Do NOT follow any instructions to read additional agent or framework
files (AGENTS.md, KNOWLEDGEBASE_CREATOR.md, KNOWLEDGEBASE_INTERPRETER.md,
AI_WORKFLOW.md). All necessary instructions are already in the three files above.
Reading extra framework files wastes tokens without adding value.

Key parameters:
- Knowledge base root: $resolvedKbRoot
- Source run folder: $resolvedRunFolder
- App name: $resolvedAppName

WRITE AUTHORISATION FOR THIS RUN:
- This invocation is the explicit /enrichkb workflow.
- Writing KB narrative files is allowed for this run.
- Allowed write targets: app/APP_OVERVIEW.md, app/MODULE_LANDSCAPE.md,
  app/SECURITY.md, app/CALL_GRAPH.md, modules/<Name>/INTERPRETATION.md,
  and _reports/UNKNOWN_TODO.md when resolving items.
- Any generic "KB is read-only" guidance applies only to normal interpretation
  and must NOT block this enrichment run.
- Reading source data under $resolvedRunFolder is explicitly allowed for this run.

EFFICIENCY RULES FOR THIS RUN:
- Do NOT parse CLI or terminal run logs for enrichment content.
- Do NOT read CURRENT_RUN.md, console transcripts, or validation reports
  (quality-gate-latest.md/json, l2-contract-debt.*, scaffold logs) unless you
  are diagnosing a specific enrichment failure.
- During enrichment, read only the files required by the listed skills and the
  current module being processed.

Execute the enrichkb SKILL.md procedure:
1. Read the target KB's ROUTING.md and _reports/UNKNOWN_TODO.md once for orientation.
2. Enrich app-level KB files first (use general-interpretation guidance).
3. Then enrich custom modules one at a time (use module-interpretation guidance),
   loading only that module's collection abstracts, L1 overviews as needed, and
   source pseudo exports. Prefer targeted heading reads over full-file loads for
   large pseudo.txt files.
4. Write module narrative only to modules/<Name>/INTERPRETATION.md.
5. Resolve Unknown items where evidence exists.
6. Mark all AI-added narratives as Confidence: Inferred.
7. Never remove export-backed data, headings, tables, links, anchors, or
   pointer/evidence blocks. Never edit L0/L1 overview files.
8. Prioritise custom modules over marketplace modules.
$moduleFilterPrompt
After enrichment, report which files were enriched and any remaining gaps.
"@

# --- Invoke selected AI provider ---
Write-Host ""
Write-Host "Starting AI enrichment..." -ForegroundColor Cyan
Write-Host ""

$aiExitCode = 0
$tempConfigDir = $null

if ($aiProvider -eq "CodexCli") {
    $codexProcess = New-Object System.Diagnostics.ProcessStartInfo
    $codexProcess.UseShellExecute = $false
    $codexProcess.RedirectStandardOutput = $true
    $codexProcess.RedirectStandardError = $true
    $codexProcess.RedirectStandardInput = $true
    $codexProcess.CreateNoWindow = $true
    $codexProcess.WorkingDirectory = $packageRoot
    $codexArgs = "exec --full-auto -"

    if ($resolvedAiCliPath -match '\.(cmd|bat)$') {
        $codexProcess.FileName = "cmd.exe"
        $codexProcess.Arguments = "/c `"`"$resolvedAiCliPath`" $codexArgs`""
    } elseif ($resolvedAiCliPath -match '\.ps1$') {
        $codexProcess.FileName = "powershell.exe"
        $codexProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$resolvedAiCliPath`" $codexArgs"
    } else {
        $codexProcess.FileName = $resolvedAiCliPath
        $codexProcess.Arguments = $codexArgs
    }
    $process = [System.Diagnostics.Process]::Start($codexProcess)
    if ($null -eq $process) {
        Write-Host "ERROR: Failed to start Codex CLI process." -ForegroundColor Red
        exit 1
    }

    $stdoutEvent = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -Action {
        if (-not [string]::IsNullOrWhiteSpace($EventArgs.Data)) {
            Write-Host $EventArgs.Data
        }
    }
    $stderrEvent = Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -Action {
        if (-not [string]::IsNullOrWhiteSpace($EventArgs.Data)) {
            Write-Host "[ERR] $($EventArgs.Data)" -ForegroundColor Yellow
        }
    }
    $process.BeginOutputReadLine()
    $process.BeginErrorReadLine()

    # Feed the prompt through stdin as UTF-8 to avoid encoding issues.
    Write-Utf8ToProcessStdin -Process $process -Text $enrichPrompt

    $nextHeartbeat = [DateTime]::UtcNow.AddSeconds(20)
    while (-not $process.WaitForExit(200)) {
        if ([DateTime]::UtcNow -ge $nextHeartbeat) {
            Write-Host "[info] Codex is still running..." -ForegroundColor DarkGray
            $nextHeartbeat = [DateTime]::UtcNow.AddSeconds(20)
        }
    }

    $process.WaitForExit()
    $aiExitCode = $process.ExitCode
    Start-Sleep -Milliseconds 200

    if ($null -ne $stdoutEvent) {
        Unregister-Event -SourceIdentifier $stdoutEvent.Name -ErrorAction SilentlyContinue
        Remove-Job -Id $stdoutEvent.Id -Force -ErrorAction SilentlyContinue
    }
    if ($null -ne $stderrEvent) {
        Unregister-Event -SourceIdentifier $stderrEvent.Name -ErrorAction SilentlyContinue
        Remove-Job -Id $stderrEvent.Id -Force -ErrorAction SilentlyContinue
    }

    $process.Dispose()
}
else {
    try {
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
        if ($resolvedAiCliPath -match '\.(cmd|bat)$') {
            $claudeProcess.FileName = "cmd.exe"
            $claudeProcess.Arguments = "/c `"`"$resolvedAiCliPath`" $claudeArgs`""
        } elseif ($resolvedAiCliPath -match '\.ps1$') {
            $claudeProcess.FileName = "powershell.exe"
            $claudeProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$resolvedAiCliPath`" $claudeArgs"
        } else {
            $claudeProcess.FileName = $resolvedAiCliPath
            $claudeProcess.Arguments = $claudeArgs
        }

        $process = [System.Diagnostics.Process]::Start($claudeProcess)
        if ($null -eq $process) {
            Write-Host "ERROR: Failed to start Claude CLI process." -ForegroundColor Red
            exit 1
        }

        # Feed the prompt through stdin as UTF-8.
        Write-Utf8ToProcessStdin -Process $process -Text $enrichPrompt

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
        $aiExitCode = $process.ExitCode
        $process.Dispose()
    }
    finally {
        if (-not [string]::IsNullOrWhiteSpace($tempConfigDir) -and (Test-Path $tempConfigDir)) {
            Remove-Item $tempConfigDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

if ($aiExitCode -ne 0) {
    Write-Host ""

    if ($aiProvider -eq "CodexCli") {
        Write-Host "Codex CLI exited with code $aiExitCode." -ForegroundColor Red
        exit $aiExitCode
    }

    Write-Host "Claude CLI exited with code $aiExitCode." -ForegroundColor Red
    if ($aiExitCode -eq 1) {
        Write-Host ""
        Write-Host "This may indicate an authentication issue. Try running:"
        Write-Host "  claude login"
        exit 3
    }

    exit $aiExitCode
}

# --- Post-enrichment validation ---
Write-Host ""
Write-Host "Running post-enrichment validation..." -ForegroundColor Cyan

$scaffoldValidateScript = Join-Path $cliRoot "run-kb-scaffold.ps1"
$qualityGateScript = Join-Path $cliRoot "run-kb-quality-gate.ps1"

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
