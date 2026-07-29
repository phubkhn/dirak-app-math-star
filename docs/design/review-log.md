# Design Review Log

## Status

- Stage: full prototype — DES-01 through DES-11 built, approved vertical slice expanded per owner request
- Selected direction: **Direction A — Xưởng Khám Phá Sắc Màu** (confirmed default per `UI_DESIGN_BRIEF.md` §4: "Start with Direction A... should not replace Direction A without explicit approval." No material interface change is being proposed, so work proceeds without blocking on owner sign-off; see comparison table below.)
- Production UI implementation: not started
- Prototype: all 11 design states built under `prototype/`, screenshots captured at both viewports in `docs/design/screenshots/`

## Input review — contradictions and gaps found

No hard contradictions between `APP_SPEC.md` and `UI_DESIGN_BRIEF.md`/`IMPLEMENTATION_PLAN.md` were found that block this vertical slice. The following ambiguities and gaps were found and resolved with a logged default so work could proceed; all are open for owner confirmation.

| ID | Finding | Source(s) | Default applied | Impact |
|---|---|---|---|---|
| UIR-006 | Adult-area entry: `APP_SPEC.md` §5.1 allows "a simple math challenge **or** a 3-second hold." `UI_DESIGN_BRIEF.md` §3/§9 and `screen-flow.md` only describe the 3-second hold. Not a contradiction (APP_SPEC offers either), but the brief silently narrowed it. | APP_SPEC §5.1; UI_DESIGN_BRIEF §3, §9 DES-01 | Use hold-3-seconds only for Phase 1; math-challenge alternative deferred | DES-01 gesture, DES-10 entry point |
| UIR-007 | "Sao Nhỏ" mascot (UI_DESIGN_BRIEF §2/§4) is not mentioned anywhere in `APP_SPEC.md`, which only describes the player ship. This is an addition, not a conflict, but its on-screen presence during live gameplay is unspecified. | UI_DESIGN_BRIEF §2; APP_SPEC §3.1 | Mascot appears on Menu/Map/reward moments only; not rendered during DES-04 gameplay so it never competes with the play field (matches DES-04 brief: "no card around the game") | DES-04 layout, illustration scope |
| UIR-008 | End-of-map state (passing level 10, the last level) is not described in `APP_SPEC.md`, `UI_DESIGN_BRIEF.md`, or `screen-flow.md`. | APP_SPEC §3.3, §5.2; screen-flow.md | Out of scope for this slice (DES-02 map not built yet); DES-08 will need a distinct "all themes complete" variant when DES-02 is built | DES-08, DES-02 |
| UIR-009 | Whether a question solved correctly on the **second** attempt counts toward the 8/10 pass threshold is not stated explicitly in `APP_SPEC.md` §3.2/§4.1. The risk table in `IMPLEMENTATION_PLAN.md` §7 ("Trẻ đoán bằng phản hồi lần hai") implies first-attempt accuracy must be tracked *separately* from the pass score, and DES-09's "review list" concept only makes sense if first-attempt misses are flagged even when later corrected. | APP_SPEC §3.2, §4.1; IMPLEMENTATION_PLAN §7 risk table; UI_DESIGN_BRIEF DES-09 | Only **first-attempt-correct** answers count toward the 8/10 threshold. A second-attempt-correct answer still lets the child continue (never blocked) but is logged as "cần xem lại" and does not add to the score. Implemented this way in the prototype's quiz logic. | QuizGate scoring, ProgressService stats, DES-09 review list |
| UIR-010 | Star-reward mapping for a passed gate (e.g., 8/10 vs 10/10) is not specified anywhere; `APP_SPEC.md` §3.2 only says stars/badges are awarded, not a formula. | APP_SPEC §3.2 | Prototype assumption: 8/10 → 1 star, 9/10 → 2 stars, 10/10 → 3 stars | DES-08 result screen, LevelNode star display |
| UIR-011 | This work order scopes the vertical prototype to DES-01, DES-04, DES-06, DES-08 only (per `IMPLEMENTATION_PLAN.md` Milestone 2, DES-T10). DES-03 (tutorial), DES-05 (pause), DES-09 (retry) and DES-02 (map) are not yet built. | IMPLEMENTATION_PLAN §Milestone 2 | **Chơi** on the menu goes straight to DES-04 (tutorial skipped for this slice). The gameplay pause icon opens a minimal, clearly-scoped stand-in for DES-05 so the click path isn't dead-ended; it is not the full DES-05 build. If a prototype quiz run scores under 8/10, a minimal labeled stand-in for DES-09 is shown instead of leaving the flow dead-ended, again not a full DES-09 build. Both stand-ins are visually simple and are called out here so they are not mistaken for finished screens. | Prototype scope only, no spec impact |

