# Claude Code Project Instructions

## Canonical context

Read these files before making design or implementation decisions:

- @APP_SPEC.md
- @UI_DESIGN_BRIEF.md
- @IMPLEMENTATION_PLAN.md
- @docs/design/screen-flow.md
- @docs/design/design-tokens.json
- @docs/design/question-samples.json

Do not load all of `questions.math.vi.json` into context unless validating data. Use `docs/design/question-samples.json` for UI examples.

## Current project stage

The current stage is **UI design and interactive prototype**, not production Godot implementation.

Until the user explicitly approves the design:

- Create and iterate the local prototype under `prototype/`.
- Update design deliverables under `docs/design/`.
- Do not initialize a Godot project or create production gameplay code.
- Do not change learning rules, scoring, question selection or Google Play requirements.
- If two source files conflict, stop and report the exact conflict. `APP_SPEC.md` has priority for product behavior.

## Product invariants

- Audience: Vietnamese Grade 2 children, approximately 7 years old.
- Primary language: Vietnamese with correct diacritics.
- Platform: Android phone and tablet, landscape-only in Phase 1.
- Core loop: runner level → exactly 10 math questions → pass at 8/10 → unlock next level.
- Quiz set: exactly 5 additions and 5 subtractions; no repeated question ID in a session before the eligible pool is exhausted.
- Phase 1 is offline, has no account, ads, purchases, chat, analytics SDK or personal-data collection.
- Wrong answers must be supportive, never punitive or embarrassing.
- Final production engine is Godot 4.x; the web prototype is not production code.

## Design task

Build a dependency-free interactive prototype with:

- `prototype/index.html`
- `prototype/styles.css`
- `prototype/app.js`

It must run by opening `index.html` directly, without a backend, package installation, CDN, remote font or network request. Use CSS/HTML shapes and clearly labeled placeholder assets when final illustrations are unavailable.

The prototype must cover DES-01 through DES-11 in `IMPLEMENTATION_PLAN.md`, including pass, retry, locked, pause, wrong-answer and data-fallback states. It must be usable at 960×540 and 1280×800 without text overlap or horizontal scrolling.

## Visual implementation rules

- Follow `UI_DESIGN_BRIEF.md` and `docs/design/design-tokens.json`.
- Use stable layout constraints; dynamic labels must not resize controls or shift the HUD.
- Minimum touch target is 48×48 dp-equivalent.
- Use familiar symbols for pause, sound, back and close. Add accessible labels/tooltips in the web prototype.
- Use icon + text when a seven-year-old may not recognize an icon alone.
- Do not use nested cards, decorative gradient blobs, excessive rounded pills or viewport-scaled font sizes.
- Keep cards at 8px radius or less. Reserve larger rounded shapes for circular icon controls or in-game objects.
- Never communicate correct/incorrect/locked state only through color.
- Use Vietnamese microcopy from `UI_DESIGN_BRIEF.md`; do not invent long instructional paragraphs.
- Do not use copyrighted characters, brands, stock watermarks or unlicensed assets.

## Required design outputs

Maintain these files as the prototype evolves:

- `docs/design/ui-spec.md`: screen and component behavior.
- `docs/design/component-inventory.md`: reusable components and all states.
- `docs/design/design-tokens.json`: approved tokens only.
- `docs/design/asset-manifest.csv`: every visual/audio asset, status, source and license.
- `docs/design/review-log.md`: assumptions, decisions and `UIR-xxx` review issues.
- `docs/design/screenshots/phone/`: 960×540 screenshots.
- `docs/design/screenshots/tablet/`: 1280×800 screenshots.

## Work sequence

1. Review inputs and write missing/conflicting decisions to `docs/design/review-log.md`.
2. Propose two visual directions in prose and token diffs; do not build both fully.
3. Wait for the user to select a direction if the choice materially changes the interface.
4. Build the vertical prototype for DES-01, DES-04, DES-06 and DES-08.
5. Verify both viewports and resolve Blocker/Major issues.
6. Expand to DES-01 through DES-11.
7. Produce final handoff files and summarize deviations from the spec.

## Verification

- Check all navigation paths and back/pause behavior manually.
- Check at least one long Vietnamese label and the longest representative equation.
- Verify keyboard-only interaction in the web prototype where practical.
- If browser automation is available, capture both required viewports and inspect them before declaring completion.
- Never claim Godot or Android behavior has been verified from the web prototype.

## Data and safety

- Use fictional data only. Never add a real child's name, image, voice or learning history.
- Do not add trackers, remote requests, telemetry or external embeds to the prototype.
- Preserve `questions.math.vi.json`; design work may read it but must not rewrite it.
