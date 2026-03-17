# PROMPT 06: Tabbed UI, Integration Testing, and Polish

## Priority

High — final integration phase before marketplace preparation.

## Context

Read before starting:

1. `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` — full requirements spec.
2. Phase 01–05 output — all extension services and UI tabs.
3. `KnowledgeBase-Copilot/frontend/src/` — current React frontend structure.

## Problem Statement

The three feature tabs (Copilot, Creator, Developer) have been built independently. This phase integrates them into a cohesive tabbed UI, performs cross-feature testing, and polishes the extension for production use.

## Deliverable

### 1. Tabbed Navigation

Implement a tab bar at the top of the SPA:

```tsx
function App() {
  const [activeTab, setActiveTab] = useState<'copilot' | 'creator' | 'developer'>('copilot');

  return (
    <div className="app">
      <TabBar active={activeTab} onChange={setActiveTab} />
      <div className="tab-content">
        {activeTab === 'copilot' && <CopilotTab />}
        {activeTab === 'creator' && <CreatorTab />}
        {activeTab === 'developer' && <DeveloperTab />}
      </div>
    </div>
  );
}
```

**Tab bar design:**
- Compact, minimal chrome (extension pane has limited height).
- Active tab indicator (underline or highlight).
- Tab labels: "Copilot", "Creator", "Developer".
- Tab state persisted across pane close/reopen (via config).

### 2. Cross-Feature Integration

**Copilot + Creator:**
- After KB generation (Creator tab), the Copilot tab auto-detects the new KB root.
- Copilot conversations reference the most recently generated KB.
- "Generate KB" action available as a Copilot suggestion when no KB exists.

**Copilot + Developer:**
- AI-assisted mode in Developer tab routes to the Copilot conversation with mx tools enabled.
- Copilot can suggest mx CLI commands during regular KB Q&A (e.g., "I see the entity is missing an attribute. Want me to create it?").

**Creator + Developer:**
- After creating entities/microflows via Developer tab, suggest re-running KB validation to update the knowledge base.

### 3. Error Handling and UX

- **Connection status indicator:** Show whether the message bridge / backend is connected.
- **Loading states:** Skeleton screens or spinners for async operations.
- **Error boundaries:** React error boundaries per tab (one tab crashing doesn't break others).
- **Empty states:** Helpful messages when no KB exists, no conversations, CLI not found.
- **Settings panel:** Accessible from all tabs. AI provider selection, KB root override, mx CLI path.

### 4. Performance

- **Lazy loading:** Only load tab content when the tab is first activated.
- **Message deduplication:** Ignore duplicate message bridge responses.
- **Debounced search:** KB search in Copilot and Creator tabs debounced at 300ms.
- **Virtual scrolling:** For conversation list and log output panels.

### 5. Accessibility

- Keyboard navigation between tabs (arrow keys).
- Focus management when switching tabs.
- ARIA labels on interactive elements.
- High contrast support (respect Studio Pro theme if possible).

### 6. Integration Test Scenarios

| # | Scenario | Steps | Expected |
|---|---|---|---|
| 1 | Fresh start — no KB | Open extension. Creator tab. Run full pipeline. Switch to Copilot. Ask a question. | Pipeline succeeds. Copilot answers from generated KB. |
| 2 | Existing KB — chat | Open extension. Copilot tab. Ask "What entities exist?" | AI navigates KB, lists entities. |
| 3 | Direct lookup | Ask "What attributes does [entity] have?" | Classifier pre-fetches. AI answers in 0–1 tool calls. |
| 4 | Architecture question | Ask "What does this app do?" | AI follows L0→L1→L2 navigation. |
| 5 | mx CLI — create entity | Developer tab. Create entity form. Execute. | Entity created. Success message. |
| 6 | AI-assisted creation | Developer tab. AI mode. "Create entity Invoice with Amount, Date." | Copilot generates and executes mx CLI command. |
| 7 | KB regeneration | Change app in Studio Pro. Creator tab. Re-run pipeline. Copilot reflects changes. | Updated KB content in Copilot. |
| 8 | Config persistence | Change AI provider. Close pane. Reopen. | Setting persisted. |
| 9 | Conversation persistence | Have a conversation. Close pane. Reopen. Load conversation. | Full history restored. |
| 10 | Error recovery | Disconnect CLI. Send message. Reconnect. Retry. | Error shown. Retry works. |

## Exit Criteria

1. All three tabs work in a single cohesive UI.
2. Tab switching is instant (no full reload).
3. Cross-feature workflows (listed above) work end-to-end.
4. Settings panel accessible and functional.
5. Error states handled gracefully (no crashes).
6. All 10 integration test scenarios pass.
7. `dotnet build` and `npm run build` succeed.
8. Extension loads and runs in Studio Pro 10.24+.

## Out of Scope

- Marketplace submission (Phase 07).
- Automated test suite (future improvement).
- Multi-language support / i18n.
