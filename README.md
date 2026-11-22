# Hanzi

Ứng dụng học từ vựng tiếng Trung cho người Việt: HSK 1–6, âm Hán-Việt (学生 = HỌC SINH), tách bộ thủ, lịch ôn FSRS-6, chạy offline và đồng bộ Firestore.

Đồ án môn **CMP177 – Lập trình trên thiết bị di động**. Đề xuất: [DE_XUAT_DE_TAI.md](DE_XUAT_DE_TAI.md) · Thiết kế: [docs/superpowers/specs](docs/superpowers/specs) · Quy trình nhóm: [CONTRIBUTING.md](CONTRIBUTING.md) · **Thành viên mới: [docs/BAT_DAU.md](docs/BAT_DAU.md)**

## Cài đặt

- Flutter stable 3.50.1, Dart 3.14.0, Android minSdk 23.
- `flutter pub get`
- `dart run build_runner build --delete-conflicting-outputs` (chỉ khi sửa bảng drift; file `*.g.dart` đã được commit)
- Từ khi có đăng nhập (D3): chép `google-services.json` (leader gửi riêng) vào `android/app/`.
- `flutter test`, `flutter run`

## Đáp ứng yêu cầu đồ án

| Yêu cầu | Đáp ứng | Bằng chứng |
|---|---|---|
| Flutter/Dart | Toàn bộ app | |
| Cấu trúc phân lớp | `lib/core`, `lib/data`, `lib/presentation` | |
| UI đồng bộ, responsive, animation | Theme sáng/tối, NavigationRail ≥600dp, chuyển trang, skeleton, lật thẻ 3D, Hero | |
| Quản lý trạng thái | Cubit (`flutter_bloc`) | |
| UI tách khỏi logic | screen → cubit → repository | `test/architecture_test.dart` |
| API: timeout, mất mạng, cache | Firestore timeout 10s, offline-first, SQLite là cache | |
| Kiểm thử | Unit, cubit, widget, so khớp FSRS với py-fsrs | |
| CRUD | Bộ từ, thẻ | |
| Thống kê/biểu đồ | 4 biểu đồ `fl_chart` | |
| Đăng nhập/Đăng ký | Firebase Auth | |
| Thông báo | Local notification nhắc ôn | |
| Tìm kiếm | FTS5 theo chữ Hán, pinyin, Hán-Việt, nghĩa | |
| Lưu cục bộ + đám mây | drift (SQLite) + Firestore | |

## Nguồn dữ liệu & giấy phép

| Dữ liệu | Nguồn | Giấy phép |
|---|---|---|
| Nghĩa tiếng Việt | CVDICT | CC BY-SA 4.0 |
| Nghĩa tiếng Anh, pinyin | CC-CEDICT | CC BY-SA 3.0 |
| Âm Hán-Việt | Unihan `kVietnamese` | Unicode License |
| Bộ thủ | Make Me a Hanzi (`dictionary.txt`) | LGPL-3.0+ |
| Danh sách HSK | complete-hsk-vocabulary | MIT |

File `assets/dictionary.sqlite` do nhóm build từ các nguồn trên, phát hành theo CC BY-SA 4.0.
