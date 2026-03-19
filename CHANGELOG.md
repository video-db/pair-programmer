# Changelog

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
