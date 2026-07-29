# UI Specification

Status: full prototype — DES-01 through DES-11 built and click-tested in `prototype/`. Canonical behavior source is `APP_SPEC.md`, `UI_DESIGN_BRIEF.md` and `screen-flow.md`; this file documents how the prototype implements that behavior. See `docs/design/review-log.md` for open decisions (`UIR-*`) referenced below.

Do not copy raw CSS values here when a named token already exists in `design-tokens.json`; reference the token name instead.

## DES-01 — Menu (`#screen-menu`)

**Layout.** Centered content column: mascot, title, subtitle, primary `Chơi` button. Sound icon button fixed top-right (`safe-x`/`safe-y` inset). Adult-corner control fixed bottom-right, same inset. Decorative sky layer (clouds, kite) is `aria-hidden` and non-interactive.

**Components.** `PrimaryButton` (Chơi), `IconButton` (sound), `HoldGesture` (adult corner — see `component-inventory.md`).

**State transitions.**
- `Chơi` → renders the map (`renderMap()`) → DES-02. (In the earlier vertical-slice pass this went straight to DES-04; now that DES-02 exists, Menu → Map → Level matches `screen-flow.md`.)
- Sound icon toggles `aria-pressed`; swaps 🔊/🔇 glyph. Not persisted between sessions (no `localStorage`); production `AudioService` will persist per FR-09/FR-11.
- Adult corner: `pointerdown` starts a 3000 ms hold (via `setInterval`, see fix notes below), rendered as a conic-gradient ring filling clockwise (`--hold-pct`). Release before completion cancels and resets the ring to 0. On completion, opens DES-10 (Adult Area) directly.

**Responsive.** Title font steps up at the tablet breakpoint (`≥1100px` width) per a small media query; all other sizing is safe-area/flex-based and identical between phone and tablet.

**Audio (documented, not implemented).** `AUD-SFX-01 ui_tap` on button presses; `AUD-BGM-01` as menu loop. Not wired in the web prototype — real playback requires licensed OGG assets handled by Godot's `AudioService` (see `APP_SPEC.md` §5.6).

## DES-02 — Level map (`#screen-map`)

**Layout.** Small top bar with a home/back icon (→ DES-01) and title. Below it, a single horizontal row of all 10 `LevelNode`s grouped into 4 theme bands (Bầu trời quê em / Đại dương vui nhộn / Khu rừng sắc màu / Vũ trụ ngôi sao) with a label above each group. All 10 nodes fit at both 960×540 and 1280×800 without horizontal scrolling.

**LevelNode states.** Locked (grey, 🔒, "—" instead of a star row) · current/frontier (blue ring — the next unlocked-but-not-yet-passed level) · completed (leaf-green fill, 1–3 filled stars). Clicking a locked node does not navigate; it shakes briefly and shows a toast, per `screen-flow.md`'s "Locked map nodes do not navigate; they provide lock feedback in place."

**Back navigation (UIR-019).** The home icon isn't drawn in `screen-flow.md` (only Menu→Map is), but some way back to the menu is necessary (e.g. to reach sound toggle or the adult corner) — added as a deliberate, transparent addition.

**Progress model.** Backed by an in-memory `progress` object (`unlockedUpTo`, `stars` per level) — not persisted to `localStorage`; see the review log's scope note.

## DES-03 — Tutorial overlay (inside `#screen-gameplay`)

**Trigger (UIR-018).** Shown only the first time Level 1 is ever entered (`progress.hasPlayedTutorial === false`), not on every replay — see the review log for why "lần đầu" (first-time) was read as a one-time gate rather than tied to every Level-1 visit.

**Layout.** A single centered card overlaid on the (dimmed, inert) gameplay screen — not a separate route, per the brief's "Overlay one instruction at a time over live-looking gameplay." Step 1: animated hand icon + "Vuốt sang trái hoặc sang phải để đổi làn." + `Tiếp theo`. Step 2: animated tap-ring + "Chạm để bay qua vật cản." + `Thử ngay`. Dismissing step 2 sets `hasPlayedTutorial = true` and hands control to DES-04.

**Accessibility.** While the overlay is open, every sibling element in `#screen-gameplay` (HUD, playfield, controls) is marked `inert` (see fix notes below) so keyboard/tab focus can't leak behind the overlay, and focus moves to the current step's button on each transition.

## DES-04 — Gameplay HUD (`#screen-gameplay`)

