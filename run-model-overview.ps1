[CmdletBinding()]
param(
    [string]$DumpPath,
    [string]$OutputPath,
    [string]$Modules,
    [switch]$SkipBuild,
    [switch]$OpenOutput
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$cliProjectPath = Join-Path $repoRoot 'model-overview-cli\ModelOverviewCli.csproj'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Read-DotEnv {
    param([string]$Path)
    $result = @{}
    if (-not (Test-Path $Path -PathType Leaf)) { return $result }
    foreach ($rawLine in Get-Content -Path $Path) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) { continue }
        $separatorIndex = $line.IndexOf('=')
        if ($separatorIndex -lt 1) { continue }
        $key = $line.Substring(0, $separatorIndex).Trim()
        if ([string]::IsNullOrWhiteSpace($key)) { continue }
        $value = $line.Substring($separatorIndex + 1).Trim()
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

function Resolve-DataRoot {
    $dotEnvPath = Join-Path $repoRoot '.env'
    $env = Read-DotEnv -Path $dotEnvPath

    if ($env.ContainsKey('MENDIX_DATA_ROOT') -and (Test-Path $env['MENDIX_DATA_ROOT'])) {
        return $env['MENDIX_DATA_ROOT']
    }

    $fallback = Join-Path $repoRoot 'mendix-data'
    if (Test-Path $fallback) { return $fallback }

    Write-Error "Could not resolve data root. Set MENDIX_DATA_ROOT in .env or ensure mendix-data/ exists."
    exit 1
}

function Show-NumberedMenu {
    param(
        [string]$Title,
        [string[]]$Items,
        [switch]$MultiSelect,
        [switch]$AllowAll
    )

    Write-Host ""
    Write-Host "=== $Title ===" -ForegroundColor Cyan
    for ($i = 0; $i -lt $Items.Length; $i++) {
        Write-Host "  [$($i + 1)] $($Items[$i])"
    }
    if ($AllowAll) {
        Write-Host "  [*] All" -ForegroundColor Yellow
    }
    Write-Host ""

    if ($MultiSelect) {
        $input = Read-Host "Select (comma-separated numbers, or * for all)"
        if ($input.Trim() -eq '*') {
            return 0..($Items.Length - 1)
        }
        $indices = @()
        foreach ($part in $input.Split(',')) {
            $num = 0
            if ([int]::TryParse($part.Trim(), [ref]$num) -and $num -ge 1 -and $num -le $Items.Length) {
                $indices += ($num - 1)
            }
        }
        return $indices
    }
    else {
        $num = 0
        do {
            $input = Read-Host "Select a number (1-$($Items.Length))"
        } while (-not ([int]::TryParse($input.Trim(), [ref]$num) -and $num -ge 1 -and $num -le $Items.Length))
        return ($num - 1)
    }
}

# ---------------------------------------------------------------------------
# Step 1: Resolve data root
# ---------------------------------------------------------------------------

$dataRoot = Resolve-DataRoot
Write-Host "Data root: $dataRoot" -ForegroundColor DarkGray

# ---------------------------------------------------------------------------
# Step 2: Select dump file
# ---------------------------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($DumpPath)) {
    $dumpsFolder = Join-Path $dataRoot 'dumps'
    if (-not (Test-Path $dumpsFolder)) {
        Write-Error "Dumps folder not found: $dumpsFolder"
        exit 1
    }

    # Find dump folders that contain a JSON dump file
    $dumpFolders = Get-ChildItem -Path $dumpsFolder -Directory |
        Where-Object { $_.Name -ne 'head-cache' } |
        Where-Object {
            (Test-Path (Join-Path $_.FullName 'working-dump.json')) -or
            (Test-Path (Join-Path $_.FullName 'head-dump.json'))
        } |
        Sort-Object Name -Descending

    if ($dumpFolders.Count -eq 0) {
        Write-Error "No dump folders found in: $dumpsFolder"
        exit 1
    }

    # Build display items: show folder name and which dump files are available
    $displayItems = @()
    $dumpFiles = @()
    foreach ($folder in $dumpFolders) {
        $hasWorking = Test-Path (Join-Path $folder.FullName 'working-dump.json')
        $hasHead = Test-Path (Join-Path $folder.FullName 'head-dump.json')
        $label = $folder.Name
        if ($hasWorking -and $hasHead) {
            $label += " (working + head)"
        } elseif ($hasWorking) {
            $label += " (working)"
        } else {
            $label += " (head)"
        }
        $displayItems += $label

        # Prefer working-dump.json for overview generation
        if ($hasWorking) {
            $dumpFiles += (Join-Path $folder.FullName 'working-dump.json')
        } else {
            $dumpFiles += (Join-Path $folder.FullName 'head-dump.json')
        }
    }

    $selectedIndex = Show-NumberedMenu -Title "Select a dump" -Items $displayItems
    $DumpPath = $dumpFiles[$selectedIndex]
    Write-Host "Selected: $DumpPath" -ForegroundColor Green
}

