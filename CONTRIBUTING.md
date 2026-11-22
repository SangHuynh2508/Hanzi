# Quy trình làm việc nhóm

Leader quyết định quy trình. Có thay đổi thì mở PR sửa file này.

## Nhánh

| Nhánh | Dùng để |
|---|---|
| `main` | Bản ổn định để demo/nộp. Chỉ merge từ `develop`. |
| `develop` | Nhánh tích hợp. Mọi PR merge vào đây. |
| `feature/<phần>-<tên>` | Nhánh làm việc, tạo từ `develop`. |

`<phần>` ∈ `app`, `data`, `srs`, `sync`, `auth`, `research`, `docs`. Ví dụ: `feature/srs-scheduler`, `feature/auth-login`, `fix/app-review-crash`.

## Làm một việc

```bash
git checkout develop && git pull
git checkout -b feature/app-deck-list
# code + test
git commit -m "feat(app): add deck list screen"
git push -u origin feature/app-deck-list
```

Mở Pull Request vào `develop`, điền PR template, cần **ít nhất 1 người review**. `develop` có thay đổi trong lúc làm thì `git merge develop` vào nhánh của mình.

## Commit

`<loại>(<phần>): <mô tả ngắn>` — loại ∈ `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.

- Commit nhỏ, mỗi người tự commit phần mình làm (lịch sử commit được chấm).
- Không squash, không force-push lên `main`/`develop`.

## Quy tắc code

- UI không gọi DB hay Firestore trực tiếp: screen → cubit → repository. `test/architecture_test.dart` sẽ báo lỗi nếu vi phạm.
- Viết test trước khi viết code cho logic (repository, cubit, `data/srs/`, `core/utils/`).
- Trước khi mở PR: `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze` sạch, `flutter test` xanh.

## Bí mật

Không commit `google-services.json`, `GoogleService-Info.plist`, `lib/firebase_options.dart`, `firebase.json`, `.env`, dataset trong `research/data/`. Leader gửi riêng file cấu hình Firebase.

## Chạy test trên Windows

Test của drift chạy SQLite trên máy tính. Nếu `flutter test` báo thiếu thư viện sqlite3, xem mục "Cài đặt" trong README.
