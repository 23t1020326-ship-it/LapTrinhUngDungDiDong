import 'package:flutter/material.dart';
import 'app_state.dart';

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

  void _login() {
    if (_formKey.currentState!.validate()) {
      final isVI = languageNotifier.value == 'Tiếng Việt';
      showSnackBar(context, SnackBar(content: Text(isVI ? 'Đăng nhập thành công!' : 'Login successful!'), backgroundColor: Colors.pink));
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(color: Color(0xFFFCE4EC), shape: BoxShape.circle),
                              child: const Icon(Icons.lock_outline_rounded, size: 48, color: Color(0xFFC2185B)),
                            ),
                            const SizedBox(height: 20),
                            Text(isVI ? 'Đăng Nhập' : 'Login', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(isVI ? 'Chào mừng bạn quay trở lại!' : 'Welcome back!', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 28),
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot-password'), child: Text(isVI ? 'Quên mật khẩu?' : 'Forgot password?')),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                child: Text(isVI ? 'ĐĂNG NHẬP' : 'LOGIN', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(isVI ? 'Chưa có tài khoản?' : "Don't have an account?"),
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