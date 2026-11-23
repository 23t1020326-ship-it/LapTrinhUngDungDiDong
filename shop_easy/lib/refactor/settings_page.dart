import 'package:flutter/material.dart';
import 'app_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _rememberLogin = true;

  void _showLangSheet() {
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

  void _showFontSizeSheet() {
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
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
      builder: (context, lang, _) {
        final isVI = lang == 'Tiếng Việt';
        final isDarkMode = themeNotifier.value == ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(isVI ? 'Cài đặt' : 'Settings', style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: Navigator.canPop(context) ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)) : null,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, top: 8.0),
                child: Text(isVI ? 'TÀI KHOẢN' : 'ACCOUNT', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              Card(
                elevation: 0,
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
                child: Text(isVI ? 'ỨNG DỤNG' : 'APP', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    ListTile(title: Text(isVI ? 'Ngôn ngữ' : 'Language'), subtitle: Text(languageNotifier.value), trailing: const Icon(Icons.chevron_right), onTap: _showLangSheet),
                    Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200),
                    ListTile(title: Text(isVI ? 'Cỡ chữ' : 'Font size'), subtitle: Text(fontSizeNotifier.value), trailing: const Icon(Icons.chevron_right), onTap: _showFontSizeSheet),
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