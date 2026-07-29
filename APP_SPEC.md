# Đặc tả phát triển ứng dụng: Hành Trình Sao Toán

## 1. Tóm tắt sản phẩm

**Tên làm việc:** Hành Trình Sao Toán  
**Nền tảng:** Android  
**Ngôn ngữ chính:** Tiếng Việt  
**Đối tượng:** Học sinh lớp 2, khoảng 7 tuổi  
**Chế độ hoạt động:** Ngoại tuyến, không cần đăng nhập  
**Mục tiêu giai đoạn 1:** Luyện phép cộng và phép trừ trong phạm vi 100 thông qua các phiên chơi ngắn.

Ứng dụng kết hợp một trò chơi phản xạ đơn giản với các “cổng toán học”. Sau mỗi màn chơi, trẻ trả lời 10 câu hỏi. Đạt yêu cầu sẽ mở màn kế tiếp; chưa đạt có thể xem lại lỗi và thử lại ngay.

## 2. Nguyên tắc thiết kế

- Mỗi phiên kéo dài khoảng 5–10 phút.
- Điều khiển bằng một ngón tay, nút bấm lớn, ít chữ trên mỗi màn hình.
- Câu hướng dẫn ngắn, có thể đọc thành tiếng bằng âm thanh thu sẵn hoặc Android Text-to-Speech.
- Luôn khích lệ; không dùng hình phạt, đồng hồ gây áp lực hoặc thông báo làm trẻ xấu hổ.
- Không quảng cáo, không mua hàng trong ứng dụng, không trò chuyện, không liên kết ra ngoài trong khu vực của trẻ.
- Không thu thập tên thật, số điện thoại, vị trí hoặc dữ liệu cá nhân.
- Hoạt động hoàn toàn ngoại tuyến sau khi cài bằng tệp APK.

## 3. Ý tưởng trò chơi giai đoạn 1

### 3.1. Trò chơi chính: Bay Nhặt Sao

Người chơi điều khiển một phi thuyền hoạt hình trên ba làn đường:

- Vuốt trái/phải để đổi làn.
- Chạm để bay qua vật cản thấp.
- Nhặt sao để tăng điểm.
- Va vào vật cản chỉ làm mất một sao và tiếp tục chơi.
- Mỗi màn kéo dài 60–90 giây.
- Tốc độ tăng nhẹ theo màn nhưng không vượt mức phù hợp với trẻ 7 tuổi.

Trò chơi dùng hình khối và hiệu ứng 2D đơn giản để giữ APK nhẹ. Không cần vật lý phức tạp hoặc kết nối mạng.

### 3.2. Vòng lặp chơi

1. Trẻ chọn nút **Chơi**.
2. Chơi một màn Bay Nhặt Sao.
3. Mở **Cổng Toán Học** gồm 10 câu.
4. Trả lời đúng ít nhất 8/10 câu để mở màn tiếp theo.
5. Nếu dưới 8 câu đúng, hiển thị các phép tính cần xem lại và cho thử lại bằng một bộ 10 câu mới.
6. Thưởng sao, huy hiệu hoặc màu phi thuyền; không khóa tiến độ bằng tiền.

### 3.3. Các chủ đề màn chơi

- Màn 1–3: Bầu trời quê em.
- Màn 4–6: Đại dương vui nhộn.
- Màn 7–9: Khu rừng sắc màu.
- Màn 10: Vũ trụ ngôi sao.

Các chủ đề chỉ thay nền, vật cản và vật phẩm; cơ chế chơi giữ nguyên để trẻ không phải học lại thao tác.

## 4. Nội dung học tập

### 4.1. Phạm vi giai đoạn 1

- Cộng hai số có kết quả từ 0 đến 100.
- Trừ hai số trong phạm vi 100, không có kết quả âm.
- Có cả phép tính không nhớ và có nhớ/mượn.
- Trẻ nhập đáp án bằng bàn phím số lớn gồm 0–9, nút xóa và nút trả lời.
- Sau mỗi câu, phản hồi ngay:
  - Đúng: âm thanh vui, hiển thị phép tính hoàn chỉnh.
  - Sai: cho thử lần hai; sau đó hiện đáp án và lời giải ngắn.