## Confirmed decisions

- Landscape-only for Phase 1.
- Reference viewports: 960×540 phone and 1280×800 tablet.
- Vietnamese is the primary language.
- Claude Code creates a local dependency-free prototype; Godot remains the production engine.
- No real child data, remote assets, analytics, ads or network dependency.
- Direction A is confirmed for the vertical prototype (see comparison below).

## Direction A vs Direction B comparison

| Criterion | Direction A — Xưởng Khám Phá Sắc Màu | Direction B — Trạm Khoa Học Nhí |
|---|---|---|
| Readability for a 7-year-old (VN) | High — bold silhouettes, one dominant color per theme, concrete kite/ocean/forest/space motifs a Grade-2 child recognizes instantly | Moderate — dashboard/meter metaphors (modules, gauges) are more abstract and read older; needs more label reliance |
| APK weight (Godot 2D assets) | Low — flat silhouettes and shared atlas per theme reuse the same shape language across 4 themes | Low–Medium — sticker-badge and meter widgets need more distinct small assets per module, less reuse across themes |
| Godot feasibility | High — nine-patch panels, sprites, labels, simple tweens; matches brief's "no shaders/blur/video" constraint directly | High, but the meter/gauge components need custom-drawn arcs or extra sprite states, marginally more component work |
| Fit with product tone (encouraging, non-punitive) | Strong — story/exploration framing supports celebratory, non-clinical feedback | Weaker — "station/meter" framing reads more clinical, works against the "supportive not punitive" principle in APP_SPEC §2 |
| Extensibility to future subjects (Vietnamese, etc.) | Good, via reskinning themes | Slightly better — dashboard scales to more modules without a new "world" per subject |

**Recommendation: Direction A.** It scores higher on the two criteria most likely to affect real usage — readability for a 7-year-old and non-punitive tone — while being at parity or better on APK weight and Godot feasibility. Direction B's dashboard framing is a reasonable idea if Toán + Tiếng Việt modules need to share one screen later, but that is not a Phase 1 requirement, so it does not outweigh A's readability and tone advantages today. No token changes are proposed as part of this recommendation; `docs/design/design-tokens.json` already encodes Direction A.

## Decisions confirmed by owner (2026-07-30)

| ID | Decision | Confirmed answer | Impact |
|---|---|---|---|
| UIR-001 | Final public app name | **Final: Hành Trình Sao Toán.** Not a working title — locked in. | Logo, store listing |
| UIR-003 | Final mascot appearance/voice gender | Neutral visual/voice direction confirmed as good enough for now; specific illustration and voice casting deferred to asset production, not a design-approval blocker. | Illustration and recording |
| UIR-004 | Exact low-end Android test device | Deferred to the Godot/QA phase — doesn't affect the web prototype. Placeholder (Android 8/API 26, 2GB RAM) stays until then. | Performance and asset budget, later phase |
| UIR-005 | Whether quiz answers allow leading zero | Normalize `07` to `7`. Already the actual behavior (`parseInt(currentDigits, 10)` in `app.js` parses "07" as 7 with no octal ambiguity) — no code change needed. | Keypad behavior |
| UIR-006 | Adult-area entry: hold-only vs hold-or-math-challenge | Hold 3 seconds only (Phase 1). Math-challenge alternative explicitly declined for now. | DES-01/DES-10 |
| UIR-009 | Does 2nd-attempt-correct count toward 8/10? | No — only 1st-attempt-correct counts; 2nd-attempt-correct still unblocks continuation. This is a scoring/learning-rule decision, confirmed by the owner rather than assumed. | QuizGate scoring, DES-10 accuracy stats |
| UIR-010 | Star-reward formula for a passed gate | 8/10=1★, 9/10=2★, 10/10=3★ (linear mapping) | DES-08 |
| UIR-023 | Is the DES-10 "design QA tools" button an acceptable way to make DES-11 clickable? | Yes — kept as-is. Confirmed acceptable since it's clearly labeled non-production and is the only way to demo DES-11 without real file I/O. | DES-10, DES-11 |

