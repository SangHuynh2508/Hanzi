# App học từ vựng tiếng Trung – Kế hoạch code

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **Ghi chú:** theo yêu cầu của leader, kế hoạch này **chưa chứa code sản phẩm**. Mỗi task ghi file, chữ ký interface (hợp đồng giữa các phần), test case cụ thể dạng đầu vào → kết quả, các bước và commit. Khi bắt đầu một task, người làm viết test trước theo đúng các case ở đây rồi mới cài đặt.

**Goal:** App Flutter học từ vựng tiếng Trung cho người Việt (HSK 1–6, Hán-Việt, bộ thủ, FSRS-6), offline-first, đồng bộ Firestore, kèm nghiên cứu so sánh thuật toán bằng Python.

**Architecture:** Chia lớp `core/` – `data/` – `presentation/`. Screen → Cubit → Repository → (drift DB | Firestore | `data/srs/` Dart thuần). Từ điển là file SQLite chỉ đọc build sẵn bằng Python; dữ liệu người dùng ở SQLite riêng có cột đồng bộ. Nghiên cứu nằm ở `research/` (Python), không chạy trong app.

**Tech Stack:** Flutter/Dart, flutter_bloc (Cubit), go_router, drift + drift_flutter (SQLite, FTS5), Firebase Auth + Cloud Firestore, fsrs ^2.0.1 (FSRS-6), flutter_tts, flutter_local_notifications, fl_chart, connectivity_plus, uuid. Python: py-fsrs (commit 6fd0857), numpy, pandas, matplotlib, scikit-learn, pytest.

**Spec:** `docs/superpowers/specs/2026-11-22-app-tu-vung-tieng-trung-design.md`

**Mới vào nhóm / bắt đầu task đầu tiên:** đọc [`docs/BAT_DAU.md`](../../BAT_DAU.md) trước.

## Trạng thái (cập nhật 22/11/2026)

| Task | Trạng thái | Commit |
|---|---|---|
| L0 Repo, quy trình | Xong | `6b57f28` |
| L1 Khung app, theme, router, test kiến trúc | Xong | `c354372` |
| L2 SrsScheduler + vector FSRS | Xong | `9556c0e` |
| L3 Pinyin, chuẩn hoá chữ | Xong | `7132f4e` |
| L4 Hai drift DB, từ điển mẫu 20 từ, splash | Xong | `ce66dfe` |
| L5 Tra từ, chi tiết từ, TTS | Xong | `8fb388d`, `c81869b` |
| L6 CRUD bộ từ/thẻ, thêm bộ HSK | Xong | `30cd957` |
| L7–L14 | Chưa làm | |
| D1–D7 (Ly), C1–C7 (Nhi) | Chưa làm | |

Code ở trên nằm ở nhánh `feature/app-week1`, vào `develop` sau khi PR của leader được merge. Người làm xong task thì sửa dòng tương ứng trong bảng này trong cùng PR.

## Thay đổi so với kế hoạch (đọc trước khi làm task phụ thuộc)

Phần dưới của kế hoạch giữ nguyên bản gốc; chỗ nào khác với mục này thì **mục này đúng**.

**Thư viện, tiện ích có sẵn**
- Không dùng package `uuid`: id mới lấy từ `newId()` trong `lib/core/utils/ids.dart` (UUID v4).
- Giờ hiện tại lấy qua `Clock` (`lib/core/utils/clock.dart`, `nowUtc()`); repository nhận `Clock` qua constructor để test giả lập được.
- Chuẩn hoá: `toPlain`, `containsHanzi` (`core/utils/pinyin.dart`), `normalizeVi` (`core/utils/text_normalize.dart`). Mẫu chung cho test chéo với Python: `test/fixtures/normalize_samples.json`.
- `lib/core/router/app_router.dart` **chưa có** `redirect`/`isSignedIn`; D3 tự thêm (đừng tìm tham số có sẵn).
- Firebase chưa được thêm vào `pubspec.yaml`, chưa có `main.dart` khởi tạo Firebase. Leader tạo project Firebase và gửi `google-services.json` trước khi D3 bắt đầu.

**Từ điển (liên quan D2)**
- Schema: `lib/data/db/dictionary.drift` (đọc comment đầu file: thứ tự chạy, `PRAGMA user_version = 1`).
- File hiện tại `assets/dictionary.sqlite` là bản mẫu 20 từ HSK 1, build bằng `tools/build_sample_dictionary.py` từ `test/fixtures/dictionary_sample.sql`. D2 thay file này bằng output của `tools/build_dictionary.py`.
- **Mỗi lần thay `assets/dictionary.sqlite` phải tăng `kDictionaryBuild`** trong `lib/data/db/dictionary_database.dart`, nếu không máy đã cài app sẽ giữ file cũ. `user_version` chỉ đổi khi đổi schema.
- Test Dart vẫn dùng `test/fixtures/dictionary_sample.sql` (không đọc file asset), nên thay asset không làm hỏng test.

**Chữ ký đã đổi so với bản gốc**
- `TtsService.speak(String hanzi)` trả `Future<bool>` (false khi máy không có engine/giọng tiếng Trung).
- `DeckRepository.addHskDeck(int level)` trả `Future<String?>`: id bộ (bộ đã có thì trả id cũ), `null` khi cấp đó chưa có từ.
- Thêm `DeckRepository.watchDeck(String id)`; `DeckRepository` nhận `cards`, `dictionary`, `clock` qua constructor.
- Model nằm cùng file repository: `DictEntry`, `HanziInfo` (`dictionary_repository.dart`), `CardDraft`, `CardItem` (`card_repository.dart`), `Deck` (`deck_repository.dart`, che row drift cùng tên bằng `hide Deck`).
- `HanziApp` nhận `openDictionary` và `openAppDatabase` để test thay DB thật bằng DB trong bộ nhớ.

**Dữ liệu người dùng (liên quan D5, D6)**
- Xoá đều là xoá mềm (`deletedAt`); mọi lần ghi đặt `updatedAt = clock.nowUtc()` và `dirty = true`.
- Xoá bộ: bộ và mọi thẻ còn sống của nó nhận **cùng một** `deletedAt`; khôi phục bộ chỉ khôi phục các thẻ có đúng mốc đó. Khi pull tombstone từ Firestore cần giữ đúng quy tắc này.
- DateTime lưu dạng text ISO-8601 (`build.yaml`: `store_date_time_values_as_text`).
- File `*.g.dart` được commit. Chỉ chạy `dart run build_runner build --delete-conflicting-outputs` khi sửa bảng drift hoặc `dictionary.drift`, rồi commit file sinh ra.

**Test**
- Helper trong `test/helpers/`: `TestRepos.open()` (DB người dùng trong bộ nhớ + từ điển mẫu, đồng hồ cố định 22/11/2026 10:00 UTC), `FixedClock`, `openSampleDictionary()`, `testApp()`.
- Widget test có drift stream phải dùng `testAppWidgets(...)` thay cho `testWidgets(...)` và **không** `close()` DB người dùng trong `tearDown` (sẽ treo). Lý do ghi trong `test/helpers/test_app.dart`.
- Chữ trong app viết tiếng Việt; test tìm widget bằng chữ đó (`find.text('Tạo bộ')`).

## Global Constraints

- Chỉ Android. `minSdkVersion` 23. Flutter stable mới nhất lúc tạo repo; ghi phiên bản Flutter/Dart vào README.
- Lớp: screen không import `lib/data/db/**` hay `lib/data/remote/**` (có test chặn).
- `SrsScheduler` luôn dùng `enableFuzzing: false`; `desiredRetention` trong [0.80, 0.95], mặc định 0.90.
- `newPerDay` mặc định 10. Debounce tìm kiếm 300 ms. Mốc responsive 600 dp.
- Mọi id dữ liệu người dùng là UUID v4. Mọi bảng đồng bộ có `updatedAt`, `deletedAt`, `dirty`.
- Thời gian lưu dạng UTC; chỉ đổi sang giờ địa phương khi tính "ngày" (streak, hôm nay, dự báo).
- Mọi lời gọi Firestore có `.timeout(const Duration(seconds: 10))`; batch ≤ 500 thao tác.
- Widget test responsive ở 320×640, 411×891, 800×1280.
- Không commit: `google-services.json`, `GoogleService-Info.plist`, `lib/firebase_options.dart`, `firebase.json`, `.env`, dataset `research/data/**`.
- Nhánh `feature/<phần>-<tên>` (phần ∈ `app`, `data`, `srs`, `sync`, `auth`, `research`, `docs`); commit `<loại>(<phần>): <mô tả>`; PR vào `develop` cần ≥ 1 review; không force-push `main`/`develop`.
- Chữ hiển thị trong app bằng tiếng Việt.

