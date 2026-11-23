import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final List<String> images;
  final double price;
  final double discountPercentage;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.images,
    required this.price,
    required this.discountPercentage,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

class User {
  final String firstName;
  final String accessToken;

  User({required this.firstName, required this.accessToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TestApiPage(),
  ));
}

class TestApiPage extends StatefulWidget {
  const TestApiPage({super.key});

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  final _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  List<Product> _danhSach = [];
  User? _user;
  String? _loi;
  bool _dangTai = false;

  Future<void> _goiApi() async {
    setState(() {
      _dangTai = true;
      _loi = null;
    });

    try {
      final response = await _dio.get('/products', queryParameters: {'limit': 10});
      if (!mounted) return;
      final List rawList = response.data['products'];
      setState(() {
        _danhSach = rawList.map((e) => Product.fromJson(e)).toList();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loi = e.toString());
    } finally {
      if (mounted) setState(() => _dangTai = false);
    }
  }

  Future<void> _testDangNhap() async {
    setState(() {
      _dangTai = true;
      _loi = null;
    });

    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': 'emilys', 'password': 'emilyspass'},
      );
      if (!mounted) return;
      setState(() => _user = User.fromJson(response.data));
    } catch (e) {
      if (!mounted) return;
      setState(() => _loi = e.toString());
    } finally {
      if (mounted) setState(() => _dangTai = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Product.fromJson')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: _dangTai ? null : _goiApi,
                  child: const Text('Lấy SP'),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  onPressed: _dangTai ? null : _testDangNhap,
                  child: const Text('Test Đăng nhập'),
                ),
              ],
            ),
            if (_user != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  'User: ${_user!.firstName}\nToken: ${_user!.accessToken}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: _dangTai
                  ? const Center(child: CircularProgressIndicator())
                  : _loi != null
                      ? SingleChildScrollView(
                          child: Text(_loi!, style: const TextStyle(color: Colors.red)),
                        )
                      : ListView.builder(
                          itemCount: _danhSach.length,
                          itemBuilder: (context, index) {
                            final sp = _danhSach[index];
                            return ListTile(
                              leading: Image.network(
                                sp.thumbnail,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(Icons.image),
                              ),
                              title: Text(sp.title),
                              subtitle: Text(
                                '⭐ ${sp.rating} • -${sp.discountPercentage}% (${sp.images.length} ảnh)\n${sp.description}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text('${sp.price} USD'),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}