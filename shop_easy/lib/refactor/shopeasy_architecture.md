# Tài liệu Kiến trúc & Luồng hoạt động — ShopEasy App

### Cấu trúc thư mục `lib/`

```text
lib/
├── main.dart             # Điểm chạy chính, cấu hình Theme & BottomNavigationBar
├── app_state.dart        # Models, ValueNotifiers toàn cục & tiện ích SnackBar
├── login_page.dart       # GD 1: Màn hình Đăng nhập
├── register_page.dart    # GD 2: Màn hình Đăng ký
├── forgot_pw_page.dart   # GD 3: Màn hình Quên mật khẩu
├── profile_page.dart     # GD 4: Màn hình Hồ sơ cá nhân
├── settings_page.dart    # GD 5: Màn hình Cài đặt
├── product_page.dart     # GD 6 & 7: Danh sách sản phẩm & Chi tiết sản phẩm
├── cart_page.dart        # GD 8: Màn hình Giỏ hàng
└── dashboard_page.dart   # GD 11: Màn hình Tổng quan (Dashboard)
```

---

## Chi tiết cấu trúc & hoạt động từng file

### 1. `app_state.dart` — Lõi dữ liệu & Tiện ích chung
* **Cấu trúc:**
  * Model `Product` và `CartItem`.
  * 4 biến trạng thái toàn cục: `themeNotifier`, `languageNotifier`, `fontSizeNotifier`, `cartItemsNotifier`.
  * Hàm tiện ích `showSnackBar()`.
* **Cách hoạt động:**
  * Khởi tạo sẵn 2 sản phẩm mẫu trong `cartItemsNotifier`.
  * Hàm `showSnackBar()` sử dụng biến đếm `_snackBarToken` kết hợp `Future.delayed` để ép thông báo tự động ẩn sau đúng $3\text{s}$ (kể cả khi người dùng rê chuột vào trên Web/Desktop) và ngăn việc tắt nhầm thông báo mới nếu bấm thêm sản phẩm liên tiếp.

### 2. `main.dart` — Điểm chạy chính & Khung điều hướng
* **Cấu trúc:** Widget `MyApp` (`StatelessWidget`) và `MainScreen` (`StatefulWidget`).
* **Cách hoạt động:**
  * `MyApp` sử dụng `ListenableBuilder` kết hợp `Listenable.merge` để lắng nghe đồng thời 3 notifier (Theme, Ngôn ngữ, Cỡ chữ) và áp dụng tỉ lệ chữ (`textScaler`) cho toàn bộ ứng dụng.
  * `MainScreen` quản lý `NavigationBar` 4 tab (Tổng quan, Sản phẩm, Giỏ hàng, Hồ sơ) và hiển thị huy hiệu số lượng (`Badge`) trực tiếp trên icon Giỏ hàng.

### 3. `login_page.dart` — GD 1: Đăng nhập
* **Cấu trúc:** `LoginPage` (`StatefulWidget`), sử dụng `GlobalKey<FormState>` cùng 2 `TextEditingController` (`_emailController`, `_passwordController`).
* **Cách hoạt động:** Hàm `_login()` kiểm tra định dạng Email và độ dài mật khẩu ($\ge 6$ ký tự). Nếu hợp lệ, ứng dụng gọi `Navigator.pushReplacementNamed(context, '/main')` để vào trang chính và xóa màn hình đăng nhập khỏi ngăn xếp điều hướng.

### 4. `register_page.dart` — GD 2: Đăng ký
* **Cấu trúc:** `RegisterPage` (`StatefulWidget`), sử dụng 4 `TextEditingController` (Họ tên, Email, Mật khẩu, Xác nhận mật khẩu).
* **Cách hoạt động:** Hàm `_register()` kiểm tra dữ liệu đầu vào và đối chiếu sự trùng khớp giữa 2 ô mật khẩu. Khi đăng ký thành công, hiển thị thông báo và gọi `Navigator.pop()` để quay về màn hình Đăng nhập.

