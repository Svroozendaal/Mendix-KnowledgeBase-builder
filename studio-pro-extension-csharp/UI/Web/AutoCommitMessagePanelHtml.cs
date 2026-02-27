using System.Text.Json;

namespace AutoCommitMessage;

internal static class AutoCommitMessagePanelHtml
{
    public static string Render(AutoCommitMessagePayload payload, string projectPath)
    {
        var payloadJson = JsonSerializer.Serialize(payload);
        var projectPathJson = JsonSerializer.Serialize(projectPath ?? string.Empty);

        return $$"""
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>AutoCommitMessage</title>
  <style>
    :root {
      color-scheme: light;
      font-family: "Segoe UI", Tahoma, sans-serif;
    }
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background: #f5f7fb;
      color: #1e293b;
    }
    #root {
      display: flex;
      flex-direction: column;
      width: 100%;
      height: 100%;
    }
    .topbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      padding: 10px 14px;
      border-bottom: 1px solid #d7ddea;
      background: #ffffff;
    }
    .title {
      font-weight: 700;
      font-size: 13px;
      color: #0f172a;
    }
    .meta {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .badge {
      border-radius: 999px;
      border: 1px solid #b9c6dc;
      background: #eef3fb;
      color: #1e3a8a;
      padding: 3px 10px;
      font-weight: 600;
      font-size: 11px;
      max-width: 480px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .btn {
      border: 1px solid #2563eb;
      background: #2563eb;
      color: #ffffff;
      border-radius: 6px;
      padding: 6px 10px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
    }
    .btn[disabled] {
      opacity: 0.6;
      cursor: not-allowed;
    }
    .btn-secondary {
      border-color: #1d4ed8;
      background: #1d4ed8;
    }
    .subtitle {
      padding: 8px 14px;
      border-bottom: 1px solid #e4e8f2;
      font-size: 12px;
      color: #475569;
      background: #fbfcff;
    }
    .status-line {
      padding: 8px 14px;
      border-bottom: 1px solid #e4e8f2;
      font-size: 12px;
      color: #334155;
      background: #ffffff;
    }
    .content {
      flex: 1;
      min-height: 0;
      display: flex;
      flex-direction: column;
      padding: 12px;
    }
    .card {
      border: 1px solid #d8e0ef;
      border-radius: 10px;
      background: #ffffff;
      padding: 14px;
      line-height: 1.45;
      font-size: 13px;
    }
    .layout {
      display: grid;
      grid-template-columns: 1.3fr 0.7fr;
      gap: 12px;
      height: 100%;
      min-height: 0;
    }
    .panel {
      border: 1px solid #d8e0ef;
      border-radius: 10px;
      background: #ffffff;
      overflow: hidden;
      min-height: 0;
      display: flex;
      flex-direction: column;
    }
    .panel-title {
      padding: 8px 10px;
      border-bottom: 1px solid #e5eaf5;
      font-size: 12px;
      font-weight: 700;
      color: #0f172a;
      background: #f8faff;
    }
    .table-wrap {
      overflow: auto;
      min-height: 0;
      flex: 1;
    }
    .table-wrap.compact {
      flex: 0 0 auto;
      max-height: 230px;
      border-bottom: 1px solid #e5eaf5;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 12px;
    }
    thead th {
      position: sticky;
      top: 0;
      background: #f8faff;
      z-index: 1;
      border-bottom: 1px solid #e5eaf5;
      color: #334155;
      text-align: left;
      padding: 8px 9px;
      font-weight: 700;
    }
    tbody td {
      border-bottom: 1px solid #eef2f8;
      padding: 7px 9px;
      font-size: 12px;
    }
    tbody tr {
      cursor: pointer;
    }
    tbody tr:hover {
      background: #f8fbff;
    }
    tbody tr.active {
      background: #e8f0ff;
    }
    .status {
      font-weight: 700;
    }
    .status-modified { color: #236cc0; }
    .status-added { color: #228b22; }
    .status-deleted { color: #b22222; }
    .status-renamed { color: #b8860b; }
    .right-content {
      display: flex;
      flex-direction: column;
      min-height: 0;
      flex: 1;
    }
    .section-label {
      padding: 8px 10px;
      border-bottom: 1px solid #e5eaf5;
      font-size: 12px;
      font-weight: 700;
      color: #334155;
      background: #fbfdff;
    }
    pre {
      margin: 0;
      padding: 10px;
      overflow: auto;
      white-space: pre;
      font-size: 12px;
      line-height: 1.4;
      background: #ffffff;
      color: #111827;
      font-family: Consolas, "Courier New", monospace;
      min-height: 120px;
      flex: 1 1 auto;
    }
    .model-changes {
      padding: 8px 10px 10px 10px;
      overflow: auto;
      flex: 1 1 auto;
      min-height: 320px;
    }
    .model-title {
      font-size: 12px;
      font-weight: 700;
      margin-bottom: 6px;
      color: #0f172a;
    }
    .model-group {
      margin-bottom: 8px;
      border: 1px solid #e2e8f5;
      border-radius: 6px;
      background: #fbfdff;
    }
    .model-group > summary {
      cursor: pointer;
      padding: 6px 8px;
      font-size: 12px;
      font-weight: 600;
      color: #334155;
    }
    .model-subgroup {
      margin: 6px 8px 8px 8px;
      border: 1px solid #e2e8f5;
      border-radius: 6px;
      background: #ffffff;
    }
    .model-subgroup > summary {
      cursor: pointer;
      padding: 6px 8px;
      font-size: 12px;
      font-weight: 600;
      color: #334155;
    }
    .model-list {
      margin: 0 0 8px 0;
      padding: 0 22px;
      font-size: 12px;
      line-height: 1.5;
    }
    .model-list > li {
      margin: 0 0 4px 0;
    }
    .model-change-head {
      font-weight: 600;
      color: #1e293b;
    }
    .model-detail-list {
      margin: 4px 0 0 0;
      padding: 0 0 0 18px;
    }
    .model-detail-list > li {
      margin: 2px 0;
      color: #334155;
      font-weight: 400;
    }
    .model-change-added { color: #228b22; }
    .model-change-modified { color: #236cc0; }
    .model-change-deleted { color: #b22222; }
    .model-file-label {
      margin-bottom: 8px;
      font-size: 12px;
      color: #475569;
      font-weight: 600;
    }
    @media (max-width: 760px) {
      .layout {
        grid-template-columns: 1fr;
        grid-template-rows: 1.3fr 0.7fr;
      }
    }
  </style>
</head>
<body>
  <div id="root"></div>
  <script>
    const initialPayload = {{payloadJson}};
    const projectPath = {{projectPathJson}};
    const actionQueryKey = "{{ExtensionConstants.ActionQueryKey}}";
    const exportActionValue = "{{ExtensionConstants.ExportActionValue}}";
    const refreshActionValue = "{{ExtensionConstants.RefreshActionValue}}";
    const projectPathQueryKey = "{{ExtensionConstants.ProjectPathQueryKey}}";
    let currentPayload = initialPayload;
    let refreshInProgress = false;

    function buildActionUrl(actionName) {
      const query = new URLSearchParams();
      query.set(actionQueryKey, actionName);
      query.set(projectPathQueryKey, projectPath || "");
      return `${window.location.pathname}?${query.toString()}`;
    }

    function element(tag, className, textContent) {
      const node = document.createElement(tag);
      if (className) {
        node.className = className;
      }
      if (textContent !== undefined) {
        node.textContent = textContent;
      }
      return node;
    }

    function statusClass(status) {
      switch (status) {
        case "Modified":
          return "status-modified";
        case "Added":
          return "status-added";
        case "Deleted":
          return "status-deleted";
        case "Renamed":
          return "status-renamed";
        default:
          return "";
      }
    }

    function modelChangeClass(changeType) {
      switch (changeType) {
        case "Added":
          return "model-change-added";
        case "Modified":
          return "model-change-modified";
        case "Deleted":
          return "model-change-deleted";
        default:
          return "";
      }
    }

    function renderCard(content, className) {
      const card = element("div", className ? `card ${className}` : "card");
      card.textContent = content;
      return card;
    }

    function renderChanges(changes) {
      const layout = element("div", "layout");

      const modelPanel = element("section", "panel");
      modelPanel.appendChild(element("div", "panel-title", "Model changes (.mpr)"));
      const modelChangesContainer = element("div", "model-changes");
      modelPanel.appendChild(modelChangesContainer);

      const detailsPanel = element("section", "panel");
      detailsPanel.appendChild(element("div", "panel-title", "Changed files and diff"));

      const rightContent = element("div", "right-content");
      rightContent.appendChild(element("div", "section-label", "Changed Files"));
      const tableWrap = element("div", "table-wrap compact");
      const table = element("table");
      const thead = element("thead");
      const headerRow = element("tr");
      ["Name", "Path", "Status", "Staged"].forEach((label) => {
        headerRow.appendChild(element("th", null, label));
      });
      thead.appendChild(headerRow);
      table.appendChild(thead);

      const tbody = element("tbody");
      table.appendChild(tbody);
      tableWrap.appendChild(table);
      rightContent.appendChild(tableWrap);
      rightContent.appendChild(element("div", "section-label", "Diff"));
      const diffText = element("pre");
      diffText.textContent = "Select a file to view diff.";
      rightContent.appendChild(diffText);
      detailsPanel.appendChild(rightContent);

      function resolveModuleName(elementName) {
        const rawName = typeof elementName === "string" ? elementName.trim() : "";
        if (!rawName) {
          return "Unknown";
        }

        const separatorIndex = rawName.indexOf(".");
        if (separatorIndex <= 0) {
          return "Unknown";
        }

        const moduleName = rawName.slice(0, separatorIndex).trim();
        return moduleName || "Unknown";
      }

      function resolveModelCategory(elementType) {
        const type = typeof elementType === "string" ? elementType.trim().toLowerCase() : "";
        if (type === "entity" || type === "nonpersistententity" || type === "association") {
          return "DomainModel";
        }
        if (type === "microflow") {
          return "Microflows";
        }
        if (type === "page") {
          return "Pages";
        }
        if (type === "nanoflow") {
          return "Nanoflows";
        }

        return "Resources";
      }

      function normalizeElementName(elementName) {
        const value = typeof elementName === "string" ? elementName.trim() : "";
        if (!value) {
          return "<unnamed>";
        }

        const separatorIndex = value.indexOf(".");
        if (separatorIndex > 0 && separatorIndex < value.length - 1) {
          const unprefixed = value.slice(separatorIndex + 1).trim();
          if (unprefixed) {
            return unprefixed;
          }
        }

        return value;
      }

      function resolveAbbreviation(elementType) {
        const type = typeof elementType === "string" ? elementType.trim().toLowerCase() : "";
        switch (type) {
          case "entity": return "";
          case "nonpersistententity": return "NP";
          case "microflow": return "MF";
          case "nanoflow": return "NF";
          case "page": return "PG";
          case "snippet": return "";
          case "constant": return "Constant";
          case "queue": return "TQ";
          case "enumeration": return "ENUM";
          case "exportmapping": return "EM";
          case "importmapping": return "IM";
          case "workflow": return "WF";
          default: return "";
        }
      }

      function resolveDetails(changeType, details, elementType) {
        const normalizedDetails = typeof details === "string" ? details.trim() : "";
        if (normalizedDetails) {
          return normalizedDetails;
        }

        const normalizedElementType = typeof elementType === "string" ? elementType.trim().toLowerCase() : "";
        if (normalizedElementType === "entity" || normalizedElementType === "nonpersistententity") {
          return "";
        }

        const normalizedChangeType = typeof changeType === "string" ? changeType.trim().toLowerCase() : "";
        if (normalizedChangeType === "added") {
          return "added";
        }
        if (normalizedChangeType === "modified") {
          return "modified";
        }
        if (normalizedChangeType === "deleted") {
          return "deleted";
        }

        return "changed";
      }

      function buildDisplayText(change) {
        const changeType = typeof change.ChangeType === "string" ? change.ChangeType.trim() : "";
        const elementType = typeof change.ElementType === "string" ? change.ElementType.trim().toLowerCase() : "";
        const normalizedChangeType = changeType.toLowerCase();
        let changeMarker = "";
        if (normalizedChangeType === "added") {
          changeMarker = "NEW";
        } else if (
          normalizedChangeType === "deleted" &&
          (elementType === "microflow" || elementType === "nanoflow")
        ) {
          changeMarker = "DEL";
        }

        const abbreviation = resolveAbbreviation(change.ElementType);
        const elementName = normalizeElementName(change.ElementName);
        const details = resolveDetails(change.ChangeType, change.Details, change.ElementType);
        return `${changeMarker} ${abbreviation} ${elementName} : ${details}`
          .split(/\s+/)
          .filter(Boolean)
          .join(" ");
      }

      function isZeroOnlyDetailSegment(segment) {
        const normalized = typeof segment === "string" ? segment.trim() : "";
        if (!normalized) {
          return true;
        }

        const numberMatches = normalized.match(/\b\d+\b/g);
        if (!numberMatches || numberMatches.length === 0) {
          return false;
        }

        return numberMatches.every((value) => Number(value) === 0);
      }

      function splitDetailSegments(rawDetails) {
        const normalized = typeof rawDetails === "string" ? rawDetails.trim() : "";
        if (!normalized) {
          return [];
        }

        return normalized
          .split(";")
          .map((segment) => segment.trim())
          .filter((segment) => segment.length > 0)
          .filter((segment) => !isZeroOnlyDetailSegment(segment));
      }

      function parseDisplayParts(change) {
        const baseText = change.DisplayText && String(change.DisplayText).trim().length > 0
          ? String(change.DisplayText).trim()
          : buildDisplayText(change);
        const normalizedText = baseText.replace(/^\-\s*/, "").trim();
        const separatorIndex = normalizedText.indexOf(" : ");
        if (separatorIndex < 0) {
          return { header: normalizedText, details: [] };
        }

        const header = normalizedText.slice(0, separatorIndex).trim();
        const detailsText = normalizedText.slice(separatorIndex + 3).trim();
        return {
          header,
          details: splitDetailSegments(detailsText),
        };
      }

      function createModuleBucket(moduleName) {
        return {
          Module: moduleName,
          DomainModel: [],
          Microflows: [],
          Pages: [],
          Nanoflows: [],
          Resources: [],
        };
      }

      function orderModelChanges(changes) {
        return changes
          .slice()
          .sort((a, b) => (a.ElementName || "").localeCompare(b.ElementName || ""));
      }

      function getModelChangesByModule(selectedChange) {
        if (!selectedChange) {
          return [];
        }

        if (Array.isArray(selectedChange.ModelChangesByModule) && selectedChange.ModelChangesByModule.length > 0) {
          return selectedChange.ModelChangesByModule
            .slice()
            .sort((a, b) => (a.Module || "").localeCompare(b.Module || ""));
        }

        const modelChanges = Array.isArray(selectedChange.ModelChanges)
          ? selectedChange.ModelChanges
          : [];
        if (modelChanges.length === 0) {
          return [];
        }

        const modules = new Map();
        modelChanges.forEach((change) => {
          const moduleName = resolveModuleName(change.ElementName);
          if (!modules.has(moduleName)) {
            modules.set(moduleName, createModuleBucket(moduleName));
          }

          const category = resolveModelCategory(change.ElementType);
          modules.get(moduleName)[category].push(change);
        });

        return Array.from(modules.values())
          .map((moduleGroup) => ({
            Module: moduleGroup.Module,
            DomainModel: orderModelChanges(moduleGroup.DomainModel),
            Microflows: orderModelChanges(moduleGroup.Microflows),
            Pages: orderModelChanges(moduleGroup.Pages),
            Nanoflows: orderModelChanges(moduleGroup.Nanoflows),
            Resources: orderModelChanges(moduleGroup.Resources),
          }))
          .sort((a, b) => (a.Module || "").localeCompare(b.Module || ""));
      }

      function renderModelChangeList(changes) {
        const list = element("ul", "model-list");
        changes.forEach((change) => {
          const item = element("li");
          const changeClass = modelChangeClass(change.ChangeType);
          if (changeClass) {
            item.classList.add(changeClass);
          }

          const displayParts = parseDisplayParts(change);
          item.appendChild(element("div", "model-change-head", displayParts.header || "<unnamed>"));

          if (displayParts.details.length > 0) {
            const detailsList = element("ul", "model-detail-list");
            displayParts.details.forEach((detail) => {
              detailsList.appendChild(element("li", null, detail));
            });
            item.appendChild(detailsList);
          }

          list.appendChild(item);
        });

        return list;
      }

      function countModuleChanges(moduleGroup) {
        const domainModel = Array.isArray(moduleGroup.DomainModel) ? moduleGroup.DomainModel.length : 0;
        const microflows = Array.isArray(moduleGroup.Microflows) ? moduleGroup.Microflows.length : 0;
        const pages = Array.isArray(moduleGroup.Pages) ? moduleGroup.Pages.length : 0;
        const nanoflows = Array.isArray(moduleGroup.Nanoflows) ? moduleGroup.Nanoflows.length : 0;
        const resources = Array.isArray(moduleGroup.Resources) ? moduleGroup.Resources.length : 0;
        return domainModel + microflows + pages + nanoflows + resources;
      }

      function appendEmptyModelState(message) {
        const emptyGroup = element("div", "model-group");
        const emptyMessage = element("div", null, message);
        emptyMessage.style.padding = "8px";
        emptyMessage.style.fontSize = "12px";
        emptyMessage.style.color = "#475569";
        emptyGroup.appendChild(emptyMessage);
        modelChangesContainer.appendChild(emptyGroup);
      }

      function renderModelChanges(selectedChange) {
        const isMpr = selectedChange &&
          typeof selectedChange.FilePath === "string" &&
          selectedChange.FilePath.toLowerCase().endsWith(".mpr");
        const groupedModelChanges = getModelChangesByModule(selectedChange);

        modelChangesContainer.replaceChildren();
        modelChangesContainer.appendChild(element("div", "model-title", "Model changes by module"));
        const sourceFile = selectedChange && selectedChange.FilePath
          ? selectedChange.FilePath
          : "No file selected";
        modelChangesContainer.appendChild(element("div", "model-file-label", `Source: ${sourceFile}`));

        if (!selectedChange) {
          appendEmptyModelState("Select a file to view model changes.");
          return;
        }

        if (!isMpr) {
          appendEmptyModelState("Model changes are available for .mpr files.");
          return;
        }

        if (groupedModelChanges.length === 0) {
          appendEmptyModelState("No model-level changes detected.");
          return;
        }

        const categories = [
          { key: "DomainModel", label: "Domain model" },
          { key: "Microflows", label: "Microflows" },
          { key: "Pages", label: "Pages" },
          { key: "Nanoflows", label: "Nanoflows" },
          { key: "Resources", label: "Resources" },
        ];

        groupedModelChanges.forEach((moduleGroup) => {
          const moduleName = moduleGroup.Module || "Unknown";
          const moduleChangeCount = countModuleChanges(moduleGroup);
          const moduleDetails = element("details", "model-group");
          moduleDetails.open = true;
          moduleDetails.appendChild(
            element("summary", null, `${moduleName}: ${moduleChangeCount} changed`));

          categories.forEach((category) => {
            const categoryChanges = Array.isArray(moduleGroup[category.key])
              ? moduleGroup[category.key]
              : [];
            if (categoryChanges.length === 0) {
              return;
            }

            const categoryDetails = element("details", "model-subgroup");
            categoryDetails.open = true;
            categoryDetails.appendChild(
              element("summary", null, `${category.label}: ${categoryChanges.length} changed`));
            categoryDetails.appendChild(renderModelChangeList(orderModelChanges(categoryChanges)));
            moduleDetails.appendChild(categoryDetails);
          });

          modelChangesContainer.appendChild(moduleDetails);
        });
      }

      const rows = [];
      function selectRow(index) {
        rows.forEach((row, rowIndex) => {
          row.classList.toggle("active", rowIndex === index);
        });

        const selectedChange = changes[index];
        if (!selectedChange) {
          diffText.textContent = "Diff unavailable";
          renderModelChanges(null);
          return;
        }

        diffText.textContent =
          selectedChange.DiffText && selectedChange.DiffText.trim().length > 0
            ? selectedChange.DiffText
            : "Diff unavailable";

        renderModelChanges(selectedChange);
      }

      changes.forEach((change, index) => {
        const row = element("tr");
        row.appendChild(element("td", null, change.FilePath.split("/").pop() || change.FilePath));

        const lastSlash = change.FilePath.lastIndexOf("/");
        const folder = lastSlash >= 0 ? change.FilePath.slice(0, lastSlash) : "";
        row.appendChild(element("td", null, folder));

        const statusCell = element("td");
        const statusValue = element("span", "status", change.Status || "");
        const colorClass = statusClass(change.Status);
        if (colorClass) {
          statusValue.classList.add(colorClass);
        }
        statusCell.appendChild(statusValue);
        row.appendChild(statusCell);

        row.appendChild(element("td", null, change.IsStaged ? "Yes" : "No"));

        row.addEventListener("click", () => selectRow(index));
        tbody.appendChild(row);
        rows.push(row);
      });

      if (changes.length > 0) {
        selectRow(0);
      }

      layout.appendChild(modelPanel);
      layout.appendChild(detailsPanel);
      return layout;
    }

    function render(statusOverride) {
      const payload = currentPayload || {};
      const root = document.getElementById("root");
      root.replaceChildren();

      const topbar = element("div", "topbar");
      topbar.appendChild(element("div", "title", "AutoCommitMessage"));
      const meta = element("div", "meta");
      const pathLabel = projectPath && projectPath.length > 0 ? projectPath : "Project path unavailable";
      meta.appendChild(element("span", "badge", pathLabel));

      const exportButton = element("button", "btn btn-secondary", "Export");
      exportButton.type = "button";
      exportButton.disabled = !(payload && payload.IsGitRepo === true && Array.isArray(payload.Changes) && payload.Changes.length > 0);
      meta.appendChild(exportButton);

      const refreshButton = element("button", "btn", "Refresh");
      refreshButton.type = "button";
      refreshButton.disabled = refreshInProgress;
      meta.appendChild(refreshButton);
      topbar.appendChild(meta);
      root.appendChild(topbar);

      const branchName = payload && payload.BranchName ? payload.BranchName : "-";
      root.appendChild(element("div", "subtitle", `Branch: ${branchName}`));
      const statusLine = element(
        "div",
        "status-line",
        statusOverride || "Ready. Refresh re-runs Git + model analysis.");
      root.appendChild(statusLine);

      const content = element("div", "content");
      root.appendChild(content);

      function setExportAvailability() {
        exportButton.disabled = !(payload && payload.IsGitRepo === true && Array.isArray(payload.Changes) && payload.Changes.length > 0);
      }

      refreshButton.addEventListener("click", async () => {
        if (refreshInProgress) {
          return;
        }

        refreshInProgress = true;
        refreshButton.disabled = true;
        exportButton.disabled = true;
        statusLine.textContent = "Reloading change analysis...";

        try {
          const refreshUrl = `${buildActionUrl(refreshActionValue)}&_t=${Date.now()}`;
          const response = await fetch(refreshUrl, { cache: "no-store" });

          let refreshedPayload = null;
          try {
            refreshedPayload = await response.json();
          } catch {
            refreshedPayload = null;
          }

          if (!response.ok || !refreshedPayload) {
            const message =
              refreshedPayload && typeof refreshedPayload.Error === "string" && refreshedPayload.Error.length > 0
                ? refreshedPayload.Error
                : `Refresh failed (HTTP ${response.status})`;
            statusLine.textContent = `Refresh failed: ${message}`;
            refreshInProgress = false;
            refreshButton.disabled = false;
            setExportAvailability();
            return;
          }

          currentPayload = refreshedPayload;
          refreshInProgress = false;
          const refreshedAt = new Date().toLocaleTimeString();
          render(`Reloaded change analysis at ${refreshedAt}`);
          return;
        } catch (error) {
          const message = error && error.message ? error.message : "Unexpected error";
          statusLine.textContent = `Refresh failed: ${message}`;
          refreshInProgress = false;
          refreshButton.disabled = false;
          setExportAvailability();
        }
      });

      exportButton.addEventListener("click", async () => {
        exportButton.disabled = true;
        statusLine.textContent = "Exporting changes...";

        try {
          const response = await fetch(buildActionUrl(exportActionValue), { method: "POST" });
          let data = null;
          try {
            data = await response.json();
          } catch {
            data = null;
          }

          if (!response.ok || !data || data.success !== true) {
            const message = data && typeof data.message === "string"
              ? data.message
              : `Export failed (HTTP ${response.status})`;
            statusLine.textContent = `Export failed: ${message}`;
            return;
          }

          const destination = data.outputPath || "export folder";
          const count = Number.isInteger(data.changeCount) ? data.changeCount : (Array.isArray(payload.Changes) ? payload.Changes.length : 0);
          statusLine.textContent = `Exported ${count} file(s) to ${destination}`;
        } catch (error) {
          const message = error && error.message ? error.message : "Unexpected error";
          statusLine.textContent = `Export failed: ${message}`;
        } finally {
          setExportAvailability();
        }
      });

      if (!payload || payload.IsGitRepo !== true) {
        content.appendChild(renderCard("Not a Git repository"));
        statusLine.textContent = "No export available.";
        return;
      }

      if (payload.Error && payload.Error.trim().length > 0) {
        content.appendChild(renderCard(`Error: ${payload.Error}`));
        statusLine.textContent = "Cannot export due to load error.";
        return;
      }

      const changes = Array.isArray(payload.Changes) ? payload.Changes : [];
      if (changes.length === 0) {
        content.appendChild(renderCard("No uncommitted changes"));
        statusLine.textContent = "No changes to export.";
        return;
      }

      content.appendChild(renderChanges(changes));
    }

    render();
  </script>
</body>
</html>
""";
    }
}

