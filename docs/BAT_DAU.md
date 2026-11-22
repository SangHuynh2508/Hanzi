# Bắt đầu từ đâu

Đọc theo thứ tự, mất khoảng 30 phút:

1. File này.
2. [CONTRIBUTING.md](../CONTRIBUTING.md): nhánh, commit, PR.
3. [Kế hoạch](superpowers/plans/2026-11-22-app-tu-vung-tieng-trung.md): mục **Trạng thái**, **Thay đổi so với kế hoạch**, rồi task của mình (Dev 2: `Task D1`…; C: `Task C1`…).
4. [Spec](superpowers/specs/2026-11-22-app-tu-vung-tieng-trung-design.md): chỉ các mục task của mình nhắc tới (ví dụ D2 đọc mục 4 và 6).

## 1. Lấy code

```powershell
git clone https://github.com/SangHuynh2508/Hanzi.git
cd Hanzi
git checkout develop
```

Nếu `develop` chưa có thư mục `lib/` thì PR đầu của leader chưa được merge; báo leader.

Mỗi task làm trên một nhánh riêng tạo từ `develop`:

```powershell
git checkout develop
git pull
git checkout -b feature/data-dictionary-pipeline
```

Tên nhánh gợi ý: D1 `feature/app-ci`, D2 `feature/data-dictionary-pipeline`, D3 `feature/auth-login`, D5 `feature/sync-firestore`; C1 `feature/research-setup`, C2 `feature/data-hsk1-overrides`, C3 `feature/research-sm2`.

## 2. Cài môi trường

### Dev 2 (Flutter)

- Flutter stable **3.50.1** (Dart 3.14.0). Kiểm tra: `flutter --version`.
- Android Studio (để có Android SDK). Lần đầu build, Gradle tự tải NDK 28.2; nếu báo thiếu NDK thì cài trong Android Studio › SDK Manager › SDK Tools › NDK.
- Máy ảo: Android Studio Emulator hoặc MuMu. MuMu thì bật ADB trong cài đặt rồi chạy `adb connect 127.0.0.1:16384` (cổng xem trong MuMu).

```powershell
flutter pub get
flutter test
flutter run
```

`flutter test` phải xanh trước khi bắt đầu. Không cần chạy `build_runner` trừ khi sửa bảng drift (xem mục Thay đổi trong kế hoạch).

Windows: `android/gradle.properties` đã tắt Kotlin incremental vì lỗi khi project và pub cache nằm khác ổ. Đừng bật lại.

### C (Python)

- Python 3.11 trở lên.

```powershell
cd research
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

Dataset để trong `research/data/` (đã gitignore, **không commit**).

## 3. Task đầu tiên

| Người | Làm trước | Làm song song | Cần gì từ người khác |
|---|---|---|---|
| Dev 2 | D1: CI + `NotificationService` chỉ có chữ ký | D2 v0: chỉ HSK 1 | Không. Schema từ điển đã có ở `lib/data/db/dictionary.drift` |
| C | C1: môi trường, đọc giấy phép dataset | C2 HSK 1: chờ Dev 2 xuất danh sách từ HSK 1 (D2) | Danh sách từ từ D2 |

Ghi chú cho D2:
- Đọc comment đầu `lib/data/db/dictionary.drift` và xem `tools/build_sample_dictionary.py` (bản mẫu 20 từ) để biết cách tạo file đúng định dạng.
- Thay `assets/dictionary.sqlite` thì tăng `kDictionaryBuild` trong `lib/data/db/dictionary_database.dart`.
- Kiểm tra trên máy: tab Tra từ, gõ `xuesheng` và `hoc sinh` đều ra `学生`.

Xong task: mở PR vào `develop`, gắn leader review, sửa dòng của task trong bảng **Trạng thái** của kế hoạch.

## 4. Giao task cho AI (Claude Code, Cursor, Copilot…)

Mở thư mục repo trong công cụ AI rồi dán (sửa mã task):

```text
Mình làm Task D1 trong docs/superpowers/plans/2026-11-22-app-tu-vung-tieng-trung.md.
Trước khi code, đọc: docs/BAT_DAU.md, CONTRIBUTING.md, mục "Global Constraints"
và "Thay đổi so với kế hoạch" trong kế hoạch, rồi toàn bộ Task D1.
Spec ở docs/superpowers/specs/2026-11-22-app-tu-vung-tieng-trung-design.md (chỉ đọc mục task nhắc tới).
Chỉ làm Task D1, không sửa code của task khác.
Viết test theo đúng các test case của task trước, chạy thấy đỏ, rồi mới cài đặt.
Trước khi commit: flutter analyze sạch, flutter test xanh.
Commit theo mẫu <loại>(<phần>): <mô tả>, không thêm dòng Co-Authored-By.
```

Tự đọc lại code AI viết trước khi commit: người chấm xem lịch sử commit của từng người, và người review sẽ hỏi.

## 5. Kẹt thì sao

- Câu hỏi về interface, task của người khác: hỏi leader trong nhóm chat hoặc comment vào PR.
- Lỗi máy/môi trường: dán nguyên log lỗi vào nhóm chat.
- Thấy kế hoạch sai hoặc thiếu: ghi vào mô tả PR và sửa mục "Thay đổi so với kế hoạch" trong cùng PR.
