import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_state.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'forgot_pw_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'product_page.dart';
import 'cart_page.dart';
import 'dashboard_page.dart';

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
      listenable: Listenable.merge([
        themeNotifier,
        languageNotifier,
        fontSizeNotifier,
      ]),
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
              seedColor: const Color.fromARGB(255, 244, 143, 143),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFCE4EC),
              foregroundColor: Color(0xFF880E4F),
              elevation: 0.5,
              centerTitle: true,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: const Color(0xFFFCE4EC),
              indicatorColor: const Color(0xFFF8BBD0),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 244, 143, 143),
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFCE4EC),
              foregroundColor: Color(0xFF880E4F),
              elevation: 0.5,
              centerTitle: true,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: const Color(0xFFFCE4EC),
              indicatorColor: const Color(0xFFF8BBD0),
            ),
          ),
          themeMode: themeNotifier.value,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  _fontScale(fontSizeNotifier.value),
                ),
              ),
              child: child!,
            );
          },
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/forgot-password': (context) => const ForgotPasswordPage(),
            '/main': (context) => const MainScreen(),
            '/profile': (context) => const ProfilePage(),
            '/settings': (context) => const SettingsPage(),
            '/products': (context) => const ProductListPage(),
            '/dashboard': (context) => const DashboardPage(),
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardPage(),
      ProductListPage(onOpenCart: () => _switchTab(2)),
      CartPage(onContinueShopping: () => _switchTab(1)),
      const ProfilePage(),
    ];
  }

  void _switchTab(int index) {
    setState(() => _currentNavIndex = index);
  }

  Widget _cartBadge(IconData iconData) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: cartItemsNotifier,
      builder: (context, items, _) {
        final totalCount = items.fold(0, (sum, i) => sum + i.quantity);
        return Badge(
          label: Text('$totalCount'),
          isLabelVisible: totalCount > 0,
          child: Icon(iconData),
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

        return Scaffold(
          body: IndexedStack(index: _currentNavIndex, children: _pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentNavIndex,
            onDestinationSelected: _switchTab,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: isVI ? 'Tổng quan' : 'Dashboard',
              ),
              NavigationDestination(
                icon: const Icon(Icons.storefront_outlined),
                selectedIcon: const Icon(Icons.storefront),
                label: isVI ? 'Sản phẩm' : 'Products',
              ),
              NavigationDestination(
                icon: _cartBadge(Icons.shopping_cart_outlined),
                selectedIcon: _cartBadge(Icons.shopping_cart),
                label: isVI ? 'Giỏ hàng' : 'Cart',
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: isVI ? 'Hồ sơ' : 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
