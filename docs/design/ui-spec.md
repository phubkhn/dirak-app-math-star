# UI Specification

Status: vertical prototype (DES-01, DES-04, DES-06, DES-08 built and verified in `prototype/`). Canonical behavior source is `APP_SPEC.md`, `UI_DESIGN_BRIEF.md` and `screen-flow.md`; this file documents how the prototype implements that behavior. See `docs/design/review-log.md` for open decisions (`UIR-*`) referenced below.

Do not copy raw CSS values here when a named token already exists in `design-tokens.json`; reference the token name instead.

## DES-01 — Menu (`#screen-menu`)

**Layout.** Centered content column: mascot, title, subtitle, primary `Chơi` button. Sound icon button fixed top-right (`safe-x`/`safe-y` inset). Adult-corner control fixed bottom-right, same inset. Decorative sky layer (clouds, kite) is `aria-hidden` and non-interactive.

**Components.** `PrimaryButton` (Chơi), `IconButton` (sound), a dedicated hold-gesture control (adult corner) not yet in `component-inventory.md` as a named component — see addition below.

**State transitions.**
- `Chơi` → resets gameplay state (lane, star count) → DES-04.
- Sound icon toggles `aria-pressed`; swaps 🔊/🔇 glyph. Not persisted between sessions in this slice (no `localStorage`); production `AudioService` will persist per FR-09/FR-11.
- Adult corner: `pointerdown` starts a 3000 ms hold, rendered as a conic-gradient ring filling clockwise (`--hold-pct` custom property). Release before completion cancels and resets the ring to 0 with no side effect. On completion, shows a toast: "Góc người lớn sẽ có trong bản dựng tiếp theo (DES-10)." — DES-10 itself is out of scope this pass (UIR-011). Decision on hold-only vs hold-or-math-challenge is UIR-006.

**Responsive.** Title font steps up at the tablet breakpoint (`≥1100px` width) per a small media query; all other sizing is safe-area/flex-based and identical between phone and tablet.

**Audio (documented, not implemented).** `AUD-SFX-01 ui_tap` on button presses; `AUD-BGM-01` as menu loop. Not wired in the web prototype — real playback requires licensed OGG assets handled by Godot's `AudioService` (see `APP_SPEC.md` §5.6).

## DES-04 — Gameplay HUD (`#screen-gameplay`)

**Layout.** Full-bleed playfield with no surrounding card, matching the brief. HUD sits above the playfield: star counter (left), pause icon button (right), both within the token HUD height (`hud_phone`/`hud_tablet`). Below the playfield: lane-change buttons (◀ jump ▶) and a persistent `Vào Cổng Toán Học` primary button that stands in for "level complete" in this slice (no timed 60–90s run is simulated; see UIR-011 scope note).

**Runner representation.** Three CSS lane columns with a ship (rounded rectangle, `--lane` position transition), static obstacle shapes (rock/cloud, decorative only, not collidable in this slice) and tappable star collectibles. This is intentionally a UI/interaction stand-in, not the production physics runner — per `CLAUDE.md`, gameplay logic itself is out of scope for the web prototype.

**Interactions verified.**
- Lane left/right buttons and `ArrowLeft`/`ArrowRight` keys move the ship between the 3 lanes (clamped).
- Jump button / `ArrowUp` / `Space` briefly raises the ship (`is-jumping`, 420 ms) over the obstacle row.
- Tapping an uncollected star increments the HUD star counter and hides the star (`data-collected`).
- Pause icon opens a modal (see below); `Vào Cổng Toán Học` navigates to DES-06.

**Pause (light stand-in for DES-05).** Dims the playfield and shows a modal with `Tiếp tục` (close), `Chơi lại` (resets lane/star state), `Về bản đồ` (returns to DES-01). This is a minimal, clearly-scoped stand-in — the full DES-05 states (e.g. confirmation nuance) are not built this pass (UIR-011).

**Mascot.** Not rendered on this screen by design (UIR-007) — keeps the playfield uncluttered per the DES-04 brief ("no card around the game").

## DES-06 — Cổng Toán Học (`#screen-quiz`) + inline DES-07 feedback

Built as one screen because DES-07's feedback states are intrinsic to the quiz gate loop — a click-through of "answer a question" cannot be demonstrated without them.