## Review Focus

Những tình huống spec ngụ ý mà dễ làm hỏng trải nghiệm. Mỗi dòng đã có test ở task sở hữu:

1. **Qua nửa đêm và đổi múi giờ**: ôn lúc 23:59 và 00:01 giờ địa phương phải tính là 2 ngày cho streak; "hôm nay" theo giờ máy, không theo UTC. → Task L10.
2. **Gõ pinyin nhiều kiểu**: chữ hoa, có/không khoảng trắng, `lv4`/`lu:4`/`lü4`, thanh nhẹ `ma`/`ma5`/`ma0` đều phải chấm đúng. → Task L3.
3. **Xoá bộ từ khi còn thẻ đến hạn**: thẻ của bộ đã xoá không được xuất hiện trong hàng đợi, thống kê, tìm kiếm trong bộ. → Task L7, L10.
4. **Bộ từ quá ít thẻ cho trắc nghiệm/nghe**: bộ chỉ có 2 thẻ vẫn phải ra đủ 4 lựa chọn khác nhau (lấy nhiễu từ từ điển cùng cấp HSK). → Task L8.
5. **App bị tắt giữa phiên ôn**: các câu đã trả lời không mất, mở lại chỉ còn thẻ chưa ôn. → Task L7.

---

## Bản đồ file

```
CONTRIBUTING.md  README.md  DE_XUAT_DE_TAI.md  .gitignore
.github/pull_request_template.md  .github/workflows/ci.yml
firestore.rules
lib/
  main.dart                         # khởi tạo Firebase, DB, chạy App
  app.dart                          # MultiRepositoryProvider + MaterialApp.router
  core/
    router/app_router.dart          # go_router, StatefulShellRoute, redirect
    theme/app_theme.dart            # light/dark ThemeData
    constants/app_constants.dart    # các hằng ở Global Constraints
    utils/pinyin.dart               # số↔dấu, bỏ dấu, so sánh
    utils/text_normalize.dart       # bỏ dấu tiếng Việt (đ→d), lowercase
    utils/clock.dart                # Clock có thể giả lập trong test
  data/
    db/dictionary.drift             # SQL thuần: bảng từ điển + FTS5 (dùng chung với Python)
    db/dictionary_database.dart     # drift DB chỉ đọc, chép từ assets
    db/app_database.dart            # drift DB người dùng: decks, cards, review_logs, settings, sync_state
    models/                         # model thuần không phải row drift (QuizQuestion, StatsSnapshot…)
    repositories/{auth,deck,card,review,dictionary,stats,settings}_repository.dart
    remote/sync_service.dart
    srs/srs_scheduler.dart  srs/review_queue_builder.dart  srs/replay.dart
    services/notification_service.dart  services/tts_service.dart
  presentation/
    state/<tính năng>/<x>_cubit.dart + <x>_state.dart
    screens/<tính năng>/...
    widgets/flip_card.dart  hanzi_breakdown.dart  skeleton_list.dart  charts/*.dart
assets/dictionary.sqlite
test/                               # giống lib/; test/fixtures/{fsrs_vectors.json, dictionary_sample.sql}
tools/build_dictionary.py  tools/check_dictionary.py  tools/overrides/{meaning_vi,hanviet}.csv
research/
  requirements.txt  export_fsrs_vectors.py
  srs/{sm2.py,hlr.py}  eval/{load_revlogs.py,evaluate.py}  sim/{learner.py,strategies.py,simulate.py}
  tests/  figures/  data/ (gitignore)
docs/algorithms.md  docs/test-cases.md
```

## Điểm giao giữa các người (để không ai phải chờ)

| Thứ | Người tạo | Người dùng | Khi nào phải có |
|---|---|---|---|
| `lib/data/db/dictionary.drift` (schema từ điển) | Leader (L4) | Ly (D2) | Cuối tuần 1 |
| Cột đồng bộ trong `app_database.dart` | Leader (L4) | Ly (D5) | Cuối tuần 1 |
| `NotificationService` (chỉ chữ ký, thân rỗng) | Ly (D1) | Leader (L9) | Cuối tuần 1 |
| `replay.dart` | Leader (L13) | Ly (D6) | Tuần 6 |
| `research/sim/` khung mô phỏng | Leader (L12) | Nhi (C6) | Tuần 5 |
| `tools/overrides/*.csv` | Nhi (C2) | Ly (D2) | Dần theo tuần 2–4 |

---

# TRACK LEADER

### Task L0: Repo và quy trình nhóm (tuần 1)

**Files:**
- Create: `CONTRIBUTING.md`, `.github/pull_request_template.md`, `.gitignore`, `README.md`, `DE_XUAT_DE_TAI.md`
- Move: `docs/superpowers/specs/*`, `docs/superpowers/plans/*` vào repo

**Interfaces:** Produces: quy ước nhánh/commit/PR cho mọi task sau.

- [ ] **Step 1:** Tạo repo GitHub, nhánh `main` và `develop`; bật branch protection cho cả hai: bắt buộc PR, ≥ 1 approval, cấm force-push, bắt buộc check CI (bật sau khi D1 xong).
- [ ] **Step 2:** Viết `CONTRIBUTING.md` (ngắn, ≤ 1 trang): cách clone, tạo nhánh `feature/<phần>-<tên>` từ `develop`, mẫu commit `<loại>(<phần>): <mô tả>` với loại ∈ feat/fix/refactor/test/docs/chore, PR cần 1 review, kéo `develop` thường xuyên, không commit file cấu hình Firebase, quy tắc "UI không gọi DB/Firestore".
- [ ] **Step 3:** Viết PR template: mục "Thay đổi", "Phần" (checkbox app/data/srs/sync/auth/research/docs), "Đã kiểm tra" (`flutter analyze` sạch, `flutter test` xanh, chạy trên máy, không lộ key).
- [ ] **Step 4:** `.gitignore`: mặc định Flutter + các file ở Global Constraints + `research/data/`, `research/.venv/`.
- [ ] **Step 5:** README khung: tên app, cách chạy, bảng "Đáp ứng yêu cầu đồ án" (chép mục 12 của spec, cột bằng chứng để trống dần), mục "Nguồn dữ liệu & giấy phép". `DE_XUAT_DE_TAI.md`: tên đồ án + danh sách chức năng (mục 2 spec).
- [ ] **Step 6:** Tạo Firebase project, bật Email/Password Auth và Firestore (Native mode), thêm email 2 thành viên vào Users and permissions.
- [ ] **Step 7:** Commit `docs(docs): add contributing guide, PR template, README skeleton` lên `develop`.

**Xong khi:** Ly và Nhi clone được, mở được PR thử, Firebase project truy cập được.

### Task L1: Khung app, theme, router, test kiến trúc (tuần 1)

**Files:**
- Create: `pubspec.yaml`, `analysis_options.yaml`, `lib/main.dart`, `lib/app.dart`, `lib/core/router/app_router.dart`, `lib/core/theme/app_theme.dart`, `lib/core/constants/app_constants.dart`, `lib/core/utils/clock.dart`, `lib/presentation/screens/shell/main_shell.dart`, 4 màn placeholder (home, decks, dictionary, stats)
- Test: `test/app_smoke_test.dart`, `test/architecture_test.dart`

**Interfaces:**
- Produces: `class AppRoutes { static const home='/home', decks='/decks', dictionary='/dictionary', stats='/stats', settings='/settings', review='/review', reviewSummary='/review/summary', licenses='/licenses', login='/login', register='/register'; }`
- Produces: `GoRouter buildRouter({required Stream<bool> isSignedIn})` – tạm truyền `Stream.value(true)` cho tới khi D3 xong.
- Produces: `abstract class Clock { DateTime nowUtc(); }` với `SystemClock` và `FixedClock(DateTime)` cho test. (Ngoại lệ có chủ đích của quy tắc "không interface 1 cài đặt": cần giả lập thời gian trong mọi test liên quan ngày.)

