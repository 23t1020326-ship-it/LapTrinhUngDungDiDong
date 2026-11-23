import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

class Product {
  final String id;
  final String name;
  final String description;
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
    this.description = '',
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.rating = 5.0,
    this.reviewCount = '100',
    required this.imageUrl,
    this.imageUrls,
    required this.category,
  });
  // Map JSON từ DummyJSON (/products) sang model Product
  factory Product.fromJson(Map<String, dynamic> json) {
    final double usdPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    final double vndPrice =
        usdPrice * 25000; // Quy đổi USD -> VND khớp với _formatPrice
    final double discount =
        (json['discountPercentage'] as num?)?.toDouble() ?? 0.0;
    final int discountInt = discount.round();
    final double? origPrice = discount > 0
        ? vndPrice / (1 - discount / 100)
        : null;

    return Product(
      id: (json['id'] ?? '').toString(),
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      price: vndPrice,
      originalPrice: origPrice,
      discountPercent: discountInt > 0 ? discountInt : null,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: (json['reviews'] as List?)?.length.toString() ?? '0',
      imageUrl: json['thumbnail'] ?? '',
      imageUrls: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      category: json['category'] ?? '',
    );
  }

  List<String> get displayImages =>
      (imageUrls != null && imageUrls!.isNotEmpty) ? imageUrls! : [imageUrl];
}

class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final String accessToken;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    this.accessToken = '',
  });

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json, {String? fallbackToken}) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'] ?? '',
      accessToken: json['accessToken'] ?? fallbackToken ?? '',
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
final languageNotifier = ValueNotifier<String>('Tiếng Việt');
final fontSizeNotifier = ValueNotifier<String>('Vừa');
final currentUserNotifier = ValueNotifier<User?>(null);
final cartItemsNotifier = ValueNotifier<List<CartItem>>([]);

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
