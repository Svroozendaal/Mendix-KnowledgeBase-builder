# PROMPT 07: Question Classifier — Fast-Path Routing for Simple Queries

## Priority

High — directly reduces token consumption and response latency for the majority of user questions.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/copilot/INDEX.md`
4. `KnowledgeBase-Copilot/backend/src/services/system-prompt/index.ts` — current system prompt with the search-first navigation strategy.
5. `KnowledgeBase-Copilot/backend/src/services/conversation/index.ts` — current conversation service with tool-use loop.
6. `KnowledgeBase-Copilot/backend/src/services/kb-navigator/index.ts` — KB file access and search tools.
7. A generated KB at `mendix-data/knowledge-base/` — examine its structure to understand what kinds of questions map to what files.

## Problem Statement

Currently, all user questions go through the same AI model with the same system prompt and the same tool budget (up to 8 tool-loop iterations). A simple lookup question like "What XPath does User Story 2 use?" consumes the same resources as "Explain the full security model of the app."

The copilot needs a **question classification layer** that detects simple, direct-lookup questions and routes them through a lighter, faster path — either by constraining the AI's behavior or by pre-fetching the likely answer files before the AI even starts.

## Design Goals

1. **Reduce tool calls for simple questions from 6–8 down to 1–3.**
2. **No false negatives** — if the classifier is unsure, fall back to the full navigation path. It's better to be slow than wrong.
3. **Zero extra latency for complex questions** — classification should be near-instant (regex/heuristic, not an extra LLM call).
4. **Transparent** — the user should not notice the classifier; it just makes the copilot faster.

## Deliverable

### 1. Question Classifier Service (`backend/src/services/question-classifier/index.ts`)

A lightweight, rule-based classifier that categorizes incoming questions before they reach the AI.

**Categories:**

| Category | Description | Example Questions |
|---|---|---|
| `direct-entity` | Names a specific entity | "What attributes does TraineeLocation have?" |
| `direct-page` | Names a specific page | "What data sources are on Trainee_XPaths?" |
| `direct-flow` | Names a specific microflow/nanoflow | "What does ACT_GetTrainees do?" |
| `direct-artifact` | Names a user story, answer page, or other artifact | "How do I solve User Story 2?" |
| `architecture` | Broad app-level question | "What does this app do?", "How are modules connected?" |
| `comparison` | Compares or spans multiple artifacts | "What's the difference between Location and Trainee?" |
| `unknown` | Cannot classify with confidence | Anything else |

**Detection rules (heuristics, not LLM):**

- Extract named artifacts using regex patterns against KB structure:
  - Entity names: match against entity list from ROUTING.md or module READMEs (pre-loaded in seed context).
  - Page names: match against page list.
  - Flow names: match against flow list.
  - User story patterns: `US\d+`, `user story \d+`, `story \d+` (case-insensitive).
- If a named artifact is found → classify as the matching `direct-*` category.
- If keywords like "architecture", "overview", "security", "modules", "how does the app" are found → `architecture`.
- If multiple distinct artifact names are found → `comparison`.
- Otherwise → `unknown`.

**Interface:**

```typescript
interface ClassificationResult {
  category: 'direct-entity' | 'direct-page' | 'direct-flow' | 'direct-artifact' | 'architecture' | 'comparison' | 'unknown';
  /** Artifact names extracted from the question (e.g. ["TraineeLocation", "US2"]) */
  detectedArtifacts: string[];
  /** Suggested search queries to pre-run (e.g. ["TraineeLocation", "US2_Answer"]) */
  suggestedSearches: string[];
  /** Confidence: high if a clear artifact name was matched, low otherwise */
  confidence: 'high' | 'low';
}

export class QuestionClassifier {
  constructor(private kbRoot: string) {}

  /** Build the artifact index from the seeded KB context (ROUTING.md, module READMEs). */
  async initialize(): Promise<void>;

  /** Classify a user question. */
  classify(question: string): ClassificationResult;
}
```

### 2. Context Pre-fetch (`backend/src/services/conversation/index.ts`)

When the classifier returns a `direct-*` category with high confidence, **pre-fetch** the likely answer files and inject them into the conversation context before the AI's first turn.

**Approach:**

- After classifying the question, run `search_content` for each `suggestedSearches` entry.
- Read the top result file(s) (max 2 files, using the existing KBNavigator).
- Inject these as a synthetic assistant message (similar to the existing KB context seeding):
  ```
  I found the following relevant KB files for your question:

  --- modules/MyFirstModule/pages/US2_Answer.md ---
  [file content]
  ```
- The AI then sees the answer context immediately and can respond without any tool calls — or with 1 verification call at most.

**Implementation in ConversationService.processMessage:**

```typescript
// After seedKbContext, before entering the tool loop:
const classification = classifier.classify(userMessage);
if (classification.confidence === 'high' && classification.category.startsWith('direct-')) {
  const prefetchedContext = await this.prefetchContext(kbRoot, classification);
  if (prefetchedContext) {
    conversation.messages.push(...prefetchedContext);
  }
}
```

### 3. Adaptive System Prompt Hints

When a question is classified, add a one-line hint to the system prompt context (not a permanent change — injected per-turn):

- For `direct-*`: `"Hint: The user is asking about a specific artifact. Relevant KB content has been pre-loaded. Check it before using tools."`
- For `architecture`: `"Hint: This is a broad architecture question. Start from APP_OVERVIEW.md or MODULE_LANDSCAPE.md."`
- For `unknown`: No hint — use default navigation strategy.

### 4. Artifact Index Cache

The classifier needs an index of known artifact names to match against. This should be built once per conversation (or per KB root) and cached:

- Parse entity names, page names, and flow names from the seeded ROUTING.md content.
- Optionally, on first use, scan module README files for entity/page/flow lists.
- Store as simple `Set<string>` lookups: `entityNames`, `pageNames`, `flowNames`.

## Exit Criteria

1. `QuestionClassifier` service exists with the interface above.
2. For a question like "What XPath does User Story 2 use?", the classifier returns `{ category: 'direct-artifact', detectedArtifacts: ['US2'], suggestedSearches: ['US2'], confidence: 'high' }`.
3. Pre-fetched context is injected and the AI answers in 0–1 tool calls instead of 6–8.
4. For broad questions like "What does this app do?", the classifier returns `{ category: 'architecture', confidence: 'high' }` and no pre-fetch occurs — the AI follows the normal navigation path.
5. `npm run build` passes.
6. Manual test: ask the same "User Story 2" question and verify reduced tool calls in the copilot log.

## Out of Scope

- LLM-based classification (keep it heuristic for speed).
- Caching answer results across conversations.
- Changing the KB structure itself.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Classifier matches wrong artifact | Use exact name matching from KB index, not fuzzy. Fall back to `unknown` when ambiguous. |
| Pre-fetched content is wrong file | Only pre-fetch when confidence is `high`. AI can still use tools to verify. |
| Adds latency for complex questions | Classification is regex-based (~1ms). Pre-fetch is skipped for non-direct categories. |
| KB artifact names change between KBs | Index is rebuilt per-conversation from the actual KB content. |