**Test cases:**
- App khởi động → thấy tab "Trang chủ"; bấm tab "Bộ từ" → thấy tiêu đề "Bộ từ"; quay lại "Trang chủ" vẫn giữ trạng thái cuộn (StatefulShellRoute).
- Màn rộng 800 dp → có `NavigationRail`; 411 dp → có `NavigationBar`.
- `architecture_test`: duyệt mọi file `lib/presentation/**/*.dart`, không dòng `import` nào chứa `data/db/` hoặc `data/remote/`. Thêm 1 file vi phạm tạm để thấy test đỏ, rồi xoá.

- [ ] **Step 1:** `flutter create --org vn.<nhom> --platforms android hoc_tu_vung`; đặt `minSdkVersion 23`.
- [ ] **Step 2:** Thêm dependency theo Tech Stack (chưa thêm Firebase options); `flutter pub get`.
- [ ] **Step 3:** Viết 2 file test ở trên → chạy `flutter test` → đỏ.
- [ ] **Step 4:** Cài theme sáng/tối (ColorScheme.fromSeed, font hệ thống), router với `StatefulShellRoute.indexedStack` 4 nhánh, `MainShell` dùng `LayoutBuilder` chọn Bar/Rail tại 600 dp, transition fade+slide bằng `CustomTransitionPage`.
- [ ] **Step 5:** `flutter test` → xanh; `flutter analyze` → 0 issue.
- [ ] **Step 6:** Commit `feat(app): scaffold app shell, theme, router, architecture test`.

### Task L2: SrsScheduler và test so khớp FSRS (tuần 1)

**Files:**
- Create: `research/requirements.txt`, `research/export_fsrs_vectors.py`, `test/fixtures/fsrs_vectors.json`, `lib/data/srs/srs_scheduler.dart`, `docs/algorithms.md` (mục FSRS)
- Test: `test/data/srs/srs_scheduler_test.dart`

**Interfaces:**
- Consumes: package `fsrs` – `Scheduler(parameters:, desiredRetention:, learningSteps:, relearningSteps:, maximumInterval:, enableFuzzing:)`, `Scheduler.reviewCard(card, rating, …)` trả `({Card card, ReviewLog reviewLog})`, `Scheduler.getCardRetrievability(card, …)`, `Card.create()`, enum `Rating`, `State`. **Bước 1 xác nhận lại tên tham số tùy chọn (thời điểm ôn, thời điểm hiện tại) trong README package trước khi viết wrapper.**
- Produces:
  ```
  class SrsState { final int state; final int? step; final double? stability; final double? difficulty; final DateTime due; final DateTime? lastReview; }
  class SrsScheduler {
    SrsScheduler({required double desiredRetention});
    SrsState newCard(DateTime nowUtc);
    ({SrsState next, double retrievabilityBefore}) review(SrsState s, int rating, DateTime nowUtc);  // rating 1..4
    double retrievability(SrsState s, DateTime nowUtc);
    Duration previewInterval(SrsState s, int rating, DateTime nowUtc);   // hiện trên 4 nút lật thẻ
    double expectedStabilityGain(SrsState s, DateTime nowUtc);          // R·S'(Good) + (1−R)·S'(Again) − S, dùng ở L13
  }
  ```
  `SrsState` là kiểu của mình (không lộ kiểu của package ra ngoài `srs/`), để đổi package không ảnh hưởng repository.

**Test cases:**
- So khớp: với mỗi chuỗi trong `fsrs_vectors.json` (~20 chuỗi: toàn Good; Again-Good-Good; Easy ngay lần đầu; Hard xen kẽ; quên sau 30 ngày; ôn 2 lần trong 1 ngày; desiredRetention 0.85 và 0.95), sau mỗi bước `stability`, `difficulty` khớp sai số 1e-6 và `due` khớp tới giây.
- Tính tay theo wiki FSRS-6: thẻ mới chấm Good lần đầu → `stability == w[2]` của tham số mặc định; `difficulty` theo công thức D₀(G=3).
- `retrievability` ngay sau khi ôn ≈ 1.0; tại thời điểm `due` của thẻ ở trạng thái review ≈ `desiredRetention` (sai số 0.01).
- `previewInterval`: Again < Hard < Good < Easy với thẻ đang review.
- `expectedStabilityGain` ≥ 0 khi R gần 1 và có thể âm khi R rất thấp (ghi lại giá trị cụ thể từ một trường hợp tính tay).

- [ ] **Step 1:** Đọc mục FSRS-6 trên wiki awesome-fsrs/The-Algorithm; ghi tóm tắt D/S/R và vai trò w0–w20 vào `docs/algorithms.md` bằng lời của mình.
- [ ] **Step 2:** `research/requirements.txt` ghim `fsrs @ git+https://github.com/open-spaced-repetition/py-fsrs@6fd0857`; tạo venv, cài.
- [ ] **Step 3:** Viết `export_fsrs_vectors.py`: các chuỗi (rating, thời điểm) cố định, `enable_fuzzing=False`, xuất JSON gồm input và trạng thái sau mỗi bước. Chạy, commit file JSON.
- [ ] **Step 4:** Viết test Dart theo các case trên → đỏ.
- [ ] **Step 5:** Cài `SrsScheduler` bọc package → xanh.
- [ ] **Step 6:** Commit `feat(srs): add SrsScheduler wrapper with py-fsrs conformance vectors`.

### Task L3: Tiện ích pinyin và chuẩn hoá chữ (tuần 1)

**Files:**
- Create: `lib/core/utils/pinyin.dart`, `lib/core/utils/text_normalize.dart`
- Test: `test/core/utils/pinyin_test.dart`, `test/core/utils/text_normalize_test.dart`

**Interfaces:**
- Produces:
  ```
  String numberedToMarked(String s);      // "xue2 sheng1" → "xué shēng"
  String toPlain(String s);               // "xué shēng" / "xue2 sheng1" → "xuesheng"
  enum PinyinMatch { exact, wrongTone, wrong }
  PinyinMatch comparePinyin(String input, String expectedMarked);
  String normalizeVi(String s);           // "Học Sinh" → "hoc sinh", "Đại" → "dai"
  bool containsHanzi(String s);           // có ký tự CJK U+4E00–U+9FFF (và mở rộng A)
  ```

**Test cases:**
- `numberedToMarked`: `ni3 hao3`→`nǐ hǎo`; `lv4`→`lǜ`; `lu:4`→`lǜ`; `nu:3`→`nǚ`; `ma5`→`ma`; `er2`→`ér`; `xian1`→`xiān` (dấu trên a); `gui4`→`guì` (dấu trên i khi "ui"); `liu2`→`liú` (dấu trên u khi "iu").
- `toPlain`: `Xué Shēng`→`xuesheng`; `lǜ`→`lv`; `nǚ`→`nv`.
- `comparePinyin(input, "xué shēng")`: `xue2sheng1`→exact; `XUÉ SHĒNG`→exact; `xuesheng`→wrongTone; `xue1sheng1`→wrongTone; `xie2sheng1`→wrong; chuỗi rỗng→wrong.
- `comparePinyin("ma", "ma")` và `("ma5","ma")`, `("ma0","ma")` → exact (thanh nhẹ).
- `normalizeVi`: `Học sinh`→`hoc sinh`; `ĐẠI HỌC`→`dai hoc`; `  khoảng   trắng `→`khoang trang`.
- `containsHanzi`: `学生`→true; `xue`→false; `学a`→true.

- [ ] **Step 1:** Viết test → đỏ. **Step 2:** Cài đặt → xanh. **Step 3:** Commit `feat(app): add pinyin and Vietnamese text normalization utils`.

### Task L4: Hai drift DB và file từ điển mẫu (tuần 1)

**Files:**
- Create: `lib/data/db/dictionary.drift`, `lib/data/db/dictionary_database.dart`, `lib/data/db/app_database.dart`, `test/fixtures/dictionary_sample.sql` (20 từ HSK 1 viết tay, chạy được bằng sqlite3)
- Test: `test/data/db/dictionary_database_test.dart`, `test/data/db/app_database_test.dart`