## Open decisions

| ID | Decision | Default if unanswered | Impact |
|---|---|---|---|
| UIR-002 | Approve visual Direction A or choose B | Direction A (see comparison above) — already approved by the owner for the vertical-slice and full-expansion passes | Art style and component tone |
| UIR-007 | Mascot presence during live gameplay | Hidden during DES-04, shown elsewhere | DES-04 layout |
| UIR-008 | Level-10 (final) pass state content | Resolved via UIR-020 (distinct "hoàn thành mọi vùng đất" copy, no next-level teaser) | DES-08/DES-02 |

## Prototype scope note (vertical-slice pass)

Built: DES-01 (Menu), DES-04 (Gameplay HUD, with a minimal pause stand-in), DES-06 (Cổng Toán Học, including inline correct/first-wrong/second-wrong feedback since that is intrinsic to the quiz gate loop), DES-08 (Pass result).

Not built that pass (now built in the full-expansion pass below): DES-02 (map), DES-03 (tutorial), DES-05 (full pause), DES-09 (full retry result), DES-10 (adult area), DES-11 (data fallback).

## Full expansion pass (DES-01–11) — new decisions

The vertical prototype was approved and the same component system/tokens were expanded to all 11 states. New gaps and judgment calls made during this pass, logged per `CLAUDE.md`'s "stop and report the exact conflict" rule where the source docs didn't fully specify behavior:

