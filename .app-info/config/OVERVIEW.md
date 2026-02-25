# config/
## Application Configuration Context

This folder stores contextual information about this application's configuration, environment, and tooling.

## What Belongs Here

- Technology stack summary (languages, frameworks, platforms, versions).
- Environment configuration notes (local dev setup, required env variables).
- Tool version requirements (SDK versions, IDE versions, extension dependencies).
- Integration endpoints or service context that agents need to understand the system.

## What Does Not Belong Here

- Actual secrets or credentials — never store these here.
- Live configuration files — those belong in the repository root.
- Session-specific state — use `memory/` for that.

## Suggested Files

Create files as needed. Suggested names:
- `STACK.md` — technology stack and versions.
- `ENVIRONMENT.md` — local dev setup, env variables, tooling notes.
- `INTEGRATIONS.md` — external services, APIs, SDKs this app depends on.