**Interfaces:**
- Produces (`dictionary.drift`, **chỉ SQL chuẩn SQLite**, vì Python D2 chạy file này bằng `executescript`):
  - `dict_entries(id INTEGER PK, simplified TEXT, traditional TEXT, pinyin TEXT, pinyin_plain TEXT, han_viet TEXT, han_viet_plain TEXT, meaning_vi TEXT, meaning_vi_plain TEXT, meaning_en TEXT, hsk_level INTEGER NULL, freq_rank INTEGER NULL)`
  - `hanzi(char TEXT PK, han_viet_readings TEXT, radical TEXT, decomposition TEXT, meaning TEXT)`
  - `dict_fts USING fts5(pinyin_plain, han_viet_plain, meaning_vi_plain, content='dict_entries', content_rowid='id')`
  - index `simplified`, `hsk_level`; `PRAGMA user_version = 1`.
- Produces (`app_database.dart`), mọi bảng đồng bộ có `updated_at` (UTC), `deleted_at` NULL, `dirty` bool:
  - `decks(id TEXT PK, name, description, hsk_level NULL, created_at, …)`
  - `cards(id TEXT PK, deck_id, dict_entry_id NULL, hanzi, pinyin, han_viet, meaning, example, srs_state, srs_step NULL, stability NULL, difficulty NULL, due, last_review NULL, …)`
  - `review_logs(id TEXT PK, card_id, rating, reviewed_at, duration_ms, mode, retrievability_before, …)` (không có `deleted_at`: chỉ thêm)
  - `settings(id=1, desired_retention, new_per_day, reminder_minutes NULL, theme_mode, updated_at, dirty)`
  - `sync_state(id=1, last_pulled_at NULL)`
- Produces: `Future<DictionaryDatabase> DictionaryDatabase.openFromAssets({void Function(double)? onProgress})` – chép `assets/dictionary.sqlite` ra thư mục app nếu chưa có hoặc `user_version` khác, rồi mở chỉ đọc.

**Test cases:**
- Nạp `dictionary_sample.sql` vào DB trong RAM bằng chính `dictionary.drift` → truy vấn `simplified='学生'` trả `han_viet='học sinh'`, `pinyin_plain='xuesheng'`.
- FTS: `dict_fts MATCH 'xue*'` trả có 学生 và 学习.
- App DB: tạo deck, card, log; xoá mềm deck → hàng còn trong bảng, `deleted_at` khác NULL, `dirty = true`.
- `settings` lần đầu đọc ra mặc định: 0.90, 10, NULL, system.
- Trên Windows: nếu test drift báo thiếu thư viện sqlite3, ghi cách xử lý vào `CONTRIBUTING.md` (mục "Chạy test trên Windows") trước khi đi tiếp.

- [ ] **Step 1:** Viết schema và test → đỏ. **Step 2:** Chạy `dart run build_runner build` → cài 2 DB → xanh.
- [ ] **Step 3:** Màn Splash (`lib/presentation/screens/splash/splash_screen.dart`): gọi `openFromAssets(onProgress:)`, hiện thanh tiến trình khi chép lần đầu, xong thì vào router. Widget test: `onProgress` 0 → 0.5 → 1.0 thì thanh tiến trình đổi theo và cuối cùng chuyển sang `/home`.
- [ ] **Step 4:** Push `dictionary.drift` lên `develop` sớm (cuối tuần 1) và báo Ly.
- [ ] **Step 5:** Commit `feat(data): add dictionary and app drift databases with splash loader`.

### Task L5: Tra từ, tìm kiếm, chi tiết từ, TTS (tuần 2–3)

**Files:**
- Create: `lib/data/repositories/dictionary_repository.dart`, `lib/data/services/tts_service.dart`, `lib/presentation/state/dictionary/{search_cubit,search_state,word_detail_cubit,word_detail_state}.dart`, `lib/presentation/screens/dictionary/{dictionary_screen,word_detail_screen}.dart`, `lib/presentation/widgets/{hanzi_breakdown,skeleton_list}.dart`
- Test: `test/data/repositories/dictionary_repository_test.dart`, `test/presentation/state/search_cubit_test.dart`

**Interfaces:**
- Produces:
  ```
  class DictEntry { int id; String simplified, traditional, pinyin, hanViet, meaningVi, meaningEn; int? hskLevel; }
  class HanziInfo { String char, hanVietReadings, radical, decomposition, meaning; }
  class DictionaryRepository {
    Future<List<DictEntry>> search(String query, {int limit = 50});
    Future<DictEntry?> byId(int id);
    Future<List<HanziInfo>> breakdown(String word);          // tách từng chữ
    Future<List<DictEntry>> byHskLevel(int level);
    Future<List<DictEntry>> randomSameLevel(int? level, {required int count, required Set<int> excludeIds});
  }
  class TtsService { Future<void> speak(String hanzi); }      // zh-CN, tốc độ 0.45
  ```
- Quy tắc `search`: rỗng → `[]`. Có chữ Hán → `simplified LIKE q%` trước, rồi `instr(simplified,q)>0`. Không có chữ Hán → `toPlain` + `normalizeVi` → FTS prefix trên 3 cột. Sắp xếp: khớp chính xác trước, có `hsk_level` trước, rồi bm25.

**Test cases:**
- `search('学生')` → phần tử đầu là 学生. `search('xuesheng')`, `search('xué shēng')`, `search('xue2sheng1')` → có 学生. `search('hoc sinh')` và `search('học sinh')` → có 学生. `search('student')` không bắt buộc (nghĩa Anh không đánh FTS). `search('   ')` → rỗng.
- `breakdown('学生')` → 2 phần tử, `char` = 学, 生.
- `randomSameLevel(1, count: 3, excludeIds: {id学生})` → 3 phần tử khác nhau, không chứa 学生.
- `SearchCubit`: gõ 'x','xu','xue' trong 100 ms → chỉ 1 lần gọi repository (debounce 300 ms) và state cuối có kết quả; lỗi repository → state lỗi có thông báo tiếng Việt.

- [ ] **Step 1:** Test repository + cubit → đỏ. **Step 2:** Cài đặt → xanh.
- [ ] **Step 3:** Màn tra từ (ô tìm, skeleton khi tải, trạng thái rỗng "Không tìm thấy"), màn chi tiết (chữ to bọc `Hero`, pinyin, nút 🔊, Hán-Việt, nghĩa, `HanziBreakdown`, nút "Thêm vào bộ…" để mở ở L6).
- [ ] **Step 4:** Chạy app với từ điển mẫu, tìm thử 4 kiểu. **Step 5:** Commit `feat(app): dictionary search, word detail and TTS`.

### Task L6: CRUD bộ từ và thẻ, thêm bộ HSK (tuần 2)

**Files:**
- Create: `lib/data/repositories/{deck,card}_repository.dart`, `lib/presentation/state/decks/{deck_list_cubit,deck_detail_cubit,card_editor_cubit}.dart` + state, `lib/presentation/screens/decks/{deck_list_screen,deck_detail_screen,card_editor_screen,add_hsk_sheet}.dart`
- Test: `test/data/repositories/{deck,card}_repository_test.dart`, `test/presentation/state/card_editor_cubit_test.dart`

**Interfaces:**
- Consumes: `DictionaryRepository.byHskLevel`, `.search` (gợi ý khi gõ chữ Hán), `SrsScheduler.newCard`, `Clock`.
- Produces:
  ```
  class Deck { String id, name, description; int? hskLevel; int cardCount; int dueCount; }
  class CardItem { String id, deckId, hanzi, pinyin, hanViet, meaning, example; int? dictEntryId; SrsState srs; }
  class DeckRepository {
    Stream<List<Deck>> watchDecks({String filter = ''});
    Future<String> create(String name, String description);
    Future<void> rename(String id, String name, String description);
    Future<void> delete(String id);                    // xoá mềm deck + mọi card của nó
    Future<void> restore(String id);                   // cho nút Hoàn tác
    Future<String> addHskDeck(int level);              // tạo deck + chép thẻ; gọi lần 2 cùng level → trả deck cũ, không nhân đôi
  }
  class CardRepository {
    Stream<List<CardItem>> watchCards(String deckId, {String filter = ''});
    Future<String> create(String deckId, CardDraft draft);
    Future<void> update(String id, CardDraft draft);
    Future<void> delete(String id);
    Future<void> restore(String id);
  }
  class CardDraft { String hanzi, pinyin, hanViet, meaning, example; int? dictEntryId; }
  ```
  Mọi thao tác ghi đặt `updated_at = clock.nowUtc()`, `dirty = true`.