### 4.2. Mức độ

| Mức | Phạm vi | Cách sử dụng |
|---|---|---|
| Dễ | Kết quả/số bị trừ trong 20 | Màn 1–3 |
| Vừa | Trong 50 | Màn 4–6 |
| Khó | Trong 100 | Màn 7–10 |

Bộ câu hỏi có 200 câu: 100 câu cộng và 100 câu trừ. Tệp dữ liệu ghi rõ mức độ, phép tính có nhớ/mượn, đáp án, gợi ý và lời giải.

### 4.3. Quy tắc chọn 10 câu

- Nạp toàn bộ câu hỏi từ `questions.math.vi.json`.
- Lọc theo mức độ của màn hiện tại.
- Một bộ gồm 5 câu cộng và 5 câu trừ.
- Trộn thứ tự bằng Fisher–Yates.
- Không lặp lại cùng `id` trong một phiên ứng dụng.
- Khi đã dùng hết nhóm phù hợp, xóa lịch sử của nhóm và trộn lại.
- Không đặt quá 3 câu có nhớ/mượn liên tiếp.
- Lưu danh sách ID đã dùng và tiến độ vào bộ nhớ cục bộ.
- Khi trẻ chọn **Chơi lại từ đầu**, có thể xóa lịch sử câu hỏi sau xác nhận của người lớn.

## 5. Màn hình và trải nghiệm

### 5.1. Màn hình chính

- Logo/tên trò chơi.
- Nút lớn **Chơi**.
- Nút biểu tượng loa để bật/tắt âm thanh.
- Nút **Góc người lớn**, bảo vệ bằng phép tính đơn giản hoặc nhấn giữ 3 giây.

### 5.2. Chọn màn

- Bản đồ ngang đơn giản với 10 màn.
- Màn đã mở có nút chơi; màn chưa mở có biểu tượng khóa.
- Hiển thị số sao tốt nhất, không có bảng xếp hạng trực tuyến.

### 5.3. Màn chơi

- Điểm sao ở góc trên.
- Nút tạm dừng bằng biểu tượng quen thuộc.
- Không có đoạn văn hướng dẫn trong lúc chơi.
- Lần đầu vào game có hướng dẫn thao tác bằng hình ảnh và giọng nói.

### 5.4. Cổng Toán Học

- Hiển thị tiến độ, ví dụ: **Câu 3/10**.
- Một phép tính lớn ở giữa.
- Bàn phím số ở nửa dưới màn hình.
- Có nút loa để nghe câu hỏi.
- Sau 10 câu, hiển thị số câu đúng, câu cần xem lại và nút tiếp tục/thử lại.

### 5.5. Góc người lớn

- Xem số màn đã hoàn thành.
- Xem tỷ lệ đúng tổng thể, phép cộng, phép trừ và câu có nhớ/mượn.
- Đặt âm lượng.
- Xóa tiến độ sau bước xác nhận.
- Giai đoạn sau có thể nhập tệp câu hỏi mới.

### 5.6. Thiết kế âm thanh

Âm thanh phải quen thuộc, ngắn, vui và không gây giật mình. Không dùng âm thanh có bản quyền không rõ nguồn gốc. Ưu tiên tự tạo, mua đúng giấy phép hoặc dùng tài nguyên CC0; lưu bằng chứng giấy phép trong `docs/licenses/audio/`.

#### Danh mục nhạc nền

