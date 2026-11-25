# Bắt đầu từ đâu

Phân công: **Ly** làm task `D1`–`D7`, **Nhi** làm task `C1`–`C7`, leader làm `L0`–`L14`.

Đọc theo thứ tự, mất khoảng 30 phút:

1. File này.
2. [CONTRIBUTING.md](../CONTRIBUTING.md): nhánh, commit, PR.
3. [Kế hoạch](superpowers/plans/2026-11-22-app-tu-vung-tieng-trung.md): mục **Trạng thái**, **Thay đổi so với kế hoạch**, rồi task của mình.
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

### Ly (Flutter)

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

### Nhi (Python)

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
| Ly | D1: CI + `NotificationService` chỉ có chữ ký | D2 v0: chỉ HSK 1 | Không. Schema từ điển đã có ở `lib/data/db/dictionary.drift` |
| Nhi | C1: môi trường, đọc giấy phép dataset | C2 HSK 1: chờ Ly xuất danh sách từ HSK 1 (D2) | Danh sách từ từ D2 |

Ghi chú cho D2:
- Đọc comment đầu `lib/data/db/dictionary.drift` và xem `tools/build_sample_dictionary.py` (bản mẫu 20 từ) để biết cách tạo file đúng định dạng.
- Thay `assets/dictionary.sqlite` thì tăng `kDictionaryBuild` trong `lib/data/db/dictionary_database.dart`.
- Kiểm tra trên máy: tab Tra từ, gõ `xuesheng` và `hoc sinh` đều ra `学生`.

Xong task: mở PR vào `develop`, gắn leader review.

Quy tắc nhánh, commit, phạm vi task, code: xem [CONTRIBUTING.md](../CONTRIBUTING.md).

Dùng AI (Claude Code, Codex, Cursor, Copilot…): mở đúng thư mục repo, công cụ sẽ tự đọc [AGENTS.md](../AGENTS.md). Câu đầu tiên nói rõ mã task, ví dụ "Mình làm Task D2". Code AI viết vẫn là code của mình: tự đọc lại trước khi commit.

## 4. Kẹt thì sao

- Câu hỏi về interface, task của người khác: hỏi leader trong nhóm chat hoặc comment vào PR.
- Lỗi máy/môi trường: dán nguyên log lỗi vào nhóm chat.
- Thấy kế hoạch sai hoặc thiếu: ghi vào mô tả PR và sửa mục "Thay đổi so với kế hoạch" trong cùng PR.
