# Thiết kế: App học từ vựng tiếng Trung cho người Việt (CMP177)

- Ngày: 2026-11-22
- Môn: CMP177 – Lập trình trên thiết bị di động (Flutter + Dart)
- Nhóm: 3 người (2 người code). Leader phụ trách quy trình, thuật toán và UI.
- Trạng thái: đã duyệt từng phần trong buổi brainstorming, chờ duyệt bản viết.

## 1. Mục tiêu và tiêu chí thành công

App học từ vựng tiếng Trung chuyên cho người Việt. Thẻ có chữ Hán, pinyin, âm Hán-Việt (学生 = HỌC SINH), tách chữ thành bộ thủ. Lịch ôn tính bằng FSRS.

Thành công khi:
1. Demo chạy ổn trên điện thoại Android thật, đáp ứng mọi mục trong bảng đối chiếu yêu cầu môn (mục 12).
2. App dùng được hoàn toàn offline sau lần đăng nhập đầu. Dữ liệu người dùng đồng bộ lên Firestore khi có mạng.
3. Có báo cáo nghiên cứu với số liệu thật: so sánh FSRS-6 / SM-2 / HLR, và so sánh các chiến lược chọn thẻ khi dồn bài bằng mô phỏng 90 ngày.
4. Mỗi thành viên giải thích được phần thuật toán mình làm.

## 2. Phạm vi

**Có làm**
1. Đăng ký, đăng nhập, quên mật khẩu (Firebase Auth).
2. CRUD bộ từ và thẻ. Thẻ gồm chữ Hán, pinyin, Hán-Việt, nghĩa, ví dụ. Có sẵn bộ HSK 1–6 (HSK 2.0).
3. Ôn tập theo FSRS với 4 kiểu: lật thẻ, trắc nghiệm, gõ pinyin, nghe chọn từ.
4. Tra từ offline, phát âm bằng TTS, tách chữ thành bộ thủ.
5. Tìm kiếm theo chữ Hán, pinyin (có hoặc không dấu), Hán-Việt (có hoặc không dấu), nghĩa.
6. Thống kê: số từ theo HSK, streak, dự báo số thẻ cần ôn 30 ngày, đường cong lãng quên.
7. Local notification nhắc ôn hằng ngày.
8. Offline-first: SQLite trên máy, đồng bộ Firestore.
9. Cài đặt: tỉ lệ ghi nhớ mong muốn, số từ mới mỗi ngày, giờ nhắc, giao diện sáng/tối.
10. Nghiên cứu phần A (mục 9).

**Không làm**
- Chấm thanh điệu (YIN + DTW). Bỏ hẳn, kèm biểu đồ tỉ lệ đọc đúng thanh.
- Cộng độ nhớ cho các từ có chung chữ Hán.
- Optimizer tham số FSRS. Dùng tham số mặc định của package.
- Hoạt hình thứ tự nét chữ.
- iOS. Chỉ build và demo trên Android.
- PIN/vân tay. Đề chỉ bắt buộc với dữ liệu cá nhân nhạy cảm; app đã có đăng nhập.

## 3. Quyết định công nghệ

| Vấn đề | Chốt | Lý do ngắn |
|---|---|---|
| Quản lý trạng thái | Cubit (`flutter_bloc`) | Có tiền lệ được chấp nhận ở môn (DevRadar AI). Test bằng `bloc_test`. Cần GV xác nhận lần cuối. |
| Lưu cục bộ | `drift` (SQLite) | Đúng ví dụ của môn, query kiểm tra lúc compile, FTS5, Stream, test bằng DB trong RAM. |
| Lưu đám mây | Firebase Auth + Firestore | Đề nêu đích danh. Không bị tạm dừng như Supabase free. Có `fake_cloud_firestore` để test. |
| Lập lịch | FSRS-6 qua pub `fsrs` ^2.0.1 (21 tham số) | Package bản hiện tại là FSRS-6, không còn 4.5. Port từ py-fsrs commit `6fd0857`. |
| Code nghiên cứu | Python trong `research/` | pandas/matplotlib cho dataset lớn và hình báo cáo. |

Không dùng: `dio`/`http` (không gọi REST), `get_it` (`RepositoryProvider` đủ), `freezed`, `shimmer`, `shared_preferences`, Hive/Isar.