| ID | Màn hình/sự kiện | Đặc điểm | Quy tắc phát |
|---|---|---|---|
| AUD-BGM-01 | Menu và bản đồ | Vui nhẹ, 90–110 BPM | Lặp mượt, không có giọng hát |
| AUD-BGM-02 | Bay Nhặt Sao | Năng động vừa phải, 110–125 BPM | Lặp 45–75 giây, không tăng tốc gây áp lực |
| AUD-BGM-03 | Cổng Toán Học | Êm, ít nhạc cụ | Âm lượng thấp hơn gameplay, giúp tập trung |
| AUD-BGM-04 | Kết quả | Đoạn nhạc tích cực | Phát một lần, tối đa 6 giây |

#### Danh mục hiệu ứng thông dụng

| ID/tên tệp đề xuất | Khi phát | Kiểu âm thanh | Thời lượng mục tiêu |
|---|---|---|---|
| AUD-SFX-01 `ui_tap` | Chạm nút | Click mềm | 50–120 ms |
| AUD-SFX-02 `game_start` | Bắt đầu màn | Whoosh tăng nhẹ | 0,5–1 giây |
| AUD-SFX-03 `countdown_tick` | Đếm 3, 2, 1 | Tick gỗ hoặc pop | 100–250 ms |
| AUD-SFX-04 `lane_move` | Đổi làn | Whoosh rất ngắn | 100–250 ms |
| AUD-SFX-05 `jump` | Phi thuyền nhảy/bay | Boing hoặc swoosh mềm | 200–450 ms |
| AUD-SFX-06 `star_collect` | Nhặt sao | Bell/chime sáng | 150–350 ms |
| AUD-SFX-07 `soft_hit` | Chạm vật cản | Thud mềm | 200–400 ms |
| AUD-SFX-08 `number_key` | Nhập số | Pop nhỏ | 40–100 ms |
| AUD-SFX-09 `answer_correct` | Trả lời đúng | Hai nốt đi lên | 0,5–1 giây |
| AUD-SFX-10 `answer_incorrect` | Trả lời sai | Hai nốt mềm, không dùng buzzer gắt | 0,4–0,8 giây |
| AUD-SFX-11 `level_complete` | Hoàn thành màn | Fanfare ngắn | 2–4 giây |
| AUD-SFX-12 `level_unlock` | Mở màn mới | Sparkle + click khóa | 1–2 giây |
| AUD-SFX-13 `badge_earned` | Nhận huy hiệu | Chime ba nốt | 1–2 giây |
| AUD-SFX-14 `pause_open` | Tạm dừng | Click hạ nhẹ | 100–250 ms |

#### Lời nói tiếng Việt

| ID | Nội dung dự kiến | Khi dùng |
|---|---|---|
| AUD-VO-01 | “Vuốt sang trái hoặc sang phải để đổi làn.” | Hướng dẫn lần đầu |
| AUD-VO-02 | “Chạm để bay qua vật cản.” | Hướng dẫn lần đầu |
| AUD-VO-03 | “Hãy trả lời mười câu hỏi để mở màn tiếp theo.” | Trước Cổng Toán Học đầu tiên |
| AUD-VO-04 | “Chính xác!” / “Giỏi lắm!” / “Tuyệt vời!” | Chọn ngẫu nhiên khi đúng |
| AUD-VO-05 | “Gần đúng rồi, con thử lại nhé.” | Lần trả lời sai đầu tiên |
| AUD-VO-06 | “Con đã mở được màn mới!” | Khi đạt từ 8/10 |

Giai đoạn đầu ưu tiên giọng người thu sẵn cho sáu câu cố định. Phần đọc phép tính có thể dùng Android Text-to-Speech tiếng Việt nếu thiết bị hỗ trợ; nếu không hỗ trợ thì game vẫn hoạt động đầy đủ bằng chữ.

#### Quy tắc kỹ thuật âm thanh

