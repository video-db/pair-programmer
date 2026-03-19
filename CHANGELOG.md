# Changelog

## 0.2.3

- Add `/pair-programmer act` command — find a spoken instruction from the mic transcript and execute it
- Rewrite README: merge Install + Setup + Quick start into a single Quickstart flow
- Use `npx skills add` as primary install method, move marketplace install to bottom
- Add agent-neutral note about command prefixes (`/` for Claude Code, `$` for Codex, etc.)
- Rename marketplace to `videodb` to avoid `pair-programmer:pair-programmer` double namespace
- Use `strict: false` with explicit skills reference in marketplace.json
- Remove standalone plugin.json (marketplace.json is the full definition)

## 0.2.2

- Flatten directory structure for better skills.sh discovery (Phase 2 vs Phase 3 fallback)
- Promote plugin root to repo root — remove unnecessary `plugins/` nesting
- Keep marketplace.json for Claude Code `/plugin install` compatibility
- Fix plugin.json repository URL (was pointing to wrong repo)
- Sync versions across plugin.json, marketplace.json, and CHANGELOG

## 0.2.1

- Use binary's display channels as source of truth for picker — no more name-matching failures across platforms
- Electron display info (dimensions, thumbnails) now enriches binary channels as best-effort
- Skip non-final transcript events from JSONL logs to reduce noise
