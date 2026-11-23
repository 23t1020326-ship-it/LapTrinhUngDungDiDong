import 'package:flutter/material.dart';
import '19_10_2026.dart';

// 1. Khai báo 3 trạm phát tín hiệu toàn cục
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> languageNotifier = ValueNotifier('Tiếng Việt');
final ValueNotifier<String> fontSizeNotifier = ValueNotifier('Vừa'); // Mới bổ sung

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Hàm quy đổi Cỡ chữ sang Tỉ lệ thu phóng (TextScaler)
  double _getFontScale(String size) {
    switch (size) {
      case 'Nhỏ':
        return 0.85; // Thu nhỏ 15%
      case 'Lớn':
        return 1.25; // Phóng to 25%
      default:
        return 1.0;  // Vừa (Chuẩn mặc định)
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, child) {
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, currentLang, child) {
            return ValueListenableBuilder<String>(
              valueListenable: fontSizeNotifier, // Lắng nghe sự thay đổi cỡ chữ
              builder: (context, currentFontSize, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Ứng dụng Flutter',
                  theme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.light,
                    colorSchemeSeed: Colors.blue,
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    colorSchemeSeed: Colors.blue,
                  ),
                  themeMode: currentThemeMode,

                  // CẤU HÌNH PHÓNG TO / THU NHỎ CHỮ TOÀN APP
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(_getFontScale(currentFontSize)),
                      ),
                      child: child!,
                    );
                  },

                  initialRoute: '/login',
                  routes: {
                    '/login': (context) => const LoginPage(),
                    '/register': (context) => const RegisterPage(),
                    '/forgot-password': (context) => const ForgotPasswordPage(),
                    '/profile': (context) => const ProfilePage(),
                    '/settings': (context) => const SettingsPage(),
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}