- Nhạc nền: OGG Vorbis, stereo, 44,1 kHz, 96–128 kbps.
- Hiệu ứng và giọng nói: OGG Vorbis mono, 44,1 kHz, 64–96 kbps.
- Có ba thanh âm lượng riêng: **Nhạc**, **Hiệu ứng**, **Giọng nói**; mặc định lần lượt 45%, 70%, 80%.
- Khi phát giọng nói, giảm nhạc nền khoảng 8–12 dB; khôi phục trong 300 ms sau khi giọng nói kết thúc.
- Không phát chồng nhiều lần cùng một hiệu ứng; `star_collect` giới hạn tối đa 6 lần/giây.
- Nút tắt âm thanh phải có hiệu lực ngay và được lưu trên thiết bị.
- Không dùng âm báo lỗi lớn, tiếng nổ, tiếng khóc hoặc âm thanh mang tính trừng phạt.

### 5.7. Tiêu chí nghiệm thu âm thanh

- AUD-AC-01: Tất cả 14 sự kiện có hiệu ứng đúng và không bị trễ cảm nhận quá 100 ms trên thiết bị mục tiêu.
- AUD-AC-02: Nhạc lặp không có khoảng im lặng hoặc tiếng “click” ở điểm nối.
- AUD-AC-03: Giọng nói nghe rõ khi nhạc nền đang phát.
- AUD-AC-04: Tắt từng nhóm âm thanh, thoát và mở lại ứng dụng vẫn giữ đúng cài đặt.
- AUD-AC-05: Chơi liên tục 15 phút không có âm bị chồng gây khó chịu hoặc vỡ tiếng.
- AUD-AC-06: Mọi tệp âm thanh có nguồn và giấy phép được ghi lại trước khi phát hành.

## 6. Yêu cầu chức năng

| Mã | Yêu cầu |
|---|---|
| FR-01 | Cài đặt và chạy ngoại tuyến trên Android. |
| FR-02 | Chơi trò Bay Nhặt Sao với thao tác chạm/vuốt. |
| FR-03 | Sau mỗi màn luôn mở bộ 10 câu toán. |
| FR-04 | Đúng ít nhất 8/10 để mở màn tiếp theo. |
| FR-05 | Chọn câu ngẫu nhiên và không lặp trong cùng phiên. |
| FR-06 | Đọc và kiểm tra tệp câu hỏi JSON khi khởi động. |
| FR-07 | Lưu tiến độ, điểm cao và thống kê trên thiết bị. |
| FR-08 | Hoạt động khi không có mạng hoặc tài khoản. |
| FR-09 | Hỗ trợ bật/tắt nhạc, hiệu ứng và giọng đọc. |
| FR-10 | Khôi phục an toàn nếu tệp dữ liệu lỗi bằng bộ câu hỏi mặc định đóng gói trong ứng dụng. |
| FR-11 | Điều chỉnh và lưu riêng âm lượng nhạc, hiệu ứng, giọng nói. |
| FR-12 | Giảm nhạc tự động khi phát lời nói tiếng Việt. |

## 7. Yêu cầu phi chức năng

| Mã | Yêu cầu đo được |
|---|---|
| NFR-01 | APK Phase 1 dưới 50 MB; mục tiêu 20–35 MB. |
| NFR-02 | Mục tiêu 60 FPS; tối thiểu 30 FPS ổn định trên thiết bị cấu hình thấp đã chọn. |
| NFR-03 | Từ chạm icon đến menu tương tác được trong dưới 3 giây trên thiết bị mục tiêu. |
| NFR-04 | Hỗ trợ từ Android 8/API 26; kiểm tra lại theo thiết bị lớp học thực tế. |
| NFR-05 | Không tràn hoặc chồng UI trên điện thoại 16:9, màn hình dài và máy tính bảng. |
| NFR-06 | Chữ lớn, tương phản rõ, không truyền đạt trạng thái chỉ bằng màu và có thể tắt âm. |
| NFR-07 | Tự lưu sau mỗi màn và mỗi bộ câu hỏi; file lỗi không làm mất khả năng khởi động. |
| NFR-08 | Phase 1 chỉ lưu dữ liệu cục bộ, không truyền dữ liệu khỏi thiết bị. |
| NFR-09 | Phản hồi âm thanh thao tác trong tối đa 100 ms trên thiết bị mục tiêu và không clipping. |
| NFR-10 | Chơi liên tục 30 phút không crash và không tăng bộ nhớ không giới hạn. |
| NFR-11 | Phase 1 dùng landscape cố định; hỗ trợ 16:9, màn hình dài và tablet mà không đổi orientation giữa phiên. |

