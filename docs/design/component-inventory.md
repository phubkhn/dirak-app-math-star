# Component Inventory

Status: full prototype built (DES-01 through DES-11). "Built" below means present and click-tested in `prototype/`.

| Component | Required states | Status |
|---|---|---|
| PrimaryButton | default, pressed, focused, disabled | Built (default/pressed/focused; disabled state used on keypad keys) |
| IconButton | default, pressed, focused, muted/on where relevant | Built (sound mute/on, pause, speaker, exit, keypad delete, map back, adult close) |
| HoldGesture (adult corner) | idle, holding (0–100% ring), cancelled, completed | Built. 3s pointerdown hold with a conic-gradient progress ring (driven by `setInterval`, not `requestAnimationFrame` — see `ui-spec.md` fix notes); release early cancels and resets to 0; completion opens DES-10. See `UIR-006` for the hold-vs-math-challenge decision. |
| LevelNode | locked, current, available, completed 0–3 stars | Built on DES-02. All 4 states verified: locked (🔒 + shake/toast on click), current/frontier (blue ring), available-not-completed, completed (leaf-green, 1–3 filled stars). |
| StarCounter | 0, one digit, two digits, three digits | Built (HUD star count on DES-04; also floors at 0 after a simulated collision) |
| QuizProgress | question 1–10, answered/current/upcoming | Built (10-dot bar: upcoming/current/answered) |
| AnswerField | empty, typing, correct, incorrect, revealed | Built, all 4 states verified by click-through |
| NumericKeypad | enabled, temporarily locked, submit enabled/disabled | Built. Locked during the correct-answer auto-advance and during the first-wrong-attempt auto-clear window (timer-cancellation bug fixed in the vertical-slice pass; kept working through this pass's changes). |
| FeedbackBand | correct, first retry, answer revealed | Built, fixed-height to avoid layout jump per DES-07 brief |
| ResultSummary | pass, retry | Both fully built. Pass = DES-08 (incl. last-level variant, UIR-020). Retry = DES-09, no longer a stand-in (disclaimer text removed this pass). |
| GameplayPlayfield (lanes/ship/obstacles/collectibles) | idle, lane-0/1/2, jumping, star collected/pending, obstacle hit | Built. Obstacles are now tappable to simulate a collision (UIR-021): coral flash + "-1 ★" + star-count decrement, floor 0. CSS-shape placeholders per `asset-manifest.csv`, not final art. |
| TutorialOverlay | step 1 (swipe), step 2 (tap), dismissed | Built — new component this pass. Shown once per the `hasPlayedTutorial` flag (UIR-018); traps focus via `inert` on background siblings. |
| PauseModal | open, resume, restart-prompt, restart-confirmed, to-map | Built, now with the restart confirmation sub-view required by `UI_DESIGN_BRIEF.md` DES-05 (UIR-022) — the vertical-slice pass reset immediately with no confirmation. |
| VolumeControl | music, effects, voice; 0–100% | Built on DES-10 (Cài đặt tab): 3 sliders with live percentage labels, defaults 45/70/80 from `design-tokens.json`. Not persisted across reloads (in-memory only, see `review-log.md`). |
| AdultStatCard | with data, "Chưa có dữ liệu" (no data yet) | Built — new component this pass. 5 cards: levels completed, overall/addition/subtraction/regrouping accuracy (first-attempt-only, UIR-024). |
| AdultTabs | Tiến độ (active/inactive), Cài đặt (active/inactive) | Built — new component this pass. |
| ConfirmationModal | restart level, abandon quiz, reset progress | All 3 built and click-tested: restart-level (DES-05), abandon-quiz (Tiếp tục làm bài / Về bản đồ), reset-progress (Xóa tiến độ / Hủy). |
| DataFallbackScreen | loading/spinner, (auto-)recovered | Built — new component this pass (DES-11). Only reachable via the DES-10 QA tool (UIR-023), since the prototype has no real file I/O to fail. |
| Toast/Announcement | unlocked, saved, data restored, locked-node feedback | Built: locked-level-node toast, reset-progress toast, speaker-unsupported fallback toast, DES-11 recovery-announcement toast. Repositioned this pass to sit below the top bar/HUD instead of bottom-center, after it was found overlapping the quiz keypad (see `ui-spec.md` fix notes). |
