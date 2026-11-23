import 'package:flutter/material.dart';

// =======================================================
// MODELS & GLOBAL STATE MANAGEMENT
// =======================================================
class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final int? discountPercent;
  final double rating;
  final String reviewCount;
  final String imageUrl;
  final List<String>? imageUrls;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.rating = 5.0,
    this.reviewCount = '100',
    required this.imageUrl,
    this.imageUrls,
    required this.category,
  });

  List<String> get displayImages {
    if (imageUrls != null && imageUrls!.isNotEmpty) {
      return imageUrls!;
    }
    return [imageUrl];
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// Global ValueNotifiers quản lý trạng thái ứng dụng
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> languageNotifier = ValueNotifier('Tiếng Việt');
final ValueNotifier<String> fontSizeNotifier = ValueNotifier('Vừa');

final ValueNotifier<List<CartItem>> cartItemsNotifier = ValueNotifier([
  CartItem(
    product: const Product(
      id: '1',
      name: 'Điện thoại iPhone 15 Pro Max 256GB chính hãng VN/A',
      price: 21990000,
      originalPrice: 28990000,
      discountPercent: 25,
      rating: 4.8,
      reviewCount: '1.2k',
      imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500',
      imageUrls: [
        'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500',
      ],
      category: 'Điện thoại',
    ),
    quantity: 1,
  ),
  CartItem(
    product: const Product(
      id: '5',
      name: 'Tai nghe Bluetooth Apple AirPods Pro 2 MagSafe',
      price: 5490000,
      originalPrice: 6990000,
      discountPercent: 21,
      rating: 4.7,
      reviewCount: '2.4k',
      imageUrl: 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=500',
      imageUrls: [
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=500',
        'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=500',
        'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500',
      ],
      category: 'Tai nghe',
    ),
    quantity: 2,
  ),
]);

void showAppSnackBar(BuildContext context, SnackBar snackBar, {Duration duration = const Duration(seconds: 2)}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(snackBar);
  Future.delayed(duration, () {
    messenger.hideCurrentSnackBar();
  });
}

// =======================================================
// GD 1: MÀN HÌNH ĐĂNG NHẬP
// =======================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final isVI = languageNotifier.value == 'Tiếng Việt';
      showAppSnackBar(context, SnackBar(content: Text(isVI ? 'Đăng nhập thành công!' : 'Login successful!'), backgroundColor: Colors.pink));
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock_outline_rounded, size: 48, color: Color(0xFFC2185B)),
                            ),
                            const SizedBox(height: 20),
                            Text(isVI ? 'Đăng Nhập' : 'Login', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                            const SizedBox(height: 6),
                            Text(isVI ? 'Chào mừng bạn quay trở lại!' : 'Welcome back!', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 28),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'nhapemail@domain.com',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng nhập Email' : 'Please enter Email') : (!v.contains('@') ? (isVI ? 'Email không hợp lệ' : 'Invalid Email') : null),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                labelText: isVI ? 'Mật khẩu' : 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => _isObscure = !_isObscure)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng nhập mật khẩu' : 'Please enter password') : (v.length < 6 ? (isVI ? 'Mật khẩu phải có ít nhất 6 ký tự' : 'Password must be at least 6 characters') : null),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot-password'), child: Text(isVI ? 'Quên mật khẩu?' : 'Forgot password?')),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF48FB1),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: Text(isVI ? 'ĐĂNG NHẬP' : 'LOGIN', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(isVI ? 'Chưa có tài khoản?' : "Don't have an account?", style: TextStyle(color: Colors.grey[700])),
                                TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: Text(isVI ? 'Đăng ký ngay' : 'Register now', style: const TextStyle(fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =======================================================
// GD 2: MÀN HÌNH ĐĂNG KÝ
// =======================================================
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      final isVI = languageNotifier.value == 'Tiếng Việt';
      showAppSnackBar(context, SnackBar(content: Text(isVI ? 'Đăng ký tài khoản thành công!' : 'Registration successful!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';
        return Scaffold(
          appBar: AppBar(title: Text(isVI ? 'Tạo tài khoản' : 'Create Account')),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person_add_alt_1_rounded, size: 48, color: Color(0xFFC2185B)),
                            ),
                            const SizedBox(height: 20),
                            Text(isVI ? 'Đăng Ký' : 'Register', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: isVI ? 'Họ và tên' : 'Full Name', prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng nhập họ và tên' : 'Please enter full name') : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng nhập Email' : 'Please enter Email') : (!v.contains('@') ? (isVI ? 'Email không hợp lệ' : 'Invalid Email') : null),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                labelText: isVI ? 'Mật khẩu' : 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => _isObscure = !_isObscure)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng nhập mật khẩu' : 'Please enter password') : (v.length < 6 ? (isVI ? 'Mật khẩu phải có ít nhất 6 ký tự' : 'Password must be at least 6 characters') : null),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _isConfirmObscure,
                              decoration: InputDecoration(
                                labelText: isVI ? 'Xác nhận mật khẩu' : 'Confirm Password',
                                prefixIcon: const Icon(Icons.lock_reset_outlined),
                                suffixIcon: IconButton(icon: Icon(_isConfirmObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => _isConfirmObscure = !_isConfirmObscure)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng xác nhận mật khẩu' : 'Please confirm password') : (v != _passwordController.text ? (isVI ? 'Mật khẩu xác nhận không khớp' : 'Passwords do not match') : null),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                child: Text(isVI ? 'ĐĂNG KÝ' : 'REGISTER', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(isVI ? 'Đã có tài khoản?' : 'Already have an account?'),
                                TextButton(onPressed: () => Navigator.pop(context), child: Text(isVI ? 'Đăng nhập ngay' : 'Login now', style: const TextStyle(fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =======================================================
// GD 3: MÀN HÌNH QUÊN MẬT KHẨU
// =======================================================
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      final isVI = languageNotifier.value == 'Tiếng Việt';
      showAppSnackBar(context, SnackBar(content: Text(isVI ? 'Yêu cầu khôi phục mật khẩu đã được gửi tới ${_emailController.text}' : 'Password reset link sent to ${_emailController.text}'), backgroundColor: Colors.orange[800]));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';
        return Scaffold(
          appBar: AppBar(title: Text(isVI ? 'Khôi phục mật khẩu' : 'Reset Password')),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mark_email_unread_outlined, size: 48, color: Color(0xFFC2185B)),
                            ),
                            const SizedBox(height: 20),
                            Text(isVI ? 'Quên Mật Khẩu?' : 'Forgot Password?', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                            const SizedBox(height: 8),
                            Text(isVI ? 'Nhập email của bạn để nhận liên kết đặt lại mật khẩu.' : 'Enter your email to receive a password reset link.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'nhapemail@domain.com',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng nhập Email' : 'Please enter Email') : (!v.contains('@') ? (isVI ? 'Email không hợp lệ' : 'Invalid Email') : null),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _handleResetPassword,
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                child: Text(isVI ? 'GỬI YÊU CẦU' : 'SUBMIT', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(onPressed: () => Navigator.pop(context), child: Text(isVI ? 'Quay lại Đăng nhập' : 'Back to Login', style: const TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =======================================================
// GD 4: MÀN HÌNH HỒ SƠ CÁ NHÂN
// =======================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';

        return Scaffold(
          appBar: AppBar(
            title: Text(isVI ? 'Hồ sơ cá nhân' : 'Personal Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: isVI ? 'Cài đặt' : 'Settings',
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8BBD0),
                              image: DecorationImage(
                                image: NetworkImage('https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 90,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 55),
                      const Text('Huỳnh Lượng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
                      const SizedBox(height: 4),
                      Text(isVI ? 'Lập trình viên Mobile' : 'Mobile Developer', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 16),
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Row(
                          children: [
                            _buildStatColumn('128', isVI ? 'Bài viết' : 'Posts'),
                            _buildStatColumn('10.5K', isVI ? 'Người theo dõi' : 'Followers'),
                            _buildStatColumn('350', isVI ? 'Đang theo dõi' : 'Following'),
                          ],
                        ),
                      ),
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () => showAppSnackBar(context, SnackBar(content: Text(isVI ? 'Đã nhấn theo dõi' : 'Followed'))),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF48FB1),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(isVI ? 'Theo dõi' : 'Follow', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: () => showAppSnackBar(context, SnackBar(content: Text(isVI ? 'Đã mở khung nhắn tin' : 'Message opened'))),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF880E4F),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(color: Color(0xFFF48FB1)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(isVI ? 'Nhắn tin' : 'Message', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(number, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// =======================================================
// GD 5: MÀN HÌNH CÀI ĐẶT
// =======================================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _rememberLogin = true;

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(languageNotifier.value == 'Tiếng Việt' ? 'Chọn Ngôn ngữ' : 'Select Language', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Tiếng Việt'),
                trailing: languageNotifier.value == 'Tiếng Việt' ? const Icon(Icons.check, color: Color(0xFFC2185B)) : null,
                onTap: () {
                  languageNotifier.value = 'Tiếng Việt';
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: languageNotifier.value == 'English' ? const Icon(Icons.check, color: Color(0xFFC2185B)) : null,
                onTap: () {
                  languageNotifier.value = 'English';
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFontSizeBottomSheet() {
    final isVI = languageNotifier.value == 'Tiếng Việt';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isVI ? 'Chọn Cỡ chữ' : 'Select Font Size', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                title: Text(isVI ? 'Nhỏ' : 'Small'),
                trailing: fontSizeNotifier.value == 'Nhỏ' ? const Icon(Icons.check, color: Color(0xFFC2185B)) : null,
                onTap: () {
                  fontSizeNotifier.value = 'Nhỏ';
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(isVI ? 'Vừa' : 'Medium'),
                trailing: fontSizeNotifier.value == 'Vừa' ? const Icon(Icons.check, color: Color(0xFFC2185B)) : null,
                onTap: () {
                  fontSizeNotifier.value = 'Vừa';
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(isVI ? 'Lớn' : 'Large'),
                trailing: fontSizeNotifier.value == 'Lớn' ? const Icon(Icons.check, color: Color(0xFFC2185B)) : null,
                onTap: () {
                  fontSizeNotifier.value = 'Lớn';
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    final isVI = languageNotifier.value == 'Tiếng Việt';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(isVI ? 'Xác nhận đăng xuất' : 'Confirm Logout'),
          content: Text(isVI ? 'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?' : 'Are you sure you want to log out?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(isVI ? 'Hủy' : 'Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, elevation: 0),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: Text(isVI ? 'Đăng xuất' : 'Log out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';
        final isDarkMode = themeNotifier.value == ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(isVI ? 'Cài đặt' : 'Settings'),
            leading: Navigator.canPop(context) ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)) : null,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, top: 8.0),
                child: Text(isVI ? 'TÀI KHOẢN' : 'ACCOUNT', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
              ),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    SwitchListTile(title: Text(isVI ? 'Nhận thông báo' : 'Notifications'), value: _notifications, onChanged: (v) => setState(() => _notifications = v)),
                    Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200),
                    SwitchListTile(title: Text(isVI ? 'Chế độ tối' : 'Dark Mode'), value: isDarkMode, onChanged: (v) => setState(() => themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light)),
                    Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200),
                    SwitchListTile(title: Text(isVI ? 'Nhớ đăng nhập' : 'Remember me'), value: _rememberLogin, onChanged: (v) => setState(() => _rememberLogin = v)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                child: Text(isVI ? 'ỨNG DỤNG' : 'APP', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
              ),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    ListTile(title: Text(isVI ? 'Ngôn ngữ' : 'Language'), subtitle: Text(languageNotifier.value), trailing: const Icon(Icons.chevron_right), onTap: _showLanguageBottomSheet),
                    Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200),
                    ListTile(title: Text(isVI ? 'Cỡ chữ' : 'Font size'), subtitle: Text(fontSizeNotifier.value), trailing: const Icon(Icons.chevron_right), onTap: _showFontSizeBottomSheet),
                    Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200),
                    ListTile(title: Text(isVI ? 'Hồ sơ cá nhân' : 'Personal Profile'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.pushNamed(context, '/profile')),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _showLogoutDialog,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(isVI ? 'Đăng xuất' : 'Log out', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =======================================================
// GD 6: MÀN HÌNH DANH SÁCH SẢN PHẨM & PRODUCT CARD
// =======================================================
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  const ProductCard({super.key, required this.product, required this.onAddToCart});
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  String _formatPrice(double price) {
    final String str = price.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: product))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported, size: 40))),
                  ),
                  if (product.discountPercent != null && product.discountPercent! > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        child: Text('-${product.discountPercent}%', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, size: 18, color: _isFavorite ? Colors.red : Colors.grey[700]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36, child: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.25))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (index) => Icon(index < product.rating.floor() ? Icons.star : (index < product.rating ? Icons.star_half : Icons.star_border), size: 13, color: Colors.amber))),
                      const SizedBox(width: 4),
                      Text('${product.rating} (${product.reviewCount})', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(_formatPrice(product.price), style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 6),
                      if (product.originalPrice != null && product.originalPrice! > product.price)
                        Flexible(child: Text(_formatPrice(product.originalPrice!), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[500], fontSize: 11, decoration: TextDecoration.lineThrough))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: FilledButton(
                      onPressed: widget.onAddToCart,
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: Text(languageNotifier.value == 'Tiếng Việt' ? 'Thêm vào giỏ' : 'Add to cart', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListPage extends StatefulWidget {
  final VoidCallback? onOpenCart;
  const ProductListPage({super.key, this.onOpenCart});
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';
  final List<String> _categories = ['Tất cả', 'Điện thoại', 'Laptop', 'Tai nghe', 'Đồng hồ'];
  final List<Product> _allProducts = const [
    Product(id: '1', name: 'Điện thoại iPhone 15 Pro Max 256GB chính hãng VN/A', price: 21990000, originalPrice: 28990000, discountPercent: 25, rating: 4.8, reviewCount: '1.2k', imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500', imageUrls: ['https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500'], category: 'Điện thoại'),
    Product(id: '2', name: 'Samsung Galaxy S24 Ultra 12GB/256GB', price: 24990000, originalPrice: 29990000, discountPercent: 17, rating: 4.9, reviewCount: '850', imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500', imageUrls: ['https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500', 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=500', 'https://images.unsplash.com/photo-1585060544812-6b45742d762f?w=500'], category: 'Điện thoại'),
    Product(id: '3', name: 'Apple MacBook Pro M3 14 inch 2023', price: 39990000, originalPrice: 42990000, discountPercent: 7, rating: 5.0, reviewCount: '520', imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500', imageUrls: ['https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500', 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=500', 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500'], category: 'Laptop'),
    Product(id: '4', name: 'Laptop Dell XPS 13 9315 Core i7', price: 31500000, originalPrice: 35000000, discountPercent: 10, rating: 4.6, reviewCount: '310', imageUrl: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500', imageUrls: ['https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500', 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=500'], category: 'Laptop'),
    Product(id: '5', name: 'Tai nghe Bluetooth Apple AirPods Pro 2 MagSafe', price: 5490000, originalPrice: 6990000, discountPercent: 21, rating: 4.7, reviewCount: '2.4k', imageUrl: 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=500', imageUrls: ['https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=500', 'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=500', 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500'], category: 'Tai nghe'),
    Product(id: '6', name: 'Đồng hồ thông minh Apple Watch Series 9 GPS 41mm', price: 9890000, originalPrice: 10490000, discountPercent: 6, rating: 4.8, reviewCount: '640', imageUrl: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500', imageUrls: ['https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500', 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=500', 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500'], category: 'Đồng hồ'),
  ];

  void _addToCart(Product product) {
    final currentList = List<CartItem>.from(cartItemsNotifier.value);
    final index = currentList.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      currentList[index].quantity++;
    } else {
      currentList.add(CartItem(product: product, quantity: 1));
    }
    cartItemsNotifier.value = currentList;
  }

  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'Tất cả' || product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';
        final filteredList = _filteredProducts;

        return Scaffold(
          appBar: AppBar(
            title: const Text('ShopEasy', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              IconButton(
                icon: ValueListenableBuilder<List<CartItem>>(
                  valueListenable: cartItemsNotifier,
                  builder: (context, items, child) {
                    final count = items.fold(0, (sum, i) => sum + i.quantity);
                    return Badge(label: Text('$count'), isLabelVisible: count > 0, child: const Icon(Icons.shopping_cart_outlined));
                  },
                ),
                onPressed: widget.onOpenCart,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: isVI ? 'Tìm sản phẩm...' : 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = '')) : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) => setState(() => _selectedCategory = category),
                          selectedColor: const Color(0xFFF8BBD0),
                          checkmarkColor: const Color(0xFF880E4F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filteredList.isEmpty
                    ? Center(child: Text(isVI ? 'Không tìm thấy sản phẩm nào' : 'No products found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: filteredList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.62, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
                        itemBuilder: (context, index) {
                          final product = filteredList[index];
                          return ProductCard(
                            product: product,
                            onAddToCart: () {
                              _addToCart(product);
                              showAppSnackBar(
                                context,
                                SnackBar(
                                  content: Text(isVI ? 'Đã thêm "${product.name}" vào giỏ' : 'Added "${product.name}" to cart'),
                                  action: SnackBarAction(label: isVI ? 'XEM GIỎ' : 'VIEW CART', onPressed: widget.onOpenCart ?? () {}),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =======================================================
// GD 7: MÀN HÌNH CHI TIẾT SẢN PHẨM
// =======================================================
class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isFavorite = false;
  int _quantity = 1;
  int _currentImageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final String str = price.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  void _addToCart() {
    final currentList = List<CartItem>.from(cartItemsNotifier.value);
    final index = currentList.indexWhere((item) => item.product.id == widget.product.id);
    if (index >= 0) {
      currentList[index].quantity += _quantity;
    } else {
      currentList.add(CartItem(product: widget.product, quantity: _quantity));
    }
    cartItemsNotifier.value = currentList;
    final isVI = languageNotifier.value == 'Tiếng Việt';
    showAppSnackBar(context, SnackBar(content: Text(isVI ? 'Đã thêm $_quantity "${widget.product.name}" vào giỏ hàng' : 'Added $_quantity "${widget.product.name}" to cart')));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.displayImages;

    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';

        return Scaffold(
          appBar: AppBar(
            title: Text(isVI ? 'Chi tiết sản phẩm' : 'Product Detail'),
            actions: [
              IconButton(icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.red : null), onPressed: () => setState(() => _isFavorite = !_isFavorite))
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 1.2,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                onPageChanged: (index) => setState(() => _currentImageIndex = index),
                                itemBuilder: (context, index) {
                                  return Image.network(images[index], fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported, size: 50)));
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentImageIndex == index ? 22 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: _currentImageIndex == index ? const Color(0xFF880E4F) : Colors.white.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text('${product.rating} (${product.reviewCount} ${isVI ? 'đánh giá' : 'reviews'})', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Chip(label: Text(product.category), backgroundColor: const Color(0xFFFCE4EC), side: BorderSide.none),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(_formatPrice(product.price), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                          const SizedBox(width: 10),
                          if (product.originalPrice != null && product.originalPrice! > product.price) ...[
                            Text(_formatPrice(product.originalPrice!), style: TextStyle(fontSize: 14, color: Colors.grey[500], decoration: TextDecoration.lineThrough)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                              child: Text('-${product.discountPercent}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Text(isVI ? 'Số lượng:' : 'Quantity:', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null),
                          Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF48FB1)), onPressed: () => setState(() => _quantity++)),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(isVI ? 'Mô tả sản phẩm' : 'Product Description', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(isVI ? 'Sản phẩm chính hãng với chất lượng đảm bảo, đầy đủ chính sách bảo hành. Thiết kế hiện đại, sang trọng, đáp ứng tốt nhu cầu sử dụng hàng ngày của bạn.' : 'Authentic product with guaranteed quality and full warranty policy. Modern design, elegant, perfectly meeting your daily needs.', style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5)),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(color: const Color(0xFFFCE4EC), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -3))]),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _addToCart,
                          icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF880E4F)),
                          label: Text(isVI ? 'Thêm vào giỏ' : 'Add to Cart', style: const TextStyle(color: Color(0xFF880E4F), fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), side: const BorderSide(color: Color(0xFFF48FB1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _addToCart();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: Text(isVI ? 'MUA NGAY' : 'BUY NOW', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =======================================================
// GD 8: MÀN HÌNH GIỎ HÀNG
// =======================================================
class CartPage extends StatelessWidget {
  final VoidCallback? onContinueShopping;
  const CartPage({super.key, this.onContinueShopping});

  String _formatPrice(double price) {
    final String str = price.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  void _removeItem(BuildContext context, int index, CartItem item, bool isVI) {
    final currentList = List<CartItem>.from(cartItemsNotifier.value);
    currentList.removeAt(index);
    cartItemsNotifier.value = currentList;

    showAppSnackBar(
      context,
      SnackBar(
        content: Text(isVI ? 'Đã xóa "${item.product.name}" khỏi giỏ' : 'Removed "${item.product.name}"'),
        action: SnackBarAction(
          label: isVI ? 'Hoàn tác' : 'Undo',
          onPressed: () {
            final restoredList = List<CartItem>.from(cartItemsNotifier.value);
            restoredList.insert(index, item);
            cartItemsNotifier.value = restoredList;
          },
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';

        return Scaffold(
          appBar: AppBar(
            title: ValueListenableBuilder<List<CartItem>>(
              valueListenable: cartItemsNotifier,
              builder: (context, items, child) {
                final totalCount = items.fold(0, (sum, i) => sum + i.quantity);
                return Text(
                  isVI ? 'Giỏ hàng ($totalCount)' : 'Shopping Cart ($totalCount)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
            actions: [
              ValueListenableBuilder<List<CartItem>>(
                valueListenable: cartItemsNotifier,
                builder: (context, items, child) {
                  if (items.isEmpty) return const SizedBox.shrink();
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: isVI ? 'Xóa tất cả' : 'Clear all',
                    onPressed: () {
                      final previousItems = List<CartItem>.from(cartItemsNotifier.value);
                      cartItemsNotifier.value = [];

                      showAppSnackBar(
                        context,
                        SnackBar(
                          content: Text(isVI ? 'Đã xóa tất cả sản phẩm' : 'All items cleared'),
                          action: SnackBarAction(
                            label: isVI ? 'Hoàn tác' : 'Undo',
                            onPressed: () => cartItemsNotifier.value = previousItems,
                          ),
                        ),
                        duration: const Duration(seconds: 3),
                      );
                    },
                  );
                },
              )
            ],
          ),
          body: ValueListenableBuilder<List<CartItem>>(
            valueListenable: cartItemsNotifier,
            builder: (context, items, child) {
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 90, color: Color(0xFFF48FB1)),
                        const SizedBox(height: 16),
                        Text(isVI ? 'Giỏ hàng của bạn đang trống' : 'Your cart is empty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(isVI ? 'Hãy chọn thêm sản phẩm để tiếp tục sắm sửa nhé!' : 'Add items to your cart to keep shopping!', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: onContinueShopping,
                          icon: const Icon(Icons.storefront),
                          label: Text(isVI ? 'Tiếp tục mua sắm' : 'Continue Shopping', style: const TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF48FB1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final double subtotal = items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
              const double freeShippingThreshold = 500000;
              final double shippingFee = subtotal >= freeShippingThreshold ? 0 : 30000;
              final double total = subtotal + shippingFee;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Dismissible(
                          key: ValueKey(item.product.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.delete_outline, color: Colors.white, size: 28),
                              ],
                            ),
                          ),
                          onDismissed: (_) => _removeItem(context, index, item, isVI),
                          child: Card(
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.product.imageUrl,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(width: 70, height: 70, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2)),
                                        const SizedBox(height: 6),
                                        Text(_formatPrice(item.product.price), style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, size: 22, color: Colors.grey),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          if (item.quantity > 1) {
                                            final currentList = List<CartItem>.from(cartItemsNotifier.value);
                                            currentList[index].quantity--;
                                            cartItemsNotifier.value = currentList;
                                          } else {
                                            _removeItem(context, index, item, isVI);
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, size: 22, color: Color(0xFFF48FB1)),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          final currentList = List<CartItem>.from(cartItemsNotifier.value);
                                          currentList[index].quantity++;
                                          cartItemsNotifier.value = currentList;
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE4EC),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -3))],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(isVI ? 'Tạm tính' : 'Subtotal', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              const Spacer(),
                              Text(_formatPrice(subtotal), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(isVI ? 'Phí vận chuyển' : 'Shipping fee', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              const Spacer(),
                              Text(
                                shippingFee == 0 ? (isVI ? 'Miễn phí' : 'Free') : _formatPrice(shippingFee),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: shippingFee == 0 ? Colors.green[700] : Colors.black87),
                              ),
                            ],
                          ),
                          if (subtotal < freeShippingThreshold) ...[
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                isVI ? '💡 Mua thêm ${_formatPrice(freeShippingThreshold - subtotal)} để được MIỄN PHÍ vận chuyển!' : '💡 Add ${_formatPrice(freeShippingThreshold - subtotal)} more for FREE shipping!',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF880E4F), fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          const Divider(height: 20, thickness: 1),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(isVI ? 'Tổng cộng' : 'Total', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text(_formatPrice(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF880E4F))),
                                ],
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  showAppSnackBar(
                                    context,
                                    SnackBar(
                                      content: Text(isVI ? 'Đang chuyển sang màn hình thanh toán...' : 'Proceeding to checkout...'),
                                      backgroundColor: const Color(0xFFF48FB1),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF48FB1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(isVI ? 'Thanh toán' : 'Checkout', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

// =======================================================
// GD 11: MÀN HÌNH TỔNG QUAN (DASHBOARD)
// =======================================================
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        final isVI = lang == 'Tiếng Việt';

        final statItems = [
          {'title': isVI ? 'Đơn hàng' : 'Orders', 'value': '1,250', 'icon': Icons.shopping_bag_outlined, 'color': Colors.blue},
          {'title': isVI ? 'Doanh thu' : 'Revenue', 'value': '128.5M', 'icon': Icons.attach_money, 'color': Colors.green},
          {'title': isVI ? 'Khách hàng' : 'Customers', 'value': '3,420', 'icon': Icons.people_outline, 'color': Colors.purple},
          {'title': isVI ? 'Sản phẩm' : 'Products', 'value': '560', 'icon': Icons.inventory_2_outlined, 'color': Colors.orange},
        ];

        final recentOrders = [
          {'id': '#ORD-8821', 'customer': 'Nguyễn Văn A', 'amount': '2,450,000 đ', 'date': '02/11/2026', 'status': isVI ? 'Hoàn thành' : 'Completed', 'statusColor': Colors.green},
          {'id': '#ORD-8820', 'customer': 'Trần Thị B', 'amount': '5,200,000 đ', 'date': '02/11/2026', 'status': isVI ? 'Đang xử lý' : 'Processing', 'statusColor': Colors.orange},
          {'id': '#ORD-8819', 'customer': 'Lê Văn C', 'amount': '1,150,000 đ', 'date': '01/11/2026', 'status': isVI ? 'Đang giao' : 'Shipping', 'statusColor': Colors.blue},
          {'id': '#ORD-8818', 'customer': 'Phạm Thị D', 'amount': '890,000 đ', 'date': '01/11/2026', 'status': isVI ? 'Đã hủy' : 'Cancelled', 'statusColor': Colors.red},
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(isVI ? 'Tổng quan' : 'Dashboard', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: CustomScrollView(
            slivers: [
              // 1 & 2. Lưới 4 ô số liệu: GridView.count + LayoutBuilder + MediaQuery
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isWide = constraints.maxWidth > 600 || screenWidth > 600;
                    final cols = isWide ? 4 : 2;

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 1.15 : 1.35,
                      padding: const EdgeInsets.all(16.0),
                      children: statItems.map((item) {
                        final color = item['color'] as Color;

                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey.shade200, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start, // CANH TRÁI NỘI DUNG THẺ
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: color.withValues(alpha: 0.12),
                                  child: Icon(item['icon'] as IconData, color: color, size: 20),
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item['value'] as String,
                                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item['title'] as String,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              // 3. Tiêu đề mục có nút "Xem tất cả" căn phải
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        isVI ? 'Đơn hàng gần đây' : 'Recent Orders',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.3),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(isVI ? 'Xem tất cả' : 'See all', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Danh sách đơn hàng gần đây
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = recentOrders[index];
                      final statusColor = order['statusColor'] as Color;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFFCE4EC),
                                child: Icon(Icons.receipt_long, color: Color(0xFF880E4F), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${order['id']} - ${order['customer']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text('${order['amount']} • ${order['date']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  order['status'] as String,
                                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: recentOrders.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      },
    );
  }
}