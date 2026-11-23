import 'package:flutter/material.dart';
import 'app_state.dart';

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

  void _register() {
    if (_formKey.currentState!.validate()) {
      final isVI = languageNotifier.value == 'Tiếng Việt';
      showSnackBar(context, SnackBar(content: Text(isVI ? 'Đăng ký tài khoản thành công!' : 'Registration successful!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
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
                              child: const Icon(Icons.person_add_alt_1_rounded, size: 48, color: Color(0xFFC2185B)),
                            ),
                            const SizedBox(height: 20),
                            Text(isVI ? 'Đăng Ký' : 'Register', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                child: Text(isVI ? 'ĐĂNG KÝ' : 'REGISTER', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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