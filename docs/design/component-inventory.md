# Component Inventory

Status: vertical prototype built (DES-01, DES-04, DES-06, DES-08). "Built" below means present and click-tested in `prototype/`; components/states not yet needed by those four screens remain planned only.

| Component | Required states | Status this pass |
|---|---|---|
| PrimaryButton | default, pressed, focused, disabled | Built (default/pressed/focused; disabled not yet needed) |
| IconButton | default, pressed, focused, muted/on where relevant | Built (sound mute/on, pause, speaker, exit, keypad delete) |
| HoldGesture (adult corner) | idle, holding (0–100% ring), cancelled, completed | Built — new component this pass, not previously listed. 3s pointerdown hold with a conic-gradient progress ring; release early cancels and resets to 0; completion shows a toast (destination screen DES-10 not built yet). See `UIR-006` for the hold-vs-math-challenge decision. |
| LevelNode | locked, current, available, completed 0–3 stars | Not built (DES-02 out of scope this pass) |
| StarCounter | 0, one digit, two digits, three digits | Built (HUD star count on DES-04, increments 0→1→2 in the sample playfield) |
| QuizProgress | question 1–10, answered/current/upcoming | Built (10-dot bar: upcoming/current/answered) |
| AnswerField | empty, typing, correct, incorrect, revealed | Built, all 4 states verified by click-through |
| NumericKeypad | enabled, temporarily locked, submit enabled/disabled | Built. Locked both during the correct-answer auto-advance and during the first-wrong-attempt auto-clear window (fixed a bug this pass where the lock/timer wasn't cancelled correctly — see `ui-spec.md`) |
| FeedbackBand | correct, first retry, answer revealed | Built, fixed-height to avoid layout jump per DES-07 brief |
| ResultSummary | pass, retry | Pass built (DES-08). Retry is a minimal, explicitly-labeled stand-in, not the full DES-09 design — see `ui-spec.md` |
| GameplayPlayfield (lanes/ship/obstacles/collectibles) | idle, lane-0/1/2, jumping, star collected/pending | Built — new component this pass, not previously listed. CSS-shape placeholders per `asset-manifest.csv`, not final art |
| PauseModal | open, resume, restart, to-map | Built as a light stand-in for DES-05 on the gameplay screen only; full DES-05 states not built this pass |
| VolumeControl | music, effects, voice; 0–100% | Not built (DES-10 out of scope this pass) |
| ConfirmationModal | restart level, abandon quiz, reset progress | Abandon-quiz built and click-tested (Tiếp tục làm bài / Về bản đồ). Restart-level exists via the pause stand-in. Reset-progress not built (DES-10 out of scope) |
| Toast/Announcement | unlocked, saved, data restored | Built minimally: adult-corner completion and speaker-unsupported fallback use the same toast component |