## 4. Nguồn dữ liệu và giấy phép

| Dữ liệu | Nguồn | Giấy phép |
|---|---|---|
| Nghĩa tiếng Việt | CVDICT (github.com/ph0ngp/CVDICT), >122.000 mục, định dạng như CC-CEDICT | CC BY-SA 4.0 |
| Nghĩa tiếng Anh, pinyin, phồn thể | CC-CEDICT | CC BY-SA 3.0 |
| Âm Hán-Việt từng chữ | Unihan, trường `kVietnamese` | Unicode License |
| Bộ thủ, tách thành phần | Make Me a Hanzi, chỉ `dictionary.txt` | LGPL-3.0+ |
| Danh sách HSK 2.0 cấp 1–6 | complete-hsk-vocabulary (drkameleon) | MIT |
| Dataset đánh giá (chỉ cho báo cáo) | anki-revlogs-10k (open-spaced-repetition) | Giấy phép riêng, gated; đọc LICENSE trước khi dùng |

Quy tắc ghép:
- Âm Hán-Việt của từ = nối âm từng chữ theo Unihan. Chữ có nhiều âm thì lấy âm đầu, rồi ghi đè bằng CSV soát tay.
- Nghĩa tiếng Việt lấy từ CVDICT. Thiếu thì hiện nghĩa tiếng Anh. Từ HSK được ghi đè bằng CSV soát tay của Nhi (`tools/overrides/*.csv`).
- Vì CC BY-SA: app có màn "Nguồn dữ liệu & giấy phép"; file `dictionary.sqlite` nhóm build ra cũng mang giấy phép CC BY-SA 4.0.

## 5. Kiến trúc

```
CONTRIBUTING.md, .github/pull_request_template.md, .github/workflows/ci.yml
README.md                         # có bảng "Đáp ứng yêu cầu đồ án"
DE_XUAT_DE_TAI.md
lib/
  main.dart, app.dart             # MultiRepositoryProvider + MaterialApp.router
  core/
    router/                       # go_router, redirect khi chưa đăng nhập
    theme/, constants/
    utils/pinyin.dart             # số↔dấu thanh, bỏ dấu, chuẩn hoá ü/v, so sánh khi gõ
  data/
    db/                           # app_database.dart (người dùng), dictionary_database.dart (chỉ đọc)
    repositories/                 # auth, deck, card, review, dictionary, stats, settings
    remote/sync_service.dart      # Firestore
    srs/                          # Dart thuần, không import Flutter
      srs_scheduler.dart          #   bọc package fsrs
      review_queue_builder.dart   #   chọn thẻ ưu tiên khi dồn bài
      replay.dart                 #   tính lại trạng thái thẻ từ danh sách ReviewLog
    services/                     # notification_service, tts_service
  presentation/
    state/<tính năng>/            # xxx_cubit.dart + xxx_state.dart
    screens/<tính năng>/
    widgets/                      # flip_card, hanzi_breakdown, chart widgets, skeleton
assets/dictionary.sqlite
test/                             # cấu trúc giống lib/, fixtures/fsrs_vectors.json
tools/build_dictionary.py, tools/overrides/*.csv
research/                         # Python
docs/algorithms.md, docs/test-cases.md, docs/superpowers/
```

Quy tắc phụ thuộc: screen → cubit → repository → (db | remote | srs). Screen không import `data/db` hay `data/remote`; một test quét import để chặn. Repository được cấp qua `RepositoryProvider`. Không có tầng domain/use-case, không viết interface cho repository (mỗi cái một cài đặt; khi test dùng drift in-memory, `fake_cloud_firestore`, `firebase_auth_mocks`, `mocktail`).

Điểm nối thuật toán:
- `ReviewRepository.answer(cardId, rating, mode)`: đọc thẻ → `SrsScheduler.review(card, rating, now)` → trong một transaction ghi trạng thái thẻ mới, thêm ReviewLog (kèm `retrievabilityBefore`), đặt `dirty = true`.
- `ReviewRepository.todayQueue()`: thẻ đến hạn + thẻ mới (giới hạn bởi "số từ mới mỗi ngày") → `ReviewQueueBuilder.build(...)`.
- `SrsScheduler` tạo `Scheduler` của package với `desiredRetention` từ cài đặt và `enableFuzzing: false` (để chạy lại log cho kết quả giống hệt).

