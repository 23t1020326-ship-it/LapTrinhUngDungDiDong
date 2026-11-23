import 'package:flutter/material.dart';
import 'UI_ShopEasy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  double _getFontScale(String size) {
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, child) {
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, currentLang, child) {
            return ValueListenableBuilder<String>(
              valueListenable: fontSizeNotifier,
              builder: (context, currentFontSize, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'ShopEasy App',
                  theme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.light,
                    scaffoldBackgroundColor: Colors.white,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFFF48FB1),
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
                      labelTextStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: const Color(0xFF121212),
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFFF48FB1),
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
                      iconTheme: WidgetStateProperty.all(
                        const IconThemeData(color: Color(0xFF880E4F)),
                      ),
                      labelTextStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF880E4F)),
                      ),
                    ),
                  ),
                  themeMode: currentThemeMode,
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
                    '/main': (context) => const MainScreen(),
                    '/profile': (context) => const ProfilePage(),
                    '/settings': (context) => const SettingsPage(),
                    '/products': (context) => const ProductListPage(),
                    '/dashboard': (context) => const DashboardPage(),
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

// =======================================================
// MAIN SCREEN (ĐIỀU HƯỚNG BOTTOM NAVIGATION BAR 4 TAB)
// =======================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVI = languageNotifier.value == 'Tiếng Việt';

    final List<Widget> pages = [
      const DashboardPage(),
      ProductListPage(onOpenCart: () => _switchTab(2)),
      CartPage(onContinueShopping: () => _switchTab(1)),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentNavIndex,
        children: pages,
      ),
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
            icon: ValueListenableBuilder<List<CartItem>>(
              valueListenable: cartItemsNotifier,
              builder: (context, items, child) {
                final totalCount = items.fold(0, (sum, i) => sum + i.quantity);
                return Badge(
                  label: Text('$totalCount'),
                  isLabelVisible: totalCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            selectedIcon: ValueListenableBuilder<List<CartItem>>(
              valueListenable: cartItemsNotifier,
              builder: (context, items, child) {
                final totalCount = items.fold(0, (sum, i) => sum + i.quantity);
                return Badge(
                  label: Text('$totalCount'),
                  isLabelVisible: totalCount > 0,
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
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
  }
}