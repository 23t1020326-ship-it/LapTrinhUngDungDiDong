import 'package:flutter/material.dart';
import 'app_state.dart';

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

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      final isVI = languageNotifier.value == 'Tiếng Việt';
      showSnackBar(context, SnackBar(content: Text(isVI ? 'Yêu cầu khôi phục mật khẩu đã được gửi tới ${_emailController.text}' : 'Password reset link sent to ${_emailController.text}'), backgroundColor: Colors.orange[800]));
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
          appBar: AppBar(title: Text(isVI ? 'Khôi phục mật khẩu' : 'Reset Password')),
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
                              child: const Icon(Icons.mark_email_unread_outlined, size: 48, color: Color(0xFFC2185B)),
                            ),
                            const SizedBox(height: 20),
                            Text(isVI ? 'Quên Mật Khẩu?' : 'Forgot Password?', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(isVI ? 'Nhập email của bạn để nhận liên kết đặt lại mật khẩu.' : 'Enter your email to receive a password reset link.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                              validator: (v) => (v == null || v.isEmpty) ? (isVI ? 'Vui lòng nhập Email' : 'Please enter Email') : (!v.contains('@') ? (isVI ? 'Email không hợp lệ' : 'Invalid Email') : null),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _resetPassword,
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                child: Text(isVI ? 'GỬI YÊU CẦU' : 'SUBMIT', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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