## 6. Mô hình dữ liệu (mức khái niệm)

**Từ điển chỉ đọc** (`dictionary.sqlite`, đóng gói trong assets, chép ra thư mục app ở lần chạy đầu, không đồng bộ):
- DictEntry: id, simplified, traditional, pinyin (có dấu), pinyinPlain (không dấu, không cách), hanViet, meaningVi, meaningEn, hskLevel (có thể trống).
- Hanzi: char, hanVietReadings, radical, decomposition, meaning.
- Chỉ mục FTS5 trên simplified, pinyinPlain, hanViet bỏ dấu, meaningVi bỏ dấu.
- Không có bảng nối từ–chữ: tách chuỗi chữ của từ rồi tra Hanzi.

**Dữ liệu người dùng** (`app.sqlite`, đồng bộ). Mọi id là UUID v4. Mọi bảng đồng bộ có `updatedAt`, `deletedAt` (tombstone), `dirty`.
- Deck: id, name, description, hskLevel (trống = bộ tự tạo), createdAt.
- Card: id, deckId, dictEntryId (có thể trống), hanzi, pinyin, hanViet, meaning, example; trạng thái FSRS: state, step, stability, difficulty, due, lastReview.
  - "Thêm bộ HSK n" tạo Deck và chép nội dung từ DictEntry sang Card, nên người dùng sửa được.
- ReviewLog: id, cardId, rating (1–4), reviewedAt, durationMs, mode (flip | choice | typing | listening), retrievabilityBefore. Chỉ thêm, không sửa.
- Settings (một dòng): desiredRetention (0.80–0.95, mặc định 0.90), newPerDay (mặc định 10), reminderTime, themeMode.
- SyncState (chỉ trên máy): lastPulledAt.

Quan hệ: User 1–n Deck 1–n Card 1–n ReviewLog; Card n–0..1 DictEntry; DictEntry n–n Hanzi (qua chuỗi chữ).

Thống kê tính từ dữ liệu, không có bảng riêng:
- Số từ theo HSK: đếm Card theo hskLevel của DictEntry/Deck.
- Streak: số ngày liên tiếp (theo giờ địa phương) có ít nhất một ReviewLog, tính lùi từ hôm nay.
- Dự báo: đếm Card theo ngày `due` trong 30 ngày tới.
- Đường cong lãng quên: nhóm ReviewLog theo số ngày kể từ lần ôn trước; mỗi nhóm vẽ tỉ lệ nhớ thực tế (rating > 1) và trung bình `retrievabilityBefore`.

## 7. Đồng bộ Firestore

- Đường dẫn: `users/{uid}/decks/{id}`, `users/{uid}/cards/{id}`, `users/{uid}/reviewLogs/{id}`, `users/{uid}/meta/settings`.
- Security rules: chỉ `request.auth.uid == uid` được đọc/ghi `users/{uid}/**`.
- Đẩy: các dòng `dirty = true` gửi bằng batch (≤ 500 thao tác/batch), mỗi document có `serverUpdatedAt = serverTimestamp()`. Thành công thì đặt `dirty = false`.
- Kéo: mỗi collection, lấy document có `serverUpdatedAt > lastPulledAt`; xong thì cập nhật `lastPulledAt`.
- Xung đột:
  - Nội dung Deck/Card/Settings: last-write-wins theo `updatedAt`. Xoá = đặt `deletedAt`, cũng là một lần ghi.
  - ReviewLog: chỉ thêm, id duy nhất → gộp hợp, không xung đột.
  - Trạng thái FSRS của Card: nếu kéo về ReviewLog mới của một thẻ, tính lại trạng thái bằng `replay` toàn bộ log của thẻ theo `reviewedAt`.