## 8. Kiến trúc đề xuất

### 8.1. Công nghệ

**Khuyến nghị:** Godot 4.x với GDScript, xuất Android APK.

Lý do: phù hợp game 2D, mã nguồn mở, APK có thể giữ nhẹ, hỗ trợ cảm ứng/âm thanh tốt và dễ thêm trò chơi nhỏ trong các giai đoạn sau. Dùng renderer Compatibility và tài nguyên 2D nén để hỗ trợ thiết bị yếu.

### 8.2. Cấu trúc mô-đun

- `MainMenu`: màn hình chính và thiết lập.
- `LevelMap`: khóa/mở màn và điểm sao.
- `RunnerGame`: điều khiển, sinh vật cản, điểm.
- `QuizGate`: chọn câu, nhập đáp án, phản hồi.
- `QuestionRepository`: đọc/kiểm tra JSON và trộn câu.
- `ProgressService`: lưu tiến độ và thống kê cục bộ.
- `AudioService`: nhạc, hiệu ứng, giọng đọc.
- `AdultDashboard`: báo cáo đơn giản cho phụ huynh/giáo viên.

### 8.3. Lưu trữ

- Câu hỏi mặc định: `res://data/questions.math.vi.json`.
- Tiến độ: tệp JSON hoặc ConfigFile trong `user://`.
- Không dùng máy chủ trong giai đoạn 1.
- Tệp câu hỏi phải được kiểm tra: ID duy nhất, toán tử hợp lệ, số trong phạm vi, đáp án đúng và không có phép trừ âm.
- Tài nguyên âm thanh: `res://assets/audio/{bgm,sfx,voice}/`; metadata nguồn và giấy phép nằm trong `docs/licenses/audio/`.

## 9. Định dạng dữ liệu câu hỏi

Mỗi mục trong `questions.math.vi.json` có:

- `id`: mã duy nhất.
- `operation`: `addition` hoặc `subtraction`.
- `difficulty`: 1, 2 hoặc 3.
- `operand_a`, `operand_b`: hai số của phép tính.
- `operator`: ký hiệu hiển thị.
- `prompt`: câu hỏi tiếng Việt.
- `answer`: đáp án số.
- `requires_regrouping`: cộng có nhớ hoặc trừ có mượn.
- `hint`: gợi ý ngắn.
- `explanation`: lời giải hiển thị sau khi trả lời.

Không lưu sẵn đáp án nhiễu vì trẻ sẽ nhập số. Trong tương lai, nếu thêm dạng trắc nghiệm, ứng dụng nên tạo đáp án nhiễu hợp lệ từ đáp án thật và không trùng nhau.

### 9.1. Yêu cầu dữ liệu

| Mã | Yêu cầu |
|---|---|
| DATA-01 | Tệp có đúng 200 câu và `question_count` khớp số phần tử thực tế. |
| DATA-02 | Mọi `id` và biểu thức là duy nhất trong bộ dữ liệu. |
| DATA-03 | Có đúng 100 câu cộng và 100 câu trừ; mỗi phép toán chia mức 34/33/33. |
| DATA-04 | Đáp án được tính lại từ toán hạng, nằm trong 0–100 và phép trừ không âm. |
| DATA-05 | Trường `requires_regrouping` phải khớp quy tắc có nhớ/mượn. |
| DATA-06 | Lỗi schema phải được ghi log và chuyển sang bộ câu hỏi dự phòng an toàn. |
| DATA-07 | Mọi lần thay đổi tệp câu hỏi phải chạy validator tự động trước khi tạo build. |