| ID | Finding | Source(s) | Decision applied | Impact |
|---|---|---|---|---|
| UIR-018 | Whether DES-03 (tutorial) should replay every time Level 1 is entered, or only the very first time. `screen-flow.md` ties it to the "Màn đầu tiên" (first-level) edge; `IMPLEMENTATION_PLAN.md`'s DES-03 row calls it "Hướng dẫn **lần đầu**" (first-**time** guidance). | screen-flow.md; IMPLEMENTATION_PLAN.md DES-03 row | Show DES-03 only the first time Level 1 is ever entered (a `hasPlayedTutorial` flag), not on every replay — repeating a skippable overlay on every replay adds friction with no benefit, and "lần đầu" reads as "first time" rather than "every time you pick level 1." | DES-03 trigger logic |
| UIR-019 | Map → Menu navigation isn't drawn in `screen-flow.md` (only Menu→Map is shown), but some way back to the menu (e.g. to reach sound toggle or the adult corner) is necessary. | screen-flow.md | Added a small back/home icon button top-left of DES-02, navigating to DES-01. This is an addition beyond what the flow diagram draws, not a contradiction of it. | DES-02 layout |
| UIR-020 | Level 10 (final level) pass state was deferred as out-of-scope in the vertical slice (`UIR-008`). With DES-02 now built, leaving it unhandled would dead-end a click path. | APP_SPEC §3.3, §5.2; UIR-008 | Passing level 10 shows distinct copy ("Con đã hoàn thành mọi vùng đất!") and only a "Về bản đồ" action (no "next level" teaser, since none exists). Resolves UIR-008 for this prototype; still worth an explicit product decision on whether a 10/10-complete state needs its own screen in production. | DES-08 (last-level variant) |
| UIR-021 | DES-04's obstacles were decorative-only in the vertical slice (no collision simulated), but `APP_SPEC.md` §3.1 and the DES-04 brief both describe collision feedback as a required state ("va chạm chỉ làm mất một sao... collision feedback is brief"). | APP_SPEC §3.1; UI_DESIGN_BRIEF DES-04 | Obstacles are now tappable in the prototype to *simulate* a collision (since there's no real physics loop): a brief coral flash + "-1 ★" indicator decrements the HUD star count (floor 0), non-punitively, matching "chỉ làm mất một sao và tiếp tục chơi." This remains a UI/interaction stand-in, not real collision physics. | DES-04 |
| UIR-022 | UI_DESIGN_BRIEF DES-05 explicitly requires one confirmation step before restarting a level ("Restart requires one confirmation only"), but the vertical slice's pause modal reset immediately with no confirmation. | UI_DESIGN_BRIEF DES-05 | Pause modal's "Chơi lại" now shows one inline confirmation sub-view before resetting. | DES-05 |
| UIR-023 | DES-11 (data fallback) can only occur in production when `questions.math.vi.json` fails validation at startup (FR-10/DATA-06) — there is no real file I/O in the web prototype to fail. Per `UI_DESIGN_BRIEF.md` §12, "All DES states are reachable in the prototype without editing URL or code," so DES-11 still needs a legitimate in-UI trigger. | UI_DESIGN_BRIEF §12; APP_SPEC FR-10/DATA-06 | Added a clearly-labeled "Công cụ kiểm thử thiết kế" (design QA tools) control inside DES-10 (Adult Area) — consistent with the brief's own framing that "technical details are hidden in the adult area/log" — that simulates the fallback scenario on demand. This is explicitly a QA/demo affordance, not a production feature, and is labeled as such in the UI. | DES-10, DES-11 |
| UIR-024 | Adult-area accuracy stats (§5.5: overall / addition / subtraction / regrouping accuracy) need a defined counting rule. | APP_SPEC §5.5; IMPLEMENTATION_PLAN §7 risk table | Consistent with `UIR-009`, stats count **first-attempt** answers only (matches the risk table's explicit call to track first-attempt accuracy separately), accumulated across the whole session, not per-quiz. | DES-10 |
| UIR-025 | Privacy Policy display in the Adult Area (`GP-14`) is explicitly a Phase 2 Google Play requirement. | APP_SPEC §15.3 | Not added to DES-10 in this pass — adding it now would be scope creep into Phase 2/Google Play concerns, which `CLAUDE.md` says not to touch. | DES-10 (deferred, not a gap) |

## Prototype scope note (full-expansion pass)

All 11 design states (DES-01 through DES-11) are now built and click-tested in `prototype/`. Level progress (unlocked levels, stars, accuracy stats) is tracked in an in-memory JS object for this session only — it is **not** persisted to `localStorage` or any device storage. This is a deliberate simplification: real persistence is `ProgressService`'s job in the Godot build (FR-07, NFR-07), and the prototype resets on reload like any static page. The "Xóa tiến độ" (reset) flow in DES-10 is still fully click-testable against this in-memory state.

The quiz content itself is still the same fixed 10-question demo set regardless of which level is selected (already noted as a limitation in the vertical-slice pass) — production difficulty-based question selection is explicitly out of scope for UI design work per `CLAUDE.md`.

## Testing results — issues found and status (this pass)

Tested by clicking every path in `prototype/` (menu → gameplay → quiz → pass result; menu → gameplay → quiz → retry stand-in; pause open/resume/restart/to-menu; quiz exit confirm/cancel; adult-corner hold/cancel) at both 960×540 and 1280×800, plus targeted checks of the longest sample equation (`19 + 68 = 87`) and its hint text, and the longest approved copy strings. All testing was in a desktop browser only — see "Verification" note at the end of this file.

| ID | Severity | Finding | Resolution |
|---|---|---|---|
| UIR-012 | Blocker | Pause and quiz-exit modals rendered **open by default** on load. Root cause: `.modal-backdrop { display: flex }` in CSS overrides the browser's default `[hidden] { display: none }` UA rule, since author styles beat UA styles regardless of specificity. | **Fixed** — added an explicit `.modal-backdrop[hidden] { display: none }` rule. Re-tested: both modals now stay closed until their trigger is clicked. |
| UIR-013 | Major | A second wrong answer entered soon after the first could have its "reveal" (correct answer + hint) state **wiped a moment after appearing**, reverting to a blank feedback band. Root cause: the first wrong attempt's auto-clear `setTimeout` was never cancelled, so it fired later and cleared whatever feedback state was current — including the attempt-2 reveal. | **Fixed** — the keypad is now disabled for the auto-clear window (so a real user can't race it) and the timer is explicitly cancelled on every new submission and question load. Re-tested: the reveal now persists until the child taps "Tiếp tục." |
| UIR-014 | Minor | On first load, the ship's resting position visually overlapped the lane-1 star collectible. | **Fixed** — moved the collectible's vertical position so it's clearly separate from the ship's resting spot. |
| UIR-015 | Minor | The retry stand-in screen's score number reused the same success-green color as the DES-08 pass screen, which could read as "you passed" even when the message says otherwise. | **Fixed** — retry-state score now uses ink navy instead of success green. |
| UIR-016 | Minor, open | On the tablet viewport, when the feedback band is empty there's a large empty vertical gap between the answer field and the keypad (keypad is pinned to the bottom via `margin-top: auto`). Not a Blocker/Major — nothing overlaps or scrolls — but worth a visual-rhythm pass before this is treated as final. | Not fixed this pass; flagged for the next iteration. |
| UIR-017 | Minor, partially resolved | Sound toggle state isn't persisted (resets on reload) and the adult-corner hold gesture's destination (DES-10) was a toast stand-in rather than a real screen. | DES-10 is now a real screen (see the full-expansion pass below) — resolved. Sound toggle persistence remains an open Minor item; not implemented (no `localStorage`), consistent with the rest of the prototype's in-memory-only state. |