- Kích hoạt: mở app, app quay lại từ nền, kết thúc phiên ôn, có mạng trở lại (`connectivity_plus`), nút "Đồng bộ ngay".
- Lỗi: mọi lời gọi Firestore có `.timeout(Duration(seconds: 10))`. Lỗi thì giữ `dirty`, hiện biểu tượng "chưa đồng bộ", thử lại ở lần kích hoạt sau. Không chặn UI.
- Đăng nhập lần đầu cần mạng; sau đó phiên được Firebase Auth giữ.
- Đăng xuất: đẩy trước rồi xoá DB người dùng trên máy. Còn dòng `dirty` không đẩy được thì hiện cảnh báo mất dữ liệu và chỉ xoá khi người dùng xác nhận.
- Hạn chế chấp nhận: LWW dựa vào đồng hồ máy, có thể sai khi đồng hồ lệch. Ghi vào báo cáo.

## 8. Màn hình, điều hướng, trải nghiệm

```
Splash (lần đầu: chép dictionary.sqlite, có thanh tiến trình)
 ├─ chưa đăng nhập → Đăng nhập ⇄ Đăng ký, Quên mật khẩu
 └─ Khung 4 tab (NavigationBar; ≥600dp dùng NavigationRail)
     ├─ Trang chủ: thẻ cần ôn hôm nay (mới/ôn lại), streak, trạng thái đồng bộ, [Bắt đầu ôn], ⚙
     ├─ Bộ từ: danh sách + lọc, FAB tạo bộ, sheet "Thêm bộ HSK 1–6"
     │    └─ Chi tiết bộ: danh sách thẻ + tìm, vuốt xoá (snackbar Hoàn tác)
     │         └─ Tạo/Sửa thẻ: gõ chữ Hán → gợi ý từ từ điển, tự điền
     ├─ Tra từ: tìm FTS (debounce 300 ms) → Chi tiết từ: chữ, pinyin, 🔊, Hán-Việt, nghĩa,
     │    tách chữ → bộ thủ, [Thêm vào bộ…]
     └─ Thống kê: 4 biểu đồ (mục 6)
Phiên ôn (toàn màn hình): chọn kiểu ôn → từng thẻ → Tổng kết
Cài đặt: retention, từ mới/ngày, giờ nhắc, sáng/tối, Đồng bộ ngay, Đăng xuất, Nguồn dữ liệu & giấy phép
```

Route (`go_router`, tab dùng `StatefulShellRoute`): `/login`, `/register`, `/home`, `/decks`, `/decks/:id`, `/decks/:id/cards/new`, `/cards/:id/edit`, `/dictionary`, `/dictionary/:entryId`, `/stats`, `/settings`, `/review`, `/review/summary`, `/licenses`. Bấm thông báo mở `/home`.

Kiểu ôn và quy ra rating FSRS:

| Kiểu | Hiển thị | Rating |
|---|---|---|
| Lật thẻ | Chữ Hán, chạm để lật 3D | Người học chọn Again/Hard/Good/Easy; mỗi nút hiện khoảng cách tới lần ôn sau |
| Trắc nghiệm | Chữ Hán + 4 nghĩa (nhiễu cùng cấp HSK) | Đúng = Good, sai = Again |
| Gõ pinyin | Chữ Hán + nghĩa; nhận `xue2sheng1` hoặc `xuéshēng` | Đúng cả thanh = Good; đúng âm sai thanh = Hard; sai = Again |
| Nghe chọn từ | TTS đọc, chọn 1 trong 4 chữ Hán | Đúng = Good, sai = Again |

Đầu phiên chọn một kiểu hoặc "Trộn". Thẻ mới luôn hiện kiểu lật thẻ ở lần đầu.

Animation: chuyển trang fade + slide (`CustomTransitionPage`), skeleton khi tải danh sách, thanh tiến trình chép từ điển, lật thẻ 3D quanh trục Y, `Hero` cho chữ Hán, `AnimatedSwitcher` giữa các thẻ.

Responsive: `LayoutBuilder` mốc 600 dp; cỡ chữ Hán theo chiều rộng; widget test ở 320×640, 411×891, 800×1280 không có lỗi tràn layout.

## 9. Nghiên cứu (phần A)

Trước khi code mọi công thức, đối chiếu với wiki chính thức: github.com/open-spaced-repetition/awesome-fsrs/wiki/The-Algorithm (mục FSRS-6) và bài HLR gốc (Settles & Meeder, ACL 2016).