## 10. Phạm vi phát hành đầu tiên

### Bao gồm

- 10 màn Bay Nhặt Sao.
- 200 câu hỏi toán tiếng Việt.
- Cổng 10 câu sau mỗi màn.
- Mở khóa màn, điểm sao, âm thanh và thống kê cục bộ.
- Một APK có thể chép và cài trực tiếp.

### Chưa bao gồm

- Tài khoản, đồng bộ đám mây hoặc bảng xếp hạng.
- Quảng cáo hoặc thanh toán.
- Chế độ nhiều người chơi.
- Công cụ soạn câu hỏi ngay trong ứng dụng.
- Nội dung tiếng Việt môn học trong giai đoạn 1.

## 11. Hướng mở rộng

Thiết kế `QuestionRepository` theo trường `subject` và `skill` để sau này thêm:

- Toán: nhân/chia cơ bản, hình học, đo lường, bài toán có lời văn.
- Tiếng Việt: chính tả, ghép vần, từ loại, đọc hiểu ngắn.
- Trò chơi nhỏ khác: ghép cặp, kéo-thả, mê cung, sắp xếp từ.
- Nhập gói nội dung do giáo viên chuẩn bị mà không sửa mã nguồn.

## 12. Tiêu chí nghiệm thu

- APK cài được từ tệp và chạy khi tắt mạng.
- Trẻ có thể hoàn thành hướng dẫn mà không cần đọc đoạn văn dài.
- Kết thúc mọi màn đều xuất hiện đúng 10 câu.
- Mỗi bộ có đúng 5 câu cộng và 5 câu trừ.
- Không câu nào lặp trong cùng phiên trước khi hết nhóm phù hợp.
- Tất cả 200 đáp án được kiểm tra tự động và đúng trong phạm vi 100.
- Đạt 8/10 mở màn kế; dưới 8/10 không mở nhưng cho thử lại.
- Thoát ứng dụng giữa chừng không làm mất tiến độ đã hoàn thành.
- Không có quảng cáo, liên kết ngoài hoặc thu thập dữ liệu cá nhân.
- Giao diện không tràn chữ trên điện thoại nhỏ và máy tính bảng.
- Toàn bộ tiêu chí AUD-AC-01 đến AUD-AC-06 đạt trên ít nhất một điện thoại và một máy tính bảng mục tiêu.

## 13. Phát triển theo đặc tả (Spec-Driven Development)

### 13.1. Bộ tài liệu kiểm soát

Thứ tự ưu tiên khi có mâu thuẫn:

1. `APP_SPEC.md`: hành vi sản phẩm và tiêu chí nghiệm thu.
2. `questions.math.vi.json`: nội dung câu hỏi thực tế.
3. `IMPLEMENTATION_PLAN.md`: thứ tự và phạm vi triển khai.
4. `docs/adr/ADR-xxx.md`: quyết định kiến trúc và lý do.
5. Mã nguồn và test tự động.

Mỗi yêu cầu phải có ID ổn định: `FR-*` cho chức năng, `NFR-*` cho phi chức năng, `AUD-*` cho âm thanh, `DATA-*` cho dữ liệu, `GP-*` cho Google Play. Không triển khai yêu cầu mới chỉ từ trao đổi miệng; trước tiên phải bổ sung ID, hành vi và tiêu chí nghiệm thu vào đặc tả.

### 13.2. Luồng từ đặc tả đến mã nguồn

1. Viết hoặc cập nhật yêu cầu và trường hợp biên.
2. Viết kịch bản nghiệm thu theo dạng **Given/When/Then**.
3. Gắn yêu cầu vào task trong `IMPLEMENTATION_PLAN.md`.
4. Viết test đơn vị/tích hợp trước hoặc cùng lúc với mã triển khai.
5. Chạy test, xuất build thử và kiểm tra trên thiết bị thật.
6. Cập nhật bảng truy vết; yêu cầu chỉ hoàn tất khi có bằng chứng test.