**Test cases:**
- `addHskDeck(1)` với từ điển mẫu → deck có đúng số thẻ HSK 1 trong mẫu, mọi thẻ `srs_state` mới; gọi lại → cùng id, không thêm thẻ.
- `delete(deck)` → `watchDecks` không còn deck, thẻ của nó `deleted_at` khác NULL; `restore` → hiện lại đủ thẻ.
- `watchCards(deck, filter:'hoc')` → khớp theo Hán-Việt bỏ dấu; `filter:'学'` → khớp chữ Hán.
- `CardEditorCubit`: hanzi rỗng hoặc meaning rỗng → lỗi validate, không ghi DB; gõ '学生' → gợi ý từ từ điển, chọn gợi ý → điền pinyin/Hán-Việt/nghĩa và `dictEntryId`.

- [ ] **Step 1:** Test → đỏ. **Step 2:** Cài repository + cubit → xanh.
- [ ] **Step 3:** Màn danh sách bộ (ô lọc, FAB tạo bộ, sheet chọn HSK 1–6, badge số thẻ đến hạn), chi tiết bộ (vuốt xoá + SnackBar "Hoàn tác"), form tạo/sửa thẻ; nối nút "Thêm vào bộ…" của L5.
- [ ] **Step 4:** Commit `feat(app): deck and card CRUD with HSK deck import`.

### Task L7: Ôn tập: ReviewRepository, phiên ôn kiểu lật thẻ (tuần 2)

**Files:**
- Create: `lib/data/repositories/review_repository.dart`, `lib/data/srs/review_queue_builder.dart` (bản đầu: theo hạn), `lib/presentation/state/review/{review_session_cubit,review_session_state}.dart`, `lib/presentation/screens/review/{review_screen,review_summary_screen,mode_picker}.dart`, `lib/presentation/widgets/flip_card.dart`
- Test: `test/data/repositories/review_repository_test.dart`, `test/data/srs/review_queue_builder_test.dart`, `test/presentation/state/review_session_cubit_test.dart`, `test/presentation/widgets/flip_card_test.dart`

**Interfaces:**
- Consumes: `SrsScheduler`, `SettingsRepository.current()` (L9; tới khi có L9 dùng mặc định), `Clock`.
- Produces:
  ```
  enum ReviewMode { flip, choice, typing, listening }
  enum QueueStrategy { byDue, lowestR, maxGain }
  class ReviewQueueBuilder {
    static List<CardItem> build({required List<CardItem> due, required List<CardItem> fresh,
      required int dailyLimit, required int newLimit, required QueueStrategy strategy,
      required DateTime nowUtc, required SrsScheduler scheduler});
  }
  class ReviewRepository {
    Future<List<CardItem>> todayQueue({String? deckId});
    Future<void> answer(String cardId, int rating, ReviewMode mode, Duration took);  // 1 transaction
    Future<({int due, int fresh})> todayCounts();
  }
  ```
- `todayQueue`: thẻ chưa xoá, deck chưa xoá, `due <= now` (đã có `last_review`) + thẻ mới tối đa `newPerDay − số thẻ mới đã học hôm nay`; xếp bằng `ReviewQueueBuilder` (strategy `byDue` cho tới L13). `dailyLimit` = 200.

**Test cases:**
- `answer(c, 3, flip, 5s)` → thẻ có `due` mới bằng `SrsScheduler.review(...).next.due`, có 1 `review_logs` với `retrievability_before` đúng, cả thẻ và log `dirty = true`; nếu ghi log lỗi (giả lập) thì thẻ không đổi (transaction).
- `todayQueue` không chứa: thẻ đã xoá, thẻ của deck đã xoá (**Review Focus 3**), thẻ chưa đến hạn.
- `newPerDay = 2`, đã học 1 thẻ mới hôm nay → queue có tối đa 1 thẻ mới.
- **Review Focus 5:** queue 5 thẻ, `answer` 2 thẻ, tạo `ReviewSessionCubit` mới → queue còn 3.
- `ReviewQueueBuilder.byDue`: due [hôm qua, 10 ngày trước, 3 ngày trước] → thứ tự [10 ngày, 3 ngày, hôm qua]; vượt `dailyLimit` thì cắt.
- `ReviewSessionCubit`: start → `showingFront`; flip → `showingBack` có 4 `previewInterval`; rate → thẻ kế tiếp; hết thẻ → `finished` với số đúng/sai; queue rỗng → `empty`.
- `FlipCard`: tap → sau animation thấy mặt sau; `AnimatedSwitcher` đổi thẻ không lỗi.

- [ ] **Step 1:** Test → đỏ. **Step 2:** Cài đặt → xanh.
- [ ] **Step 3:** Màn chọn kiểu ôn (chip Lật thẻ / Trắc nghiệm / Gõ pinyin / Nghe / Trộn; tạm chỉ bật Lật thẻ), màn ôn có thanh tiến độ, 4 nút kèm khoảng cách ôn sau, màn tổng kết.
- [ ] **Step 4:** Commit `feat(srs): review repository, queue builder and flip-card session`.

### Task L8: Ba kiểu ôn còn lại (tuần 3)

**Files:**
- Create: `lib/data/models/quiz_question.dart`, `lib/data/repositories/quiz_builder.dart`, `lib/presentation/screens/review/modes/{choice_view,typing_view,listening_view}.dart`
- Modify: `review_session_cubit.dart`, `mode_picker.dart`
- Test: `test/data/repositories/quiz_builder_test.dart`, mở rộng `review_session_cubit_test.dart`

**Interfaces:**
- Consumes: `DictionaryRepository.randomSameLevel`, `comparePinyin`, `TtsService`.
- Produces:
  ```
  class QuizQuestion { CardItem card; List<String> options; int correctIndex; }
  class QuizBuilder {
    Future<QuizQuestion> meaningChoice(CardItem card, List<CardItem> pool);   // 4 nghĩa
    Future<QuizQuestion> hanziChoice(CardItem card, List<CardItem> pool);     // 4 chữ Hán (kiểu nghe)
  }
  int ratingFor(ReviewMode mode, {bool? correct, PinyinMatch? match});
  ```
- Quy tắc: choice/listening đúng → 3, sai → 1; typing exact → 3, wrongTone → 2, wrong → 1. Thẻ mới (chưa có `last_review`) luôn hiện kiểu lật thẻ. "Trộn": chọn ngẫu nhiên trong 4 kiểu cho thẻ đã học, seed cố định trong test.

**Test cases:**
- **Review Focus 4:** pool chỉ 2 thẻ → `meaningChoice` vẫn trả 4 lựa chọn khác nhau, đúng 1 đáp án đúng ở `correctIndex`, nhiễu không trùng nghĩa đáp án.
- `ratingFor(typing, match: wrongTone) == 2`; `ratingFor(choice, correct: false) == 1`.
- Cubit ở chế độ Trộn: thẻ mới → flip; thẻ đã học → một trong 4 kiểu.
- Kiểu gõ: input `xue2sheng1` cho 学生 → state hiện "Đúng" và rating 3 được gửi.

- [ ] **Step 1:** Test → đỏ. **Step 2:** Cài đặt → xanh. **Step 3:** 3 view kiểu ôn (phản hồi đúng/sai có màu + animation ngắn, kiểu nghe tự phát TTS khi hiện). **Step 4:** Commit `feat(app): multiple choice, pinyin typing and listening review modes`.

### Task L9: Trang chủ và Cài đặt (tuần 4)

**Files:**
- Create: `lib/data/repositories/settings_repository.dart`, `lib/presentation/state/{home/home_cubit,settings/settings_cubit}.dart` + state, `lib/presentation/screens/{home/home_screen,settings/settings_screen,settings/licenses_screen}.dart`
- Test: `test/data/repositories/settings_repository_test.dart`, `test/presentation/state/settings_cubit_test.dart`