**9.1 Mô hình so sánh** (`research/`)
- FSRS-6: py-fsrs ghim commit `6fd0857` (cùng gốc với package Dart), tham số mặc định.
- SM-2: tự cài theo công thức gốc (EF, interval). SM-2 không có xác suất nhớ; dùng giả định `p = 0.9^(Δ/I)` (I là interval SM-2 đặt ra) và nêu rõ giả định này trong báo cáo.
- HLR: `p = 2^(−Δ/h)`, `h = 2^(θ·x)`, đặc trưng tối thiểu √(1+số lần đúng), √(1+số lần sai), bias; huấn luyện bằng gradient descent theo bài gốc.

**9.2 Đánh giá trên dữ liệu thật: anki-revlogs-10k**
- Chỉ dùng cho báo cáo, chạy bằng Python trên laptop. App không dùng, không đóng gói dataset.
- Dataset: huggingface.co/datasets/open-spaced-repetition/anki-revlogs-10k (log ôn thật của 10.000 người dùng Anki, rating 1–4, đủ lịch sử từng thẻ, không có nội dung thẻ). Gated: phải đồng ý chia sẻ thông tin liên hệ; đọc file LICENSE trước khi dùng. Lấy tập con 100–200 người dùng.
- Cách làm: với mỗi lần ôn, mỗi mô hình dự đoán xác suất nhớ chỉ từ lịch sử trước đó; nhãn thực tế: rating 1 = quên, 2–4 = nhớ. Bỏ các lần ôn thứ hai trở đi trong cùng một ngày (như srs-benchmark).
- Chỉ số: log-loss, AUC, RMSE(bins) theo định nghĩa của srs-benchmark. Chia train/test theo người dùng (HLR cần train).
- Kiểm tra chéo: đặt số của nhóm cạnh số công bố của srs-benchmark (github.com/open-spaced-repetition/srs-benchmark) cho FSRS-6, SM-2, HLR. Lệch nhiều thì rà lại code trước khi viết báo cáo.
- Người làm: Nhi chạy chính (tải dữ liệu, SM-2, HLR, chạy đánh giá, vẽ hình). Leader kiểm tra phần gọi py-fsrs và duyệt kết quả. Ly không tham gia.

**9.3 Mở rộng: chọn thẻ ưu tiên khi dồn bài**
- Bối cảnh: người học nghỉ N ngày, quay lại có nhiều thẻ quá hạn hơn giới hạn K lượt ôn mỗi ngày.
- Ba chiến lược sắp hàng đợi:
  1. Theo hạn: `due` tăng dần (quá hạn lâu nhất trước).
  2. R thấp nhất: retrievability hiện tại tăng dần.
  3. Mức tăng S kỳ vọng: `gain = R·S'_nhớ + (1−R)·S'_quên − S`, giảm dần, với `S'_nhớ` tính khi rating = Good và `S'_quên` khi rating = Again theo công thức FSRS-6.
- Mô phỏng 90 ngày: người học ảo có trí nhớ thật theo FSRS-6 với tham số **lệch ngẫu nhiên** so với tham số của bộ lập lịch (tránh kết quả lạc quan do dùng cùng mô hình). Kịch bản nghỉ N ∈ {7, 14, 30} ngày, K ∈ {50, 100}. Lặp nhiều seed.
- Chỉ số: tổng R của mọi thẻ ở ngày 90 (số từ "đang nhớ" kỳ vọng), số ngày để hết dồn bài, tổng lượt ôn.
- Chiến lược tốt nhất được port sang Dart trong `ReviewQueueBuilder` và dùng trong app khi số thẻ đến hạn > giới hạn trong ngày.

## 10. Kiểm thử

