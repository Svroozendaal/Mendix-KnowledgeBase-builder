using System.ComponentModel.Composition;
using System.Net;
using System.Text;
using System.Text.Json;
using Mendix.StudioPro.ExtensionsAPI.UI.WebServer;

namespace AutoCommitMessage;

[Export(typeof(WebServerExtension))]
public sealed class AutoCommitMessageWebServerExtension : WebServerExtension
{
    public override void InitializeWebServer(IWebServer webServer)
    {
        webServer.AddRoute(ExtensionConstants.WebServerRoutePrefix, HandleRequestAsync);
    }

    private static async Task HandleRequestAsync(
        HttpListenerRequest request,
        HttpListenerResponse response,
        CancellationToken cancellationToken)
    {
        var projectPath = NormalizeProjectPath(ReadQueryParameter(request.Url, ExtensionConstants.ProjectPathQueryKey));
        var action = ReadQueryParameter(request.Url, ExtensionConstants.ActionQueryKey);

        if (string.Equals(action, ExtensionConstants.ExportActionValue, StringComparison.OrdinalIgnoreCase))
        {
            await HandleExportRequestAsync(projectPath, response, cancellationToken);
            return;
        }

        if (string.Equals(action, ExtensionConstants.RefreshActionValue, StringComparison.OrdinalIgnoreCase))
        {
            await HandleRefreshRequestAsync(projectPath, response, cancellationToken);
            return;
        }

        var payload = await Task.Run(() => AutoCommitMessageChangeService.ReadChanges(projectPath), cancellationToken);
        var html = AutoCommitMessagePanelHtml.Render(payload, projectPath);
        var content = Encoding.UTF8.GetBytes(html);

        ApplyNoCacheHeaders(response);
        response.ContentType = "text/html; charset=utf-8";
        response.StatusCode = 200;
        response.ContentLength64 = content.Length;
        await response.OutputStream.WriteAsync(content, cancellationToken);
    }

    private static async Task HandleRefreshRequestAsync(
        string projectPath,
        HttpListenerResponse response,
        CancellationToken cancellationToken)
    {
        var payload = await Task.Run(() => AutoCommitMessageChangeService.ReadChanges(projectPath), cancellationToken);
        await WriteJsonResponseAsync(response, 200, payload, cancellationToken);
    }

    private static async Task HandleExportRequestAsync(
        string projectPath,
        HttpListenerResponse response,
        CancellationToken cancellationToken)
    {
        var payload = await Task.Run(() => AutoCommitMessageChangeService.ReadChanges(projectPath, persistModelDumps: true), cancellationToken);
        if (!payload.IsGitRepo)
        {
            await WriteJsonResponseAsync(
                response,
                400,
                new { success = false, message = "Current project is not a Git repository." },
                cancellationToken);
            return;
        }

        if (!string.IsNullOrWhiteSpace(payload.Error))
        {
            await WriteJsonResponseAsync(
                response,
                500,
                new { success = false, message = payload.Error },
                cancellationToken);
            return;
        }

        if (payload.Changes.Count == 0)
        {
            await WriteJsonResponseAsync(
                response,
                400,
                new { success = false, message = "No uncommitted changes to export." },
                cancellationToken);
            return;
        }

        try
        {
            var outputPath = await Task.Run(
                () => AutoCommitMessageExportService.ExportChanges(payload, projectPath),
                cancellationToken);

            await WriteJsonResponseAsync(
                response,
                200,
                new
                {
                    success = true,
                    message = $"Exported {payload.Changes.Count} file(s).",
                    outputPath,
                    changeCount = payload.Changes.Count,
                    exportFolder = ExtensionDataPaths.ExportFolder,
                },
                cancellationToken);
        }
        catch (Exception exception)
        {
            await WriteJsonResponseAsync(
                response,
                500,
                new { success = false, message = exception.Message },
                cancellationToken);
        }
    }

    private static string NormalizeProjectPath(string? projectPath) =>
        string.IsNullOrWhiteSpace(projectPath) ? Environment.CurrentDirectory : projectPath;

    private static string? ReadQueryParameter(Uri? requestUrl, string key)
    {
        if (requestUrl is null || string.IsNullOrWhiteSpace(requestUrl.Query))
        {
            return null;
        }

        var rawQuery = requestUrl.Query.TrimStart('?');
        if (string.IsNullOrWhiteSpace(rawQuery))
        {
            return null;
        }

        var pairs = rawQuery.Split('&', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        foreach (var pair in pairs)
        {
            var separator = pair.IndexOf('=', StringComparison.Ordinal);
            var rawKey = separator >= 0 ? pair[..separator] : pair;
            var decodedKey = Uri.UnescapeDataString(rawKey.Replace('+', ' '));
            if (!string.Equals(decodedKey, key, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var rawValue = separator >= 0 ? pair[(separator + 1)..] : string.Empty;
            return Uri.UnescapeDataString(rawValue.Replace('+', ' '));
        }

        return null;
    }

    private static async Task WriteJsonResponseAsync(
        HttpListenerResponse response,
        int statusCode,
        object payload,
        CancellationToken cancellationToken)
    {
        var json = JsonSerializer.Serialize(payload);
        var content = Encoding.UTF8.GetBytes(json);

        ApplyNoCacheHeaders(response);
        response.ContentType = "application/json; charset=utf-8";
        response.StatusCode = statusCode;
        response.ContentLength64 = content.Length;
        await response.OutputStream.WriteAsync(content, cancellationToken);
    }

    private static void ApplyNoCacheHeaders(HttpListenerResponse response)
    {
        response.Headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0";
        response.Headers["Pragma"] = "no-cache";
        response.Headers["Expires"] = "0";
    }
}

