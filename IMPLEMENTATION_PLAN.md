# Implementation Plan: Hành Trình Sao Toán

## 1. Mục tiêu và cách dùng

Tài liệu này chuyển `APP_SPEC.md` thành các phần việc có thể triển khai và kiểm chứng. Mọi task phải tham chiếu ít nhất một ID yêu cầu. Nếu hành vi cần thay đổi, cập nhật đặc tả trước rồi mới sửa mã.

Hai mốc phát hành:

- **Phase 1:** APK nhẹ, cài trực tiếp, chạy hoàn toàn ngoại tuyến.
- **Phase 2:** Android App Bundle phát hành trên Google Play và tuân thủ chính sách trẻ em.

## 2. Công cụ và cấu trúc dự án

- Engine: Godot 4.x, GDScript, renderer Compatibility.
- Kiểm thử: GUT hoặc framework test GDScript tương đương; script kiểm tra JSON chạy trong CI.
- Phiên bản: Git, nhánh tính năng ngắn, pull request hoặc review trước khi gộp.
- Build: debug APK cho phát triển; signed release APK cho Phase 1; signed AAB cho Phase 2.

```text
project/
├── assets/
│   ├── audio/{bgm,sfx,voice}/
│   ├── fonts/
│   └── images/
├── data/questions.math.vi.json
├── scenes/{menu,map,runner,quiz,adult}/
├── scripts/{core,gameplay,quiz,services}/
├── tests/{unit,integration,fixtures}/
└── docs/{adr,licenses,qa,release}/
```

## 3. Hướng dẫn dùng Claude cho thiết kế giao diện

### 3.1. Vai trò của Claude trong dự án

Dùng **Claude Code** với file `CLAUDE.md` ở root để tạo prototype giao diện local, thử nhanh luồng màn hình và so sánh các phương án. Prototype là tài liệu thiết kế; không nhúng Claude, API hoặc mã web vào APK production. Giao diện cuối cùng vẫn được triển khai bằng Godot theo `APP_SPEC.md`. Claude Artifacts có thể dùng bổ sung để chia sẻ prototype nhưng không phải đầu ra bắt buộc.

Claude được phép hỗ trợ:

- Tạo 2–3 hướng visual khác nhau từ cùng một screen brief.
- Tạo prototype web local có thể bấm cho menu, bản đồ, gameplay HUD, quiz và kết quả.
- Đề xuất design token, component states, microcopy tiếng Việt và asset manifest.
- Phân tích screenshot sau mỗi vòng review và sửa prototype.

Claude không được tự quyết định:

- Thay đổi luật 10 câu, ngưỡng 8/10, độ khó hoặc nội dung học tập.
- Thêm quảng cáo, tài khoản, thu thập dữ liệu, liên kết ngoài hoặc cơ chế mua hàng.
- Dùng hình/nhạc lấy trên mạng mà không ghi rõ nguồn và giấy phép.
- Dùng prototype web làm bằng chứng duy nhất rằng UI hoạt động tốt trên Android.