**Interfaces:**
- Consumes: `NotificationService.scheduleDailyReminder(int minutesOfDay)` và `.cancelReminder()` (D1 stub, D4 thật), `ReviewRepository.todayCounts`, `StatsRepository.streak` (L10; tới khi có trả 0).
- Produces:
  ```
  class AppSettings { double desiredRetention; int newPerDay; int? reminderMinutes; ThemeMode themeMode; }
  class SettingsRepository { Stream<AppSettings> watch(); Future<AppSettings> current(); Future<void> save(AppSettings s); }
  ```
  `save` kẹp `desiredRetention` vào [0.80, 0.95] và `newPerDay` vào [1, 100].

**Test cases:**
- `save(retention 0.99)` → đọc lại 0.95; `save(newPerDay 0)` → 1.
- `SettingsCubit.setReminder(20:30)` → gọi `scheduleDailyReminder(1230)`; tắt nhắc → gọi `cancelReminder()`.
- Đổi theme → `MaterialApp` dùng `ThemeMode` mới (widget test).
- `HomeCubit`: 3 thẻ đến hạn + 2 thẻ mới → state hiện 3/2; 0/0 → state "Hôm nay đã xong".

- [ ] **Step 1:** Test → đỏ. **Step 2:** Cài đặt → xanh.
- [ ] **Step 3:** Trang chủ (số thẻ, streak, nút Bắt đầu ôn, chỗ cho biểu tượng đồng bộ của D6), Cài đặt (slider retention, stepper từ mới, time picker, theme, chỗ cho nút "Đồng bộ ngay" và "Đăng xuất" của D3/D6), màn giấy phép (liệt kê 5 nguồn dữ liệu + `showLicensePage`).
- [ ] **Step 4:** Commit `feat(app): home and settings screens`.

### Task L10: Thống kê (tuần 4–5)

**Files:**
- Create: `lib/data/repositories/stats_repository.dart`, `lib/data/models/stats_snapshot.dart`, `lib/presentation/state/stats/{stats_cubit,stats_state}.dart`, `lib/presentation/screens/stats/stats_screen.dart`, `lib/presentation/widgets/charts/{hsk_bar_chart,forecast_chart,forgetting_curve_chart,streak_card}.dart`
- Test: `test/data/repositories/stats_repository_test.dart`

**Interfaces:**
- Produces:
  ```
  class StatsRepository {
    Future<Map<int?, int>> wordsByHsk();                         // null = ngoài HSK
    Future<int> streak();                                        // theo ngày địa phương
    Future<List<int>> forecast({int days = 30});                 // phần tử i = số thẻ đến hạn ngày i
    Future<List<({int bucketDays, double actual, double predicted, int n})>> forgettingCurve();
  }
  ```
  Nhóm `forgettingCurve` theo số ngày kể từ lần ôn trước: 0,1,2,3–4,5–7,8–14,15–30,>30.

**Test cases:**
- **Review Focus 1:** log lúc 23:59 và 00:01 (giờ địa phương, `FixedClock`) → `streak == 2`; chỉ log hôm qua, chưa ôn hôm nay → streak vẫn tính tới hôm qua; cách 1 ngày trống → streak đứt.
- `forecast`: thẻ due hôm nay (kể cả quá hạn) vào phần tử 0; due ngày mai vào phần tử 1; thẻ đã xoá không tính (**Review Focus 3**).
- `forgettingCurve`: 4 log ở nhóm 1 ngày, 3 nhớ 1 quên → `actual 0.75`, `predicted` = trung bình `retrievability_before`.
- `wordsByHsk` không đếm thẻ của deck đã xoá.

- [ ] **Step 1:** Test → đỏ. **Step 2:** Cài đặt → xanh. **Step 3:** 4 biểu đồ `fl_chart` có animation mặc định, trạng thái rỗng khi chưa có log. **Step 4:** Commit `feat(app): statistics charts`.

### Task L11: Animation, responsive, widget test 3 kích thước (tuần 5, 7)

**Files:**
- Modify: các screen; Create: `test/presentation/responsive_test.dart`

**Test cases:**
- Với mỗi kích thước 320×640, 411×891, 800×1280 và cả 2 theme: dựng Trang chủ, Bộ từ, Chi tiết từ, Phiên ôn (lật thẻ, trắc nghiệm), Thống kê, Cài đặt → không có lỗi overflow (`tester.takeException() == null`).
- Chữ Hán trên thẻ ôn co theo chiều rộng: ở 320 dp không tràn với từ 4 chữ.

- [ ] **Step 1:** Viết test → ghi lại màn nào đỏ. **Step 2:** Sửa layout (Flexible, FittedBox cho chữ Hán, cuộn khi cần). **Step 3:** Rà 5 animation: chuyển trang, skeleton, tiến trình chép từ điển ở Splash, lật thẻ, Hero. **Step 4:** Commit `test(app): responsive layout tests on three screen sizes`.

### Task L12: Khung mô phỏng người học (Python, tuần 5)

**Files:**
- Create: `research/sim/{learner.py,strategies.py,simulate.py}`, `research/tests/test_sim.py`, mục "Mô phỏng" trong `docs/algorithms.md`

**Interfaces:**
- Produces:
  ```
  class Learner:  # trí nhớ thật theo FSRS-6, tham số = mặc định × nhiễu log-normal (sigma 0.1), seed được
      def recall(self, card_id, t) -> bool
  def order_by_due(cards, t) / order_by_lowest_r(cards, t, sched) / order_by_max_gain(cards, t, sched) -> list
  def simulate(strategy, n_cards=1000, days=90, break_start=30, break_days=14, daily_limit=100, new_per_day=10, seed=0) -> dict
      # trả: total_r_day90, days_to_clear_backlog, total_reviews, daily_series
  ```

**Test cases:**
- Không nghỉ, giới hạn rất lớn → 3 chiến lược cho cùng `total_reviews` (không có dồn bài thì thứ tự không quan trọng).
- Cùng seed → cùng kết quả; khác seed → khác.
- `order_by_lowest_r` trả thẻ R nhỏ nhất đầu tiên trên một danh sách tự tạo.

- [ ] **Step 1:** Test → đỏ. **Step 2:** Cài đặt → xanh. **Step 3:** Script chạy lưới N ∈ {7,14,30}, K ∈ {50,100}, 20 seed → `research/figures/*.png` + bảng CSV. Bàn giao cho Nhi. **Step 4:** Commit `feat(research): learner simulator and backlog strategies`.

### Task L13: Port chiến lược thắng và replay (tuần 6)

**Files:**
- Modify: `lib/data/srs/review_queue_builder.dart`; Create: `lib/data/srs/replay.dart`
- Test: mở rộng `review_queue_builder_test.dart`; `test/data/srs/replay_test.dart`

**Interfaces:**
- Produces: `SrsState replayLogs(SrsScheduler s, DateTime createdAt, List<({int rating, DateTime reviewedAt})> logs)` – sắp theo `reviewedAt` rồi áp lần lượt.
- `ReviewQueueBuilder` dùng chiến lược thắng (theo kết quả C6) **khi số thẻ đến hạn > dailyLimit**; ngược lại giữ `byDue`.

**Test cases:**
- `replayLogs` trên log 2 máy gộp lẫn thứ tự == trạng thái khi ôn tuần tự cùng các log đó.
- `replayLogs` danh sách rỗng == `newCard(createdAt)`.
- Chiến lược thắng: cùng bộ thẻ cố định, thứ tự trả về khớp thứ tự Python `strategies.py` sinh ra cho cùng input (xuất ra `test/fixtures/strategy_vectors.json` bằng script nhỏ trong `research/`).

- [ ] **Step 1:** Test → đỏ. **Step 2:** Cài đặt → xanh. **Step 3:** Commit `feat(srs): backlog-aware queue ordering and log replay`.

### Task L14: Hoàn thiện (tuần 8–9)

- [ ] Trạng thái rỗng/lỗi cho mọi màn (danh sách rỗng, mất mạng chỉ hiện ở biểu tượng đồng bộ, lỗi DB hiện SnackBar).
- [ ] Rà dark mode từng màn; chụp ảnh màn hình cho README.
- [ ] Điền cột "Bằng chứng" của bảng yêu cầu trong README (đường dẫn file/test cụ thể).
- [ ] Commit `docs(docs): complete requirement mapping in README`.

