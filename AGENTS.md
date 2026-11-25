# Hướng dẫn cho AI agent

File này dành cho mọi công cụ AI làm việc trong repo (Claude Code, Codex, Cursor, Copilot, Gemini…). Quy tắc của nhóm nằm trong các file dưới đây; file này chỉ chỉ đường và thêm vài luật riêng cho AI.

## Trước khi sửa bất kỳ file nào

1. Hỏi người dùng đang làm **task nào** (ví dụ `D2`, `C3`, `L7`) nếu họ chưa nói. Chưa biết task thì không code.
2. Đọc, theo thứ tự:
   - [CONTRIBUTING.md](CONTRIBUTING.md): nhánh, commit, phạm vi task, quy tắc code, bí mật.
   - [docs/BAT_DAU.md](docs/BAT_DAU.md): môi trường, tên nhánh gợi ý, ghi chú riêng từng task.
   - [Kế hoạch](docs/superpowers/plans/2026-11-22-app-tu-vung-tieng-trung.md): mục **Trạng thái**, **Thay đổi so với kế hoạch**, **Global Constraints**, **Bản đồ file**, rồi **toàn bộ** mục của task đang làm.
   - [Spec](docs/superpowers/specs/2026-11-22-app-tu-vung-tieng-trung-design.md): chỉ các mục mà task nhắc tới.
3. Nói lại ngắn gọn cho người dùng: task yêu cầu tạo/sửa file nào, interface nào phải giữ, test nào phải có. Chờ họ đồng ý rồi mới làm.

Khi tài liệu mâu thuẫn nhau, thứ tự ưu tiên: **Thay đổi so với kế hoạch** > mục của task > Global Constraints > spec. Vẫn không rõ thì dừng lại hỏi, không tự đoán.

## Trong lúc làm

- Chỉ làm đúng task được giao. Không sửa file thuộc task của người khác, không "tiện tay" refactor, không thêm tính năng ngoài kế hoạch. Thấy chỗ cần sửa ngoài task thì báo người dùng.
- Giữ nguyên chữ ký trong mục **Interfaces** của task. Bắt buộc phải đổi thì hỏi người dùng trước; nếu họ đồng ý, sửa mục "Thay đổi so với kế hoạch" trong cùng PR và ghi lý do vào mô tả PR.
- Không thêm package mới ngoài danh sách trong kế hoạch/spec (spec mục 3 có danh sách "Không dùng").
- Logic (repository, cubit, `lib/data/srs/`, `lib/core/utils/`, code Python): viết test theo test case của task trước, chạy thấy đỏ, rồi mới cài đặt.
- Screen không import `lib/data/db/**` hay `lib/data/remote/**`.
- Chữ hiển thị trong app bằng tiếng Việt.
- Không đọc, in ra hay commit file bí mật và dataset (danh sách trong CONTRIBUTING mục Bí mật).

## Trước khi bàn giao

- Flutter: `flutter analyze` sạch, `flutter test` xanh. Có sửa bảng drift thì chạy `dart run build_runner build --delete-conflicting-outputs` và giữ file `*.g.dart`. Python: `pytest` xanh.
- Báo kết quả thật, kể cả khi test đỏ hay có bước chưa làm.
- Nhắc người dùng sửa dòng của task trong bảng **Trạng thái** của kế hoạch, trong cùng PR.

## Git

- Không tự commit, push hay mở PR khi người dùng chưa bảo. Người dùng tự commit phần mình làm (lịch sử commit được chấm điểm).
- Nếu được bảo commit: commit nhỏ, mẫu `<loại>(<phần>): <mô tả>`. **Không** thêm dòng `Co-Authored-By`, "Generated with…" hay chữ ký bất kỳ của công cụ AI vào commit hoặc PR.
- Nhánh `feature/<phần>-<tên>` tạo từ `develop`. PR luôn mở vào `develop`, không vào `main`.
- Không push thẳng, không force-push, không squash lên `main`/`develop`.

## Giúp người dùng hiểu code

Người review sẽ hỏi từng dòng. Sau mỗi thay đổi, giải thích ngắn gọn bằng tiếng Việt: đã làm gì, vì sao, và chỗ nào người dùng nên tự đọc lại.
