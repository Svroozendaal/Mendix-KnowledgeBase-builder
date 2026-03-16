# Build the Mendix Studio Pro C# extension and publish to artifacts/CoPilot
$ErrorActionPreference = 'Stop'

$repoRoot   = Split-Path $PSScriptRoot -Parent
$projectDir = Join-Path $PSScriptRoot 'mendix-extension\KbCopilotExtension'
$artifactDir = Join-Path $repoRoot 'KnowledgeBase-Creator\artifacts\CoPilot'

Write-Host "Building extension: $projectDir"

# Clean artifacts folder
if (Test-Path $artifactDir) {
    Write-Host "Cleaning: $artifactDir"
    Remove-Item $artifactDir -Recurse -Force
}
New-Item $artifactDir -ItemType Directory -Force | Out-Null

# Publish the extension
$publishDir = Join-Path $projectDir 'publish'
if (Test-Path $publishDir) { Remove-Item $publishDir -Recurse -Force }

dotnet publish $projectDir -c Release -o $publishDir
if ($LASTEXITCODE -ne 0) {
    Write-Error "dotnet publish failed with exit code $LASTEXITCODE"
    exit 1
}

# Copy published output to artifacts
Copy-Item "$publishDir\*" $artifactDir -Recurse

# Create manifest.json
$manifest = @{ mx_extensions = @('KbCopilotExtension.dll'); mx_build_extensions = @() }
$manifest | ConvertTo-Json | Set-Content (Join-Path $artifactDir 'manifest.json') -Encoding UTF8

Write-Host ""
Write-Host "Extension published to: $artifactDir"
Write-Host "Done."
