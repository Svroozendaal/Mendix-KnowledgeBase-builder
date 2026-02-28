using System;
using System.ComponentModel.Composition;
using Mendix.StudioPro.ExtensionsAPI.UI.DockablePane;

namespace AutoCommitMessage;

[Export(typeof(DockablePaneExtension))]
public sealed class AutoCommitMessageDockablePaneExtension : DockablePaneExtension
{
    public override string Id => ExtensionConstants.PaneId;

    public override DockablePanePosition InitialPosition => DockablePanePosition.Right;

    public override DockablePaneViewModelBase Open()
    {
        var currentProjectPath = CurrentApp?.Root?.DirectoryPath ?? string.Empty;

        // Detect Mendix installation at startup if not already detected.
        DetectMendixInstallationIfNeeded(currentProjectPath);

        // Run one-time migration for legacy folder names.
        RunFolderMigrationIfNeeded(currentProjectPath);

        var panelAddress = BuildPanelAddress(currentProjectPath);
        return new AutoCommitMessageDockablePaneViewModel(panelAddress);
    }

    /// <summary>
    /// Runs Mendix installation detection at startup.
    /// Stores result in ExtensionConfigurationService for use by MxToolService and UI.
    /// </summary>
    private void DetectMendixInstallationIfNeeded(string projectPath)
    {
        if (string.IsNullOrWhiteSpace(projectPath))
        {
            return;
        }

        try
        {
            // Check if we already have a detection result.
            var existing = ExtensionConfigurationService.GetDetectionResult();
            if (existing?.Success == true)
            {
                return; // Already detected successfully.
            }

            // Locate the .mpr file in the project path.
            var mprPath = FindMprFile(projectPath);
            if (string.IsNullOrWhiteSpace(mprPath))
            {
                return; // No .mpr file found; skip detection.
            }

            // Run detection with any override from settings.
            var installRootOverride = ExtensionConfigurationService.GetInstallRootOverride();
            var detector = new MendixInstallationDetectorService();
            var result = detector.Detect(mprPath, installRootOverride);

            ExtensionConfigurationService.SetDetectionResult(result);
        }
        catch
        {
            // Silently ignore detection errors at startup; UI will show the failure.
        }
    }

    /// <summary>
    /// Runs one-time folder migration for legacy names (exports/ → _legacy_exports/, structured/ → _legacy_structured/).
    /// Safe to call every startup (idempotent).
    /// </summary>
    private void RunFolderMigrationIfNeeded(string projectPath)
    {
        if (string.IsNullOrWhiteSpace(projectPath))
        {
            return;
        }

        try
        {
            var dataRootPath = ExtensionDataPaths.ResolveDataRoot(projectPath);
            AutoCommitMessageFolderMigrationService.MigrateIfNeeded(dataRootPath);
        }
        catch
        {
            // Silently ignore migration errors - they are non-fatal.
        }
    }

    /// <summary>
    /// Finds the .mpr file in the project directory.
    /// Searches for *.mpr files and returns the first one found.
    /// </summary>
    private string? FindMprFile(string projectPath)
    {
        try
        {
            if (!Directory.Exists(projectPath))
            {
                return null;
            }

            var mprFiles = Directory.EnumerateFiles(projectPath, "*.mpr", SearchOption.TopDirectoryOnly);
            return mprFiles.FirstOrDefault();
        }
        catch
        {
            return null;
        }
    }

    private Uri BuildPanelAddress(string projectPath)
    {
        var routeAddress = new Uri(WebServerBaseUrl, $"{ExtensionConstants.WebServerRoutePrefix}/");
        var query = new List<string>
        {
            $"_v={DateTimeOffset.UtcNow.Ticks}",
        };

        if (!string.IsNullOrWhiteSpace(projectPath))
        {
            query.Add($"{ExtensionConstants.ProjectPathQueryKey}={Uri.EscapeDataString(projectPath)}");
        }

        return new Uri($"{routeAddress}?{string.Join("&", query)}");
    }
}