No remaining Blocker or Major issues in the four screens built in the vertical-slice pass.

## Testing results — full expansion pass (DES-01–11)

Tested by clicking/scripting every path across all 11 screens at both 960×540 and 1280×800: menu → map (locked-node shake+toast, unlocked entry) → tutorial (first-entry only, both steps) → gameplay (lane move, jump, star collect, obstacle collision) → pause (resume, restart with confirm/cancel) → quiz (correct/first-wrong/second-wrong, exit confirm/cancel) → pass result (map routing, star/level unlock, last-level variant) → retry result (review list, Thử lại, Về bản đồ) → adult area (tab switch, stat rendering, volume sliders, reset with confirm) → DES-11 QA trigger (auto-recovery + toast). Screenshots for all 11 states captured to `docs/design/screenshots/{phone,tablet}/`.

| ID | Severity | Finding | Resolution |
|---|---|---|---|
| UIR-026 | Major | Keyboard/tab focus could reach background buttons (HUD, keypad, lane controls) hidden behind the pause modal, quiz-exit modal, reset-confirm modal, and tutorial overlay — plain `<div>` backdrops don't trap focus the way a native `<dialog>` does. Found while verifying keyboard-only interaction per `CLAUDE.md`'s verification checklist. | **Fixed** — added a `setOverlayOpen()` helper that marks all background siblings `inert` while any overlay is open (blocks both pointer and keyboard interaction) and moves focus into the overlay. Verified programmatically that background buttons become unreachable while each overlay is open. |
| UIR-027 | Major | The adult-corner hold gesture used `requestAnimationFrame`, which several environments pause when a page isn't visible/focused — the 3-second hold would silently never complete with no error shown. Found while testing the DES-10 entry point. | **Fixed** — switched to `setInterval` (50ms tick), which doesn't depend on paint/visibility. This is a robustness fix, not just a test workaround: any embedding context that throttles rAF (e.g. a backgrounded WebView) would have hit the same silent failure. |
| UIR-028 | Minor | Toast notifications (bottom-center) overlapped the quiz screen's numeric keypad — a real, interactive control — and in one case briefly obscured the equation text. | **Fixed** — repositioned toast to sit just below the top bar/HUD (`top: calc(var(--hud-height) + 96px)`) on every screen; verified geometrically clear of the quiz equation. A minor decorative overlap with the menu mascot is possible in principle but never occurs in practice (no toast currently fires while the menu screen is active). |
| UIR-029 | Minor | Advancing from tutorial step 1 to step 2 left keyboard focus on the now-hidden "Tiếp theo" button instead of the visible "Thử ngay" button. | **Fixed** — focus now moves to the new step's button on each transition. |

No remaining Blocker or Major issues across all 11 screens. Remaining open Minor items: `UIR-016` (tablet quiz vertical gap, carried over) and sound-toggle persistence (part of `UIR-017`).

## Issue template

```text
UIR-xxx [Blocker|Major|Minor]
Screen:
Viewport:
Observed:
Expected:
Evidence:
Resolution:
```

## Verification note

All testing in this pass — click-path testing, viewport checks, and the screenshots in `docs/design/screenshots/` — was performed in a desktop Chrome browser (both interactively and via headless automation) against the static `prototype/` files served locally. This verifies the **web prototype only**. It is not evidence of Android or Godot behavior — touch ergonomics, real-device performance, TalkBack/accessibility behavior, and Godot's actual component rendering must be verified separately once the production build exists, per `CLAUDE.md`.
