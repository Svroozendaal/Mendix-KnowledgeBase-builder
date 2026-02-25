# DEPLOYMENT — App Extension
## Extends: `.agents/agents/DEPLOYMENT.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Branch Policy [OVERRIDE]

| Branch | Role |
|---|---|
| `development` | Working branch — fast iteration, exploration, tooling, docs. May include `/developer/` and other non-plugin artefacts. |
| `docs` | Documentation branch — holds docs including `/developer/`. Must **not** be merged into `staging`/`main`. Contains no runtime source files (PHP/JS/CSS). |
| `staging` | Validation branch — plugin-only (no `/developer/`). CI runs here. |
| `main` | Production branch — plugin-only. No direct pushes; only via merge from `staging`. |

Standard flow: `development` → PR into `staging` (plugin changes) / PR into `docs` (documentation). Then: `staging` → validated on Cloudways staging + green CI → PR into `main`.

## Mandatory Behaviour (App-specific)

11. Never let `/developer/` or other non-plugin content into `staging` or `main`.
12. The docs branch must contain only allowlisted paths: `AGENTS.md`, `developer/**/*.MD`, `core/**/info_*.MD`, `templates/info_*.MD`, `templates/*/info_*.MD`.
13. Before staging → main: verify the `chore: bump js-loader script versions` commit from CI is included if JS files were changed.
14. Use the documentation consistency check (DOCUMENTER) before committing changes that affect user-facing behaviour.

## CI/CD Workflows

- `.github/workflows/build-plugin.yml` — "Build Wellbased Plugin": triggers on push to `staging`; builds Tailwind, bumps JS cache versions, packages plugin zip.
- `.github/workflows/merge-staging-to-codex.yml` — "Merge staging into codex": merges `origin/staging` into `codex/set-up-environment-for-github-code-access` on push to `staging`.

## Versioning

- JS cache-busting versions in `js-loader.php` are patch-bumped automatically by CI on `staging`.
- Plugin version in `wellbased.php` — versioning policy is a TODO; confirm before bumping.