1. So khớp FSRS: `research/export_fsrs_vectors.py` chạy py-fsrs trên ~20 chuỗi rating, tắt fuzzing → `test/fixtures/fsrs_vectors.json`; test Dart so stability, difficulty, due sai số 1e-6. Thêm vài test tính tay theo wiki (S₀ = w[rating−1], D₀).
2. Hàm thuần: `ReviewQueueBuilder` (thứ tự từng chiến lược, giới hạn), `replay` (log gộp từ 2 máy cho kết quả như chạy tuần tự), `pinyin.dart` (ü/v, thanh nhẹ, so sánh khi gõ).
3. Repository trên drift in-memory: CRUD + xoá mềm, cờ `dirty`, transaction `answer()`, streak qua nửa đêm, dự báo 30 ngày.
4. SyncService trên `fake_cloud_firestore`: đẩy xoá cờ, kéo ghi đè đúng, LWW, tombstone, lỗi/timeout giữ cờ.
5. Cubit bằng `bloc_test` + `mocktail`: Auth, ReviewSession, Search (debounce).
6. Widget: lật thẻ, trọn một phiên ôn, 3 kích thước màn hình.
7. Test kiến trúc: `lib/presentation/**` không import `data/db` hay `data/remote`.
8. Python: pytest cho SM-2, HLR; script kiểm tra `dictionary.sqlite` sau khi build (số mục, 学生 → HỌC SINH).
9. CI: GitHub Actions `flutter analyze && flutter test` cho mỗi PR.
10. Test tay: `docs/test-cases.md`, chạy trên máy thật mỗi tuần.

## 11. Rủi ro và đường lui

| Rủi ro | Đường lui |
|---|---|
| Nghĩa CVDICT sai/thiếu | CSV soát tay cho từ HSK ghi đè; thiếu thì hiện nghĩa tiếng Anh |
| Ghép sai âm Hán-Việt chữ đa âm | CSV ghi đè; màn chi tiết luôn hiện âm từng chữ |
| APK quá nặng vì từ điển đầy đủ | Đo tuần 1; nặng thì chỉ đóng gói từ HSK + ~30.000 từ thông dụng |
| Package `fsrs` lệch py-fsrs | Test so khớp phát hiện; tự cài theo wiki (~150 dòng) với test vector có sẵn |
| Không tải được anki-revlogs-10k (gated, giấy phép) | Dùng dataset Duolingo halflife-regression cho HLR vs SM-2; FSRS chỉ so trong mô phỏng |
| Số của nhóm lệch xa srs-benchmark | Rà lại cách lọc dữ liệu và định nghĩa chỉ số theo code srs-benchmark trước khi kết luận |
| Lỗi đồng bộ gây mất dữ liệu | Làm sau khi app offline vững (tuần 5–6); tombstone; cảnh báo khi đăng xuất; tệ nhất demo 1 máy |
| Android 13+ chặn thông báo/báo thức chính xác | Xin `POST_NOTIFICATIONS`; lịch inexact hằng ngày |
| 2 người code quá tải | Cắt lần lượt: kiểu nghe chọn từ → đánh giá trên anki-revlogs → `replay` khi gộp (thay bằng LWW) |
| Lệch đồng hồ làm LWW sai | Chấp nhận, ghi vào báo cáo |
| Lộ cấu hình Firebase | `.gitignore` cho `google-services.json`, `firebase_options.dart`; gửi riêng |
| GV không chấp nhận Cubit | Logic nằm trong repository/srs; chỉ viết lại `presentation/state` |

## 12. Bảng đối chiếu yêu cầu môn (sẽ đưa vào README)

| Yêu cầu | Đáp ứng |
|---|---|
| Flutter/Dart | Toàn bộ app |
| Cấu trúc phân lớp | `core/`, `data/`, `presentation/` (mục 5) |
| UI đồng bộ, responsive, animation | Theme sáng/tối; NavigationRail ≥600 dp; 5 animation (mục 8); widget test 3 kích thước |
| Quản lý trạng thái | Cubit (`flutter_bloc`) |
| UI tách khỏi logic | screen → cubit → repository; test kiến trúc chặn import |
| Clean code, dễ mở rộng | Repository theo thực thể, `srs/` Dart thuần, lint `flutter_lints` |
| API: timeout, mất mạng, cache | Firestore `.timeout(10s)`, offline-first, SQLite là cache |
| Kiểm thử | Mục 10, CI trên mỗi PR |
| Hiểu thuật toán | `docs/algorithms.md` do người cài viết; test tính tay theo wiki |
| CRUD | Bộ từ, thẻ |
| Thống kê/biểu đồ | 4 biểu đồ `fl_chart` |
| Đăng nhập/Đăng ký | Firebase Auth |
| Thông báo | Local notification nhắc ôn |
| Tìm kiếm | FTS5 theo chữ Hán, pinyin, Hán-Việt, nghĩa; tìm trong bộ từ |
| Lưu cục bộ + đám mây | drift (SQLite) + Firestore |