**Layout.** Full-bleed playfield with no surrounding card. HUD sits above the playfield: star counter (left), pause icon button (right), both within the token HUD height (`hud_phone`/`hud_tablet`). Below the playfield: lane-change buttons (◀ jump ▶) and a persistent `Vào Cổng Toán Học` primary button that stands in for "level complete" (no timed 60–90s run is simulated — see the review log's scope note).

**Runner representation.** Three CSS lane columns with a ship (rounded rectangle, `--lane` position transition), obstacle shapes (rock/cloud) and tappable star collectibles. This is intentionally a UI/interaction stand-in, not the production physics runner — per `CLAUDE.md`, gameplay logic itself is out of scope for the web prototype.

**Interactions verified.**
- Lane left/right buttons and `ArrowLeft`/`ArrowRight` keys move the ship between the 3 lanes (clamped); disabled while the tutorial overlay is open.
- Jump button / `ArrowUp` / `Space` briefly raises the ship (`is-jumping`, 420 ms) over the obstacle row.
- Tapping an uncollected star increments the HUD star counter and hides the star (`data-collected`).
- **Collision feedback (UIR-021).** Tapping an obstacle simulates a soft collision: a brief coral outline pulse on the obstacle plus a "-1 ★" flash near the ship, and the HUD star count decrements (floor 0). This is a UI stand-in for real collision physics, added this pass because both `APP_SPEC.md` §3.1 and the DES-04 brief require collision feedback as a state, and it was decorative-only in the earlier vertical slice.
- Pause icon opens the DES-05 modal; `Vào Cổng Toán Học` navigates to DES-06.

**Mascot.** Not rendered on this screen by design (UIR-007) — keeps the playfield uncluttered per the DES-04 brief ("no card around the game").

## DES-05 — Pause (modal inside `#screen-gameplay`)

**Layout.** Dims the playfield and shows a modal with `Tiếp tục` (close), `Chơi lại` (restart), `Về bản đồ` (→ DES-02).

**Restart confirmation (UIR-022).** Clicking `Chơi lại` swaps the modal to a single confirmation sub-view ("Chơi lại từ đầu màn này?" / Đồng ý, chơi lại / Hủy) before actually resetting lane and star state — per the brief's explicit "Restart requires one confirmation only because no permanent progress is lost." The earlier vertical-slice pass reset immediately with no confirmation; this pass corrects that.

**Accessibility.** Background siblings are marked `inert` while any pause sub-view is open; focus moves to the relevant sub-view's primary button on each transition.

## DES-06 — Cổng Toán Học (`#screen-quiz`) + inline DES-07 feedback

Built as one screen because DES-07's feedback states are intrinsic to the quiz gate loop — a click-through of "answer a question" cannot be demonstrated without them.

**Layout.** Top bar: exit (✕) icon, `QuizProgress` (10 segment dots), `Câu n/10` counter — all within HUD height. Body: equation (largest text on screen, `size-equation-phone`/`tablet`), speaker icon beside it, `AnswerField`, a fixed-height `FeedbackBand` (prevents layout jump per DES-07 brief), then the numeric keypad pinned toward the bottom.

**Question source.** 10 fixed sample questions drawn from `docs/design/question-samples.json` (5 addition + 5 subtraction, mixed difficulty/regrouping), shuffled per-session with Fisher–Yates and reshuffled if the shuffle produces more than 3 consecutive `requires_regrouping` questions, mirroring the production rule in `APP_SPEC.md` §4.3. This is illustrative sample data only — the canonical 200-question bank (`questions.math.vi.json`) is untouched, and the same fixed set is shown regardless of which level was entered (documented limitation, unchanged from the vertical-slice pass).

**Answer flow / states.**
1. Digits 0–9 (max 3 digits, since range is 0–100) build `AnswerField`; delete removes the last digit; `Trả lời` submits.
2. **Correct:** `answer-field.is-correct`, `FeedbackBand` shows a check icon + one of the three approved phrases (Chính xác! / Giỏi lắm! / Tuyệt vời!), keypad locks briefly, auto-advances after 900 ms.
3. **First wrong attempt:** `answer-field.is-incorrect`, `FeedbackBand` shows "Con thử lại nhé.", keypad locks for 1100 ms while the field clears, then re-enables for a second attempt.
4. **Second wrong attempt:** equation is revealed with the correct answer plus the question's `hint`, keypad stays locked, submit button relabels to `Tiếp tục` to advance.

**Scoring rule (UIR-009).** Only first-attempt-correct answers count toward the 8/10 pass threshold. A second-attempt-correct still lets the child continue (never blocked) but is logged to the "cần xem lại" list. Also feeds the DES-10 accuracy stats (UIR-024), split by addition / subtraction / regrouping. This interpretation is a logged assumption, not an explicit spec statement — flagged for owner confirmation.

**Exit.** ✕ opens a confirmation modal ("Thoát Cổng Toán Học?" / Tiếp tục làm bài / Về bản đồ → DES-02) per the Back-button semantics in `screen-flow.md`.

**Speaker button.** Attempts `window.speechSynthesis` with a `vi-VN` utterance; if unsupported, shows a toast and does nothing else. No network request either way.

## DES-08 — Pass result (`#screen-result-pass`, pass branch)

Shown when first-attempt score ≥ 8/10. Displays score, a 3-star bar (mapping: 8→1★, 9→2★, 10→3★ — UIR-010 assumption), a next-destination teaser box, and the single action `Về bản đồ` (renamed from the vertical slice's `Sang màn mới` now that it correctly returns to DES-02 with the next level unlocked, rather than to the menu).

**Last-level variant (UIR-020).** Passing level 10 shows "Con đã hoàn thành mọi vùng đất!" instead of the usual "Con đã mở màn mới!", and omits the next-destination teaser (there is no level 11).

## DES-09 — Retry result (`#screen-result-pass`, retry branch)

Shown when first-attempt score < 8/10: "Con sắp mở được rồi!", the score (in ink navy, not success green, so it doesn't read as "passed"), up to 3 review items (equations answered wrong on the first attempt), `Thử lại` (restarts the quiz set) and `Về bản đồ` (→ DES-02). No failure language is used, per the brief. This is now the final DES-09 build — the vertical-slice pass had a labeled "stand-in" disclaimer paragraph, which is removed.

## DES-10 — Adult area (`#screen-adult`)

Entered by the DES-01 3-second hold; closed via the ✕ icon (→ DES-01).

**Layout.** Two tabs: **Tiến độ** (progress) and **Cài đặt** (settings). Visually calmer/quieter than the child flow (neutral grey background, no playful shapes), per the brief's "adult area should look calmer than the child flow."

**Tiến độ tab.** Stat cards: levels completed (`x/10`), overall accuracy, addition accuracy, subtraction accuracy, regrouping accuracy. All accuracy figures count **first-attempt-only** answers (UIR-024), showing "Chưa có dữ liệu" until at least one question has been answered.

**Cài đặt tab.** Three volume sliders (Nhạc 45%, Hiệu ứng 70%, Giọng nói 80% — defaults from `design-tokens.json`'s `audio_default_percent`), each with a live percentage readout. `Xóa tiến độ` opens a confirmation modal ("Xóa toàn bộ tiến độ?" / Xóa tiến độ / Hủy) before actually resetting the in-memory `progress` object, per APP_SPEC §5.5's "Xóa tiến độ sau bước xác nhận."

**QA tools (UIR-023).** A clearly-labeled, visually separated "Công cụ kiểm thử thiết kế (không phải tính năng sản phẩm)" section with a single button that simulates the DES-11 data-fallback scenario. This exists only because DES-11 can't occur naturally in a browser prototype with no real file I/O to fail, and `UI_DESIGN_BRIEF.md` §12 requires every DES state to be reachable without editing URL or code. It is explicitly not a production feature.

**Privacy Policy (UIR-025).** Not included — `GP-14` (Privacy Policy link in the Adult Area) is a Phase 2 Google Play requirement; adding it now would be out-of-scope Phase 2 work per `CLAUDE.md`.

## DES-11 — Data fallback (`#screen-data-fallback`)

**Trigger.** Only reachable via the DES-10 QA tool described above (see UIR-023) — real fallback is triggered by `questions.math.vi.json` failing validation at startup (FR-10/DATA-06), which has no equivalent in this prototype.

**Layout / behavior.** Child-facing copy only: a spinning retry icon and "Mình thử lại nhé!" — no technical detail, per the brief. After ~1.6s (simulating a successful reload of the fallback question set), the prototype automatically returns to the quiz gate and shows a toast announcing readiness ("Đã khôi phục dữ liệu, sẵn sàng!"), matching "If fallback questions load successfully, return to the previous screen automatically and announce readiness."

## Verified issues fixed during this pass (full DES-01–11 expansion)

- **Modal `hidden` attribute losing to CSS** (carried over fix, re-applied defensively to two more elements this pass — `.modal[hidden]` and `.tutorial-step[hidden]`, and `.tutorial-overlay[hidden]`) — the same class of bug (`display: flex` on an element beating the browser's default `[hidden] { display:none }`) was pre-emptively fixed on every new overlay/step element that sets its own `display`, after it was found once in the vertical-slice pass.
- **Keyboard focus leaking behind modals/overlays** — background buttons (HUD, keypad, lane controls) remained focusable/clickable behind the pause modal, quiz-exit modal, reset-confirm modal, and tutorial overlay, since plain `<div>` backdrops don't trap focus the way a native `<dialog>` does. Fixed with a `setOverlayOpen()` helper that toggles the `inert` attribute on background siblings and moves focus into the overlay whenever one opens.
- **Adult-area hold gesture depended on `requestAnimationFrame`**, which some environments pause when a page isn't visible/focused, silently stalling the 3-second hold with no error. Switched to `setInterval` (50 ms tick), which doesn't depend on paint/visibility — more robust across embedding contexts, not just a test-environment fix.
- **Toast overlapping primary content** — the toast was bottom-center, which overlapped the quiz screen's numeric keypad (a real, interactive control). Repositioned to sit just below the top bar/HUD on every screen (`top: calc(var(--hud-height) + 96px)`), verified geometrically clear of the quiz equation; a very minor decorative overlap with the menu mascot is possible in principle but never occurs in practice since no toast currently fires while the menu screen is active.
- **Tutorial step-advance focus** — advancing from tutorial step 1 to step 2 left focus on the now-hidden "Tiếp theo" button instead of moving it to the visible "Thử ngay" button. Fixed.

## Known Minor issue (not fixed this pass)

- On the tablet viewport, when the quiz `FeedbackBand` is empty there's a large empty vertical gap between the answer field and the keypad (keypad is pinned to the bottom via `margin-top: auto`). Nothing overlaps or scrolls; flagged for a future visual-rhythm pass (see `review-log.md` UIR-016, carried over unresolved).