Tài liệu Anthropic tham khảo: [What are artifacts and how do I use them?](https://support.anthropic.com/en/articles/9487310-what-are-artifacts-and-how-do-i-use-them) và [Use artifacts to visualize and create apps](https://support.anthropic.com/articles/11649427-use-artifacts-to-visualize-and-create-ai-apps-without-ever-writing-a-line-of-code).

### 3.2. Chuẩn bị đầu vào cho Claude

Chạy Claude Code từ root của repo để nó tự nạp `CLAUDE.md`. Các tài liệu đầu vào chuẩn là:

- `APP_SPEC.md`, đặc biệt mục 2–5, yêu cầu NFR-05/NFR-06 và tiêu chí nghiệm thu.
- `UI_DESIGN_BRIEF.md`, `docs/design/screen-flow.md` và `docs/design/design-tokens.json`.
- `CLAUDE_CODE_START_PROMPT.md` cho lượt thiết kế đầu tiên.
- Một bản mẫu 20–30 câu từ `questions.math.vi.json`; không cần tải toàn bộ nếu prototype chỉ minh họa.
- Danh sách màn hình, trạng thái và kích thước thiết bị mục tiêu.
- Ảnh/logo đã có cùng file ghi nguồn, giấy phép; chỉ dùng mock asset nếu chưa chốt art.
- Quy ước bàn giao trong mục 3.6.

Không cung cấp cho Claude tên, ảnh, giọng nói, kết quả học tập hoặc dữ liệu thật của trẻ. Khi cần minh họa thống kê, dùng dữ liệu giả như “Bé Sao”, 8/10 và 120 ngôi sao.

### 3.3. Danh sách màn hình Claude phải thiết kế

| Mã design | Màn hình/trạng thái |
|---|---|
| DES-01 | Menu chính: Chơi, âm thanh, Góc người lớn |
| DES-02 | Bản đồ 10 màn: đã mở, đang chọn, bị khóa, số sao |
| DES-03 | Hướng dẫn lần đầu: vuốt đổi làn và chạm để bay |
| DES-04 | Gameplay HUD: điểm sao, pause, phản hồi va chạm |
| DES-05 | Pause: tiếp tục, chơi lại, về bản đồ |
| DES-06 | Cổng Toán Học: câu 1/10, bàn phím số, nghe câu hỏi |
| DES-07 | Trả lời đúng, sai lần một, sai lần hai và hiện lời giải |
| DES-08 | Kết quả đạt 8–10/10 và mở màn mới |
| DES-09 | Kết quả dưới 8/10 và luồng thử lại |
| DES-10 | Góc người lớn, thống kê, âm lượng và xác nhận xóa dữ liệu |
| DES-11 | Trạng thái lỗi dữ liệu câu hỏi và fallback an toàn |

Mỗi màn phải có bản mặc định, trạng thái nhấn/disabled/focus cần thiết và ít nhất hai kích thước: điện thoại landscape nhỏ 960×540 và tablet landscape 1280×800. Prototype phải scale trong trình duyệt nhưng giữ đúng tỷ lệ và safe area.

### 3.4. Master prompt cho Claude Design

Dùng nội dung tương đương trong `CLAUDE_CODE_START_PROMPT.md`. Prompt đầy đủ tham khảo:

```text
Bạn là product designer và UI prototyper cho game Android giáo dục
“Hành Trình Sao Toán”, dành riêng cho trẻ em Việt Nam lớp 2, khoảng 7 tuổi.

Hãy đọc APP_SPEC.md và coi các requirement ID, luật gameplay và tiêu chí
nghiệm thu trong đó là nguồn sự thật. Không tự thêm quảng cáo, đăng nhập,
chat, mua hàng, liên kết ngoài hoặc thu thập dữ liệu.

Nhiệm vụ vòng này:
1. Tạo prototype web local tương tác mô phỏng các màn DES-01 đến DES-11.
2. Dùng tiếng Việt tự nhiên, câu ngắn, từ quen thuộc với trẻ 7 tuổi.
3. Thiết kế landscape cho Android phone 960x540 và tablet 1280x800.
4. Nút chạm tối thiểu 48dp; phép tính và đáp án là điểm nhìn chính của quiz.
5. Không dùng đoạn văn hướng dẫn dài. Dùng icon quen thuộc kèm nhãn khi cần.
6. Trạng thái đúng phải tích cực; trạng thái sai phải nhẹ nhàng, không dùng
   màu đỏ hoặc buzzer như hình phạt.
7. Palette có nhiều nhóm màu cân bằng, tương phản rõ, không chỉ dựa vào màu
   để truyền đạt trạng thái. Không dùng gradient/orb trang trí hoặc card lồng card.
8. HUD phải gọn, không che gameplay; mọi text phải vừa ở cả hai kích thước.
9. Dùng dữ liệu giả, không dùng dữ liệu trẻ em thật.

Trước khi dựng prototype, hãy trả về:
- hai hướng visual ngắn gọn;
- design tokens sơ bộ;
- sơ đồ luồng màn hình;
- các giả định cần xác nhận.

Sau khi tôi chọn một hướng, hãy dựng prototype có thể bấm, bao gồm toàn bộ
trạng thái loading, locked, correct, retry, pause và result. Cuối cùng xuất
UI inventory, design tokens, asset manifest và danh sách điểm chưa chắc chắn.
Không coi mã HTML/CSS/JS của prototype là mã production Godot.
```

### 3.5. Vòng lặp thiết kế với Claude

1. **Explore:** yêu cầu hai hướng visual; chọn một hướng theo độ rõ, phù hợp trẻ 7 tuổi và khả năng dựng nhẹ trong Godot.
2. **Vertical prototype:** chỉ làm DES-01, DES-04, DES-06 và DES-08 trước để kiểm tra ngôn ngữ thiết kế và vòng gameplay → quiz → unlock.
3. **Review:** chụp từng màn ở 960×540 và 1280×800; ghi issue bằng mã `UIR-xxx` với mức Blocker/Major/Minor.
4. **Iterate:** yêu cầu Claude sửa theo từng `UIR-xxx`, không dùng prompt chung như “làm đẹp hơn”. Mỗi vòng lưu commit/snapshot riêng.
5. **Complete flow:** mở rộng tới DES-01–DES-11 và tất cả trạng thái.
6. **Child usability:** cho 3–5 trẻ dùng prototype với người lớn giám sát; quan sát trẻ tìm nút Chơi, hiểu câu hỏi, sửa đáp án và trở lại game. Không hỏi hoặc lưu thông tin cá nhân.
7. **Handoff:** đóng băng version được duyệt, xuất tài liệu mục 3.6 rồi mới dựng Godot.

Prompt review mẫu:

```text
Giữ nguyên style và component API của prototype hiện tại. Sửa đúng các issue:
- UIR-012 Major: nút “Trả lời” quá nhỏ ở viewport 960x540; tăng vùng chạm
  lên tối thiểu 48dp nhưng không đẩy bàn phím khỏi safe area.
- UIR-013 Major: trạng thái sai chỉ đổi màu; thêm icon và câu “Con thử lại nhé”.
- UIR-014 Minor: rút “Quay trở lại bản đồ” thành “Về bản đồ”.

Sau khi sửa, liệt kê màn hình/component bị ảnh hưởng và không thay đổi các
màn khác nếu không cần thiết.
```

### 3.6. Gói bàn giao từ Claude sang Godot

Lưu kết quả được duyệt trong repo:

```text
prototype/
├── index.html
├── styles.css
└── app.js
docs/design/
├── ui-spec.md
├── screen-flow.md
├── design-tokens.json
├── component-inventory.md
├── asset-manifest.csv
├── review-log.md
└── screenshots/{phone,tablet}/
```

`design-tokens.json` tối thiểu có palette, typography, spacing, corner radius, touch target, icon size và animation duration. `component-inventory.md` mô tả button, numeric keypad, progress, modal, HUD và trạng thái. `asset-manifest.csv` có tên asset, mục đích, kích thước, format, nguồn, tác giả và giấy phép.

Godot developer phải dựng component native từ token/spec, không sao chép mù CSS pixel. Sau khi dựng, chụp đúng hai viewport và so sánh với bản duyệt; mọi sai khác có chủ ý phải ghi trong `review-log.md`.

### 3.7. Điều kiện duyệt thiết kế

- DES-01 đến DES-11 và mọi trạng thái đã có trong prototype.
- Trẻ test có thể bắt đầu chơi và trả lời một câu mà không cần người lớn chỉ vị trí nút.
- Không có text tràn/chồng ở 960×540 và 1280×800.
- Nút tương tác đạt tối thiểu 48dp và không đặt sát nhau gây bấm nhầm.
- Quiz đọc được trong dưới 3 giây; đáp án nhập và sửa được rõ ràng.
- Đúng/sai được thể hiện bằng icon + chữ + âm thanh, không chỉ bằng màu.
- Asset manifest không có tài nguyên thiếu nguồn hoặc giấy phép.
- Prototype không chứa dữ liệu trẻ em thật, chạy không cần backend và không trở thành dependency runtime.

## 4. Phase 1: APK ngoại tuyến

### Milestone 0 — Chốt đặc tả và thiết bị (2–3 ngày)

**Task**

- SDD-001: Review `APP_SPEC.md`, xác nhận ngưỡng 8/10, 10 màn và điều khiển ba làn.
- SDD-002: Chọn tối thiểu hai thiết bị test: điện thoại Android 8/10 cấu hình thấp và máy tính bảng Android 12+.
- SDD-003: Tạo ADR-001 cho Godot/renderer; ADR-002 cho lưu tiến độ cục bộ; ADR-003 cho chiến lược giọng đọc.
- SDD-004: Tạo bảng traceability ban đầu từ FR/NFR/AUD đến test ID.
- DES-T01: Chạy Claude Code tại root, xác nhận `CLAUDE.md` đã được nạp và dùng `CLAUDE_CODE_START_PROMPT.md`.
- DES-T02: Chọn một trong hai hướng visual; ghi quyết định vào `docs/design/review-log.md`.

**Đầu ra:** đặc tả được duyệt, danh sách thiết bị, ba ADR, test matrix và visual direction được duyệt.  
**Điều kiện kết thúc:** không còn yêu cầu Phase 1 thiếu tiêu chí nghiệm thu.

### Milestone 1 — Nền tảng chạy được (Tuần 1)

**Task**

- DEV-001: Khởi tạo Godot project ở landscape cố định theo NFR-11; cấu hình stretch/safe area cho phone và tablet.
- DEV-002: Tạo scene router và các màn hình placeholder.
- DEV-003: Cài `ProgressService` với schema version và ghi tệp an toàn.
- DEV-004: Cài `QuestionRepository`, validate toàn bộ 200 câu khi khởi động.
- DEV-005: Thiết lập CI kiểm tra parse JSON, đáp án, ID và biểu thức trùng.

**Test:** UT-DATA-001 đến 006 cho schema, đáp án, phạm vi, ID, fallback và shuffle.  
**Điều kiện kết thúc:** mở app → menu → quiz giả lập; tiến độ sống qua lần khởi động lại; mọi test dữ liệu đạt.

### Milestone 2 — Vertical slice một màn (Tuần 2)

**Task**

- DEV-010: Điều khiển đổi ba làn, nhảy/bay và vùng va chạm.
- DEV-011: Sinh sao/vật cản từ pool để tránh tạo node liên tục.
- DEV-012: Một màn 60–90 giây với bắt đầu, tạm dừng và kết thúc.
- DEV-013: HUD điểm sao và hướng dẫn lần đầu.
- DEV-014: Tích hợp hiệu ứng `ui_tap`, `lane_move`, `jump`, `star_collect`, `soft_hit` dạng placeholder có giấy phép.
- DES-T10: Dùng Claude hoàn thiện vertical prototype DES-01, DES-04, DES-06 và DES-08.
- DES-T11: Export screenshot hai viewport và xử lý toàn bộ `UIR-*` Blocker/Major trước khi dựng UI Godot tương ứng.

**Test:** IT-GAME-001 cho vòng đời màn; DT-GAME-001 cho cảm ứng; kiểm tra 15 phút không tăng bộ nhớ bất thường.  
**Điều kiện kết thúc:** một trẻ/người test mới hiểu thao tác sau hướng dẫn; FPS tối thiểu 30 ổn định trên thiết bị thấp.

### Milestone 3 — Cổng Toán Học hoàn chỉnh (Tuần 3)

**Task**

- DEV-020: Chọn đúng 5 câu cộng + 5 câu trừ theo độ khó.
- DEV-021: Fisher–Yates shuffle, lịch sử không lặp và reset khi hết nhóm.
- DEV-022: Bàn phím số, xóa, gửi đáp án và giới hạn đầu vào 0–100.
- DEV-023: Hai lần thử, gợi ý, lời giải và tổng kết.
- DEV-024: Mở màn ở 8/10; lưu tiến độ ngay sau kết quả.
- DEV-025: Thêm hiệu ứng/giọng nói đúng-sai, ducking nhạc và nút nghe lại.

**Test:** UT-QUIZ-001 đến 010 cho chọn câu và tính điểm; IT-QUIZ-001 cho 7/10; IT-QUIZ-002 cho 8/10; IT-QUIZ-003 cho khởi động lại.  
**Điều kiện kết thúc:** toàn bộ luồng FR-03 đến FR-06 và AUD-AC-03 đạt.

### Milestone 4 — Nội dung 10 màn và âm thanh (Tuần 4)

**Task**

- DEV-030: Bản đồ 10 màn, khóa/mở và ba dải độ khó.
- DEV-031: Bốn chủ đề hình ảnh dùng chung atlas để giảm dung lượng.
- DEV-032: Cân bằng tốc độ, khoảng cách vật cản và tỷ lệ sao theo màn.
- DEV-033: Thu/chọn bốn nhạc nền, 14 hiệu ứng và sáu nhóm lời nói.
- DEV-034: Chuẩn hóa OGG, loop point, âm lượng; hoàn thành hồ sơ giấy phép.
- DEV-035: Cài ba thanh âm lượng và lưu cài đặt.
- DES-T20: Hoàn thiện prototype local cho DES-01–DES-11, gồm trạng thái âm lượng và phản hồi âm thanh.
- DES-T21: Xuất design token, component inventory, asset manifest và screenshot theo mục 3.6.

**Test:** toàn bộ AUD-AC; test mở lần lượt 10 màn; kiểm tra tài nguyên thiếu.  
**Điều kiện kết thúc:** chơi liền từ màn 1 qua ít nhất màn 3 không có lỗi luồng; không có tài nguyên chưa rõ giấy phép.

### Milestone 5 — Góc người lớn, accessibility và polish (Tuần 5)

**Task**

- DEV-040: Dashboard thống kê và cơ chế nhấn giữ 3 giây.
- DEV-041: Xóa tiến độ với hai bước xác nhận.
- DEV-042: Kiểm tra chữ tiếng Việt, font có dấu và vùng chạm tối thiểu.
- DEV-043: Kiểm tra tương phản, icon + nhãn, trạng thái tắt âm.
- DEV-044: Hoàn thiện trạng thái pause, app background/foreground và back button.
- DES-T30: So sánh screenshot Godot với bản Claude được duyệt ở hai viewport.
- DES-T31: Chạy child usability test; đưa issue về Claude để thử phương án sửa, sau đó áp dụng phương án được duyệt vào Godot.

**Test:** usability test có người lớn; thử luồng trên điện thoại nhỏ và tablet; test background/resume 20 lần.  
**Điều kiện kết thúc:** không tràn chữ, không mất tiến độ và không có đường dẫn trẻ tự thoát ra web.

### Milestone 6 — QA và APK Release Candidate (Tuần 6–7)

**Task**

- QA-001: Chạy regression theo traceability matrix.
- QA-002: Soak test 30 phút, kiểm tra FPS, memory, crash và âm thanh.
- QA-003: Cài/xóa/cập nhật APK ký số trên cả hai thiết bị mục tiêu.
- QA-004: Test hoàn toàn ở airplane mode.
- QA-005: Cho 3–5 trẻ dùng thử có người lớn giám sát; chỉ ghi nhận hành vi, không thu dữ liệu cá nhân.
- REL-001: Sửa lỗi mức Blocker/Critical; lập release notes và checksum APK.

**Điều kiện phát hành Phase 1**

- Tất cả tiêu chí mục 12 của `APP_SPEC.md` đạt.
- Không còn lỗi Blocker/Critical; lỗi Major phải có quyết định chấp nhận bằng văn bản.
- APK cài trực tiếp, ngoại tuyến, dung lượng dưới 50 MB.
- 200 câu hỏi vượt qua validator tự động.
- Traceability matrix có test evidence cho mọi FR và AUD.

## 5. Phase 2: Google Play

### Milestone 7 — Tài khoản và compliance (bắt đầu song song từ Tuần 3)

- GP-T01: Chọn Personal/Organization, tạo tài khoản và hoàn tất xác minh (GP-01 đến GP-03).
- GP-T02: Chốt package name và đăng ký ứng dụng (GP-04).
- GP-T03: Viết Privacy Policy, đưa lên URL công khai và thêm vào Góc người lớn (GP-14).
- GP-T04: Audit Android manifest và mọi SDK; xác nhận không có `AD_ID`, location hoặc quyền thừa.
- GP-T05: Chuẩn bị câu trả lời Data Safety, Target Audience, Ads, App Access và IARC.

**Điều kiện kết thúc:** Play Console không còn task account/compliance bắt buộc chưa hoàn thành trước khi tạo closed test.

### Milestone 8 — Store build và listing (3–5 ngày)

- GP-T10: Cấu hình export target API 36 nếu gửi từ 31/08/2026; build signed AAB.
- GP-T11: Bật Play App Signing và lưu upload key an toàn.
- GP-T12: Chuẩn bị tên, mô tả, icon, feature graphic, screenshots thật và email hỗ trợ.
- GP-T13: Upload internal track; chạy pre-review checks và test cài từ Play.

**Điều kiện kết thúc:** internal release cài/chạy được; listing và policy forms đầy đủ; không còn lỗi pre-review blocking.

### Milestone 9 — Closed test bắt buộc (ít nhất 14 ngày)

- GP-T20: Tuyển ít nhất 12 tester có Google Account; nên có 15–20 để dự phòng người rời test.
- GP-T21: Duy trì tối thiểu 12 người opted-in liên tục đủ 14 ngày.
- GP-T22: Thu phản hồi có cấu trúc về cài đặt, gameplay, quiz, âm thanh và crash; không thu dữ liệu trẻ em không cần thiết.
- GP-T23: Phát bản sửa lỗi qua closed track và ghi release notes.
- GP-T24: Chuẩn bị câu trả lời xin Production access: đối tượng, cách tuyển tester, mức độ tương tác, phản hồi và thay đổi đã thực hiện.

**Điều kiện kết thúc:** Play Console xác nhận đủ điều kiện và Production access được chấp thuận.

### Milestone 10 — Production và theo dõi (3–7 ngày cộng thời gian review)

- GP-T30: Chạy full regression trên đúng AAB release candidate.
- GP-T31: Gửi duyệt production; dùng managed publishing để kiểm soát thời điểm lên store.
- GP-T32: Phát hành theo staged rollout nếu khả dụng; theo dõi Android Vitals hằng ngày trong tuần đầu.
- GP-T33: Có quy trình hotfix: tăng `versionCode`, regression trọng yếu, upload và release notes.

**Điều kiện kết thúc:** ứng dụng có thể tìm/cài trên Google Play tại khu vực đã chọn, Data Safety/Privacy Policy hiển thị đúng và không có crash/ANR vượt ngưỡng Play Console.

## 6. Ma trận test tối thiểu

| Nhóm | Test | Môi trường |
|---|---|---|
| Dữ liệu | 200 câu đúng, duy nhất, trong 0–100 | CI mỗi commit |
| Quiz | 5 cộng + 5 trừ, no-repeat, 7/10 và 8/10 | Unit + integration |
| Lưu trữ | Save/load, file lỗi, nâng schema | Unit + thiết bị |
| Gameplay | Va chạm, pause/resume, pooling, FPS | Thiết bị thấp + tablet |
| Âm thanh | Latency, loop, ducking, mute persistence | Tai nghe + loa thiết bị |
| UI | Điện thoại nhỏ, màn hình dài, tablet | Screenshot + thao tác thật |
| Design handoff | Token, component, asset license, DES-01–DES-11 | Review prototype + repo artifacts |
| Offline | Airplane mode từ cài đặt đến hoàn thành màn | Release APK/AAB |
| Store | Cài mới, cập nhật, uninstall/reinstall | Internal/closed track |

## 7. Rủi ro và biện pháp

| Rủi ro | Tác động | Biện pháp |
|---|---|---|
| Thiếu 12 tester liên tục | Trễ Phase 2 ít nhất 14 ngày | Tuyển 15–20 tester trước khi RC hoàn tất |
| D-U-N-S chậm | Trễ tài khoản Organization | Bắt đầu từ tuần 1 hoặc dùng Personal nếu đúng tư cách |
| Godot export chưa hỗ trợ target API mới | Không upload AAB | Kiểm tra phiên bản Godot/Android template sớm, dành buffer nâng cấp |
| Tài nguyên âm thanh không rõ license | Không thể phát hành | Lưu URL, tác giả, license và ngày tải ngay khi nhận asset |
| SDK tự thu thập dữ liệu | Vi phạm Families/Data Safety | Không dùng SDK không cần thiết; audit manifest và Play SDK Index |
| Trẻ đoán bằng phản hồi lần hai | Giảm hiệu quả học | Ghi first-attempt accuracy riêng; hiển thị gợi ý sau lần sai đầu |
| Prototype đẹp nhưng khó dựng nhẹ trong Godot | Trễ hoặc tăng APK | Chọn visual direction theo feasibility; duyệt vertical slice trước full flow |
| Claude tự thay đổi luật sản phẩm | Prototype lệch spec | Luôn đính kèm spec, dùng requirement ID và review thay đổi theo `UIR-*` |

## 8. Nhịp báo cáo

- Mỗi tuần demo một build cài được, không chỉ demo trong editor.
- Mỗi milestone cập nhật: task hoàn thành, test evidence, lỗi mở, thay đổi đặc tả và dung lượng build.
- Không chuyển milestone khi điều kiện kết thúc chưa đạt, trừ khi có quyết định chấp nhận rủi ro được ghi trong ADR hoặc release note.
