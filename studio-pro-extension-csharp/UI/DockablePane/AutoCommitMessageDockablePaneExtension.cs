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
        var panelAddress = BuildPanelAddress(currentProjectPath);
        return new AutoCommitMessageDockablePaneViewModel(panelAddress);
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