**Layout.** Top bar: exit (✕) icon, `QuizProgress` (10 segment dots), `Câu n/10` counter — all within HUD height. Body: equation (largest text on screen, `size-equation-phone`/`tablet`), speaker icon beside it, `AnswerField`, a fixed-height `FeedbackBand` (prevents layout jump per DES-07 brief), then the numeric keypad pinned toward the bottom.

**Question source.** 10 fixed sample questions drawn from `docs/design/question-samples.json` (5 addition + 5 subtraction, mixed difficulty/regrouping), shuffled per-session with Fisher–Yates and reshuffled if the shuffle produces more than 3 consecutive `requires_regrouping` questions, mirroring the production rule in `APP_SPEC.md` §4.3. This is illustrative sample data only — the canonical 200-question bank (`questions.math.vi.json`) is untouched.

**Answer flow / states.**
1. Digits 0–9 (max 3 digits, since range is 0–100) build `AnswerField`; delete removes the last digit; `Trả lời` submits.
2. **Correct:** `answer-field.is-correct`, `FeedbackBand` shows a check icon + one of the three approved phrases (Chính xác! / Giỏi lắm! / Tuyệt vời!), keypad locks briefly, auto-advances after 900 ms.
3. **First wrong attempt:** `answer-field.is-incorrect`, `FeedbackBand` shows "Con thử lại nhé.", keypad locks for 1100 ms while the field clears, then re-enables for a second attempt. (Keypad-lock + timer-cancellation bug found and fixed during this pass — see review notes below.)
4. **Second wrong attempt:** equation is revealed with the correct answer plus the question's `hint`, keypad stays locked, submit button relabels to `Tiếp tục` to advance.

**Scoring rule (UIR-009).** Only first-attempt-correct answers count toward the 8/10 pass threshold. A second-attempt-correct still lets the child continue (never blocked) but is logged to the "cần xem lại" list. This interpretation is a logged assumption, not an explicit spec statement — flagged for owner confirmation.

**Exit.** ✕ opens a confirmation modal ("Thoát Cổng Toán Học?" / Tiếp tục làm bài / Về bản đồ) per the Back-button semantics in `screen-flow.md`.

**Speaker button.** Attempts `window.speechSynthesis` with a `vi-VN` utterance; if unsupported, shows a toast and does nothing else. No network request either way.

## DES-08 — Pass result (`#screen-result-pass`, pass branch)

Shown when first-attempt score ≥ 8/10. Displays score, a 3-star bar (mapping: 8→1★, 9→2★, 10→3★ — UIR-010 assumption), a next-destination teaser box, and the single primary action `Sang màn mới`. In this slice (no DES-02 map yet) that action returns to the menu; production will route to `LevelMap` with the next node unlocked.

### Retry stand-in (score < 8/10, not a DES-09 build)

To keep every click path in the prototype functional, a score under 8 shows a clearly-labeled minimal screen: "Con sắp mở được rồi!", score, up to 3 review items (equations answered wrong on the first attempt), `Thử lại` (restarts the quiz) and `Về bản đồ`. The score number uses ink navy (not the pass screen's success green) so it doesn't visually read as "passed." This is explicitly not the full DES-09 build (UIR-011) — full retry-result design (e.g. concept grouping, richer encouragement copy) is scoped for the next expansion pass.

## Verified issues fixed during this pass

- **Modal `hidden` attribute losing to CSS** — `.modal-backdrop { display: flex }` beat the browser's default `[hidden] { display:none }` UA rule, so the pause and quiz-exit modals rendered open on load. Fixed by adding an explicit `.modal-backdrop[hidden] { display: none }` rule.
- **Stray retry-clear timer** — a wrong-then-wrong answer in quick succession could have its "reveal" state wiped a moment later by the first attempt's un-cancelled auto-clear timeout. Fixed by disabling the keypad during the auto-clear window and cancelling the timer on every new submission / question load.
- **Initial star/ship overlap** — the lane-1 star collectible's default vertical position visually collided with the ship's resting position. Moved the collectible higher in the lane.

## Not built this pass

DES-02 (map), DES-03 (tutorial), full DES-05 (pause), full DES-09 (retry result), DES-10 (adult area), DES-11 (data fallback). See `review-log.md` §"Prototype scope note" for what stands in for them today.
