# Feature: Unified Mendix Studio Pro Extension

## Status

PLANNED

## Summary

A self-contained C# Mendix Studio Pro extension that replaces the current Node.js backend + thin C# shell architecture with a single DLL. Combines three feature areas: KB Copilot, KB Creator, and Mendix Developer (mx CLI bridge).

## Scope

- Single C# DLL using `WebServerExtension` + WebView message bridge
- Port all Copilot backend services from TypeScript to C#
- Integrate existing KB Creator pipeline within Studio Pro
- Add Mendix Developer tab with mx CLI bridge for AI-assisted development
- React 18 SPA with tabbed UI (Copilot / Creator / Developer), served as embedded static assets
- AI providers via `System.Diagnostics.Process` (Claude CLI, Codex CLI)
- Target: Mendix Studio Pro 10.24+, Mendix Marketplace distribution

## Location

- Product spec: `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md`
- Development prompts: `.app-info/development/prompts/extension/INDEX.md`
- Current prototype extension: `KnowledgeBase-Copilot/mendix-extension/`

## Tech Stack

- **Extension:** C# / .NET 8.0, Mendix ExtensionsAPI v10.24+
- **Frontend:** React 18, TypeScript, Vite (bundled as static assets)
- **Communication:** WebView message bridge (`chrome.webview.postMessage` ↔ `PostMessageAsJsonAsync`)
- **AI Providers:** Claude CLI, Codex CLI (process spawning)
- **Model Operations:** Mendix mx CLI

## Key Design Decisions

1. **No MCP, no IModel API** — all Mendix model operations go through the mx CLI.
2. **WebView message bridge** — replaces HTTP/WebSocket transport with in-process messaging.
3. **Three tabs in one pane** — Copilot, Creator, and Developer share a single dockable pane.
4. **Marketplace-ready** — designed for public distribution via the Mendix Marketplace.

## Development Prompts

Extension rewrite track: `.app-info/development/prompts/extension/INDEX.md` (phases 01–07)

## Improvement Notes

- Supersedes the current `KnowledgeBase-Copilot` Node.js architecture.
- The existing TypeScript Copilot prompts (`.app-info/development/prompts/copilot/`) serve as reference for the C# port.
