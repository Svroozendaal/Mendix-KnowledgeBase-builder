using Mendix.StudioPro.ExtensionsAPI.UI.DockablePane;
using Mendix.StudioPro.ExtensionsAPI.UI.WebView;

namespace AutoCommitMessage;

internal sealed class AutoCommitMessageDockablePaneViewModel : WebViewDockablePaneViewModel
{
    private readonly Uri panelAddress;

    public AutoCommitMessageDockablePaneViewModel(Uri panelAddress)
    {
        this.panelAddress = panelAddress;
    }

    public override void InitWebView(IWebView webView)
    {
        Title = ExtensionConstants.PaneTitle;
        webView.Address = panelAddress;
    }
}

