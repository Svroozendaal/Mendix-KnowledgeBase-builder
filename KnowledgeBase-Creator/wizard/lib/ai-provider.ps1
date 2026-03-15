<#
.SYNOPSIS
    Shared AI provider abstraction for KnowledgeBase Creator pipeline scripts.

.DESCRIPTION
    Dot-source this file from any run-*.ps1 script to get:
      - AI provider detection and configuration loading
      - A single Invoke-AiPrompt function that dispatches to Claude CLI, Codex CLI, or Claude API
      - Consistent streaming output, error handling, and exit-code semantics

    Supported providers:
      ClaudeCli  - Anthropic Claude Code CLI  (claude -p ...)
      CodexCli   - OpenAI Codex CLI           (codex -q --full-auto ...)
      ClaudeApi  - Anthropic Messages API     (Invoke-RestMethod)

    Settings are loaded from wizard/config.last.json (written by the .exe wizard).
    Scripts can also override via parameters or environment variables.

.EXAMPLE
    . "$PSScriptRoot/lib/ai-provider.ps1"
    $config = Get-AiConfig -WizardRoot $PSScriptRoot
    $result = Invoke-AiPrompt -Config $config -Prompt "Summarise this KB" -WorkingDirectory $packageRoot
#>

# ── Exit-code contract ──────────────────────────────────────────────────
# 0  = success
# 2  = AI CLI not found / not installed
# 3  = authentication failure
# 4  = API error (rate limit, bad key, etc.)
# 1  = other / unknown failure

# ═══════════════════════════════════════════════════════════════════════
# Models / Config
# ═══════════════════════════════════════════════════════════════════════

