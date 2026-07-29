# UI Design Brief: Hành Trình Sao Toán

## 1. Design goal

Create a Vietnamese Android learning game that feels cheerful and capable rather than babyish. A seven-year-old should recognize the primary action within three seconds, complete the main flow with little reading and understand mistakes without feeling punished.

The design should be lightweight enough to reproduce in Godot with sprites, nine-patch panels, labels and simple tweens. Avoid visual ideas that require real-time blur, complex shaders, video backgrounds or large 3D assets.

## 2. Fixed decisions

| Decision | Value |
|---|---|
| Working name | Hành Trình Sao Toán |
| Orientation | Landscape only |
| Reference phone | 960×540 |
| Reference tablet | 1280×800 |
| Primary language | Vietnamese |
| Input | One-finger touch; no hardware keyboard required |
| Theme | Friendly exploration through sky, ocean, forest and space |
| Mascot | “Sao Nhỏ”, a simple five-point star guide with face and tiny backpack |
| Player vehicle | Compact rounded 2D exploration ship, original design |
| Rendering | Flat 2D, crisp silhouettes, subtle texture only |
| Monetization | None |

## 3. Audience principles

- Use concrete verbs: **Chơi**, **Trả lời**, **Thử lại**, **Tiếp tục**.
- Keep instructions to one sentence and pair them with animation or an icon.
- Do not show a countdown during math questions.
- Do not remove earned stars for wrong math answers.
- Correct feedback celebrates effort briefly; wrong feedback explains the next action.
- The adult area should look calmer than the child flow and require a three-second hold to enter.

## 4. Chosen visual direction

### Direction A — Xưởng Khám Phá Sắc Màu (default)

A crisp 2D world built from paper-cut-like layers and bold silhouettes. Controls resemble durable classroom tools rather than candy. The four environment themes have different dominant colors while sharing the same navy text, white surfaces and component system.

- Sky: blue, white and sunflower yellow; kites and soft cloud shapes.
- Ocean: teal, coral and light aqua; bubbles and rounded rocks.
- Forest: leaf green, yellow and berry red; broad leaves and wooden signs.
- Space: deep indigo used only in the scene, with cyan and gold stars.
- Vietnamese character comes from language, kite/rice-field/cloud motifs and landscape details, not stereotypes or flags.

### Direction B — Trạm Khoa Học Nhí (alternative)

A quieter science-station interface using modules, meters and sticker-like badges. It is easier to scale for future subjects but feels less story-driven. Select this only if the team expects math and Vietnamese modules to share one dashboard soon.

Start with Direction A. Claude may propose a token-level comparison but should not replace Direction A without explicit approval.

## 5. Color roles

The canonical values live in `docs/design/design-tokens.json`.

- Ink navy: all primary text and outlines.
- Action blue: primary actions and focus.
- Leaf green: success and opened progress.
- Sun yellow: rewards and selected stars; never body text on white.
- Coral: obstacle emphasis and secondary accent, not error punishment.
- Berry: errors only together with an icon and supportive text.
- White/light sky: surfaces and reading backgrounds.

Every screen should use at least one warm and one cool accent. Do not let the whole app become monochrome blue/purple, beige or dark slate.

## 6. Typography

- Preferred production family: **Be Vietnam Pro**, bundled locally under the SIL Open Font License after its license is recorded.
- Prototype fallback: `Arial`, `Tahoma`, sans-serif; no remote font request.
- Use Semibold for buttons/headings and Regular/Medium for explanations.
- Do not use all caps for Vietnamese sentences.
- Do not scale font size with viewport width. Use fixed token sizes with phone/tablet layout adjustments.
- Keep line length short; a quiz explanation should fit within two lines.

## 7. Layout and safe areas

- Base design grid: 8 px/dp.
- Phone safe inset: 24 left/right, 16 top/bottom.
- Tablet content max width: 1120; center content rather than stretching controls.
- HUD height: 64 phone, 72 tablet; stable across score changes.
- Primary command area must remain in the lower-right or lower-center region depending on screen.
- Do not place essential controls within 24 dp of a screen corner.
- Touch targets are at least 48×48; primary buttons are at least 160×56 on phone.

## 8. Component rules

### Buttons

- Primary: solid action blue, white label, optional leading icon.
- Secondary: white surface, navy outline, navy label.
- Destructive actions exist only in the adult area and use berry outline, not a large red fill.
- Disabled: neutral surface plus lock icon or explanatory label; never opacity alone.
- Pressed state moves down 2 dp and shortens shadow; it must not change layout size.

