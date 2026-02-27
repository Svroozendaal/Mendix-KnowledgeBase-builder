using System.ComponentModel.Composition;
using Mendix.StudioPro.ExtensionsAPI.UI.Menu;
using Mendix.StudioPro.ExtensionsAPI.UI.Services;

namespace AutoCommitMessage;

[Export(typeof(MenuExtension))]
public sealed class AutoCommitMessageMenuExtension : MenuExtension
{
    private readonly IDockingWindowService dockingWindowService;

    [ImportingConstructor]
    public AutoCommitMessageMenuExtension(IDockingWindowService dockingWindowService)
    {
        this.dockingWindowService = dockingWindowService;
    }

    public override IEnumerable<MenuViewModel> GetMenus()
    {
        yield return new MenuViewModel(
            "Open AutoCommitMessage",
            () => dockingWindowService.OpenPane(ExtensionConstants.PaneId));

        yield return new MenuViewModel(
            "Close AutoCommitMessage",
            () => dockingWindowService.ClosePane(ExtensionConstants.PaneId));
    }
}