## 13. Chia việc

- **Leader (bạn)** – quy trình, thuật toán, luồng chính:
  - Quy trình: tạo repo, branch protection `main`/`develop`, `CONTRIBUTING.md` (nhánh `feature/<phần>-<tên>`, commit `feat(app): …`, PR ≥ 1 review, không force-push `main`/`develop`), PR template, Firebase project, duyệt merge.
  - `core/`, `data/srs/` (+ test so khớp), cả hai drift DB (bảng người dùng có sẵn cột đồng bộ), repository + cubit của deck, card, review, dictionary, stats, settings.
  - Mọi màn hình trừ đăng nhập; animation; responsive; widget test; test kiến trúc.
  - `research/`: khung mô phỏng + 3 chiến lược; port chiến lược thắng.
  - Dùng file từ điển mẫu ~150 từ HSK 1 cho tới khi có bản thật.
- **Ly** – các module cắm vào sau, mỗi module tự test được:
  1. `tools/build_dictionary.py` sinh `assets/dictionary.sqlite` đúng schema leader định nghĩa, kèm script kiểm tra.
  2. Đăng nhập: AuthRepository, AuthCubit, màn đăng nhập/đăng ký/quên mật khẩu, `redirect` router.
  3. Đồng bộ: SyncService, security rules, test `fake_cloud_firestore`, nút "Đồng bộ ngay", biểu tượng trạng thái.
  4. NotificationService, `connectivity_plus`. (TtsService chuyển cho leader vì kiểu ôn "nghe" và nút 🔊 cần nó sớm.)
  5. Workflow CI theo quy trình leader đặt ra.
- **Nhi** – dữ liệu, nghiên cứu, tài liệu: CSV soát nghĩa và Hán-Việt HSK 1–6; SM-2; HLR (leader hỗ trợ); chạy mô phỏng và đánh giá trên anki-revlogs; hình; `docs/test-cases.md`; bảng đối chiếu trong README; báo cáo; slide; video.
- **Cả ba**: mỗi người viết mục thuật toán của mình trong `docs/algorithms.md`.

## 14. Lịch (tuần 1 = 23/11/2026, tuần 10 kết thúc 31/01/2027)

| Tuần | Leader | Ly | Nhi | Mốc |
|---|---|---|---|---|
| 1 | Repo, CONTRIBUTING, PR template, Firebase; khung app; SrsScheduler + test vector; schema drift | CI, build_dictionary v0 | Tải dataset, soát CSV | Test FSRS xanh; schema từ điển trên `develop` |
| 2 | Deck/Card repo, cubit, màn hình; phiên ôn lật thẻ | build_dictionary v1, đo kích thước APK | CSV HSK 1–2, tải và đọc anki-revlogs | |
| 3 | 3 kiểu ôn còn lại; tra từ + FTS | Đăng nhập | SM-2, CSV HSK 3–4 | |
| 4 | Trang chủ, Cài đặt, Thống kê | Thông báo, TTS; ghép từ điển thật | HLR, CSV HSK 5–6 | **App offline đủ chức năng** |
| 5 | Khung mô phỏng; animation | Đồng bộ: đẩy, kéo, LWW, tombstone | Chạy mô phỏng | |
| 6 | Port chiến lược thắng; `replay` | Kích hoạt đồng bộ, UI lỗi/timeout, rules | Đánh giá trên anki-revlogs | **Đồng bộ 2 máy; số liệu v1** |
| 7 | Responsive, widget test, test kiến trúc | Test đồng bộ, sửa lỗi | Test tay máy thật | **Đóng băng tính năng** |
| 8–10 | Hoàn thiện, diễn tập | APK release, diễn tập | Báo cáo, slide, video | **Nộp bài** |

Nếu leader trễ sau tuần 4: chuyển màn Cài đặt + SettingsRepository cho Ly.

## 15. Việc cần xác nhận ngoài nhóm

1. GV xác nhận dùng Cubit được (đã có tiền lệ, nhưng nên hỏi).
2. Đối chiếu lịch 10 tuần với hạn nộp và ngày demo thật của môn.
3. Đọc LICENSE của anki-revlogs-10k và đăng ký truy cập trên Hugging Face.