---

# TRACK LY (task D)

### Task D1: CI và chữ ký NotificationService (tuần 1)

**Files:**
- Create: `.github/workflows/ci.yml`, `lib/data/services/notification_service.dart` (chỉ chữ ký, thân rỗng)

**Interfaces:**
- Produces: `class NotificationService { Future<void> init(); Future<bool> requestPermission(); Future<void> scheduleDailyReminder(int minutesOfDay); Future<void> cancelReminder(); }`

- [ ] **Step 1:** Workflow chạy trên PR vào `develop`/`main`: setup Flutter stable, `flutter pub get`, `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`.
- [ ] **Step 2:** Mở PR thử có một test cố tình đỏ → CI đỏ; sửa → xanh. Báo leader bật "required check".
- [ ] **Step 3:** Commit `chore(ci): add flutter analyze and test workflow` và `feat(data): notification service interface stub`.

### Task D2: Pipeline từ điển (tuần 1–2, cập nhật CSV tới tuần 4)

**Files:**
- Create: `tools/build_dictionary.py`, `tools/check_dictionary.py`, `tools/requirements.txt`, `tools/README.md` (nguồn + giấy phép + cách chạy), `tools/overrides/{meaning_vi,hanviet}.csv` (header do D2 định nghĩa, Nhi điền)
- Output: `assets/dictionary.sqlite`

**Interfaces:**
- Consumes: `lib/data/db/dictionary.drift` (L4) – chạy nguyên văn bằng `sqlite3.executescript`, không tự viết CREATE TABLE.
- Produces: `assets/dictionary.sqlite` với `user_version = 1`; CSV: `meaning_vi.csv(simplified,pinyin,meaning_vi)`, `hanviet.csv(simplified,han_viet)`.
- Quy tắc ghép (mục 4 spec): CEDICT là khung mục từ; nghĩa Việt từ CVDICT khớp theo (simplified, pinyin); Hán-Việt = nối âm đầu của `kVietnamese` từng chữ, viết thường; HSK theo HSK 2.0; CSV ghi đè sau cùng; `*_plain` dùng cùng quy tắc với `toPlain`/`normalizeVi` (L3) – thêm test chéo bằng 10 cặp mẫu chung.
- Tải nguồn vào `tools/raw/` (gitignore), mỗi nguồn một thư mục riêng; script nhận đường dẫn làm tham số.

**Test cases (`check_dictionary.py`, chạy sau mỗi lần build, thoát mã ≠ 0 nếu sai):**
- Số mục > 100.000 (bản đầy đủ) hoặc ≥ số từ HSK 1 (bản v0).
- `学生` → `han_viet = 'học sinh'`, `pinyin_plain = 'xuesheng'`, `hsk_level = 1`.
- Mọi từ HSK 1–6 có trong `dict_entries`; in danh sách từ HSK thiếu `meaning_vi`.
- FTS `xue*` trả kết quả; `PRAGMA integrity_check` = ok.
- In kích thước file; nếu > 40 MB thì in cảnh báo và gợi ý chế độ `--hsk-plus-top 30000`.

- [ ] **Step 1 (v0, tuần 1):** chỉ HSK 1, đủ cột → leader thay file mẫu. **Step 2 (v1, tuần 2):** đầy đủ + CSV + đo kích thước APK (`flutter build apk --release --analyze-size`), báo số đo. **Step 3:** Commit `feat(data): dictionary build pipeline` và mỗi lần cập nhật CSV `chore(data): rebuild dictionary with HSK n overrides`.

### Task D3: Đăng nhập (tuần 3)

**Files:**
- Create: `lib/data/repositories/auth_repository.dart`, `lib/presentation/state/auth/{auth_cubit,auth_state}.dart`, `lib/presentation/screens/auth/{login_screen,register_screen,forgot_password_screen}.dart`
- Modify: `lib/app.dart`, `lib/core/router/app_router.dart` (truyền `isSignedIn` thật)
- Test: `test/data/repositories/auth_repository_test.dart` (firebase_auth_mocks), `test/presentation/state/auth_cubit_test.dart`

**Interfaces:**
- Produces: `class AuthRepository { Stream<String?> watchUid(); Future<void> signIn(String email, String password); Future<void> register(String email, String password); Future<void> sendReset(String email); Future<void> signOut(); }` – ném `AuthFailure(String messageVi)`.

**Test cases:**
- Email sai định dạng / mật khẩu < 6 ký tự → lỗi validate trước khi gọi Firebase.
- `wrong-password`, `user-not-found`, `email-already-in-use`, `network-request-failed` → thông báo tiếng Việt tương ứng.
- Chưa đăng nhập → router chuyển `/login`; đăng nhập xong → `/home`; đăng xuất → `/login`.
- Không có mạng ở lần đầu → hiện "Cần kết nối mạng để đăng nhập lần đầu".

- [ ] Test → đỏ → cài → xanh → màn hình → commit `feat(auth): email login, register, password reset`.

### Task D4: Thông báo nhắc ôn và kết nối mạng (tuần 4)

**Files:**
- Modify: `lib/data/services/notification_service.dart`; Create: `lib/data/services/connectivity_service.dart`; Modify `AndroidManifest.xml` (quyền `POST_NOTIFICATIONS`)
- Test: `test/data/services/notification_service_test.dart` (mock plugin bằng mocktail)

**Interfaces:**
- Produces: `class ConnectivityService { Stream<bool> watchOnline(); Future<bool> isOnline(); }`
- `scheduleDailyReminder` dùng `zonedSchedule` lặp hằng ngày theo giờ địa phương, chế độ inexact; nội dung "Bạn có thẻ cần ôn hôm nay"; bấm mở `/home`.

**Test cases:**
- `scheduleDailyReminder(1230)` → plugin nhận lịch 20:30 giờ địa phương, lặp theo ngày; gọi lần 2 → huỷ lịch cũ trước.
- Từ chối quyền → `requestPermission()` trả false, app không crash, Cài đặt hiện gợi ý mở quyền.

- [ ] Test → đỏ → cài → xanh → thử trên máy Android 13+ thật → commit `feat(data): daily review reminder and connectivity service`.

### Task D5: SyncService: đẩy, kéo, LWW, tombstone (tuần 5)

**Files:**
- Create: `lib/data/remote/sync_service.dart`, `firestore.rules`
- Test: `test/data/remote/sync_service_test.dart` (fake_cloud_firestore + app DB in-memory)

**Interfaces:**
- Consumes: bảng và cột đồng bộ của L4.
- Produces:
  ```
  enum SyncStatus { idle, syncing, ok, offline, error }
  class SyncService {
    Stream<SyncStatus> watchStatus();
    Future<void> syncNow();          // push rồi pull; không ném lỗi ra ngoài, chỉ đổi status
    Future<int> pendingCount();      // số dòng dirty
  }
  ```

**Test cases:**
- Push: 1 deck + 1 card + 1 review log + settings đều dirty → có document tương ứng ở `users/{uid}/decks|cards|reviewLogs/{id}` và `users/{uid}/meta/settings`, mỗi cái có `serverUpdatedAt`; sau đó `dirty = false`.
- Pull settings: remote `meta/settings` mới hơn → `SettingsRepository.current()` trả giá trị remote.
- Pull: document remote mới hơn → ghi đè local; local `updated_at` mới hơn remote → giữ local (LWW).
- Tombstone: remote có `deletedAt` → local bị xoá mềm.
- ReviewLog cùng id ở cả hai phía → không nhân đôi.
- Firestore ném lỗi / quá 10 s (giả lập bằng wrapper chậm) → `dirty` giữ nguyên, status `offline`/`error`.
- `firestore.rules`: kiểm tra bằng Rules Playground trong Firebase Console: uid A đọc `users/B/...` → bị từ chối (ghi kết quả vào `docs/test-cases.md`).

- [ ] Test → đỏ → cài → xanh → commit `feat(sync): firestore push/pull with last-write-wins`.

### Task D6: Kích hoạt đồng bộ, replay, đăng xuất an toàn (tuần 6)