Ví dụ cho FR-04:

```gherkin
Given trẻ đang ở màn 3 và màn 4 chưa mở
When trẻ hoàn thành bộ câu hỏi với 8 đáp án đúng
Then màn 4 được mở
And tiến độ được lưu trên thiết bị
```

Trường hợp biên bắt buộc: 7/10 không mở màn; 8/10 mở màn; thoát ngay sau kết quả và mở lại vẫn giữ trạng thái.

### 13.3. Definition of Ready

Một yêu cầu sẵn sàng phát triển khi có: ID, mục đích, luồng chính, trường hợp biên, dữ liệu đầu vào/đầu ra, tiêu chí nghiệm thu đo được, mockup nếu liên quan giao diện và phụ thuộc đã xác định.

### 13.4. Definition of Done

Một yêu cầu hoàn tất khi: mã đã review, test liên quan đạt, không có lỗi nghiêm trọng, chạy được ngoại tuyến, kiểm tra trên thiết bị mục tiêu, tài nguyên có giấy phép, đặc tả/bảng truy vết được cập nhật và có build dùng thử.

### 13.5. Bảng truy vết tối thiểu

| Yêu cầu | Thành phần | Test bắt buộc |
|---|---|---|
| FR-03, FR-04 | `QuizGate`, `ProgressService` | Quiz flow + persistence integration test |
| FR-05, FR-06 | `QuestionRepository` | Shuffle, no-repeat, schema validation unit tests |
| FR-07 | `ProgressService` | Save/load/corrupt-file recovery tests |
| FR-09, FR-11, FR-12 | `AudioService` | Audio settings persistence + ducking device tests |
| NFR hiệu năng | `RunnerGame` | 15 phút soak test và đo FPS |
| GP-01 đến GP-12 | Android export + Play Console | Pre-review và closed-test evidence |

## 14. Kế hoạch triển khai

Kế hoạch chi tiết, thứ tự task, đầu ra và điều kiện kết thúc nằm trong [`IMPLEMENTATION_PLAN.md`](./IMPLEMENTATION_PLAN.md).

Ước tính Phase 1: 5–7 tuần cho một lập trình viên khi đã có hình ảnh và âm thanh. Phase 2 cần thêm tối thiểu 3–5 tuần theo lịch, chủ yếu vì chuẩn bị hồ sơ và thời gian closed test bắt buộc của tài khoản cá nhân mới.

## 15. Phase 2: Phát hành trên Google Play

Phần này áp dụng cho Google Play vì sản phẩm là Android. Các yêu cầu dưới đây được kiểm tra ngày **29/07/2026** và phải được xác nhận lại trong Play Console ngay trước ngày gửi duyệt.

### 15.1. Tài khoản nhà phát triển

- GP-01: Tạo Play Console account, chấp nhận thỏa thuận và trả phí đăng ký một lần 25 USD.
- GP-02: Chọn đúng loại tài khoản: **Personal** nếu phát hành cá nhân; **Organization** nếu đứng tên công ty/trường học. Organization cần D-U-N-S và hồ sơ tổ chức; quá trình lấy D-U-N-S có thể mất nhiều tuần.
- GP-03: Xác minh danh tính, email, số điện thoại và thông tin thanh toán. Tài khoản Personal mới phải xác minh bằng thiết bị Android vật lý không root, Android 10 trở lên, qua ứng dụng Play Console.
- GP-04: Chọn package name ổn định, ví dụ `vn.<tennhaphattrien>.hanhtrinhsao`; package name là duy nhất và không thể tái sử dụng sau khi đăng ký.

### 15.2. Build phát hành

