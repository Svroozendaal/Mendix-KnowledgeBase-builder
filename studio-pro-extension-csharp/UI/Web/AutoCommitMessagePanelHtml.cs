using System.Text.Json;

namespace AutoCommitMessage;

internal static class AutoCommitMessagePanelHtml
{
    public static string Render(AutoCommitMessagePayload payload, string projectPath)
    {
        var payloadJson = JsonSerializer.Serialize(payload);
        var projectPathJson = JsonSerializer.Serialize(projectPath ?? string.Empty);
        var defaultDataRootBasePathJson =
            JsonSerializer.Serialize(
                ExtensionDataPaths.ResolveDefaultDataRootBasePath(projectPath ?? string.Empty));

        return $$"""
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>AutoCommitMessage</title>
  <style>
    :root {
      color-scheme: dark;
      font-family: "Segoe UI", Tahoma, sans-serif;
      --bg-primary: #0f172a;
      --bg-surface: #111c34;
      --bg-surface-soft: #17233f;
      --bg-subtle: #13203a;
      --bg-hover: #1b2a4a;
      --bg-active: #24395f;
      --text-primary: #e2e8f0;
      --text-strong: #f8fafc;
      --text-muted: #cbd5e1;
      --text-subtle: #94a3b8;
      --border-primary: #304261;
      --border-soft: #233454;
      --accent: #3b82f6;
      --accent-strong: #2563eb;
      --accent-contrast: #ffffff;
      --badge-bg: #1e3a8a;
      --badge-text: #dbeafe;
      --code-bg: #0b1220;
    }
    :root[data-theme="light"] {
      color-scheme: light;
      --bg-primary: #f5f7fb;
      --bg-surface: #ffffff;
      --bg-surface-soft: #f8faff;
      --bg-subtle: #fbfcff;
      --bg-hover: #f8fbff;
      --bg-active: #e8f0ff;
      --text-primary: #1e293b;
      --text-strong: #0f172a;
      --text-muted: #334155;
      --text-subtle: #475569;
      --border-primary: #d8e0ef;
      --border-soft: #e5eaf5;
      --accent: #2563eb;
      --accent-strong: #1d4ed8;
      --accent-contrast: #ffffff;
      --badge-bg: #eef3fb;
      --badge-text: #1e3a8a;
      --code-bg: #ffffff;
    }
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background: var(--bg-primary);
      color: var(--text-primary);
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
    .icon-btn {
      width: 28px;
      height: 28px;
      border: 1px solid #b9c6dc;
      background: #ffffff;
      color: #1e3a8a;
      border-radius: 6px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      padding: 0;
    }
    .icon-btn:hover:not([disabled]) {
      background: #eef3fb;
      border-color: #93a5c4;
    }
    .icon-btn[disabled] {
      opacity: 0.55;
      cursor: not-allowed;
    }
    .icon-btn.active {
      border-color: #2563eb;
      background: #e8f0ff;
    }
    .copy-icon {
      position: relative;
      width: 11px;
      height: 11px;
      border: 1.5px solid #1e3a8a;
      border-radius: 2px;
      box-sizing: border-box;
      display: inline-block;
    }
    .copy-icon::before {
      content: "";
      position: absolute;
      width: 11px;
      height: 11px;
      border: 1.5px solid #1e3a8a;
      border-radius: 2px;
      box-sizing: border-box;
      background: #ffffff;
      left: 3px;
      top: -4px;
    }
    .settings-icon {
      position: relative;
      width: 11px;
      height: 11px;
      border: 1.6px solid currentColor;
      border-radius: 50%;
      box-sizing: border-box;
      display: inline-block;
    }
    .settings-icon::before {
      content: "";
      position: absolute;
      width: 17px;
      height: 17px;
      border: 1.4px dashed currentColor;
      border-radius: 50%;
      left: -4.8px;
      top: -4.8px;
      box-sizing: border-box;
      opacity: 0.9;
    }
    .settings-icon::after {
      content: "";
      position: absolute;
      width: 3px;
      height: 3px;
      border-radius: 50%;
      background: currentColor;
      left: 3px;
      top: 3px;
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
    .nav-bar {
      display: flex;
      align-items: center;
      gap: 8px;
      min-height: 34px;
      padding: 0 14px;
      border-bottom: 1px solid #dce4f2;
      background: #f8fbff;
    }
    .nav-menu {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }
    .nav-actions {
      margin-left: auto;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }
    .nav-btn {
      border: 1px solid #c5d0e4;
      background: #ffffff;
      color: #334155;
      border-radius: 6px;
      padding: 4px 10px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
    }
    .nav-btn.active {
      border-color: #2563eb;
      background: #2563eb;
      color: #ffffff;
    }
    .nav-btn:focus-visible {
      outline: 2px solid #1d4ed8;
      outline-offset: 1px;
    }
    .refresh-icon {
      position: relative;
      width: 12px;
      height: 12px;
      border: 1.5px solid currentColor;
      border-right-color: transparent;
      border-radius: 50%;
      box-sizing: border-box;
      display: inline-block;
      transform: rotate(-25deg);
    }
    .refresh-icon::after {
      content: "";
      position: absolute;
      right: -1px;
      top: -2px;
      width: 0;
      height: 0;
      border-top: 4px solid transparent;
      border-bottom: 4px solid transparent;
      border-left: 5px solid currentColor;
      transform: rotate(18deg);
    }
    .info-line {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
      padding: 8px 14px;
      border-bottom: 1px solid #e4e8f2;
      font-size: 12px;
      background: #fbfcff;
    }
    .info-branch {
      color: #475569;
      font-weight: 600;
      min-width: 0;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .status-line {
      color: #334155;
      text-align: right;
      margin-left: auto;
      min-width: 0;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
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
    .settings-panel {
      height: 100%;
      min-height: 0;
    }
    .settings-content {
      padding: 12px;
      display: flex;
      flex-direction: column;
      gap: 12px;
      min-height: 0;
      overflow: auto;
    }
    .settings-group {
      border: 1px solid #d8e0ef;
      border-radius: 8px;
      background: #fbfdff;
      padding: 10px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .settings-label {
      font-size: 12px;
      font-weight: 700;
      color: #334155;
    }
    .settings-help {
      font-size: 12px;
      color: #64748b;
      line-height: 1.4;
    }
    .settings-inline {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }
    .settings-input {
      border: 1px solid #c5d0e4;
      background: #ffffff;
      color: #1e293b;
      border-radius: 6px;
      padding: 6px 8px;
      font-size: 12px;
      min-width: 280px;
      width: min(100%, 560px);
      box-sizing: border-box;
    }
    .settings-input:focus {
      outline: 2px solid #1d4ed8;
      outline-offset: 1px;
    }
    .settings-preview {
      font-size: 12px;
      font-weight: 600;
      color: #334155;
      word-break: break-all;
    }
    .compose-overlay {
      position: fixed;
      inset: 0;
      background: rgba(15, 23, 42, 0.55);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 14px;
      z-index: 9999;
    }
    .compose-modal {
      width: min(920px, 100%);
      max-height: calc(100vh - 28px);
      overflow: auto;
      border: 1px solid #d8e0ef;
      border-radius: 12px;
      background: #ffffff;
      box-shadow: 0 18px 38px rgba(15, 23, 42, 0.28);
      padding: 12px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .compose-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
    }
    .compose-title {
      font-size: 13px;
      font-weight: 700;
      color: #0f172a;
    }
    .compose-close {
      border: 1px solid #c5d0e4;
      background: #ffffff;
      color: #334155;
      border-radius: 6px;
      padding: 4px 8px;
      font-size: 12px;
      cursor: pointer;
    }
    .compose-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      align-items: end;
    }
    .compose-field {
      display: flex;
      flex-direction: column;
      gap: 6px;
      min-width: 0;
    }
    .compose-label {
      font-size: 12px;
      font-weight: 700;
      color: #334155;
    }
    .compose-input,
    .compose-textarea {
      border: 1px solid #c5d0e4;
      background: #ffffff;
      color: #1e293b;
      border-radius: 6px;
      padding: 7px 9px;
      font-size: 12px;
      box-sizing: border-box;
      width: 100%;
      font-family: inherit;
    }
    .compose-textarea {
      resize: vertical;
      line-height: 1.4;
    }
    .compose-textarea.changes {
      font-family: Consolas, "Courier New", monospace;
      overflow: auto;
      min-height: 200px;
      white-space: pre;
    }
    .compose-input:focus,
    .compose-textarea:focus {
      outline: 2px solid #1d4ed8;
      outline-offset: 1px;
    }
    .compose-actions {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      gap: 8px;
    }
    .compose-note {
      font-size: 12px;
      color: #64748b;
      margin-right: auto;
    }
    .overview-panel {
      height: 100%;
      min-height: 0;
    }
    .overview-content {
      padding: 10px;
      display: flex;
      flex-direction: column;
      min-height: 0;
      gap: 10px;
      flex: 1;
    }
    .overview-hint {
      font-size: 12px;
      color: #475569;
      line-height: 1.45;
    }
    .overview-toolbar {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }
    .overview-meta {
      font-size: 12px;
      color: #334155;
      font-weight: 600;
    }
    .overview-output {
      border: 1px solid #d8e0ef;
      border-radius: 8px;
      min-height: 280px;
      max-height: 100%;
    }
    .overview-placeholder {
      border: 1px dashed #c8d5ea;
      border-radius: 8px;
      padding: 12px;
      font-size: 12px;
      color: #475569;
      background: #fbfdff;
    }
    .overview-module-picker {
      border: 1px solid #d8e0ef;
      border-radius: 8px;
      padding: 10px;
      background: #f8fbff;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .overview-module-picker-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      flex-wrap: wrap;
    }
    .overview-selector-toolbar {
      display: flex;
      gap: 6px;
      flex-wrap: wrap;
      align-items: center;
    }
    .overview-module-groups {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .overview-module-group {
      border: 1px solid #d8e0ef;
      border-radius: 8px;
      background: #ffffff;
      overflow: hidden;
    }
    .overview-module-group > summary {
      cursor: pointer;
      padding: 8px 10px;
      font-size: 12px;
      font-weight: 700;
      color: #334155;
      background: #f8faff;
      border-bottom: 1px solid #e2e8f5;
    }
    .overview-module-rows {
      max-height: 240px;
      overflow: auto;
      display: flex;
      flex-direction: column;
    }
    .overview-module-row {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 7px 10px;
      border-bottom: 1px solid #eef2f8;
      font-size: 12px;
      color: #1e293b;
    }
    .overview-module-row:last-child {
      border-bottom: none;
    }
    .overview-module-row label {
      display: flex;
      align-items: center;
      gap: 8px;
      width: 100%;
      cursor: pointer;
    }
    .overview-module-row input[type=\"checkbox\"] {
      margin: 0;
    }
    .overview-module-meta {
      font-size: 11px;
      color: #64748b;
      margin-left: auto;
      text-align: right;
    }
    .overview-selector-toolbar .btn[disabled] {
      opacity: 0.6;
      cursor: not-allowed;
    }
    .btn-outline {
      border: 1px solid #c3d1ea;
      background: #ffffff;
      color: #334155;
    }
    .layout {
      display: flex;
      flex-direction: column;
      gap: 10px;
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
    .panel-toolbar {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
      padding: 8px 10px;
      border-bottom: 1px solid #e5eaf5;
      background: #fbfdff;
    }
    .changes-main {
      flex: 1 1 auto;
    }
    .details-drawer {
      flex: 0 0 auto;
      position: sticky;
      bottom: 0;
      z-index: 8;
    }
    .collapsible-panel {
      min-height: 0;
    }
    .collapsible-summary {
      list-style: none;
      cursor: pointer;
      user-select: none;
      padding: 6px 10px;
      min-height: 28px;
      border-bottom: none;
    }
    .collapsible-summary::before {
      content: ">";
      display: inline-block;
      width: 14px;
      color: #334155;
    }
    .collapsible-panel[open] > .collapsible-summary::before {
      content: "v";
    }
    .collapsible-summary::-webkit-details-marker {
      display: none;
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
      padding: 5px 8px;
      border-radius: 6px;
      border-left: 3px solid transparent;
    }
    .model-change-head {
      font-weight: 600;
      color: inherit;
    }
    .model-detail-list {
      margin: 4px 0 0 0;
      padding: 0 0 0 18px;
    }
    .model-detail-list > li {
      margin: 2px 0;
      color: inherit;
      font-weight: 400;
    }
    .model-change-added {
      color: #166534;
      background: transparent;
      border-left-color: #228b22;
    }
    .model-change-modified {
      color: #1d4ed8;
      background: transparent;
      border-left-color: #236cc0;
    }
    .model-change-deleted {
      color: #b22222;
      background: transparent;
      border-left-color: #b22222;
    }
    .model-file-label {
      margin-bottom: 8px;
      font-size: 12px;
      color: #475569;
      font-weight: 600;
    }
    :root[data-theme="dark"] body {
      background: #0f172a;
      color: #e2e8f0;
    }
    :root[data-theme="dark"] .topbar,
    :root[data-theme="dark"] .panel,
    :root[data-theme="dark"] .card,
    :root[data-theme="dark"] pre,
    :root[data-theme="dark"] .table-wrap,
    :root[data-theme="dark"] .model-subgroup,
    :root[data-theme="dark"] .overview-module-group,
    :root[data-theme="dark"] .settings-input,
    :root[data-theme="dark"] .icon-btn,
    :root[data-theme="dark"] .nav-btn,
    :root[data-theme="dark"] .btn-outline {
      background: #111c34;
      color: #dbe4f1;
      border-color: #304261;
    }
    :root[data-theme="dark"] .nav-bar,
    :root[data-theme="dark"] .info-line,
    :root[data-theme="dark"] .section-label,
    :root[data-theme="dark"] .panel-title,
    :root[data-theme="dark"] .panel-toolbar,
    :root[data-theme="dark"] .model-group,
    :root[data-theme="dark"] .overview-placeholder,
    :root[data-theme="dark"] .overview-module-picker,
    :root[data-theme="dark"] .settings-group {
      background: #17233f;
      color: #dbe4f1;
      border-color: #304261;
    }
    :root[data-theme="dark"] tbody td,
    :root[data-theme="dark"] .overview-module-row {
      border-color: #243654;
    }
    :root[data-theme="dark"] thead th {
      background: #17233f;
      color: #dbe4f1;
      border-color: #304261;
    }
    :root[data-theme="dark"] tbody tr:hover {
      background: #1b2a4a;
    }
    :root[data-theme="dark"] tbody tr.active {
      background: #24395f;
    }
    :root[data-theme="dark"] .title {
      color: #f8fafc;
    }
    :root[data-theme="dark"] .badge {
      background: #1e3a8a;
      color: #dbeafe;
      border-color: #31558a;
    }
    :root[data-theme="dark"] .btn {
      background: #2563eb;
      border-color: #2563eb;
      color: #ffffff;
    }
    :root[data-theme="dark"] .btn-secondary {
      background: #1d4ed8;
      border-color: #1d4ed8;
    }
    :root[data-theme="dark"] .nav-btn.active,
    :root[data-theme="dark"] .icon-btn.active {
      background: #1d4ed8;
      border-color: #2563eb;
      color: #ffffff;
    }
    :root[data-theme="dark"] .copy-icon,
    :root[data-theme="dark"] .copy-icon::before {
      border-color: #dbe4f1;
    }
    :root[data-theme="dark"] .copy-icon::before {
      background: #111c34;
    }
    :root[data-theme="dark"] .settings-help,
    :root[data-theme="dark"] .overview-module-meta,
    :root[data-theme="dark"] .info-branch,
    :root[data-theme="dark"] .model-file-label {
      color: #94a3b8;
    }
    :root[data-theme="dark"] .status-line,
    :root[data-theme="dark"] .model-group > summary,
    :root[data-theme="dark"] .model-subgroup > summary {
      color: #e2e8f0;
    }
    :root[data-theme="dark"] .compose-modal {
      background: #111c34;
      border-color: #304261;
    }
    :root[data-theme="dark"] .compose-title,
    :root[data-theme="dark"] .compose-label {
      color: #e2e8f0;
    }
    :root[data-theme="dark"] .compose-close,
    :root[data-theme="dark"] .compose-input,
    :root[data-theme="dark"] .compose-textarea {
      background: #17233f;
      border-color: #304261;
      color: #dbe4f1;
    }
    :root[data-theme="dark"] .compose-note {
      color: #94a3b8;
    }
    :root[data-theme="dark"] .model-change-added {
      color: #86efac;
      background: transparent;
      border-left-color: #22c55e;
    }
    :root[data-theme="dark"] .model-change-modified {
      color: #93c5fd;
      background: transparent;
      border-left-color: #60a5fa;
    }
    :root[data-theme="dark"] .model-change-deleted {
      color: #fda4af;
      background: transparent;
      border-left-color: #fb7185;
    }
    @media (max-width: 760px) {
      .layout {
        gap: 8px;
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
    const storeCommitMessageActionValue = "{{ExtensionConstants.StoreCommitMessageActionValue}}";
    const refreshActionValue = "{{ExtensionConstants.RefreshActionValue}}";
    const generateOverviewModulesActionValue = "{{ExtensionConstants.GenerateOverviewModulesActionValue}}";
    const listOverviewModulesActionValue = "{{ExtensionConstants.ListOverviewModulesActionValue}}";
    const projectPathQueryKey = "{{ExtensionConstants.ProjectPathQueryKey}}";
    const dataRootBasePathQueryKey = "{{ExtensionConstants.DataRootBasePathQueryKey}}";
    const commitMessagesBasePathQueryKey = "{{ExtensionConstants.CommitMessagesBasePathQueryKey}}";
    const persistDumpsQueryKey = "{{ExtensionConstants.PersistDumpsQueryKey}}";
    const persistRawChangesQueryKey = "{{ExtensionConstants.PersistRawChangesQueryKey}}";
    const persistOverviewStructuredQueryKey = "{{ExtensionConstants.PersistOverviewStructuredQueryKey}}";
    const persistOverviewPseudocodeQueryKey = "{{ExtensionConstants.PersistOverviewPseudocodeQueryKey}}";
    const modulesQueryKey = "{{ExtensionConstants.ModulesQueryKey}}";
    const defaultDataRootBasePath = {{defaultDataRootBasePathJson}};
    const themeStorageKey = "autocommitmessage.theme";
    const dataRootBasePathStorageKey = "autocommitmessage.dataRootBasePath";
    const signatureStorageKey = "autocommitmessage.signature";
    const extendedModeStorageKey = "autocommitmessage.extendedMode";
    const exportAdditionalDataStorageKey = "autocommitmessage.exportAdditionalData";
    const persistDumpsStorageKey = "autocommitmessage.persistDumps";
    const persistRawChangesStorageKey = "autocommitmessage.persistRawChanges";
    const persistOverviewStructuredStorageKey = "autocommitmessage.persistOverviewStructured";
    const persistOverviewPseudocodeStorageKey = "autocommitmessage.persistOverviewPseudocode";
    const storeCommitMessagesStorageKey = "autocommitmessage.storeCommitMessages";
    const commitMessagesBasePathStorageKey = "autocommitmessage.commitMessagesBasePath";
    let currentPayload = initialPayload;
    let hasLoadedChanges = false;
    let refreshInProgress = false;
    let activeView = "model-changes";
    let overviewInProgress = false;
    let overviewModulesInProgress = false;
    let settingsState = {
      theme: "dark",
      dataRootBasePath: defaultDataRootBasePath,
      signature: "",
      extendedMode: false,
      exportAdditionalData: false,
      persistDumps: true,
      persistRawChanges: true,
      persistOverviewStructured: true,
      persistOverviewPseudocode: true,
      storeCommitMessages: false,
      commitMessagesBasePath: defaultDataRootBasePath,
    };
    let modelOverviewState = {
      hasGenerated: false,
      generatedAtUtc: null,
      changedFileCount: 0,
      changedModelFileCount: 0,
      mprFileCount: 0,
      overviewText: "",
      outputFolderPath: "",
      outputPaths: [],
      mode: "",
      selectedModule: "",
      selectedModules: [],
      message: "",
      error: "",
      modulesLoaded: false,
      modulesLoadGeneratedAtUtc: null,
      moduleListError: "",
      appName: "",
      availableModules: [],
    };

    function normalizeTheme(value) {
      return value === "light" ? "light" : "dark";
    }

    function resolveStoredDataRootBasePath(value) {
      if (typeof value !== "string") {
        return defaultDataRootBasePath;
      }

      const trimmed = value.trim();
      return trimmed.length > 0 ? trimmed : defaultDataRootBasePath;
    }

    function normalizeStoredBoolean(value, defaultValue) {
      if (typeof value !== "string") {
        return defaultValue;
      }

      const normalized = value.trim().toLowerCase();
      if (normalized === "true") {
        return true;
      }

      if (normalized === "false") {
        return false;
      }

      return defaultValue;
    }

    function resolveStoredBasePath(value, fallbackPath) {
      if (typeof value !== "string") {
        return fallbackPath;
      }

      const trimmed = value.trim();
      return trimmed.length > 0 ? trimmed : fallbackPath;
    }

    function loadSettingsFromStorage() {
      let storedTheme = "dark";
      let storedDataRootBasePath = defaultDataRootBasePath;
      let storedSignature = "";
      let storedExtendedMode = "false";
      let storedExportAdditionalData = "false";
      let storedPersistDumps = "true";
      let storedPersistRawChanges = "true";
      let storedPersistOverviewStructured = "true";
      let storedPersistOverviewPseudocode = "true";
      let storedStoreCommitMessages = "false";
      let storedCommitMessagesBasePath = defaultDataRootBasePath;
      try {
        storedTheme = localStorage.getItem(themeStorageKey) || "dark";
      } catch {
        storedTheme = "dark";
      }

      try {
        storedDataRootBasePath = localStorage.getItem(dataRootBasePathStorageKey) || defaultDataRootBasePath;
      } catch {
        storedDataRootBasePath = defaultDataRootBasePath;
      }

      try {
        storedSignature = localStorage.getItem(signatureStorageKey) || "";
      } catch {
        storedSignature = "";
      }

      try {
        storedExtendedMode = localStorage.getItem(extendedModeStorageKey) || "false";
      } catch {
        storedExtendedMode = "false";
      }

      try {
        storedExportAdditionalData = localStorage.getItem(exportAdditionalDataStorageKey) || "false";
      } catch {
        storedExportAdditionalData = "false";
      }

      try {
        storedPersistDumps = localStorage.getItem(persistDumpsStorageKey) || "true";
      } catch {
        storedPersistDumps = "true";
      }

      try {
        storedPersistRawChanges = localStorage.getItem(persistRawChangesStorageKey) || "true";
      } catch {
        storedPersistRawChanges = "true";
      }

      try {
        storedPersistOverviewStructured = localStorage.getItem(persistOverviewStructuredStorageKey) || "true";
      } catch {
        storedPersistOverviewStructured = "true";
      }

      try {
        storedPersistOverviewPseudocode = localStorage.getItem(persistOverviewPseudocodeStorageKey) || "true";
      } catch {
        storedPersistOverviewPseudocode = "true";
      }

      try {
        storedStoreCommitMessages = localStorage.getItem(storeCommitMessagesStorageKey) || "false";
      } catch {
        storedStoreCommitMessages = "false";
      }

      try {
        storedCommitMessagesBasePath = localStorage.getItem(commitMessagesBasePathStorageKey) || defaultDataRootBasePath;
      } catch {
        storedCommitMessagesBasePath = defaultDataRootBasePath;
      }

      const resolvedDataRootBasePath = resolveStoredDataRootBasePath(storedDataRootBasePath);

      settingsState = {
        theme: normalizeTheme(storedTheme),
        dataRootBasePath: resolvedDataRootBasePath,
        signature: typeof storedSignature === "string" ? storedSignature.trim() : "",
        extendedMode: normalizeStoredBoolean(storedExtendedMode, false),
        exportAdditionalData: normalizeStoredBoolean(storedExportAdditionalData, false),
        persistDumps: normalizeStoredBoolean(storedPersistDumps, true),
        persistRawChanges: normalizeStoredBoolean(storedPersistRawChanges, true),
        persistOverviewStructured: normalizeStoredBoolean(storedPersistOverviewStructured, true),
        persistOverviewPseudocode: normalizeStoredBoolean(storedPersistOverviewPseudocode, true),
        storeCommitMessages: normalizeStoredBoolean(storedStoreCommitMessages, false),
        commitMessagesBasePath: resolveStoredBasePath(storedCommitMessagesBasePath, resolvedDataRootBasePath),
      };
    }

    function applyTheme(theme) {
      const resolvedTheme = normalizeTheme(theme);
      settingsState = {
        ...settingsState,
        theme: resolvedTheme,
      };
      document.documentElement.setAttribute("data-theme", resolvedTheme);
    }

    function saveSettingsToStorage() {
      try {
        localStorage.setItem(themeStorageKey, settingsState.theme);
        localStorage.setItem(dataRootBasePathStorageKey, settingsState.dataRootBasePath);
        localStorage.setItem(signatureStorageKey, settingsState.signature || "");
        localStorage.setItem(extendedModeStorageKey, String(Boolean(settingsState.extendedMode)));
        localStorage.setItem(exportAdditionalDataStorageKey, String(Boolean(settingsState.exportAdditionalData)));
        localStorage.setItem(persistDumpsStorageKey, String(Boolean(settingsState.persistDumps)));
        localStorage.setItem(persistRawChangesStorageKey, String(Boolean(settingsState.persistRawChanges)));
        localStorage.setItem(
          persistOverviewStructuredStorageKey,
          String(Boolean(settingsState.persistOverviewStructured)));
        localStorage.setItem(
          persistOverviewPseudocodeStorageKey,
          String(Boolean(settingsState.persistOverviewPseudocode)));
        localStorage.setItem(storeCommitMessagesStorageKey, String(Boolean(settingsState.storeCommitMessages)));
        localStorage.setItem(commitMessagesBasePathStorageKey, settingsState.commitMessagesBasePath || "");
      } catch {
        // Ignore storage errors and continue in-memory.
      }
    }

    function getActionParameters(extraParams) {
      const queryParams = { ...(extraParams || {}) };
      const basePath = typeof settingsState.dataRootBasePath === "string"
        ? settingsState.dataRootBasePath.trim()
        : "";
      if (basePath.length > 0) {
        queryParams[dataRootBasePathQueryKey] = basePath;
      }

      const commitPath = typeof settingsState.commitMessagesBasePath === "string"
        ? settingsState.commitMessagesBasePath.trim()
        : "";
      if (commitPath.length > 0) {
        queryParams[commitMessagesBasePathQueryKey] = commitPath;
      }

      queryParams[persistDumpsQueryKey] = settingsState.persistDumps ? "true" : "false";
      queryParams[persistRawChangesQueryKey] = settingsState.persistRawChanges ? "true" : "false";
      queryParams[persistOverviewStructuredQueryKey] = settingsState.persistOverviewStructured ? "true" : "false";
      queryParams[persistOverviewPseudocodeQueryKey] = settingsState.persistOverviewPseudocode ? "true" : "false";

      return queryParams;
    }

    function getConfiguredDataRootPath() {
      const basePath = typeof settingsState.dataRootBasePath === "string"
        ? settingsState.dataRootBasePath.trim()
        : "";
      if (basePath.length === 0) {
        return "<invalid>";
      }

      const normalized = basePath.replace(/[\\\/]+$/, "");
      if (normalized.toLowerCase().endsWith("mendix-data")) {
        return normalized;
      }

      const separator = normalized.includes("\\") || /^[A-Za-z]:/.test(normalized)
        ? "\\"
        : "/";
      return `${normalized}${separator}mendix-data`;
    }

    function getConfiguredCommitMessagesFolderPath(basePathCandidate) {
      const basePath = typeof basePathCandidate === "string"
        ? basePathCandidate.trim()
        : (typeof settingsState.commitMessagesBasePath === "string"
          ? settingsState.commitMessagesBasePath.trim()
          : "");

      if (basePath.length === 0) {
        return "<invalid>";
      }

      const normalized = basePath.replace(/[\\\/]+$/, "");
      const separator = normalized.includes("\\") || /^[A-Za-z]:/.test(normalized)
        ? "\\"
        : "/";
      return `${normalized}${separator}Commit messages`;
    }

    async function loadOverviewModulesIntoState() {
      if (!settingsState.extendedMode) {
        return { success: false, message: "Extended mode is disabled." };
      }

      if (!hasLoadedChanges || !canGenerateOverview(currentPayload)) {
        return { success: false, message: "Change analysis has not been loaded yet." };
      }

      overviewModulesInProgress = true;

      try {
        const moduleListUrl = `${buildActionUrl(
          listOverviewModulesActionValue,
          getActionParameters())}&_t=${Date.now()}`;
        const response = await fetch(moduleListUrl, { cache: "no-store" });

        let data = null;
        try {
          data = await response.json();
        } catch {
          data = null;
        }

        if (!response.ok || !data || data.success !== true) {
          const message = data && typeof data.message === "string"
            ? data.message
            : `Module list loading failed (HTTP ${response.status})`;

          modelOverviewState = {
            ...modelOverviewState,
            modulesLoaded: false,
            modulesLoadGeneratedAtUtc: null,
            moduleListError: message,
            appName: "",
            selectedModules: [],
            availableModules: [],
          };

          overviewModulesInProgress = false;
          return { success: false, message };
        }

        const modules = Array.isArray(data.modules)
          ? data.modules
              .filter((item) => item && typeof item.name === "string" && item.name.trim().length > 0)
              .map((item) => {
                const rawCategory = typeof item.category === "string"
                  ? item.category.trim().toLowerCase()
                  : "";
                let normalizedCategory = "Custom";
                if (rawCategory === "system") {
                  normalizedCategory = "System";
                } else if (rawCategory === "marketplace") {
                  normalizedCategory = "Marketplace";
                }

                return {
                  name: String(item.name).trim(),
                  sourceMprPath: typeof item.sourceMprPath === "string" ? item.sourceMprPath : "",
                  category: normalizedCategory,
                  appName: typeof item.appName === "string" ? item.appName : "",
                };
              })
          : [];

        const selectedSet = new Set(
          Array.isArray(modelOverviewState.selectedModules)
            ? modelOverviewState.selectedModules
            : []);
        const validSelections = modules
          .map((moduleItem) => moduleItem.name)
          .filter((name) => selectedSet.has(name));

        const appName = typeof data.appName === "string" && data.appName.trim().length > 0
          ? data.appName.trim()
          : (modules.length > 0 && typeof modules[0].appName === "string" ? modules[0].appName : "Application");

        modelOverviewState = {
          ...modelOverviewState,
          modulesLoaded: true,
          modulesLoadGeneratedAtUtc: data.generatedAtUtc || null,
          moduleListError: "",
          appName,
          selectedModules: validSelections,
          availableModules: modules,
        };

        overviewModulesInProgress = false;
        const moduleCount = Number.isInteger(data.moduleCount) ? data.moduleCount : modules.length;
        return { success: true, count: moduleCount };
      } catch (error) {
        const message = error && error.message ? error.message : "Unexpected error";
        modelOverviewState = {
          ...modelOverviewState,
          modulesLoaded: false,
          modulesLoadGeneratedAtUtc: null,
          moduleListError: message,
          appName: "",
          selectedModules: [],
          availableModules: [],
        };

        overviewModulesInProgress = false;
        return { success: false, message };
      }
    }

    function buildActionUrl(actionName, extraParams) {
      const query = new URLSearchParams();
      query.set(actionQueryKey, actionName);
      query.set(projectPathQueryKey, projectPath || "");
      if (extraParams && typeof extraParams === "object") {
        Object.entries(extraParams).forEach(([key, value]) => {
          if (typeof value === "string" && value.trim().length > 0) {
            query.set(key, value);
          }
        });
      }

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

    function resetModelOverviewState() {
      modelOverviewState = {
        hasGenerated: false,
        generatedAtUtc: null,
        changedFileCount: 0,
        changedModelFileCount: 0,
        mprFileCount: 0,
        overviewText: "",
        outputFolderPath: "",
        outputPaths: [],
        mode: "",
        selectedModule: "",
        selectedModules: [],
        message: "",
        error: "",
        modulesLoaded: false,
        modulesLoadGeneratedAtUtc: null,
        moduleListError: "",
        appName: "",
        availableModules: [],
      };
    }

    function formatGeneratedTimestamp(timestamp) {
      if (!timestamp) {
        return "";
      }

      const parsed = new Date(timestamp);
      if (Number.isNaN(parsed.getTime())) {
        return String(timestamp);
      }

      return parsed.toLocaleString();
    }

    function canGenerateOverview(payload) {
      if (!settingsState.extendedMode) {
        return false;
      }

      if (!hasLoadedChanges) {
        return false;
      }

      if (!payload || payload.IsGitRepo !== true) {
        return false;
      }

      if (typeof payload.Error === "string" && payload.Error.trim().length > 0) {
        return false;
      }

      return true;
    }

    function resolveModuleNameForCopy(elementName) {
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

    function getDisplayTextForCopy(change) {
      const displayText = change && typeof change.DisplayText === "string"
        ? change.DisplayText.trim()
        : "";
      if (displayText.length > 0) {
        return displayText.replace(/^\-\s*/, "").trim();
      }

      const changeType = change && typeof change.ChangeType === "string" && change.ChangeType.trim().length > 0
        ? change.ChangeType.trim()
        : "Changed";
      const elementName = change && typeof change.ElementName === "string" && change.ElementName.trim().length > 0
        ? change.ElementName.trim()
        : "<unnamed>";
      const details = change && typeof change.Details === "string"
        ? change.Details.trim()
        : "";

      if (details.length > 0) {
        return `${changeType} ${elementName} : ${details}`.trim();
      }

      return `${changeType} ${elementName}`.trim();
    }

    function createCopyModuleBucket() {
      return {
        domain: [],
        other: [],
      };
    }

    function isDomainChangeForCopy(change) {
      const elementType = change && typeof change.ElementType === "string"
        ? change.ElementType.trim().toLowerCase()
        : "";
      return elementType === "entity" ||
        elementType === "nonpersistententity" ||
        elementType === "association";
    }

    function getFileModuleBucketsForCopy(fileChange) {
      const buckets = new Map();

      function appendChange(moduleName, change, isDomain) {
        const resolvedModule = typeof moduleName === "string" && moduleName.trim().length > 0
          ? moduleName.trim()
          : "Unknown";
        if (!buckets.has(resolvedModule)) {
          buckets.set(resolvedModule, createCopyModuleBucket());
        }

        const target = buckets.get(resolvedModule);
        if (isDomain) {
          target.domain.push(change);
        } else {
          target.other.push(change);
        }
      }

      if (Array.isArray(fileChange.ModelChangesByModule) && fileChange.ModelChangesByModule.length > 0) {
        fileChange.ModelChangesByModule.forEach((moduleGroup) => {
          const moduleName = typeof moduleGroup.Module === "string" ? moduleGroup.Module : "Unknown";
          const domainModel = Array.isArray(moduleGroup.DomainModel) ? moduleGroup.DomainModel : [];
          const microflows = Array.isArray(moduleGroup.Microflows) ? moduleGroup.Microflows : [];
          const pages = Array.isArray(moduleGroup.Pages) ? moduleGroup.Pages : [];
          const nanoflows = Array.isArray(moduleGroup.Nanoflows) ? moduleGroup.Nanoflows : [];
          const resources = Array.isArray(moduleGroup.Resources) ? moduleGroup.Resources : [];

          domainModel.forEach((change) => appendChange(moduleName, change, true));
          [...microflows, ...pages, ...nanoflows, ...resources]
            .forEach((change) => appendChange(moduleName, change, false));
        });

        return buckets;
      }

      const fallbackChanges = Array.isArray(fileChange.ModelChanges) ? fileChange.ModelChanges : [];
      fallbackChanges.forEach((change) =>
        appendChange(
          resolveModuleNameForCopy(change.ElementName),
          change,
          isDomainChangeForCopy(change)));

      return buckets;
    }

    function orderCopyRows(changes) {
      return changes
        .map((change) => getDisplayTextForCopy(change))
        .filter((text) => text.length > 0)
        .sort((left, right) => left.localeCompare(right));
    }

    function buildCopyTextFromPayload(payload) {
      const changes = payload && Array.isArray(payload.Changes) ? payload.Changes : [];
      const modules = new Map();

      function ensureModule(moduleName) {
        if (!modules.has(moduleName)) {
          modules.set(moduleName, createCopyModuleBucket());
        }

        return modules.get(moduleName);
      }

      changes.forEach((fileChange) => {
        if (!fileChange || typeof fileChange.FilePath !== "string") {
          return;
        }

        if (!fileChange.FilePath.toLowerCase().endsWith(".mpr")) {
          return;
        }

        const fileBuckets = getFileModuleBucketsForCopy(fileChange);
        fileBuckets.forEach((bucket, moduleName) => {
          const targetBucket = ensureModule(moduleName);
          bucket.domain.forEach((change) => targetBucket.domain.push(change));
          bucket.other.forEach((change) => targetBucket.other.push(change));
        });
      });

      const lines = [];
      const orderedModuleNames = Array.from(modules.keys())
        .sort((left, right) => left.localeCompare(right));
      orderedModuleNames.forEach((moduleName) => {
        const moduleBucket = modules.get(moduleName);
        const domainRows = orderCopyRows(moduleBucket.domain);
        const otherRows = orderCopyRows(moduleBucket.other);

        if (domainRows.length === 0 && otherRows.length === 0) {
          return;
        }

        lines.push(`[${moduleName}]`);
        lines.push("Domain mode:");
        domainRows.forEach((row) => lines.push(`- ${row}`));
        lines.push("");
        otherRows.forEach((row) => lines.push(`- ${row}`));
        lines.push("");
      });

      while (lines.length > 0 && lines[lines.length - 1].trim().length === 0) {
        lines.pop();
      }

      return lines.join("\n");
    }

    async function copyTextToClipboard(text) {
      if (typeof text !== "string" || text.length === 0) {
        return false;
      }

      if (navigator && navigator.clipboard && typeof navigator.clipboard.writeText === "function") {
        try {
          await navigator.clipboard.writeText(text);
          return true;
        } catch {
          // Fall through to legacy copy command.
        }
      }

      const textArea = document.createElement("textarea");
      textArea.value = text;
      textArea.setAttribute("readonly", "readonly");
      textArea.style.position = "fixed";
      textArea.style.left = "-9999px";
      document.body.appendChild(textArea);
      textArea.select();

      let copied = false;
      try {
        copied = document.execCommand("copy");
      } catch {
        copied = false;
      } finally {
        document.body.removeChild(textArea);
      }

      return copied;
    }

    function buildCommitMessage(storyId, signature, comments, changesText) {
      const normalizedStoryId = typeof storyId === "string" ? storyId.trim() : "";
      const normalizedSignature = typeof signature === "string" ? signature.trim() : "";
      const normalizedComments = typeof comments === "string" ? comments.trim() : "";
      const normalizedChanges = typeof changesText === "string" ? changesText.trimEnd() : "";
      const header = `${normalizedStoryId} ${normalizedSignature}`.trim();

      return `${header}\n${normalizedComments}\n\nchanges:\n${normalizedChanges}`;
    }

    function showCommitMessageDialog(statusLine) {
      const changesText = buildCopyTextFromPayload(currentPayload);
      if (changesText.trim().length === 0) {
        statusLine.textContent = "No model changes available for commit message.";
        return;
      }

      const overlay = element("div", "compose-overlay");
      const modal = element("div", "compose-modal");
      overlay.appendChild(modal);

      const head = element("div", "compose-head");
      head.appendChild(element("div", "compose-title", "Create commit message"));
      const closeButton = element("button", "compose-close", "Close");
      closeButton.type = "button";
      head.appendChild(closeButton);
      modal.appendChild(head);

      const row1 = element("div", "compose-grid");
      const storyField = element("div", "compose-field");
      storyField.appendChild(element("label", "compose-label", "Story ID"));
      const storyInput = document.createElement("input");
      storyInput.type = "text";
      storyInput.className = "compose-input";
      storyField.appendChild(storyInput);
      row1.appendChild(storyField);

      const signatureField = element("div", "compose-field");
      signatureField.appendChild(element("label", "compose-label", "Signature"));
      const signatureInput = document.createElement("input");
      signatureInput.type = "text";
      signatureInput.className = "compose-input";
      signatureInput.value = typeof settingsState.signature === "string" ? settingsState.signature : "";
      signatureField.appendChild(signatureInput);
      row1.appendChild(signatureField);
      modal.appendChild(row1);

      const row2 = element("div", "compose-field");
      row2.appendChild(element("label", "compose-label", "Comments (optional)"));
      const commentsInput = document.createElement("textarea");
      commentsInput.className = "compose-textarea";
      commentsInput.rows = 3;
      row2.appendChild(commentsInput);
      modal.appendChild(row2);

      const row3 = element("div", "compose-field");
      row3.appendChild(element("label", "compose-label", "Changes"));
      const changesInput = document.createElement("textarea");
      changesInput.className = "compose-textarea changes";
      changesInput.rows = 10;
      changesInput.value = changesText;
      row3.appendChild(changesInput);
      modal.appendChild(row3);

      const actions = element("div", "compose-actions");
      actions.appendChild(element("span", "compose-note", "Output format matches commit-message template."));
      const copyButton = element("button", "btn", "Copy");
      copyButton.type = "button";
      actions.appendChild(copyButton);
      const storeButton = element("button", "btn btn-outline", "Store");
      storeButton.type = "button";
      if (settingsState.extendedMode && settingsState.storeCommitMessages) {
        actions.appendChild(storeButton);
      }
      modal.appendChild(actions);

      function closeModal() {
        if (overlay.parentElement) {
          overlay.parentElement.removeChild(overlay);
        }
      }

      closeButton.addEventListener("click", closeModal);
      overlay.addEventListener("click", (event) => {
        if (event.target === overlay) {
          closeModal();
        }
      });
      document.addEventListener("keydown", function onKeydown(event) {
        if (event.key === "Escape") {
          document.removeEventListener("keydown", onKeydown);
          closeModal();
        }
      }, { once: true });

      copyButton.addEventListener("click", async () => {
        const commitMessage = buildCommitMessage(
          storyInput.value,
          signatureInput.value,
          commentsInput.value,
          changesInput.value);
        const copied = await copyTextToClipboard(commitMessage);
        if (!copied) {
          statusLine.textContent = "Copy failed: clipboard access unavailable.";
          return;
        }

        statusLine.textContent = "Commit message copied to clipboard.";
        closeModal();
      });

      if (settingsState.extendedMode && settingsState.storeCommitMessages) {
        storeButton.addEventListener("click", async () => {
          const commitMessage = buildCommitMessage(
            storyInput.value,
            signatureInput.value,
            commentsInput.value,
            changesInput.value);
          storeButton.disabled = true;
          statusLine.textContent = "Storing commit message...";

          try {
            const response = await fetch(
              buildActionUrl(storeCommitMessageActionValue, getActionParameters()),
              {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ message: commitMessage }),
              });

            let data = null;
            try {
              data = await response.json();
            } catch {
              data = null;
            }

            if (!response.ok || !data || data.success !== true) {
              const message = data && typeof data.message === "string"
                ? data.message
                : `Store failed (HTTP ${response.status})`;
              statusLine.textContent = `Store failed: ${message}`;
              storeButton.disabled = false;
              return;
            }

            const destination = typeof data.outputPath === "string" && data.outputPath.length > 0
              ? data.outputPath
              : "Commit messages folder";
            statusLine.textContent = `Commit message stored: ${destination}`;
            closeModal();
          } catch (error) {
            const message = error && error.message ? error.message : "Unexpected error";
            statusLine.textContent = `Store failed: ${message}`;
            storeButton.disabled = false;
          }
        });
      }

      document.body.appendChild(overlay);
      storyInput.focus();
    }

    function renderModelOverview(payload, statusLine) {
      const panel = element("section", "panel overview-panel");
      panel.appendChild(element("div", "panel-title", "Model overview"));

      const overviewContent = element("div", "overview-content");
      overviewContent.appendChild(element(
        "div",
        "overview-hint",
        "Generate module overviews from the committed model state only (HEAD)."));

      const modulePicker = element("div", "overview-module-picker");
      const modulePickerHead = element("div", "overview-module-picker-head");
      modulePickerHead.appendChild(element("span", "overview-meta", "Modules"));
      const reloadModulesButton = element("button", "btn btn-outline", "Reload modules");
      reloadModulesButton.type = "button";
      reloadModulesButton.disabled = overviewInProgress || overviewModulesInProgress || !canGenerateOverview(payload);
      modulePickerHead.appendChild(reloadModulesButton);
      modulePicker.appendChild(modulePickerHead);

      if (!canGenerateOverview(payload)) {
        modulePicker.appendChild(element(
          "div",
          "overview-placeholder",
          "Module list is unavailable until repository analysis succeeds."));
      } else if (overviewModulesInProgress && !modelOverviewState.modulesLoaded) {
        modulePicker.appendChild(element("div", "overview-meta", "Loading module list..."));
      } else if (modelOverviewState.moduleListError) {
        modulePicker.appendChild(element(
          "div",
          "overview-placeholder",
          `Module list load failed: ${modelOverviewState.moduleListError}`));
      } else if (!Array.isArray(modelOverviewState.availableModules) || modelOverviewState.availableModules.length === 0) {
        modulePicker.appendChild(element("div", "overview-placeholder", "No modules detected."));
      } else {
        const availableModules = modelOverviewState.availableModules
          .filter((moduleItem) => moduleItem && typeof moduleItem.name === "string" && moduleItem.name.trim().length > 0);
        const appModules = availableModules.filter((moduleItem) =>
          moduleItem.category === "System" || moduleItem.category === "Marketplace");
        const customModules = availableModules.filter((moduleItem) =>
          moduleItem.category === "Custom");

        const selectorToolbar = element("div", "overview-selector-toolbar");
        const selectAllButton = element("button", "btn btn-outline", "Select all");
        const selectAppButton = element("button", "btn btn-outline", "Select app");
        const selectCustomButton = element("button", "btn btn-outline", "Select custom");
        const generateSelectedButton = element("button", "btn", "Generate selected");

        [selectAllButton, selectAppButton, selectCustomButton, generateSelectedButton].forEach((button) => {
          button.type = "button";
          button.disabled = overviewInProgress || overviewModulesInProgress || !canGenerateOverview(payload);
          selectorToolbar.appendChild(button);
        });

        generateSelectedButton.disabled =
          generateSelectedButton.disabled ||
          !Array.isArray(modelOverviewState.selectedModules) ||
          modelOverviewState.selectedModules.length === 0;

        selectorToolbar.appendChild(element(
          "span",
          "overview-meta",
          `Selected: ${Array.isArray(modelOverviewState.selectedModules) ? modelOverviewState.selectedModules.length : 0}`));
        modulePicker.appendChild(selectorToolbar);

        function buildModuleGroup(title, modules, expandedByDefault) {
          const group = element("details", "overview-module-group");
          group.open = expandedByDefault;
          group.appendChild(element("summary", null, `${title}: ${modules.length}`));
          const rows = element("div", "overview-module-rows");
          const selectedSet = new Set(
            Array.isArray(modelOverviewState.selectedModules)
              ? modelOverviewState.selectedModules
              : []);

          modules.forEach((moduleItem) => {
            const moduleName = moduleItem.name;
            const row = element("div", "overview-module-row");
            const label = element("label");
            const checkbox = document.createElement("input");
            checkbox.type = "checkbox";
            checkbox.checked = selectedSet.has(moduleName);
            checkbox.disabled = overviewInProgress || overviewModulesInProgress || !canGenerateOverview(payload);
            checkbox.addEventListener("change", () => {
              const nextSet = new Set(
                Array.isArray(modelOverviewState.selectedModules)
                  ? modelOverviewState.selectedModules
                  : []);
              if (checkbox.checked) {
                nextSet.add(moduleName);
              } else {
                nextSet.delete(moduleName);
              }

              modelOverviewState = {
                ...modelOverviewState,
                selectedModules: Array.from(nextSet).sort((a, b) => a.localeCompare(b)),
              };
              render(`Selected ${modelOverviewState.selectedModules.length} module(s).`);
            });

            label.appendChild(checkbox);
            label.appendChild(element("span", null, moduleName));
            row.appendChild(label);

            const meta = element("span", "overview-module-meta");
            const sourcePath = typeof moduleItem.sourceMprPath === "string"
              ? moduleItem.sourceMprPath
              : "";
            if (sourcePath) {
              meta.textContent = moduleItem.category || "";
              meta.title = sourcePath;
            } else {
              meta.textContent = moduleItem.category || "";
            }
            row.appendChild(meta);
            rows.appendChild(row);
          });

          group.appendChild(rows);
          return group;
        }

        const groups = element("div", "overview-module-groups");
        const appNameLabel = typeof modelOverviewState.appName === "string" && modelOverviewState.appName.trim().length > 0
          ? modelOverviewState.appName.trim()
          : "Application";
        groups.appendChild(buildModuleGroup(`App ${appNameLabel}`, appModules, false));
        groups.appendChild(buildModuleGroup("Custom modules", customModules, true));
        modulePicker.appendChild(groups);

        function setSelectedModules(nextModules) {
          modelOverviewState = {
            ...modelOverviewState,
            selectedModules: nextModules
              .filter((name) => typeof name === "string" && name.trim().length > 0)
              .map((name) => name.trim())
              .filter((name, index, all) => all.indexOf(name) === index)
              .sort((a, b) => a.localeCompare(b)),
          };
        }

        selectAllButton.addEventListener("click", () => {
          setSelectedModules(availableModules.map((moduleItem) => moduleItem.name));
          render(`Selected ${modelOverviewState.selectedModules.length} module(s).`);
        });

        selectAppButton.addEventListener("click", () => {
          setSelectedModules(appModules.map((moduleItem) => moduleItem.name));
          render(`Selected ${modelOverviewState.selectedModules.length} app module(s).`);
        });

        selectCustomButton.addEventListener("click", () => {
          setSelectedModules(customModules.map((moduleItem) => moduleItem.name));
          render(`Selected ${modelOverviewState.selectedModules.length} custom module(s).`);
        });

        generateSelectedButton.addEventListener("click", async () =>
          requestOverviewForSelected());
      }

      if (modelOverviewState.modulesLoadGeneratedAtUtc) {
        const loadedAt = formatGeneratedTimestamp(modelOverviewState.modulesLoadGeneratedAtUtc);
        modulePicker.appendChild(element("div", "overview-meta", `Module list loaded: ${loadedAt}`));
      }

      overviewContent.appendChild(modulePicker);

      if (!canGenerateOverview(payload)) {
        overviewContent.appendChild(renderCard(
          "Overview generation is unavailable until repository analysis succeeds.",
          "overview-placeholder"));
      }
      else if (!modelOverviewState.hasGenerated) {
        overviewContent.appendChild(renderCard(
          "No overview has been generated yet.",
          "overview-placeholder"));
      }
      else if (modelOverviewState.error) {
        overviewContent.appendChild(renderCard(
          `Overview generation failed: ${modelOverviewState.error}`,
          "overview-placeholder"));
      }
      else {
        const modeLabel = modelOverviewState.mode || "<unknown>";
        const selectedModulesLabel = Array.isArray(modelOverviewState.selectedModules) &&
          modelOverviewState.selectedModules.length > 0
          ? ` | selected modules: ${modelOverviewState.selectedModules.join(", ")}`
          : "";
        const metrics = element(
          "div",
          "overview-meta",
          `Mode: ${modeLabel}${selectedModulesLabel} | Files in scope: ${modelOverviewState.changedFileCount} | changed .mpr files: ${modelOverviewState.changedModelFileCount} | repository .mpr files: ${modelOverviewState.mprFileCount}`);
        overviewContent.appendChild(metrics);

        if (modelOverviewState.outputFolderPath) {
          overviewContent.appendChild(element(
            "div",
            "overview-meta",
            `Output folder: ${modelOverviewState.outputFolderPath}`));
        }

        if (Array.isArray(modelOverviewState.outputPaths) && modelOverviewState.outputPaths.length > 0) {
          const outputList = element("pre", "overview-output");
          outputList.textContent = modelOverviewState.outputPaths.join("\n");
          overviewContent.appendChild(outputList);
        }

        const output = element("pre", "overview-output");
        output.textContent = modelOverviewState.overviewText || "(Overview output is empty)";
        overviewContent.appendChild(output);
      }

      function snapshotModuleListState() {
        return {
          modulesLoaded: modelOverviewState.modulesLoaded === true,
          modulesLoadGeneratedAtUtc: modelOverviewState.modulesLoadGeneratedAtUtc || null,
          moduleListError: typeof modelOverviewState.moduleListError === "string" ? modelOverviewState.moduleListError : "",
          appName: typeof modelOverviewState.appName === "string" ? modelOverviewState.appName : "",
          selectedModules: Array.isArray(modelOverviewState.selectedModules)
            ? modelOverviewState.selectedModules.slice()
            : [],
          availableModules: Array.isArray(modelOverviewState.availableModules)
            ? modelOverviewState.availableModules.slice()
            : [],
        };
      }

      async function requestModuleList(forceReload) {
        if (overviewModulesInProgress || !canGenerateOverview(payload)) {
          return;
        }

        if (!forceReload && modelOverviewState.modulesLoaded) {
          return;
        }

        statusLine.textContent = "Loading overview modules...";
        const result = await loadOverviewModulesIntoState();
        if (result.success) {
          const moduleCount = Number.isInteger(result.count) ? result.count : 0;
          render(`Loaded ${moduleCount} module(s).`);
          return;
        }

        render(`Module list loading failed: ${result.message}`);
      }

      async function requestOverviewForSelected() {
        if (overviewInProgress || !canGenerateOverview(payload)) {
          return;
        }

        const selectedModules = Array.isArray(modelOverviewState.selectedModules)
          ? modelOverviewState.selectedModules
              .filter((name) => typeof name === "string" && name.trim().length > 0)
          : [];
        if (selectedModules.length === 0) {
          render("Select at least one module before generating.");
          return;
        }

        const moduleListState = snapshotModuleListState();
        overviewInProgress = true;
        statusLine.textContent = `Generating ${selectedModules.length} module overview(s)...`;

        try {
          const modulesCsv = selectedModules.join(",");
          const overviewUrl = `${buildActionUrl(
            generateOverviewModulesActionValue,
            getActionParameters({ [modulesQueryKey]: modulesCsv }))}&_t=${Date.now()}`;
          const response = await fetch(overviewUrl, { cache: "no-store" });

          let data = null;
          try {
            data = await response.json();
          } catch {
            data = null;
          }

          if (!response.ok || !data || data.success !== true) {
            const message = data && typeof data.message === "string"
              ? data.message
              : `Overview generation failed (HTTP ${response.status})`;

            modelOverviewState = {
              hasGenerated: true,
              generatedAtUtc: null,
              changedFileCount: 0,
              changedModelFileCount: 0,
              mprFileCount: 0,
              overviewText: "",
              outputFolderPath: "",
              outputPaths: [],
              mode: "",
              selectedModule: "",
              selectedModules: moduleListState.selectedModules,
              message: "",
              error: message,
              modulesLoaded: moduleListState.modulesLoaded,
              modulesLoadGeneratedAtUtc: moduleListState.modulesLoadGeneratedAtUtc,
              moduleListError: moduleListState.moduleListError,
              appName: moduleListState.appName,
              availableModules: moduleListState.availableModules,
            };

            overviewInProgress = false;
            render(`Overview generation failed: ${message}`);
            return;
          }

          modelOverviewState = {
            hasGenerated: true,
            generatedAtUtc: data.generatedAtUtc || null,
            changedFileCount: Number.isInteger(data.changedFileCount) ? data.changedFileCount : 0,
            changedModelFileCount: Number.isInteger(data.changedModelFileCount) ? data.changedModelFileCount : 0,
            mprFileCount: Number.isInteger(data.mprFileCount) ? data.mprFileCount : 0,
            overviewText: typeof data.overviewText === "string" ? data.overviewText : "",
            outputFolderPath: typeof data.outputFolderPath === "string" ? data.outputFolderPath : "",
            outputPaths: Array.isArray(data.outputPaths) ? data.outputPaths.filter((item) => typeof item === "string") : [],
            mode: typeof data.mode === "string" ? data.mode : "",
            selectedModule: typeof data.selectedModule === "string" ? data.selectedModule : "",
            selectedModules: Array.isArray(data.selectedModules)
              ? data.selectedModules.filter((item) => typeof item === "string")
              : moduleListState.selectedModules,
            message: typeof data.message === "string" ? data.message : "",
            error: "",
            modulesLoaded: moduleListState.modulesLoaded,
            modulesLoadGeneratedAtUtc: moduleListState.modulesLoadGeneratedAtUtc,
            moduleListError: moduleListState.moduleListError,
            appName: moduleListState.appName,
            availableModules: moduleListState.availableModules,
          };

          overviewInProgress = false;
          const generatedMessage = modelOverviewState.message || "Model overview generated.";
          render(generatedMessage);
          return;
        } catch (error) {
          const message = error && error.message ? error.message : "Unexpected error";
          modelOverviewState = {
            hasGenerated: true,
            generatedAtUtc: null,
            changedFileCount: 0,
            changedModelFileCount: 0,
            mprFileCount: 0,
            overviewText: "",
            outputFolderPath: "",
            outputPaths: [],
            mode: "",
            selectedModule: "",
            selectedModules: moduleListState.selectedModules,
            message: "",
            error: message,
            modulesLoaded: moduleListState.modulesLoaded,
            modulesLoadGeneratedAtUtc: moduleListState.modulesLoadGeneratedAtUtc,
            moduleListError: moduleListState.moduleListError,
            appName: moduleListState.appName,
            availableModules: moduleListState.availableModules,
          };

          overviewInProgress = false;
          render(`Overview generation failed: ${message}`);
        }
      }

      if (canGenerateOverview(payload) && !modelOverviewState.modulesLoaded && !overviewModulesInProgress) {
        requestModuleList(false);
      }

      reloadModulesButton.addEventListener("click", async () =>
        requestModuleList(true));

      panel.appendChild(overviewContent);
      return panel;
    }

    function renderSettings(statusLine) {
      const panel = element("section", "panel settings-panel");
      panel.appendChild(element("div", "panel-title", "Settings"));

      const content = element("div", "settings-content");

      const themeGroup = element("section", "settings-group");
      themeGroup.appendChild(element("div", "settings-label", "Theme"));
      themeGroup.appendChild(element(
        "div",
        "settings-help",
        "Switch between dark and light mode. Default is dark."));

      const themeInline = element("div", "settings-inline");
      const themeSelect = document.createElement("select");
      themeSelect.className = "settings-input";
      themeSelect.style.minWidth = "180px";
      themeSelect.style.width = "180px";
      const darkOption = document.createElement("option");
      darkOption.value = "dark";
      darkOption.textContent = "Dark";
      const lightOption = document.createElement("option");
      lightOption.value = "light";
      lightOption.textContent = "Light";
      themeSelect.appendChild(darkOption);
      themeSelect.appendChild(lightOption);
      themeSelect.value = normalizeTheme(settingsState.theme);
      themeInline.appendChild(themeSelect);
      themeGroup.appendChild(themeInline);

      const modeGroup = element("section", "settings-group");
      modeGroup.appendChild(element("div", "settings-label", "Extended mode"));
      modeGroup.appendChild(element(
        "div",
        "settings-help",
        "Enable advanced export controls and model overview."));
      const modeInline = element("label", "settings-inline");
      const extendedModeInput = document.createElement("input");
      extendedModeInput.type = "checkbox";
      extendedModeInput.checked = Boolean(settingsState.extendedMode);
      modeInline.appendChild(extendedModeInput);
      modeInline.appendChild(element("span", null, "Enable extended mode"));
      modeGroup.appendChild(modeInline);

      const pathGroup = element("section", "settings-group");
      pathGroup.appendChild(element("div", "settings-label", "Data root base path"));
      pathGroup.appendChild(element(
        "div",
        "settings-help",
        "Set where the mendix-data folder will be stored. Subfolders remain automatic."));

      const pathInput = document.createElement("input");
      pathInput.type = "text";
      pathInput.className = "settings-input";
      pathInput.value = settingsState.dataRootBasePath || defaultDataRootBasePath;
      pathInput.placeholder = defaultDataRootBasePath;
      pathGroup.appendChild(pathInput);
      const preview = element("div", "settings-preview", `Resolved data root: ${getConfiguredDataRootPath()}`);
      pathGroup.appendChild(preview);

      const exportToggleInline = element("label", "settings-inline");
      const exportAdditionalDataInput = document.createElement("input");
      exportAdditionalDataInput.type = "checkbox";
      exportAdditionalDataInput.checked = Boolean(settingsState.exportAdditionalData);
      exportToggleInline.appendChild(exportAdditionalDataInput);
      exportToggleInline.appendChild(element("span", null, "Export additional data"));

      const exportOptions = element("div", "settings-group");
      exportOptions.style.padding = "8px";
      exportOptions.style.marginTop = "4px";
      exportOptions.appendChild(element("div", "settings-label", "Stored outputs"));

      const dumpsInline = element("label", "settings-inline");
      const persistDumpsInput = document.createElement("input");
      persistDumpsInput.type = "checkbox";
      persistDumpsInput.checked = Boolean(settingsState.persistDumps);
      dumpsInline.appendChild(persistDumpsInput);
      dumpsInline.appendChild(element("span", null, "Dumps"));
      exportOptions.appendChild(dumpsInline);

      const rawChangesInline = element("label", "settings-inline");
      const persistRawChangesInput = document.createElement("input");
      persistRawChangesInput.type = "checkbox";
      persistRawChangesInput.checked = Boolean(settingsState.persistRawChanges);
      rawChangesInline.appendChild(persistRawChangesInput);
      rawChangesInline.appendChild(element("span", null, "Raw changes"));
      exportOptions.appendChild(rawChangesInline);

      exportOptions.appendChild(element("div", "settings-label", "App overview"));
      const structuredInline = element("label", "settings-inline");
      const persistOverviewStructuredInput = document.createElement("input");
      persistOverviewStructuredInput.type = "checkbox";
      persistOverviewStructuredInput.checked = Boolean(settingsState.persistOverviewStructured);
      structuredInline.appendChild(persistOverviewStructuredInput);
      structuredInline.appendChild(element("span", null, "Structured"));
      exportOptions.appendChild(structuredInline);

      const pseudocodeInline = element("label", "settings-inline");
      const persistOverviewPseudocodeInput = document.createElement("input");
      persistOverviewPseudocodeInput.type = "checkbox";
      persistOverviewPseudocodeInput.checked = Boolean(settingsState.persistOverviewPseudocode);
      pseudocodeInline.appendChild(persistOverviewPseudocodeInput);
      pseudocodeInline.appendChild(element("span", null, "Pseudocode"));
      exportOptions.appendChild(pseudocodeInline);

      if (settingsState.extendedMode) {
        pathGroup.appendChild(exportToggleInline);
        if (settingsState.exportAdditionalData) {
          pathGroup.appendChild(exportOptions);
        }
      }

      const actionInline = element("div", "settings-inline");
      const saveButton = element("button", "btn", "Save settings");
      saveButton.type = "button";
      actionInline.appendChild(saveButton);

      const resetButton = element("button", "btn btn-outline", "Reset default");
      resetButton.type = "button";
      actionInline.appendChild(resetButton);
      pathGroup.appendChild(actionInline);

      const signatureGroup = element("section", "settings-group");
      signatureGroup.appendChild(element("div", "settings-label", "User signature"));
      signatureGroup.appendChild(element(
        "div",
        "settings-help",
        "Used as default signature in the Create message popup (for example: Mo)."));
      const signatureInput = document.createElement("input");
      signatureInput.type = "text";
      signatureInput.className = "settings-input";
      signatureInput.value = typeof settingsState.signature === "string" ? settingsState.signature : "";
      signatureInput.placeholder = "Mo";
      signatureGroup.appendChild(signatureInput);

      const commitGroup = element("section", "settings-group");
      commitGroup.appendChild(element("div", "settings-label", "Commit messages"));
      commitGroup.appendChild(element(
        "div",
        "settings-help",
        "Store generated commit messages as text files."));
      const storeCommitInline = element("label", "settings-inline");
      const storeCommitMessagesInput = document.createElement("input");
      storeCommitMessagesInput.type = "checkbox";
      storeCommitMessagesInput.checked = Boolean(settingsState.storeCommitMessages);
      storeCommitInline.appendChild(storeCommitMessagesInput);
      storeCommitInline.appendChild(element("span", null, "Store commit messages"));
      commitGroup.appendChild(storeCommitInline);

      const commitPathInput = document.createElement("input");
      commitPathInput.type = "text";
      commitPathInput.className = "settings-input";
      commitPathInput.value = settingsState.commitMessagesBasePath || settingsState.dataRootBasePath || defaultDataRootBasePath;
      commitPathInput.placeholder = settingsState.dataRootBasePath || defaultDataRootBasePath;
      commitGroup.appendChild(commitPathInput);
      const commitPathPreview = element(
        "div",
        "settings-preview",
        `Resolved folder: ${getConfiguredCommitMessagesFolderPath(commitPathInput.value)}`);
      commitGroup.appendChild(commitPathPreview);

      themeSelect.addEventListener("change", () => {
        applyTheme(themeSelect.value);
        saveSettingsToStorage();
        preview.textContent = `Resolved data root: ${getConfiguredDataRootPath()}`;
        render("Theme updated.");
      });

      commitPathInput.addEventListener("input", () => {
        commitPathPreview.textContent = `Resolved folder: ${getConfiguredCommitMessagesFolderPath(commitPathInput.value)}`;
      });

      function savePathSettings(message) {
        const candidate = typeof pathInput.value === "string" ? pathInput.value.trim() : "";
        const resolvedDataRootBasePath = candidate.length > 0 ? candidate : defaultDataRootBasePath;
        const signatureCandidate = typeof signatureInput.value === "string" ? signatureInput.value.trim() : "";
        const commitPathCandidate = typeof commitPathInput.value === "string" ? commitPathInput.value.trim() : "";
        const resolvedCommitBasePath = commitPathCandidate.length > 0
          ? commitPathCandidate
          : resolvedDataRootBasePath;
        settingsState = {
          ...settingsState,
          dataRootBasePath: resolvedDataRootBasePath,
          signature: signatureCandidate,
          extendedMode: extendedModeInput.checked,
          exportAdditionalData: exportAdditionalDataInput.checked,
          persistDumps: persistDumpsInput.checked,
          persistRawChanges: persistRawChangesInput.checked,
          persistOverviewStructured: persistOverviewStructuredInput.checked,
          persistOverviewPseudocode: persistOverviewPseudocodeInput.checked,
          storeCommitMessages: storeCommitMessagesInput.checked,
          commitMessagesBasePath: resolvedCommitBasePath,
        };
        if (!settingsState.extendedMode && activeView === "model-overview") {
          activeView = "model-changes";
        }
        saveSettingsToStorage();
        preview.textContent = `Resolved data root: ${getConfiguredDataRootPath()}`;
        commitPathPreview.textContent = `Resolved folder: ${getConfiguredCommitMessagesFolderPath(resolvedCommitBasePath)}`;
        render(message);
      }

      saveButton.addEventListener("click", () => {
        savePathSettings("Settings saved.");
      });

      resetButton.addEventListener("click", () => {
        settingsState = {
          ...settingsState,
          dataRootBasePath: defaultDataRootBasePath,
          signature: "",
          extendedMode: false,
          exportAdditionalData: false,
          persistDumps: true,
          persistRawChanges: true,
          persistOverviewStructured: true,
          persistOverviewPseudocode: true,
          storeCommitMessages: false,
          commitMessagesBasePath: defaultDataRootBasePath,
        };
        if (activeView === "model-overview") {
          activeView = "model-changes";
        }
        pathInput.value = defaultDataRootBasePath;
        signatureInput.value = "";
        extendedModeInput.checked = false;
        exportAdditionalDataInput.checked = false;
        persistDumpsInput.checked = true;
        persistRawChangesInput.checked = true;
        persistOverviewStructuredInput.checked = true;
        persistOverviewPseudocodeInput.checked = true;
        storeCommitMessagesInput.checked = false;
        commitPathInput.value = defaultDataRootBasePath;
        saveSettingsToStorage();
        preview.textContent = `Resolved data root: ${getConfiguredDataRootPath()}`;
        commitPathPreview.textContent = `Resolved folder: ${getConfiguredCommitMessagesFolderPath(defaultDataRootBasePath)}`;
        render("Settings reset to default.");
      });

      content.appendChild(themeGroup);
      content.appendChild(modeGroup);
      content.appendChild(pathGroup);
      content.appendChild(signatureGroup);
      if (settingsState.extendedMode) {
        content.appendChild(commitGroup);
      }
      panel.appendChild(content);
      statusLine.textContent = statusLine.textContent || "Update extension settings.";
      return panel;
    }

    function renderChanges(changes, exportButton, createMessageButton, copyButton) {
      const layout = element("div", "layout");

      const modelPanel = element("section", "panel changes-main");
      modelPanel.appendChild(element("div", "panel-title", "Changes"));
      const modelToolbar = element("div", "panel-toolbar");
      if (exportButton) {
        modelToolbar.appendChild(exportButton);
      }
      modelToolbar.appendChild(createMessageButton);
      modelToolbar.appendChild(copyButton);
      modelPanel.appendChild(modelToolbar);
      const modelChangesContainer = element("div", "model-changes");
      modelPanel.appendChild(modelChangesContainer);

      const detailsPanel = element("details", "panel collapsible-panel details-drawer");
      detailsPanel.open = false;
      detailsPanel.appendChild(element("summary", "panel-title collapsible-summary", "Changed files and diff"));

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

      if (!settingsState.extendedMode && activeView === "model-overview") {
        activeView = "model-changes";
      }

      const topbar = element("div", "topbar");
      topbar.appendChild(element("div", "title", "AutoCommitMessage"));
      const meta = element("div", "meta");
      const pathLabel = projectPath && projectPath.length > 0 ? projectPath : "Project path unavailable";
      meta.appendChild(element("span", "badge", pathLabel));

      const settingsButton = element("button", "icon-btn");
      settingsButton.type = "button";
      settingsButton.title = "Settings";
      settingsButton.setAttribute("aria-label", "Settings");
      const settingsIcon = element("span", "settings-icon");
      settingsIcon.setAttribute("aria-hidden", "true");
      settingsButton.appendChild(settingsIcon);
      if (activeView === "settings") {
        settingsButton.classList.add("active");
      }
      meta.appendChild(settingsButton);

      const showExportButton = settingsState.extendedMode && settingsState.exportAdditionalData;
      const hasEnabledExportOutputs =
        settingsState.persistDumps ||
        settingsState.persistRawChanges ||
        settingsState.persistOverviewStructured ||
        settingsState.persistOverviewPseudocode;
      const exportButton = showExportButton
        ? element("button", "btn btn-secondary", "Export")
        : null;
      if (exportButton) {
        exportButton.type = "button";
        exportButton.disabled = !(
          hasEnabledExportOutputs &&
          payload &&
          payload.IsGitRepo === true &&
          Array.isArray(payload.Changes) &&
          payload.Changes.length > 0);
      }

      const createMessageButton = element("button", "btn", "Create message");
      createMessageButton.type = "button";

      const copyButton = element("button", "icon-btn");
      copyButton.type = "button";
      copyButton.title = "Copy model changes";
      copyButton.setAttribute("aria-label", "Copy model changes");
      const copyIcon = element("span", "copy-icon");
      copyIcon.setAttribute("aria-hidden", "true");
      copyButton.appendChild(copyIcon);
      topbar.appendChild(meta);
      root.appendChild(topbar);

      const navBar = element("div", "nav-bar");
      const navMenu = element("div", "nav-menu");
      const modelChangesButton = element("button", "nav-btn", "Model changes");
      modelChangesButton.type = "button";
      const modelOverviewButton = settingsState.extendedMode
        ? element("button", "nav-btn", "Model overview")
        : null;
      if (modelOverviewButton) {
        modelOverviewButton.type = "button";
      }
      if (activeView === "model-overview" && modelOverviewButton) {
        modelOverviewButton.classList.add("active");
      } else if (activeView === "model-changes") {
        modelChangesButton.classList.add("active");
      }
      navMenu.appendChild(modelChangesButton);
      if (modelOverviewButton) {
        navMenu.appendChild(modelOverviewButton);
      }
      navBar.appendChild(navMenu);

      const navActions = element("div", "nav-actions");
      const navRefreshButton = element("button", "icon-btn");
      navRefreshButton.type = "button";
      navRefreshButton.title = "Refresh";
      navRefreshButton.setAttribute("aria-label", "Refresh");
      navRefreshButton.disabled = refreshInProgress;
      const navRefreshIcon = element("span", "refresh-icon");
      navRefreshIcon.setAttribute("aria-hidden", "true");
      navRefreshButton.appendChild(navRefreshIcon);
      navActions.appendChild(navRefreshButton);
      navBar.appendChild(navActions);
      root.appendChild(navBar);

      const branchName = payload && payload.BranchName ? payload.BranchName : "-";
      const defaultStatus = activeView === "model-overview"
        ? "Model overview is generated on demand from committed model state."
        : activeView === "settings"
          ? "Update extension settings."
          : "Press Refresh to load change analysis.";
      const infoLine = element("div", "info-line");
      infoLine.appendChild(element("div", "info-branch", `Branch: ${branchName}`));
      const statusLine = element("div", "status-line", statusOverride || defaultStatus);
      infoLine.appendChild(statusLine);
      root.appendChild(infoLine);

      const content = element("div", "content");
      root.appendChild(content);

      function setExportAvailability() {
        if (!exportButton) {
          return;
        }

        exportButton.disabled = !(
          settingsState.extendedMode &&
          settingsState.exportAdditionalData &&
          hasEnabledExportOutputs &&
          hasLoadedChanges &&
          payload &&
          payload.IsGitRepo === true &&
          Array.isArray(payload.Changes) &&
          payload.Changes.length > 0);
      }

      function setCopyAvailability() {
        if (activeView === "settings") {
          copyButton.disabled = true;
          return;
        }

        if (!hasLoadedChanges) {
          copyButton.disabled = true;
          return;
        }

        const copyText = buildCopyTextFromPayload(currentPayload);
        copyButton.disabled = copyText.trim().length === 0;
      }

      function setCreateMessageAvailability() {
        if (activeView !== "model-changes") {
          createMessageButton.disabled = true;
          return;
        }

        if (!hasLoadedChanges) {
          createMessageButton.disabled = true;
          return;
        }

        const copyText = buildCopyTextFromPayload(currentPayload);
        createMessageButton.disabled = copyText.trim().length === 0;
      }

      modelChangesButton.addEventListener("click", () => {
        if (activeView === "model-changes") {
          return;
        }

        activeView = "model-changes";
        render("Model changes view.");
      });

      if (modelOverviewButton) {
        modelOverviewButton.addEventListener("click", () => {
          if (activeView === "model-overview") {
            return;
          }

          activeView = "model-overview";
          render("Model overview view. Module list is loading; select modules and generate.");
        });
      }

      settingsButton.addEventListener("click", () => {
        if (activeView === "settings") {
          activeView = "model-changes";
          render("Model changes view.");
          return;
        }

        activeView = "settings";
        render("Settings view.");
      });

      copyButton.addEventListener("click", async () => {
        if (!hasLoadedChanges) {
          statusLine.textContent = "Press Refresh to load model changes first.";
          setCopyAvailability();
          return;
        }

        const copyText = buildCopyTextFromPayload(currentPayload);
        if (copyText.trim().length === 0) {
          statusLine.textContent = "No model changes available to copy.";
          setCopyAvailability();
          return;
        }

        copyButton.disabled = true;
        statusLine.textContent = "Copying model changes...";

        const copied = await copyTextToClipboard(copyText);
        if (!copied) {
          statusLine.textContent = "Copy failed: clipboard access unavailable.";
          setCopyAvailability();
          return;
        }

        const copiedLineCount = copyText
          .split("\n")
          .filter((line) => line.trim().length > 0)
          .length;
        statusLine.textContent = `Copied ${copiedLineCount} line(s) to clipboard.`;
        setCopyAvailability();
      });

      createMessageButton.addEventListener("click", () => {
        showCommitMessageDialog(statusLine);
      });

      async function runRefresh() {
        if (refreshInProgress) {
          return;
        }

        refreshInProgress = true;
        navRefreshButton.disabled = true;
        if (exportButton) {
          exportButton.disabled = true;
        }
        statusLine.textContent = "Reloading change analysis...";

        try {
          const refreshUrl = `${buildActionUrl(
            refreshActionValue,
            getActionParameters())}&_t=${Date.now()}`;
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
            navRefreshButton.disabled = false;
            setExportAvailability();
            setCopyAvailability();
            setCreateMessageAvailability();
            return;
          }

          currentPayload = refreshedPayload;
          hasLoadedChanges = true;
          resetModelOverviewState();
          let moduleListResult = { success: false, message: "Extended mode is disabled." };
          if (settingsState.extendedMode) {
            moduleListResult = await loadOverviewModulesIntoState();
          }
          refreshInProgress = false;
          const refreshedAt = new Date().toLocaleTimeString();
          if (moduleListResult.success) {
            const count = Number.isInteger(moduleListResult.count) ? moduleListResult.count : 0;
            render(`Reloaded change analysis at ${refreshedAt}. Loaded ${count} overview module(s).`);
            return;
          }

          if (!settingsState.extendedMode) {
            render(`Reloaded change analysis at ${refreshedAt}.`);
            return;
          }

          const moduleError = typeof moduleListResult.message === "string"
            ? moduleListResult.message
            : "Unknown module-list error";
          render(`Reloaded change analysis at ${refreshedAt}. Module list load failed: ${moduleError}`);
          return;
        } catch (error) {
          const message = error && error.message ? error.message : "Unexpected error";
          statusLine.textContent = `Refresh failed: ${message}`;
          refreshInProgress = false;
          navRefreshButton.disabled = false;
          setExportAvailability();
          setCopyAvailability();
          setCreateMessageAvailability();
        }
      }

      navRefreshButton.addEventListener("click", async () => {
        await runRefresh();
      });

      if (exportButton) {
        exportButton.addEventListener("click", async () => {
          exportButton.disabled = true;
          statusLine.textContent = "Exporting changes...";

          try {
            const response = await fetch(
              buildActionUrl(exportActionValue, getActionParameters()),
              { method: "POST" });
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

            const destination = data.outputPath || data.overviewOutputFolder || "configured folders";
            statusLine.textContent = `Export complete: ${destination}`;
          } catch (error) {
            const message = error && error.message ? error.message : "Unexpected error";
            statusLine.textContent = `Export failed: ${message}`;
          } finally {
            setExportAvailability();
            setCopyAvailability();
            setCreateMessageAvailability();
          }
        });
      }

      setCopyAvailability();
      setCreateMessageAvailability();

      if (activeView === "settings") {
        content.appendChild(renderSettings(statusLine));
        return;
      }

      if (activeView === "model-overview") {
        content.appendChild(renderModelOverview(payload, statusLine));
        return;
      }

      if (!hasLoadedChanges) {
        content.appendChild(renderCard("No change data loaded. Press Refresh to start analysis."));
        statusLine.textContent = "Press Refresh to load change analysis.";
        return;
      }

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

      content.appendChild(
        renderChanges(
          changes,
          exportButton,
          createMessageButton,
          copyButton));
    }

    loadSettingsFromStorage();
    applyTheme(settingsState.theme);
    render();
  </script>
</body>
</html>
""";
    }
}