**Files:**
- Modify: `sync_service.dart`, `app.dart` (lắng nghe lifecycle), màn Trang chủ/Cài đặt (biểu tượng + nút "Đồng bộ ngay" + "Đăng xuất")
- Create: `lib/presentation/state/sync/{sync_cubit,sync_state}.dart`
- Test: mở rộng `sync_service_test.dart`, `test/presentation/state/sync_cubit_test.dart`

**Interfaces:**
- Consumes: `replayLogs` (L13), `ConnectivityService`, `AuthRepository.signOut`.

**Test cases:**
- Pull về log mới của thẻ X → trạng thái thẻ X == `replayLogs` của mọi log X.
- Kích hoạt: mở app, resume, có mạng trở lại, kết thúc phiên ôn → mỗi sự kiện gọi `syncNow` đúng 1 lần (không chạy chồng khi đang syncing).
- Đăng xuất khi `pendingCount() > 0` và offline → hiện hộp thoại cảnh báo; chọn Huỷ → không xoá gì; chọn Vẫn đăng xuất → xoá DB người dùng.
- 2 máy (thử tay, ghi vào test-cases): ôn khác thẻ trên 2 máy offline → bật mạng → cả hai máy thấy đủ log.

- [ ] Test → đỏ → cài → xanh → commit `feat(sync): sync triggers, status indicator and safe sign-out`.

### Task D7: Bản release (tuần 9)

- [ ] `flutter build apk --release`; đo thời gian khởi động lạnh lần đầu (chép từ điển) và lần sau; đo thời gian `search` 10 truy vấn mẫu trên máy thật; ghi số vào README.
- [ ] Commit `chore(release): release build notes and performance numbers`.

---

# TRACK NHI (task C)

### Task C1: Môi trường và dữ liệu nghiên cứu (tuần 1)

- [ ] Dùng chung `research/requirements.txt` (thêm numpy, pandas, matplotlib, scikit-learn, pytest, pyarrow).
- [ ] Đăng ký truy cập anki-revlogs-10k trên Hugging Face, **đọc LICENSE** và ghi tóm tắt điều khoản vào `research/README.md`; tải tập con 100–200 người dùng vào `research/data/` (gitignore).
- [ ] Đọc mục FSRS trong `docs/algorithms.md` (leader viết), bài SM-2 và bài HLR (Settles & Meeder 2016).
- [ ] Commit `docs(research): dataset terms and setup notes`.

### Task C2: Soát CSV nghĩa Việt và Hán-Việt (tuần 1–4, mỗi tuần 1–2 cấp HSK)

- [ ] Ly xuất danh sách từ HSK n kèm nghĩa CVDICT và Hán-Việt tự ghép; Nhi sửa trong Excel, lưu UTF-8 vào `tools/overrides/*.csv`.
- [ ] Ưu tiên: từ thiếu nghĩa Việt, chữ có nhiều âm Hán-Việt, nghĩa máy dịch sai rõ ràng.
- [ ] Mỗi cấp một commit `chore(data): curate HSK n meanings and Han-Viet`.

### Task C3: SM-2 (tuần 3)

**Files:** `research/srs/sm2.py`, `research/tests/test_sm2.py`, mục SM-2 trong `docs/algorithms.md`

**Interfaces:** `class SM2: def review(self, state, q, t) -> state; def p_recall(self, state, t) -> float` với `p = 0.9 ** (elapsed / interval)`; rating 1→q=1, 2→q=3, 3→q=4, 4→q=5.

**Test cases:** chuỗi q = 5,5,5 với EF đầu 2.5 → interval 1, 6, rồi 6 × EF (EF sau mỗi lần cộng 0.1 theo công thức gốc; tự tính tay, ghi rõ phép tính trong comment của test); q < 3 → interval về 1, giữ lần đếm như công thức gốc; EF không xuống dưới 1.3.

- [ ] Test → đỏ → cài → xanh → commit `feat(research): SM-2 baseline`.

### Task C4: HLR (tuần 4, leader hỗ trợ)

**Files:** `research/srs/hlr.py`, `research/tests/test_hlr.py`, mục HLR trong `docs/algorithms.md`

**Interfaces:** `class HLR: def fit(self, rows); def p_recall(self, history, elapsed_days) -> float` với `p = 2^(−Δ/h)`, `h = 2^(θ·x)`, `x = [√(1+n_right), √(1+n_wrong), 1]`.

**Test cases:** θ = 0 → h = 1 ngày → Δ = 1 ngày cho p = 0.5; dữ liệu giả lập sinh từ θ đã biết → `fit` khôi phục θ sai số < 0.1.

- [ ] Test → đỏ → cài → xanh → commit `feat(research): half-life regression baseline`.

### Task C5: Đánh giá trên anki-revlogs (tuần 6)

**Files:** `research/eval/{load_revlogs.py,evaluate.py}`, `research/tests/test_metrics.py`, `research/figures/`

- [ ] Đọc revlog: mỗi thẻ một chuỗi (thời điểm, rating); bỏ lần ôn thứ 2+ trong cùng ngày; nhãn 0 nếu rating 1, ngược lại 1.
- [ ] Mỗi mô hình dự đoán p trước mỗi lần ôn chỉ từ lịch sử trước đó: FSRS-6 (py-fsrs, tham số mặc định), SM-2, HLR (train trên 80% người dùng, test trên 20%).
- [ ] Tính log-loss, AUC (scikit-learn), RMSE(bins) chép đúng định nghĩa từ code srs-benchmark (ghi link dòng code trong comment). Test: dự đoán hoàn hảo → log-loss gần 0, AUC = 1; dự đoán toàn 0.5 → AUC = 0.5.
- [ ] Bảng 3 mô hình × 3 chỉ số + cột số công bố của srs-benchmark; leader duyệt trước khi đưa vào báo cáo.
- [ ] Commit `feat(research): evaluation on anki-revlogs subset`.

### Task C6: Chạy mô phỏng và chọn chiến lược thắng (tuần 5–6)

- [ ] Chạy script lưới của L12; vẽ: tổng R ngày 90 theo chiến lược, số ngày hết dồn bài, đường lượt ôn theo ngày.
- [ ] Kết luận chiến lược thắng (theo tổng R ngày 90, xét thêm số ngày hết dồn bài) → báo leader cho L13.
- [ ] Commit `docs(research): backlog simulation results`.

### Task C7: Tài liệu, test tay, báo cáo (tuần 2–10)

- [ ] `docs/test-cases.md`: mỗi chức năng 2–4 kịch bản (bước, kết quả mong đợi, kết quả thực tế, ngày); chạy trên máy thật mỗi thứ Sáu từ tuần 2, lỗi mở GitHub Issue.
- [ ] Báo cáo: giới thiệu, kiến trúc, thuật toán (FSRS-6, SM-2, HLR), kết quả C5 + C6, hạn chế (LWW lệch đồng hồ, giả định p của SM-2, tham số FSRS mặc định), giấy phép dữ liệu.
- [ ] Slide và video demo (tuần 10).
- [ ] Commit theo từng phần `docs(docs): ...`.

---

## Lịch theo tuần (tóm tắt)

| Tuần | Leader | Ly | Nhi |
|---|---|---|---|
| 1 (23/11) | L0, L1, L2, L3, L4 | D1, D2 v0 | C1, C2 (HSK 1) |
| 2 | L6, L7, bắt đầu L5 | D2 v1 | C2 (HSK 2), C7 bắt đầu |
| 3 | L5, L8 | D3 | C3, C2 (HSK 3–4) |
| 4 | L9, L10 | D4 | C4, C2 (HSK 5–6) |
| 5 | L11, L12 | D5 | C6 |
| 6 | L13 | D6 | C5, C6 |
| 7 | L11 (test responsive), sửa lỗi | sửa lỗi, test đồng bộ | C7 test tay |
| 8–9 | L14 | D7 | C7 báo cáo |
| 10 (–31/01) | Diễn tập | Diễn tập | Video, slide |

Thứ tự cắt khi trễ: kiểu ôn "nghe" (L8) → C5 → `replay` trong D6 (dùng LWW cho cả trạng thái thẻ). Nếu leader trễ sau tuần 4: chuyển L9 (Cài đặt) cho Ly.
