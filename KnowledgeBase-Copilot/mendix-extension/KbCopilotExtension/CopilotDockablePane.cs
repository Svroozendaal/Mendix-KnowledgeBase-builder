using System.ComponentModel.Composition;
using Mendix.StudioPro.ExtensionsAPI.UI.DockablePane;
using Mendix.StudioPro.ExtensionsAPI.UI.WebView;

namespace KbCopilotExtension;

[Export(typeof(DockablePaneExtension))]
public class CopilotDockablePane : DockablePaneExtension
{
    public const string PaneId = "kb-copilot-pane";
    private const string CopilotUrl = "http://localhost:3001";

    public override string Id => PaneId;

    public override DockablePaneViewModelBase Open()
    {
        return new CopilotWebViewModel();
    }

    private class CopilotWebViewModel : WebViewDockablePaneViewModel
    {
        public CopilotWebViewModel()
        {
            Title = "KB Copilot";
        }

        public override void InitWebView(IWebView webView)
        {
            webView.Address = new Uri(CopilotUrl);
        }
    }
}
