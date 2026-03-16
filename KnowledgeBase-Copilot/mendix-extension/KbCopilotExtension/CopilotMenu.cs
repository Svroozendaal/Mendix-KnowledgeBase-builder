using System.ComponentModel.Composition;
using Mendix.StudioPro.ExtensionsAPI.UI.Menu;
using Mendix.StudioPro.ExtensionsAPI.UI.Services;

namespace KbCopilotExtension;

[Export(typeof(MenuExtension))]
public class CopilotMenu : MenuExtension
{
    private readonly IDockingWindowService _dockingWindowService;

    [ImportingConstructor]
    public CopilotMenu(IDockingWindowService dockingWindowService)
    {
        _dockingWindowService = dockingWindowService;
    }

    public override IEnumerable<MenuViewModel> GetMenus()
    {
        yield return new MenuViewModel("Open KB Copilot", () =>
            _dockingWindowService.OpenPane(CopilotDockablePane.PaneId));
    }
}