### Cards and panels

- Use cards only for repeated level tiles, quiz result items and modals.
- Do not place a card inside another card.
- Maximum card radius is 8.
- Main screen sections are unframed layers, not floating marketing cards.

### Numeric keypad

- Fixed 3×4 grid: 1–9, delete, 0, submit.
- Number keys have identical dimensions and never shift after input.
- Delete uses familiar backspace icon plus accessible label.
- Submit is visually distinct and uses the label **Trả lời** when space allows.

### Feedback

- Correct: check icon, green role color, `answer_correct` sound and one short phrase.
- First wrong attempt: retry arrow/info icon, berry role color, soft sound and **Con thử lại nhé.**
- Second wrong attempt: show complete equation and short hint; then enable continuation.
- Unlock: open-lock icon, star motion and **Con đã mở màn mới!**

## 9. Screen briefs

### DES-01 Menu

The app name and mascot are visible immediately. **Chơi** is the only large text command. Sound is a familiar icon button. **Góc người lớn** is smaller and visually separate near an edge, entered by holding for three seconds.

### DES-02 Level map

Show a left-to-right route with ten stable level nodes. Current level is visually selected; completed nodes show 0–3 stars; locked nodes use a lock icon and subdued pattern. At least part of the next theme is visible to create progression.

### DES-03 Tutorial

Overlay one instruction at a time over live-looking gameplay. Use an animated hand/path placeholder for swipe, then a tap ring for jump. Include **Thử ngay**; do not use a multi-paragraph tutorial card.

### DES-04 Gameplay HUD

Keep the playfield full-bleed. HUD contains star count on the left and pause on the right. No card around the game. Collision feedback is brief and must not obscure the vehicle or next obstacle.

### DES-05 Pause

Dim the playfield and show a single modal with **Tiếp tục**, restart icon and map icon. Restart requires one confirmation only because no permanent progress is lost.

### DES-06 Quiz gate

Show **Câu n/10** and a stable progress indicator at top. The equation is the largest text. Answer field and keypad dominate the lower half. Speaker is an icon control beside the equation. No timer.

### DES-07 Question feedback

Keep the equation in the same position to avoid layout jump. Feedback occupies a reserved band. The keypad may lock briefly during correct feedback but should not disappear and resize the screen.

### DES-08 Pass result

Show score, earned stars and one clear action **Sang màn mới**. The unlocked destination is visible behind or beside the result, not hidden in a second dialog.

### DES-09 Retry result

Use **Con sắp mở được rồi!** and show up to three concepts/questions to review. Primary action is **Thử lại**; secondary is **Về bản đồ**. Do not show failure language.

### DES-10 Adult area

Use compact tabs or sections for progress and settings. Show overall/addition/subtraction accuracy, three volume controls and reset progress. Privacy Policy is available here in Phase 2.

### DES-11 Data fallback

Child-facing text: **Mình thử lại nhé!** with a retry button. Technical details are hidden in the adult area/log. If fallback questions load successfully, return to the previous screen automatically and announce readiness.

## 10. Vietnamese copy deck

| Purpose | Approved copy |
|---|---|
| Main action | Chơi |
| Continue | Tiếp tục |
| Submit answer | Trả lời |
| Retry question | Con thử lại nhé. |
| Correct variants | Chính xác! / Giỏi lắm! / Tuyệt vời! |
| Pass | Con đã mở màn mới! |
| Retry gate | Con sắp mở được rồi! |
| Retry action | Thử lại |
| Return | Về bản đồ |
| Pause title | Tạm dừng |
| Adult area | Góc người lớn |
| Reset | Xóa tiến độ |
| Data fallback | Mình thử lại nhé! |

Any new child-facing copy must be reviewed for vocabulary level, length and tone before becoming canonical.

## 11. Motion

- UI response: 80–140 ms.
- Panel transitions: 180–240 ms.
- Reward/unlock: 500–900 ms, skippable by tap after the key state is visible.
- Avoid flashing, camera shake and continuous decorative motion behind a math question.
- Respect a future reduced-motion setting by keeping state changes understandable without animation.

## 12. Design acceptance

- All DES states are reachable in the prototype without editing URL or code.
- The full gameplay → quiz → result → next-level loop is clickable.
- No text overlap at both reference sizes, including longest labels.
- Correct, incorrect, locked and disabled states remain understandable in grayscale.
- A new tester can identify **Chơi**, enter one answer, correct it and submit it.
- Every non-placeholder asset has source and license metadata.
- Prototype makes no network request and contains no real child data.
