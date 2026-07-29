# Hành Trình Sao Toán

Bộ tài liệu này là đầu vào cho Claude Code để thiết kế giao diện và sau đó phát triển game Android bằng Godot.

## Bắt đầu với Claude Code

1. Mở terminal tại root của project.
2. Chạy `claude`.
3. Claude Code tự đọc `CLAUDE.md` và các tài liệu được import.
4. Gửi nội dung trong `CLAUDE_CODE_START_PROMPT.md` làm yêu cầu đầu tiên.
5. Chọn Direction A hoặc B trước khi Claude dựng toàn bộ prototype.

Giai đoạn hiện tại chỉ tạo prototype web local trong `prototype/`. Không yêu cầu Claude khởi tạo Godot cho tới khi prototype và design handoff được duyệt.

## Tài liệu chính

| File | Vai trò |
|---|---|
| `CLAUDE.md` | Chỉ dẫn tự động cho Claude Code |
| `APP_SPEC.md` | Yêu cầu sản phẩm và tiêu chí nghiệm thu |
| `UI_DESIGN_BRIEF.md` | Art direction, layout, copy và screen brief |
| `IMPLEMENTATION_PLAN.md` | Milestone thiết kế, phát triển và phát hành |
| `CLAUDE_CODE_START_PROMPT.md` | Prompt khởi động và prompt mở rộng prototype |
| `questions.math.vi.json` | Bộ 200 câu hỏi canonical |
| `docs/design/question-samples.json` | Mẫu nhỏ chỉ dùng khi thiết kế UI |
| `docs/design/design-tokens.json` | Token giao diện ban đầu |
| `docs/design/screen-flow.md` | Luồng điều hướng canonical |
| `docs/design/review-log.md` | Quyết định mở và issue thiết kế |

## Quyết định cần xác nhận trước full prototype

Các mục `UIR-001` đến `UIR-005` trong `docs/design/review-log.md`. Mặc định hiện tại là tên **Hành Trình Sao Toán** và visual **Direction A — Xưởng Khám Phá Sắc Màu**.

