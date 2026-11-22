# Thuật toán

Mỗi người viết mục thuật toán mình phụ trách. Công thức dưới đây đã đối chiếu với mã nguồn package `fsrs` 2.0.1 (port của py-fsrs commit `6fd0857`) và wiki awesome-fsrs/The-Algorithm (mục FSRS-6).

## FSRS-6 (leader)

**Ba biến của một thẻ**
- **D – Difficulty** (1–10): thẻ khó cỡ nào. Bấm Again/Hard làm D tăng, Easy làm D giảm.
- **S – Stability** (ngày): số ngày để xác suất nhớ tụt từ 100% xuống 90%.
- **R – Retrievability** (0–1): xác suất còn nhớ tại thời điểm t ngày sau lần ôn trước.

**Đường lãng quên** (w20 học được, mặc định 0.2):

R(t) = (1 + F · t / S)^(−w20), với F = 0.9^(−1/w20) − 1 (chọn F để R(S) = 0.9).

Đuôi của hàm này rất dài: thẻ S ≈ 13 ngày sau 10 năm vẫn còn R ≈ 0.44.

**Khoảng ôn tiếp theo** (r = tỉ lệ ghi nhớ mong muốn, mặc định 0.9):

I = round(S / F · (r^(−1/w20) − 1)), tối thiểu 1 ngày. Với r = 0.9 thì I = S.

**Lần ôn đầu** (G = rating 1–4):
- S₀ = w[G−1] (ví dụ Good → w2 = 3.2602 ngày).
- D₀ = w4 − e^(w5·(G−1)) + 1, kẹp trong [1, 10].

**Sau mỗi lần ôn**
- D mới: D + (10 − D)·(−w6·(G−3))/9 (tăng chậm dần khi đã gần 10), rồi kéo về D₀(Easy) với trọng số w7 (mean reversion).
- Nhớ (Hard/Good/Easy): S' = S · (1 + e^w8 · (11 − D) · S^(−w9) · (e^((1−R)·w10) − 1) · hard · easy), với hard = w15 nếu Hard, easy = w16 nếu Easy.
  - R càng thấp lúc ôn mà vẫn nhớ thì S tăng càng nhiều (hiệu ứng ngắt quãng).
  - S càng lớn thì tăng càng chậm (S^(−w9)); D càng cao thì tăng càng ít (11 − D).
- Quên (Again): S' = min(w11 · D^(−w12) · ((S+1)^w13 − 1) · e^((1−R)·w14), S / e^(w17·w18)).
- Ôn lại trong cùng ngày (FSRS-6 mới có): S' = S · e^(w17·(G − 3 + w18)) · S^(−w19).

**Trạng thái**: learning (bước 1 phút, 10 phút) → review → (quên) relearning (bước 10 phút) → review.

**Trong app**: `lib/data/srs/srs_scheduler.dart` bọc package, luôn tắt fuzzing để chạy lại log khi đồng bộ cho kết quả giống hệt. `test/data/srs/srs_scheduler_test.dart` so 20 chuỗi ôn (159 bước) với py-fsrs và tính tay S₀, D₀.

**Phát hiện khi viết test** (dùng cho nghiên cứu 9.3): mức tăng S kỳ vọng `R·S'(Good) + (1−R)·S'(Again) − S` **không âm** ngay cả khi R rất thấp, vì S'(Good) sau một khoảng nghỉ dài rất lớn. Chiến lược "mức tăng S lớn nhất" vì vậy có xu hướng ưu tiên thẻ quá hạn lâu; cần xem kỹ trong mô phỏng.

## SM-2 (C)

## HLR (C)
