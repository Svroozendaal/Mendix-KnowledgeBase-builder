# Claude Code â€” Bootstrap

Before executing any task in this repository, read the following files in order:

1. `.agents/AGENTS.md` â€” governance, agent roster, and orchestration logic.
2. `.agents/FRAMEWORK.md` â€” dual-folder operating model.
3. `.app-info/ROUTING.md` â€” app-specific content navigation.

These files define how you should operate. Follow them.

## About This Repository

This is the **Mendix KnowledgeBase Builder** â€” a pipeline that converts Mendix application model exports into AI-navigable knowledge bases.

### Key entry points

- **Portable KB creator package**: `KnowledgeBase-Creator/`
- **Run full creation bootstrap**: `KnowledgeBase-Creator/run-dump-parser.ps1`
- **AI start file**: `KnowledgeBase-Creator/agents.md`
- **Understand a generated KB**: read `READER.md` inside `KnowledgeBase-Creator/mendix-data/knowledge-base/<app>/`

