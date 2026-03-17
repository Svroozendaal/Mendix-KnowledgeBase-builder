# Extension Rewrite Prompt Index

## Purpose

Implementation prompts for rewriting the Mendix KB extension as a unified, self-contained Studio Pro C# extension. This track replaces the current Node.js backend + thin C# shell with a single DLL that hosts all services internally.

The extension combines three feature areas:
1. **KB Copilot** — AI-powered Q&A against the knowledge base (ported from TypeScript).
2. **KB Creator** — generate/update the knowledge base from within Studio Pro (integrated from existing C# pipeline).
3. **Mendix Developer** — AI-assisted Mendix development via mx CLI.

## Product Spec

See [12-UNIFIED_EXTENSION_SPEC.md](../../product-plan/12-UNIFIED_EXTENSION_SPEC.md) for the full requirements specification.

## Tech Stack

- **Extension:** C# / .NET 8.0 (Mendix ExtensionsAPI v10.24+)
- **Frontend:** React 18 + TypeScript + Vite (bundled as static assets)
- **Communication:** WebView message bridge (`chrome.webview.postMessage` ↔ `PostMessageAsJsonAsync`)
- **AI Providers:** Claude CLI, Codex CLI (process spawning)
- **Model Operations:** Mendix mx CLI

## Execution Rules

1. Before executing any prompt, read `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`.
2. Read the **Context** section of each prompt for required reference files.
3. Read the product spec (`12-UNIFIED_EXTENSION_SPEC.md`) for architectural decisions.
4. Confirm assumptions before changing files.
5. Run `dotnet build` after C# changes to verify compilation.
6. Run `npm run build` after frontend changes.

## Prompt Map

| # | Prompt | Priority | Depends On | Scope |
|---|---|---|---|---|
| 01 | [01-WEBSERVER_AND_SPA_HOSTING.md](01-WEBSERVER_AND_SPA_HOSTING.md) | Critical | — | WebServerExtension, static asset serving, SPA hosting |
| 02 | [02-MESSAGE_BRIDGE_AND_TRANSPORT.md](02-MESSAGE_BRIDGE_AND_TRANSPORT.md) | Critical | 01 | WebView message bridge, BridgeClient, message routing |
| 03 | [03-COPILOT_SERVICE_PORT.md](03-COPILOT_SERVICE_PORT.md) | Critical | 02 | Port all Copilot services from TypeScript to C# |
| 04 | [04-KB_CREATOR_INTEGRATION.md](04-KB_CREATOR_INTEGRATION.md) | High | 03 | KB Creator pipeline integration, Creator tab |
| 05 | [05-MX_CLI_INTEGRATION.md](05-MX_CLI_INTEGRATION.md) | High | 03 | mx CLI service, Copilot tools, Developer tab |
| 06 | [06-TABBED_UI_AND_POLISH.md](06-TABBED_UI_AND_POLISH.md) | High | 04, 05 | Tabbed UI, cross-feature integration, testing |
| 07 | [07-MARKETPLACE_PUBLICATION.md](07-MARKETPLACE_PUBLICATION.md) | Medium | 06 | Licensing, packaging, documentation, marketplace submission |

## Dependency Graph

```text
Phase 1 (WebServer + SPA Hosting)
  → Phase 2 (Message Bridge + Transport)
    → Phase 3 (Copilot Service Port)
      ├→ Phase 4 (KB Creator Integration)
      └→ Phase 5 (mx CLI Integration)
        Phase 4 + 5 → Phase 6 (Tabbed UI + Polish)
                        → Phase 7 (Marketplace Publication)
```

Phases 1–3 are strictly sequential. Phases 4 and 5 can be developed in parallel (both depend on Phase 3). Phase 6 requires both 4 and 5. Phase 7 requires 6.

## Relationship to Copilot Prompts

The [copilot prompts](../copilot/INDEX.md) (01–07) built the current Node.js-based Copilot. This extension track supersedes the copilot architecture by porting it to C#. The copilot prompts remain as reference for the TypeScript service implementations being ported.
