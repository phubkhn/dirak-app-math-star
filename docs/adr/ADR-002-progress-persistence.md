# ADR-002: Local progress persistence

## Status

Accepted (2026-07-30).

## Context

FR-07 / NFR-07 require progress (unlocked levels, stars, accuracy stats) to autosave after every level and every quiz gate, and to recover safely if the save file is missing or corrupt, without ever blocking startup. This is implemented in `godot-project/scripts/services/ProgressService.gd`.

## Decision

- Single JSON file at `user://progress.json` (Godot's per-app persistent data directory — `/data/data/<package>/files/` on Android).
- A `schema_version` field is stored and checked on load; a missing file, an unparsable file, or a file without `schema_version` all fall back to fresh defaults rather than crashing or blocking startup (NFR-07).
- Fields persisted: `unlocked_up_to`, `stars` (per level, 0–3), `has_played_tutorial`, `stats` (first-attempt-only addition/subtraction/regrouping counters — see the design prototype's `UIR-009`/`UIR-024` decisions, which this mirrors), `volumes`, `sound_enabled`.
- Saves happen synchronously and immediately after each state-changing action (level pass, each first-attempt quiz answer, volume change, reset) rather than on a timer, matching "tự lưu sau mỗi màn và mỗi bộ câu hỏi."
- "Xóa tiến độ" (Adult Area) calls `reset_all_progress()`, which fully overwrites the save file with fresh defaults — used only after the explicit two-step confirmation already implemented in the DES-10 screen.

## Consequences

- No cloud sync, no account system — matches APP_SPEC's explicit Phase 1 scope (offline-only, no account).
- If a future schema change is needed, `schema_version` gives a place to add a migration path; none exists yet since this is schema v1.
