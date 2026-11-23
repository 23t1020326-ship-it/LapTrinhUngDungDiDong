# ShopEasy — Tích hợp REST API (Dio & DummyJSON)

Ứng dụng bán hàng Flutter sử dụng **Dio** để gọi dữ liệu thời gian thực từ **DummyJSON API** và quản lý trạng thái toàn cục bằng **ValueNotifier**.

## Cấu trúc thư mục (`lib/`)

```text
lib/
├── main.dart           # Điểm khởi chạy app, cấu hình theme, đa ngôn ngữ và 3 routes chính
├── app_state.dart      # Khởi tạo Dio, các Model (User, Product, CartItem) và ValueNotifier toàn cục
├── login_page.dart     # Màn hình đăng nhập, gọi POST /auth/login lấy accessToken
├── product_page.dart   # Danh sách & chi tiết sản phẩm (GET /products), tìm kiếm, lọc & BottomAppBar
└── profile_page.dart   # Hồ sơ cá nhân, gọi GET /auth/me kèm Bearer Token và xử lý đăng xuất