function Get-AiConfig {
    <#
    .SYNOPSIS
        Load AI provider settings from config.last.json or environment variables.
    .PARAMETER WizardRoot
        Path to the wizard/ folder that contains config.last.json.
    .PARAMETER ProviderOverride
        Force a specific provider (ClaudeCli, CodexCli, ClaudeApi). Overrides config file.
    .PARAMETER CliPathOverride
        Force a specific CLI executable path. Overrides config file.
    .PARAMETER ApiKeyOverride
        Force a specific API key. Overrides config file.
    #>
    param(
        [string]$WizardRoot,
        [string]$ProviderOverride,
        [string]$CliPathOverride,
        [string]$ApiKeyOverride
    )

    # Defaults
    $config = @{
        Provider      = "ClaudeCli"
        ClaudeCliPath = $null
        CodexCliPath  = $null
        ClaudeApiKey  = $null
        ClaudeApiModel = "claude-sonnet-4-20250514"
    }

    # Load from config.last.json
    $configPath = Join-Path $WizardRoot "config.last.json"
    if (Test-Path $configPath -PathType Leaf) {
        try {
            $json = Get-Content -Raw $configPath | ConvertFrom-Json
            if ($null -ne $json.aiSettings) {
                $ai = $json.aiSettings
                if (-not [string]::IsNullOrWhiteSpace($ai.provider))      { $config.Provider      = [string]$ai.provider }
                if (-not [string]::IsNullOrWhiteSpace($ai.claudeCliPath)) { $config.ClaudeCliPath = [string]$ai.claudeCliPath }
                if (-not [string]::IsNullOrWhiteSpace($ai.codexCliPath))  { $config.CodexCliPath  = [string]$ai.codexCliPath }
                if (-not [string]::IsNullOrWhiteSpace($ai.claudeApiKey))  { $config.ClaudeApiKey  = [string]$ai.claudeApiKey }
                if (-not [string]::IsNullOrWhiteSpace($ai.claudeApiModel)){ $config.ClaudeApiModel = [string]$ai.claudeApiModel }
            }
        }
        catch {
            Write-Warning "Could not parse config.last.json AI settings: $_"
        }
    }

    # Environment variable overrides
    $envProvider = [Environment]::GetEnvironmentVariable("AI_PROVIDER")
    if (-not [string]::IsNullOrWhiteSpace($envProvider)) { $config.Provider = $envProvider }

    $envClaudePath = [Environment]::GetEnvironmentVariable("CLAUDE_CLI_PATH")
    if (-not [string]::IsNullOrWhiteSpace($envClaudePath)) { $config.ClaudeCliPath = $envClaudePath }

    $envCodexPath = [Environment]::GetEnvironmentVariable("CODEX_CLI_PATH")
    if (-not [string]::IsNullOrWhiteSpace($envCodexPath)) { $config.CodexCliPath = $envCodexPath }

    $envApiKey = [Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY")
    if (-not [string]::IsNullOrWhiteSpace($envApiKey)) { $config.ClaudeApiKey = $envApiKey }

    $envApiModel = [Environment]::GetEnvironmentVariable("CLAUDE_API_MODEL")
    if (-not [string]::IsNullOrWhiteSpace($envApiModel)) { $config.ClaudeApiModel = $envApiModel }

    # Explicit parameter overrides (highest priority)
    if (-not [string]::IsNullOrWhiteSpace($ProviderOverride)) { $config.Provider = $ProviderOverride }
    if (-not [string]::IsNullOrWhiteSpace($CliPathOverride)) {
        switch ($config.Provider) {
            "CodexCli" { $config.CodexCliPath = $CliPathOverride }
            default    { $config.ClaudeCliPath = $CliPathOverride }
        }
    }
    if (-not [string]::IsNullOrWhiteSpace($ApiKeyOverride)) { $config.ClaudeApiKey = $ApiKeyOverride }

    return $config
}

function Write-AiConfigSummary {
    <#
    .SYNOPSIS  Print the resolved AI configuration (masking secrets).
    #>
    param([hashtable]$Config)

    Write-Host "AI provider:         $($Config.Provider)"
    switch ($Config.Provider) {
        "ClaudeCli" {
            $resolved = Resolve-ClaudeCliPath -ExplicitPath $Config.ClaudeCliPath
            Write-Host "Claude CLI:          $(if ($resolved) { $resolved } else { '(not found)' })"
        }
        "CodexCli" {
            $resolved = Resolve-CodexCliPath -ExplicitPath $Config.CodexCliPath
            Write-Host "Codex CLI:           $(if ($resolved) { $resolved } else { '(not found)' })"
        }
        "ClaudeApi" {
            $masked = if (-not [string]::IsNullOrWhiteSpace($Config.ClaudeApiKey)) {
                $Config.ClaudeApiKey.Substring(0, [Math]::Min(12, $Config.ClaudeApiKey.Length)) + "..."
            } else { "(not set)" }
            Write-Host "API Key:             $masked"
            Write-Host "Model:               $($Config.ClaudeApiModel)"
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════
# CLI Resolution
# ═══════════════════════════════════════════════════════════════════════

function Resolve-ClaudeCliPath {
    <#
    .SYNOPSIS  Find the claude CLI executable.
    #>
    param([string]$ExplicitPath)

    if (-not [string]::IsNullOrWhiteSpace($ExplicitPath)) {
        $resolved = [IO.Path]::GetFullPath($ExplicitPath.Trim().Trim('"'))
        if (Test-Path $resolved -PathType Leaf) { return $resolved }
        Write-Warning "Explicit Claude CLI path not found: $resolved"
    }

    $onPath = Get-Command claude -ErrorAction SilentlyContinue
    if ($null -ne $onPath) { return $onPath.Source }

    $candidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\claude\claude.exe"),
        (Join-Path $env:APPDATA     "npm\claude.cmd"),
        (Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Links\claude.exe")
    )
    foreach ($c in $candidates) {
        if (-not [string]::IsNullOrWhiteSpace($c) -and (Test-Path $c -PathType Leaf)) { return $c }
    }

    return $null
}

function Resolve-CodexCliPath {
    <#
    .SYNOPSIS  Find the codex CLI executable.
    #>
    param([string]$ExplicitPath)

    if (-not [string]::IsNullOrWhiteSpace($ExplicitPath)) {
        $resolved = [IO.Path]::GetFullPath($ExplicitPath.Trim().Trim('"'))
        if (Test-Path $resolved -PathType Leaf) { return $resolved }
        Write-Warning "Explicit Codex CLI path not found: $resolved"
    }

    $onPath = Get-Command codex -ErrorAction SilentlyContinue
    if ($null -ne $onPath) { return $onPath.Source }

    $candidates = @(
        (Join-Path $env:APPDATA "npm\codex.cmd")
    )
    foreach ($c in $candidates) {
        if (-not [string]::IsNullOrWhiteSpace($c) -and (Test-Path $c -PathType Leaf)) { return $c }
    }

    return $null
}

# ═══════════════════════════════════════════════════════════════════════
# Provider Dispatch
# ═══════════════════════════════════════════════════════════════════════

function Invoke-AiPrompt {
    <#
    .SYNOPSIS
        Send a prompt to the configured AI provider and stream output to the host.
    .DESCRIPTION
        Dispatches to the correct provider based on $Config.Provider.
        Returns a hashtable: @{ ExitCode = <int>; Output = <string> }
    .PARAMETER Config
        Hashtable from Get-AiConfig.
    .PARAMETER Prompt
        The prompt text to send.
    .PARAMETER WorkingDirectory
        Working directory for CLI-based providers.
    .PARAMETER MaxTurns
        Max agentic turns (Claude CLI). Default 50.
    .PARAMETER AllowedTools
        Comma-separated tool list (Claude CLI). Default "Read,Edit,Write,Glob,Grep".
    .PARAMETER SystemPrompt
        Optional system prompt (Claude API only).
    #>
    param(
        [Parameter(Mandatory)]
        [hashtable]$Config,

        [Parameter(Mandatory)]
        [string]$Prompt,

        [string]$WorkingDirectory = (Get-Location).Path,
        [int]$MaxTurns = 50,
        [string]$AllowedTools = "Read,Edit,Write,Glob,Grep",
        [string]$SystemPrompt
    )

    switch ($Config.Provider) {
        "ClaudeCli" {
            return Invoke-ClaudeCli -Config $Config -Prompt $Prompt `
                -WorkingDirectory $WorkingDirectory -MaxTurns $MaxTurns -AllowedTools $AllowedTools
        }
        "CodexCli" {
            return Invoke-CodexCli -Config $Config -Prompt $Prompt `
                -WorkingDirectory $WorkingDirectory
        }
        "ClaudeApi" {
            return Invoke-ClaudeApi -Config $Config -Prompt $Prompt `
                -SystemPrompt $SystemPrompt
        }
        default {
            Write-Error "Unknown AI provider: $($Config.Provider)"
            return @{ ExitCode = 1; Output = "" }
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════
# Provider: Claude CLI
# ═══════════════════════════════════════════════════════════════════════

function Invoke-ClaudeCli {
    param(
        [hashtable]$Config,
        [string]$Prompt,
        [string]$WorkingDirectory,
        [int]$MaxTurns,
        [string]$AllowedTools
    )

    $cliPath = Resolve-ClaudeCliPath -ExplicitPath $Config.ClaudeCliPath
    if ([string]::IsNullOrWhiteSpace($cliPath)) {
        Write-Host ""
        Write-Host "ERROR: Claude CLI not found." -ForegroundColor Red
        Write-Host "Install: npm install -g @anthropic-ai/claude-code"
        Write-Host "Then:    claude login"
        return @{ ExitCode = 2; Output = "" }
    }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $cliPath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = $WorkingDirectory
    $psi.ArgumentList.Add("-p")
    $psi.ArgumentList.Add($Prompt)
    $psi.ArgumentList.Add("--verbose")
    $psi.ArgumentList.Add("--max-turns")
    $psi.ArgumentList.Add([string]$MaxTurns)
    $psi.ArgumentList.Add("--allowedTools")
    $psi.ArgumentList.Add($AllowedTools)
    $psi.ArgumentList.Add("--output-format")
    $psi.ArgumentList.Add("stream-json")

    $process = [System.Diagnostics.Process]::Start($psi)
    $outputBuilder = New-Object System.Text.StringBuilder

    while ($null -ne ($line = $process.StandardOutput.ReadLine())) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $parsed = Read-StreamJsonLine -Line $line
        if ($null -ne $parsed) {
            [void]$outputBuilder.AppendLine($parsed)
        }
    }

    $stderrOutput = $process.StandardError.ReadToEnd()
    if (-not [string]::IsNullOrWhiteSpace($stderrOutput)) {
        Write-Host $stderrOutput -ForegroundColor Yellow
    }

    $process.WaitForExit()
    $exitCode = $process.ExitCode
    $process.Dispose()

    if ($exitCode -ne 0) {
        Write-Host "Claude CLI exited with code $exitCode." -ForegroundColor Red
        if ($exitCode -eq 1) {
            Write-Host "This may indicate an authentication issue. Try: claude login" -ForegroundColor Yellow
            return @{ ExitCode = 3; Output = $outputBuilder.ToString() }
        }
    }

    return @{ ExitCode = $exitCode; Output = $outputBuilder.ToString() }
}

# ═══════════════════════════════════════════════════════════════════════
# Provider: Codex CLI
# ═══════════════════════════════════════════════════════════════════════

function Invoke-CodexCli {
    param(
        [hashtable]$Config,
        [string]$Prompt,
        [string]$WorkingDirectory
    )

    $cliPath = Resolve-CodexCliPath -ExplicitPath $Config.CodexCliPath
    if ([string]::IsNullOrWhiteSpace($cliPath)) {
        Write-Host ""
        Write-Host "ERROR: Codex CLI not found." -ForegroundColor Red
        Write-Host "Install: npm install -g @openai/codex"
        return @{ ExitCode = 2; Output = "" }
    }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $cliPath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = $WorkingDirectory
    # Codex CLI uses: codex -q --full-auto "prompt"
    $psi.ArgumentList.Add("-q")
    $psi.ArgumentList.Add("--full-auto")
    $psi.ArgumentList.Add($Prompt)

    $process = [System.Diagnostics.Process]::Start($psi)
    $outputBuilder = New-Object System.Text.StringBuilder

    while ($null -ne ($line = $process.StandardOutput.ReadLine())) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        Write-Host $line
        [void]$outputBuilder.AppendLine($line)
    }

    $stderrOutput = $process.StandardError.ReadToEnd()
    if (-not [string]::IsNullOrWhiteSpace($stderrOutput)) {
        Write-Host $stderrOutput -ForegroundColor Yellow
    }

    $process.WaitForExit()
    $exitCode = $process.ExitCode
    $process.Dispose()

    if ($exitCode -ne 0) {
        Write-Host "Codex CLI exited with code $exitCode." -ForegroundColor Red
    }

    return @{ ExitCode = $exitCode; Output = $outputBuilder.ToString() }
}

# ═══════════════════════════════════════════════════════════════════════
# Provider: Claude API
# ═══════════════════════════════════════════════════════════════════════

function Invoke-ClaudeApi {
    param(
        [hashtable]$Config,
        [string]$Prompt,
        [string]$SystemPrompt
    )

    $apiKey = $Config.ClaudeApiKey
    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        Write-Host "ERROR: Claude API key not set." -ForegroundColor Red
        Write-Host "Set it in AI Settings or via ANTHROPIC_API_KEY environment variable."
        return @{ ExitCode = 2; Output = "" }
    }

    $model = $Config.ClaudeApiModel
    if ([string]::IsNullOrWhiteSpace($model)) { $model = "claude-sonnet-4-20250514" }

    $messages = @(
        @{ role = "user"; content = $Prompt }
    )

    $body = [ordered]@{
        model      = $model
        max_tokens = 8192
        messages   = $messages
    }

    if (-not [string]::IsNullOrWhiteSpace($SystemPrompt)) {
        $body["system"] = $SystemPrompt
    }

    $headers = @{
        "x-api-key"      = $apiKey
        "anthropic-version" = "2023-06-01"
        "content-type"   = "application/json"
    }

    $jsonBody = $body | ConvertTo-Json -Depth 10 -Compress

    Write-Host "Sending prompt to Claude API ($model)..." -ForegroundColor Cyan

    try {
        $response = Invoke-RestMethod -Uri "https://api.anthropic.com/v1/messages" `
            -Method Post -Headers $headers -Body $jsonBody -TimeoutSec 300

        $outputText = ""
        foreach ($block in @($response.content)) {
            if ($block.type -eq "text") {
                $outputText += $block.text
                Write-Host $block.text
            }
        }

        if ($response.stop_reason -eq "end_turn") {
            return @{ ExitCode = 0; Output = $outputText }
        }
        else {
            Write-Host "API response stop_reason: $($response.stop_reason)" -ForegroundColor Yellow
            return @{ ExitCode = 0; Output = $outputText }
        }
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Host "Claude API error: $errMsg" -ForegroundColor Red

        if ($errMsg -match "401|authentication|unauthorized") {
            Write-Host "Check your API key." -ForegroundColor Yellow
            return @{ ExitCode = 3; Output = "" }
        }
        if ($errMsg -match "429|rate.limit") {
            Write-Host "Rate limited. Wait and retry." -ForegroundColor Yellow
            return @{ ExitCode = 4; Output = "" }
        }

        return @{ ExitCode = 4; Output = "" }
    }
}

# ═══════════════════════════════════════════════════════════════════════
# Stream JSON parser (shared by CLI providers)
# ═══════════════════════════════════════════════════════════════════════

function Read-StreamJsonLine {
    <#
    .SYNOPSIS  Parse one line of Claude CLI stream-json output, write to host, return text if any.
    #>
    param([string]$Line)

    try {
        $obj = $Line | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($null -eq $obj) {
            Write-Host $Line
            return $Line
        }

        if ($obj.type -eq "result" -and -not [string]::IsNullOrWhiteSpace($obj.result)) {
            Write-Host $obj.result
            return $obj.result
        }

        if ($obj.type -eq "assistant" -and $null -ne $obj.message) {
            $textParts = @()
            foreach ($block in @($obj.message.content)) {
                if ($block.type -eq "text" -and -not [string]::IsNullOrWhiteSpace($block.text)) {
                    Write-Host $block.text
                    $textParts += $block.text
                }
                elseif ($block.type -eq "tool_use") {
                    Write-Host "[tool] $($block.name)" -ForegroundColor DarkGray
                }
            }
            if ($textParts.Count -gt 0) { return ($textParts -join "`n") }
        }

        if ($obj.type -eq "error") {
            Write-Host "[ERROR] $($obj.error)" -ForegroundColor Red
            return $null
        }

        return $null
    }
    catch {
        Write-Host $Line
        return $Line
    }
}

# ═══════════════════════════════════════════════════════════════════════
# Utility: Test provider availability
# ═══════════════════════════════════════════════════════════════════════

function Test-AiProviderReady {
    <#
    .SYNOPSIS  Quick check whether the configured provider is usable.
    .OUTPUTS   Hashtable with Ready (bool), Message (string).
    #>
    param([hashtable]$Config)

    switch ($Config.Provider) {
        "ClaudeCli" {
            $path = Resolve-ClaudeCliPath -ExplicitPath $Config.ClaudeCliPath
            if ($path) { return @{ Ready = $true;  Message = "Claude CLI: $path" } }
            else       { return @{ Ready = $false; Message = "Claude CLI not found. Install: npm install -g @anthropic-ai/claude-code" } }
        }
        "CodexCli" {
            $path = Resolve-CodexCliPath -ExplicitPath $Config.CodexCliPath
            if ($path) { return @{ Ready = $true;  Message = "Codex CLI: $path" } }
            else       { return @{ Ready = $false; Message = "Codex CLI not found. Install: npm install -g @openai/codex" } }
        }
        "ClaudeApi" {
            if (-not [string]::IsNullOrWhiteSpace($Config.ClaudeApiKey)) {
                return @{ Ready = $true; Message = "Claude API key set, model: $($Config.ClaudeApiModel)" }
            }
            else {
                return @{ Ready = $false; Message = "Claude API key not set. Configure in AI Settings or set ANTHROPIC_API_KEY." }
            }
        }
        default {
            return @{ Ready = $false; Message = "Unknown provider: $($Config.Provider)" }
        }
    }
}
