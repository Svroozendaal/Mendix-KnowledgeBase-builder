# SKILL: memory-compaction

## Purpose

Compact live memory files in `.app-info/memory/` by summarising old entries into a digest and archiving raw detail, keeping the live files short and scannable.

## When to Use

- A memory file has grown beyond approximately 200 lines.
- A new development phase or milestone has been reached and old session detail is no longer actively needed.
- The Memory agent or any other agent notices that memory files are becoming unwieldy.
- The user explicitly requests memory cleanup.

**Important:** Always ask the user before compacting. Never compact automatically.

## Procedure

1. **Read** the target memory file in `.app-info/memory/`.
2. **Identify** entries that are no longer actively relevant — typically entries older than the current development phase or milestone.
3. **Produce a digest section** at the top of the file:
   - Summarise key decisions, outcomes, and active blockers from the old entries.
   - Use the heading `## DIGEST — [date range]`.
   - Keep the digest concise (10–30 lines maximum).
4. **Move raw entries** to an archive file:
   - Create `.app-info/memory/_archive/` if it does not exist.
   - Archive file name: `[MEMORY_FILE]_archive_[date].md` (e.g. `DECISIONS_LOG_archive_2025-06.md`).
   - Copy the raw entries verbatim into the archive file.
5. **Remove the archived entries** from the live file, leaving only the digest and any still-active entries.
6. **Verify** that no active blockers, open items, or in-progress entries were archived — these must remain in the live file.

## Output / Expected Result

After compaction:

- The live memory file contains a digest section and only active/recent entries.
- An archive file exists in `.app-info/memory/_archive/` with the full raw entries.
- No information has been lost — it has been summarised and archived, not deleted.

## Notes

- Never compact `SESSION_STATE.md` entries that have `STATUS: BLOCKED` or `STATUS: NEEDS_INPUT` — these are still active.
- If unsure whether an entry is still relevant, keep it in the live file and flag it for the user.
- This skill can be applied to any of the six canonical memory files: `SESSION_STATE.md`, `DECISIONS_LOG.md`, `PROGRESS.md`, `REVIEW_NOTES.md`, `PROMPT_CHANGES.md`, `INCIDENTS.md`.
