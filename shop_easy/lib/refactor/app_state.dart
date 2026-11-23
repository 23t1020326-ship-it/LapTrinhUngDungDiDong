import 'package:flutter/material.dart';

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

  List<String> get displayImages => (imageUrls != null && imageUrls!.isNotEmpty) ? imageUrls! : [imageUrl];
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
final languageNotifier = ValueNotifier<String>('Tiếng Việt');
final fontSizeNotifier = ValueNotifier<String>('Vừa');

final cartItemsNotifier = ValueNotifier<List<CartItem>>([
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
      category: 'Tai nghe',
    ),
    quantity: 2,
  ),
  CartItem(
    product: const Product(
      id: '6',
      name: 'Đồng hồ Apple Watch Series 8 GPS 45mm',
      price: 12990000,
      originalPrice: 15990000,
      discountPercent: 19,
      rating: 4.6,
      reviewCount: '1.8k',
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500',
      category: 'Đồng hồ',
    ),
    quantity: 1,
  ),
]);

// app_state.dart
void showSnackBar(BuildContext context, SnackBar snackBar) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: snackBar.content,
      action: snackBar.action,
      backgroundColor: snackBar.backgroundColor,
      duration: const Duration(seconds: 3),
    ),
  );

  // Ép ẩn sau đúng 3 giây kể cả khi hover chuột hoặc giữ tay
  Future.delayed(const Duration(seconds: 3), () {
    messenger.hideCurrentSnackBar();
  });
}