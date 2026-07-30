# ADR-003: Audio strategy

## Status

Accepted (2026-07-30). Infrastructure only — no audio assets shipped yet.

## Context

`APP_SPEC.md` §5.6 specifies three independent volume buses (Nhạc/Hiệu ứng/Giọng nói), ducking behavior during voice playback, and a defined set of BGM/SFX/voice cues. `docs/design/asset-manifest.csv` records every `AUD-*` row as `planned` — no licensed audio files exist in this repository. `CLAUDE.md` explicitly forbids using unlicensed internet audio without a recorded source and license, and building/production code is not permitted to fabricate that licensing itself.

## Decision

Implement the **real bus/volume/ducking architecture** now (`godot-project/scripts/services/AudioService.gd`), so it is ready to receive licensed assets later without further engineering work, while every actual playback call (`play_sfx`, `play_bgm`, `play_voice`) is a **safe no-op** until real `.ogg` files are added under `assets/audio/{bgm,sfx,voice}/` and wired into those functions.

Concretely, this build already does:

- Creates and manages three real `AudioServer` buses (Music, SFX, Voice), each routed to Master.
- Applies persisted volume percentages from `ProgressService` on startup and whenever changed in the Adult Area (DES-10).
- Implements the documented ducking behavior (`duck_music_for()`: -10dB during voice, restored over 300ms) as a ready-to-use method, even though nothing calls it yet (no voice clips exist to trigger it).
- Speaker/read-aloud in the Quiz Gate (DES-06) uses Godot's native `DisplayServer.tts_speak()` (Android system TTS) rather than a stub — this is a real, working feature since it doesn't depend on licensed audio assets, consistent with `APP_SPEC.md`'s note that Android TTS may be used for reading equations aloud when available.

## Consequences

- The app currently ships **silent** for BGM/SFX/recorded voice lines (AUD-VO-01 through 06) — this is a known, deliberate gap, not a bug.
- Before a real release, someone must source/record licensed audio per `docs/licenses/audio/` (not yet created) and wire each cue into `AudioService`'s no-op methods — this is tracked as follow-up work, not attempted in this session per the "don't use unlicensed audio" constraint.
