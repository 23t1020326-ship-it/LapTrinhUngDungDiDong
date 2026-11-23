import 'dart:ui';

import 'package:flutter/material.dart';
import 'app_state.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  double _fontScale(String size) {
    switch (size) {
      case 'Nhỏ':
        return 0.85;
      case 'Lớn':
        return 1.25;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeNotifier, languageNotifier, fontSizeNotifier]),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ShopEasy App',
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
                            surfaceContainerLow: const Color(0xFFFCE4EC),
                            seedColor: const Color.fromARGB(255, 0, 0, 0),
                            brightness: Brightness.light),
            appBarTheme: const AppBarTheme(
                            backgroundColor: Color(0xFFFCE4EC),
                            foregroundColor: Color(0xFF880E4F), 
                            elevation: 0.5, centerTitle: true),
          ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(_fontScale(fontSizeNotifier.value))),
              child: child!,
            );
          },
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/products': (context) => const ProductListPage(),
            '/profile': (context) => const ProfilePage(),
          },
        );
      },
    );
  }
}