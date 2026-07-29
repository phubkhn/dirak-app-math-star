# Claude Code Start Prompt

Use this as the first request after starting Claude Code in the project root:

```text
Read CLAUDE.md and every canonical file it imports. We are in UI design mode only.
Do not initialize Godot yet and do not modify questions.math.vi.json.

First, review the inputs for contradictions or missing decisions that would block UI design.
Record findings and assumptions in docs/design/review-log.md.

Then compare Direction A and Direction B from UI_DESIGN_BRIEF.md using a concise table.
Recommend one direction based on readability for Vietnamese seven-year-olds, APK weight,
and feasibility in Godot. Do not build two complete versions.

After the visual direction is confirmed, build a dependency-free local prototype under
prototype/ for DES-01, DES-04, DES-06 and DES-08. It must open directly from index.html,
make no network requests and work at 960x540 and 1280x800. Use the canonical design tokens,
Vietnamese copy and fictional data only.

Maintain docs/design/ui-spec.md, component-inventory.md, asset-manifest.csv and review-log.md.
Before finishing, test every click path, inspect screenshots at both viewports and report
remaining UIR issues by severity. Do not claim Android or Godot verification.
```

After approving the vertical prototype, use this follow-up:

```text
The visual direction and vertical prototype are approved. Expand the same component system
to DES-01 through DES-11, including every state listed in APP_SPEC.md and UI_DESIGN_BRIEF.md.
Preserve the approved layout and token names. Capture phone/tablet screenshots, resolve all
Blocker and Major UIR issues, and complete the design handoff files. List any deliberate
deviation from the product spec; do not silently change behavior.
```
