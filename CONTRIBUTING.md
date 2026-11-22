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
- Không thêm dòng `Co-Authored-By` hay chữ ký của công cụ AI.
- Không squash, không push thẳng hay force-push lên `main`/`develop`.

## Phạm vi task

- Mỗi nhánh, mỗi PR chỉ làm một task trong [kế hoạch](docs/superpowers/plans/2026-11-22-app-tu-vung-tieng-trung.md).
- Không sửa code thuộc task của người khác; cần đổi thì hỏi người đó hoặc leader trước.
- Giữ đúng chữ ký trong mục **Interfaces** của task và mục **Thay đổi so với kế hoạch**. Muốn đổi thì ghi lý do vào mô tả PR và sửa mục đó trong cùng PR.
- Xong task thì sửa dòng của task trong bảng **Trạng thái** của kế hoạch, trong cùng PR.
- Hiểu và giải thích được mọi dòng mình commit; người review sẽ hỏi.

## Quy tắc code

- UI không gọi DB hay Firestore trực tiếp: screen → cubit → repository. `test/architecture_test.dart` sẽ báo lỗi nếu vi phạm.
- Viết test trước khi viết code cho logic (repository, cubit, `data/srs/`, `core/utils/`).
- Trước khi mở PR: `flutter analyze` sạch, `flutter test` xanh (code Python: `pytest` xanh). Có sửa bảng drift thì chạy `dart run build_runner build --delete-conflicting-outputs` và commit file `*.g.dart`.

## Bí mật

Không commit `google-services.json`, `GoogleService-Info.plist`, `lib/firebase_options.dart`, `firebase.json`, `.env`, dataset trong `research/data/`. Leader gửi riêng file cấu hình Firebase.

## Chạy test trên Windows

Test của drift chạy SQLite trên máy tính; thư viện sqlite3 được tải tự động khi chạy `flutter test` lần đầu (cần mạng). Vẫn lỗi thì dán log vào nhóm chat.