### 5. `forgot_pw_page.dart` — GD 3: Quên mật khẩu
* **Cấu trúc:** `ForgotPasswordPage` (`StatefulWidget`) với `_emailController`.
* **Cách hoạt động:** Hàm `_resetPassword()` xác thực địa chỉ Email, hiển thị thông báo đã gửi liên kết đặt lại mật khẩu và tự động đóng màn hình hiện tại.

### 6. `dashboard_page.dart` — GD 11: Tổng quan (Tab 1)
* **Cấu trúc:** `DashboardPage` (`StatelessWidget`), xây dựng bằng `CustomScrollView` kết hợp `SliverToBoxAdapter` và `SliverList`.
* **Cách hoạt động:** Dùng `LayoutBuilder` kiểm tra chiều rộng màn hình để tự động điều chỉnh lưới thẻ thống kê ($2$ cột trên điện thoại, $4$ cột trên màn hình rộng $> 600\text{px}$) và hiển thị danh sách các đơn hàng gần đây.

### 7. `product_page.dart` — GD 6 & 7: Danh sách & Chi tiết sản phẩm (Tab 2)
* **Cấu trúc:** Gồm 3 thành phần chính:
  * `ProductCard`: Thẻ hiển thị từng sản phẩm.
  * `ProductListPage`: Lưới sản phẩm (`GridView`), thanh tìm kiếm và bộ lọc danh mục (`FilterChip`).
  * `ProductDetailPage`: Trang chi tiết với trình trượt ảnh (`PageView`) và bộ chọn số lượng.
* **Cách hoạt động:** Danh sách hiển thị được lọc trực tiếp qua getter `_filteredProducts`. Hàm `_addToCart()` thêm mới hoặc cộng dồn số lượng sản phẩm vào `cartItemsNotifier`.

### 8. `cart_page.dart` — GD 8: Giỏ hàng (Tab 3)
* **Cấu trúc:** `CartPage` (`StatelessWidget`), lắng nghe trực tiếp `cartItemsNotifier`.
* **Cách hoạt động:**
  * Cho phép tăng/giảm số lượng từng món hoặc vuốt ngang (`Dismissible`) để xóa thông qua `_removeItem()` (kèm nút **Hoàn tác** trên SnackBar).
  * Tự động tính tạm tính, tổng tiền và áp dụng miễn phí vận chuyển khi tổng giá trị đơn hàng đạt mức $\ge 500.000\text{ đ}$.

### 9. `profile_page.dart` — GD 4: Hồ sơ cá nhân (Tab 4)
* **Cấu trúc:** `ProfilePage` (`StatelessWidget`), sử dụng `Stack` để xếp chồng ảnh đại diện (`CircleAvatar`) lên ảnh bìa.
* **Cách hoạt động:** Hiển thị thông tin cá nhân, các chỉ số tương tác qua hàm `_statCol()` và cung cấp nút biểu tượng cài đặt trên thanh `AppBar` để điều hướng sang `/settings`.

### 10. `settings_page.dart` — GD 5: Cài đặt
* **Cấu trúc:** `SettingsPage` (`StatefulWidget`), phân chia các tùy chọn bằng `SwitchListTile` và `ListTile`.
* **Cách hoạt động:**
  * Mở `ModalBottomSheet` để thay đổi ngôn ngữ (`_showLangSheet`) và cỡ chữ (`_showFontSizeSheet`), cập nhật trực tiếp vào các `ValueNotifier`.
  * Nút đăng xuất gọi hộp thoại xác nhận `_showLogoutDialog()` và dùng `pushNamedAndRemoveUntil` để xóa toàn bộ lịch sử màn hình trước khi quay về `/login`.

---

## 3. Lưu ý kỹ thuật
* Toàn bộ dữ liệu giỏ hàng và cài đặt hiện đang lưu trên bộ nhớ tạm (RAM) thông qua `ValueNotifier`. Khi khởi động lại ứng dụng hoặc tải lại trang, dữ liệu sẽ trở về trạng thái mặc định ban đầu.