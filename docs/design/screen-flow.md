# Screen Flow

```mermaid
flowchart TD
    A["DES-01 Menu"] -->|"Chơi"| B["DES-02 Bản đồ"]
    A -->|"Giữ 3 giây"| J["DES-10 Góc người lớn"]
    B -->|"Màn đầu tiên"| C["DES-03 Hướng dẫn"]
    B -->|"Chọn màn đã mở"| D["DES-04 Gameplay"]
    C --> D
    D -->|"Tạm dừng"| E["DES-05 Pause"]
    E -->|"Tiếp tục"| D
    E -->|"Về bản đồ"| B
    D -->|"Hết màn"| F["DES-06 Cổng Toán Học"]
    F --> G["DES-07 Phản hồi câu hỏi"]
    G -->|"Còn câu"| F
    G -->|"8-10 câu đúng"| H["DES-08 Kết quả đạt"]
    G -->|"0-7 câu đúng"| I["DES-09 Kết quả thử lại"]
    H -->|"Sang màn mới"| B
    I -->|"Thử lại"| F
    I -->|"Về bản đồ"| B
    F -->|"Dữ liệu lỗi"| K["DES-11 Fallback"]
    K -->|"Nạp được bộ dự phòng"| F
    K -->|"Thử lại"| F
    J -->|"Đóng"| A
```

## Navigation rules

- Android Back from gameplay opens Pause; it does not immediately leave the level.
- Android Back from quiz opens a confirmation because abandoning the gate discards current quiz answers.
- Android Back from Menu follows the normal Android exit behavior.
- Locked map nodes do not navigate; they provide lock feedback in place.
- After passing, progress is saved before DES-08 is shown.
- DES-11 never exposes stack traces or file paths to the child.