- GP-05: Xuất **Android App Bundle (`.aab`)** để tải lên Google Play; vẫn xuất APK ký số riêng cho cài trực tiếp ở Phase 1.
- GP-06: Bật Play App Signing, giữ an toàn upload key và có bản sao lưu ngoại tuyến.
- GP-07: Tăng `versionCode` cho mọi bản cập nhật; dùng Semantic Version cho `versionName`.
- GP-08: Nếu gửi từ 31/08/2026, target Android 16/API 36 trở lên. `minSdk` có thể giữ Android 8/API 26 nếu test thực tế đạt.
- GP-09: Không khai báo quyền mạng, vị trí, camera, micro, danh bạ hoặc Advertising ID nếu tính năng hiện tại không cần. Kiểm tra cả quyền do SDK bên thứ ba tự thêm.

### 15.3. Chính sách dành cho trẻ em

- GP-10: Khai đúng nhóm tuổi mục tiêu trong **Target audience and content**; ứng dụng cho trẻ 7 tuổi phải tuân thủ Families Policy.
- GP-11: Không truyền AAID hoặc các định danh thiết bị bị cấm; không yêu cầu vị trí chính xác. Thiết kế hiện tại không quảng cáo, không đăng nhập và không có SDK phân tích là lựa chọn rủi ro thấp nhất.
- GP-12: Hoàn thành bảng IARC Content Rating, khai tình trạng quảng cáo và cung cấp hướng dẫn truy cập nếu Play review cần.
- GP-13: Hoàn thành Data Safety cho cả closed/open/production track. Dù không thu thập dữ liệu vẫn phải khai biểu mẫu chính xác.
- GP-14: Có Privacy Policy bằng tiếng Việt trên URL công khai, không phải PDF, không bị giới hạn vùng; đồng thời hiển thị nội dung hoặc liên kết trong **Góc người lớn**. Chính sách phải ghi tên ứng dụng/nhà phát triển, dữ liệu được xử lý, thời gian lưu, cách xóa và địa chỉ liên hệ.
- GP-15: Mọi SDK thêm sau này phải được kiểm tra chính sách trẻ em; nếu thêm quảng cáo chỉ dùng SDK thuộc chương trình Families và cần cập nhật lại toàn bộ khai báo. Phase 2 ban đầu vẫn không quảng cáo.

### 15.4. Store listing

- GP-16: Chuẩn bị tên tối đa 30 ký tự, mô tả ngắn tối đa 80 ký tự và mô tả đầy đủ tối đa 4.000 ký tự; ngôn ngữ mặc định là tiếng Việt.
- GP-17: Chuẩn bị icon, feature graphic, ảnh chụp điện thoại/máy tính bảng và email hỗ trợ. Kích thước/tỷ lệ tài sản phải kiểm tra lại trên trang Preview assets tại thời điểm tải lên.
- GP-18: Ảnh chụp phải thể hiện gameplay và câu hỏi thật, không dùng hình ảnh hoặc tuyên bố gây hiểu nhầm.

### 15.5. Kiểm thử và phát hành

- GP-19: Chạy internal test trước để kiểm tra cài đặt, cập nhật và Android Vitals.
- GP-20: Với tài khoản Personal tạo sau 13/11/2023, chạy closed test có ít nhất 12 người tham gia liên tục 14 ngày, sau đó nộp đơn xin Production access và trả lời câu hỏi về quá trình test.
- GP-21: Sửa toàn bộ crash/ANR nghiêm trọng, hoàn thành pre-review checks và xử lý cảnh báo chính sách trước khi production.
- GP-22: Phát hành production theo staged rollout nếu Play Console hỗ trợ; theo dõi crash, ANR và phản hồi sau phát hành.

### 15.6. Tài liệu Google chính thức

- [Tạo và thiết lập ứng dụng](https://support.google.com/googleplay/android-developer/answer/9859152?hl=en)
- [Yêu cầu closed test cho tài khoản Personal mới](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en)
- [Yêu cầu target API](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en)
- [Google Play Families Policy](https://support.google.com/googleplay/android-developer/answer/9893335?hl=en)
- [Data Safety](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en)
- [User Data và Privacy Policy](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en)
- [Android App Bundle và Play App Signing](https://developer.android.com/guide/app-bundle/faq)
