# Design Review Log

## Status

- Stage: vertical prototype (DES-01, DES-04, DES-06, DES-08)
- Selected direction: **Direction A — Xưởng Khám Phá Sắc Màu** (confirmed default per `UI_DESIGN_BRIEF.md` §4: "Start with Direction A... should not replace Direction A without explicit approval." No material interface change is being proposed, so work proceeds without blocking on owner sign-off; see comparison table below.)
- Production UI implementation: not started
- Prototype: vertical slice built under `prototype/`

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

## Open decisions

| ID | Decision | Default if unanswered | Impact |
|---|---|---|---|
| UIR-001 | Final public app name | Hành Trình Sao Toán | Logo and store listing |
| UIR-002 | Approve visual Direction A or choose B | Direction A (see comparison above) | Art style and component tone |
| UIR-003 | Final mascot appearance/voice gender | Neutral visual and warm neutral voice | Illustration and recording |
| UIR-004 | Exact low-end Android test device | Android 8/API 26, 2 GB RAM baseline | Performance and asset budget |
| UIR-005 | Whether quiz answers allow leading zero | Normalize `07` to `7` | Keypad behavior |
| UIR-006 | Adult-area entry: hold-only vs hold-or-math-challenge | Hold 3 seconds only (Phase 1) | DES-01/DES-10 |
| UIR-007 | Mascot presence during live gameplay | Hidden during DES-04, shown elsewhere | DES-04 layout |
| UIR-008 | Level-10 (final) pass state content | Deferred, not built this slice | DES-08/DES-02 |
| UIR-009 | Does 2nd-attempt-correct count toward 8/10? | No — only 1st-attempt-correct counts; 2nd-attempt-correct still unblocks continuation | QuizGate scoring |
| UIR-010 | Star-reward formula for a passed gate | 8/10=1★, 9/10=2★, 10/10=3★ | DES-08 |

## Prototype scope note (this pass)

Built: DES-01 (Menu), DES-04 (Gameplay HUD, with a minimal pause stand-in), DES-06 (Cổng Toán Học, including inline correct/first-wrong/second-wrong feedback since that is intrinsic to the quiz gate loop), DES-08 (Pass result).

Not built this pass (tracked for the next expansion per `IMPLEMENTATION_PLAN.md` §3.5 step 5–6): DES-02 (map), DES-03 (tutorial), DES-05 (full pause), DES-09 (full retry result), DES-10 (adult area), DES-11 (data fallback).

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
