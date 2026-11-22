# Đề xuất đề tài – CMP177

## 1. Tên đồ án

**Hanzi** – Ứng dụng học từ vựng tiếng Trung cho người Việt, có âm Hán-Việt và lịch ôn tập theo FSRS.

## 2. Danh sách chức năng

1. Đăng ký, đăng nhập, quên mật khẩu (Firebase Auth).
2. CRUD bộ từ và thẻ (chữ Hán, pinyin, Hán-Việt, nghĩa, ví dụ). Có sẵn bộ HSK 1–6.
3. Ôn tập theo thuật toán lặp lại ngắt quãng FSRS-6 với 4 kiểu: lật thẻ, trắc nghiệm, gõ pinyin, nghe chọn từ.
4. Tra từ offline, phát âm bằng TTS, tách chữ thành bộ thủ.
5. Tìm kiếm theo chữ Hán, pinyin (có hoặc không dấu), Hán-Việt, nghĩa.
6. Thống kê bằng biểu đồ: số từ theo HSK, streak, dự báo số thẻ cần ôn, đường cong lãng quên.
7. Thông báo cục bộ nhắc ôn hằng ngày.
8. Offline-first: lưu SQLite trên máy, đồng bộ Firestore khi có mạng.
9. Cài đặt: tỉ lệ ghi nhớ mong muốn, số từ mới mỗi ngày, giờ nhắc, giao diện sáng/tối.

## 3. Phần nghiên cứu

So sánh FSRS-6, SM-2 và HLR trên log ôn tập thật (anki-revlogs-10k); mô phỏng 90 ngày để chọn chiến lược ưu tiên thẻ khi bị dồn bài sau nhiều ngày nghỉ.