if (-not (Test-Path $DumpPath -PathType Leaf)) {
    Write-Error "Dump file not found: $DumpPath"
    exit 1
}

# ---------------------------------------------------------------------------
# Step 3: Build the CLI (unless skipped)
# ---------------------------------------------------------------------------

if (-not $SkipBuild) {
    Write-Host ""
    Write-Host "Building CLI..." -ForegroundColor Yellow
    dotnet build $cliProjectPath --configuration Debug --verbosity quiet
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed."
        exit 1
    }
    Write-Host "Build succeeded." -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Step 4: List and select modules
# ---------------------------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($Modules)) {
    Write-Host ""
    Write-Host "Loading modules from dump..." -ForegroundColor Yellow

    $moduleJson = dotnet run --project $cliProjectPath --no-build -- --dump $DumpPath --list-modules
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to list modules."
        exit 1
    }

    $moduleList = $moduleJson | ConvertFrom-Json

    if ($moduleList.Count -eq 0) {
        Write-Error "No modules found in dump."
        exit 1
    }

    $moduleDisplayItems = @()
    foreach ($m in $moduleList) {
        $categoryTag = switch ($m.category) {
            'System'      { '[System]      ' }
            'Marketplace' { '[Marketplace] ' }
            default       { '[Custom]      ' }
        }
        $moduleDisplayItems += "$categoryTag$($m.module)"
    }

    $selectedIndices = Show-NumberedMenu -Title "Select modules" -Items $moduleDisplayItems -MultiSelect -AllowAll

    if ($selectedIndices.Count -eq 0) {
        Write-Error "No modules selected."
        exit 1
    }

    $selectedNames = @()
    foreach ($idx in $selectedIndices) {
        $selectedNames += $moduleList[$idx].module
    }
    $Modules = $selectedNames -join ','

    Write-Host "Selected modules: $Modules" -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Step 5: Resolve output path
# ---------------------------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $overviewsFolder = Join-Path $dataRoot 'app-overview'
    $timestamp = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH-mm-ss.fffZ')
    $OutputPath = Join-Path $overviewsFolder "cli_$timestamp"
}

# ---------------------------------------------------------------------------
# Step 6: Generate overview
# ---------------------------------------------------------------------------

Write-Host ""
Write-Host "Generating overview..." -ForegroundColor Yellow

$cliArgs = @('--dump', $DumpPath, '--output', $OutputPath)
if (-not [string]::IsNullOrWhiteSpace($Modules)) {
    $cliArgs += @('--modules', $Modules)
}

dotnet run --project $cliProjectPath --no-build -- @cliArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "Overview generation failed."
    exit 1
}

Write-Host ""
Write-Host "Done! Output: $OutputPath" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Step 7: Optionally open output
# ---------------------------------------------------------------------------

if ($OpenOutput -and (Test-Path $OutputPath)) {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        code $OutputPath
    } else {
        explorer.exe $OutputPath
    }
}
