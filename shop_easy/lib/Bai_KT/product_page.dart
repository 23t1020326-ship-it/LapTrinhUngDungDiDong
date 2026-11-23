import 'package:dio/dio.dart'; // [THÊM] Bắt lỗi DioException khi gọi API
import 'package:flutter/material.dart';

import 'app_state.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  String _formatPrice(double price) {
    final String str = price.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                  ),
                  if (product.discountPercent != null &&
                      product.discountPercent! > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: _isFavorite ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < product.rating.floor()
                                ? Icons.star
                                : (index < product.rating
                                      ? Icons.star_half
                                      : Icons.star_border),
                            size: 13,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating} (${product.reviewCount})',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formatPrice(product.price),
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.originalPrice != null &&
                          product.originalPrice! > product.price)
                        Flexible(
                          child: Text(
                            _formatPrice(product.originalPrice!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: FilledButton(
                      onPressed: widget.onAddToCart,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        languageNotifier.value == 'Tiếng Việt'
                            ? 'Thêm vào giỏ'
                            : 'Add to cart',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListPage extends StatefulWidget {
  final VoidCallback? onOpenCart;
  const ProductListPage({super.key, this.onOpenCart});
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';
  // [THAY THẾ] Xóa mảng cứng, nạp danh mục và sản phẩm động từ API
  List<String> _categories = ['Tất cả'];
  List<Product> _allProducts = [];
  bool _isLoading = true; // [THÊM] Trạng thái tải danh sách SP
  String? _error; // [THÊM] Lưu thông báo lỗi nếu gọi API thất bại

  // [THÊM] Tự động gọi API ngay khi mở màn hình danh sách
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // [THÊM] Gọi GET /products từ DummyJSON
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await dio.get('/products');
      if (!mounted) return;

      final List rawList = response.data['products'] ?? [];
      final products = rawList.map((e) => Product.fromJson(e)).toList();
      final dynamicCategories = {
        'Tất cả',
        ...products.map((p) => p.category).where((c) => c.isNotEmpty),
      }.toList();

      setState(() {
        _allProducts = products;
        _categories = dynamicCategories;
        if (!_categories.contains(_selectedCategory))
          _selectedCategory = 'Tất cả';
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message ?? 'Không thể tải danh sách sản phẩm');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addToCart(Product product) {
    final currentList = List<CartItem>.from(cartItemsNotifier.value);
    final index = currentList.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (index >= 0) {
      currentList[index].quantity++;
    } else {
      currentList.add(CartItem(product: product, quantity: 1));
    }
    cartItemsNotifier.value = currentList;
  }

  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesCategory =
          _selectedCategory == 'Tất cả' ||
          product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final isVI = lang == 'Tiếng Việt';
        final filteredList = _filteredProducts;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'ShopEasy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              // [THÊM] Nút mở Profile trên AppBar (luồng Danh sách SP -> Profile)
              IconButton(
                icon: const Icon(Icons.person_outline),
                tooltip: isVI ? 'Hồ sơ cá nhân' : 'Profile',
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
              if (widget.onOpenCart != null)
                IconButton(
                  icon: ValueListenableBuilder<List<CartItem>>(
                    valueListenable: cartItemsNotifier,
                    builder: (context, items, _) {
                      final count = items.fold(0, (sum, i) => sum + i.quantity);
                      return Badge(
                        label: Text('$count'),
                        isLabelVisible: count > 0,
                        child: const Icon(Icons.shopping_cart_outlined),
                      );
                    },
                  ),
                  onPressed: widget.onOpenCart,
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: isVI ? 'Tìm sản phẩm...' : 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = category),
                          selectedColor: const Color(0xFFF8BBD0),
                          checkmarkColor: const Color.fromARGB(255, 35, 3, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // [THAY THẾ] Xử lý trạng thái Loading / Lỗi mạng trước khi hiển thị GridView
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _fetchProducts,
                              child: Text(isVI ? 'Thử lại' : 'Retry'),
                            ),
                          ],
                        ),
                      )
                    : filteredList.isEmpty
                    ? Center(
                        child: Text(
                          isVI
                              ? 'Không tìm thấy sản phẩm nào'
                              : 'No products found',
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final int cols = width > 900
                              ? 4
                              : (width > 600 ? 3 : 2);
                          final double aspectRatio = width > 600 ? 0.68 : 0.62;

                          return GridView.builder(
                            padding: const EdgeInsets.all(12.0),
                            itemCount: filteredList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cols,
                                  childAspectRatio: aspectRatio,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                ),
                            itemBuilder: (context, index) {
                              final product = filteredList[index];
                              return ProductCard(
                                product: product,
                                onAddToCart: () {
                                  _addToCart(product);
                                  showSnackBar(
                                    context,
                                    SnackBar(
                                      content: Text(
                                        isVI
                                            ? 'Đã thêm "${product.name}" vào giỏ'
                                            : 'Added "${product.name}" to cart',
                                      ),
                                      action: widget.onOpenCart != null
                                          ? SnackBarAction(
                                              label: isVI
                                                  ? 'XEM GIỎ'
                                                  : 'VIEW CART',
                                              onPressed: widget.onOpenCart!,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isFavorite = false;
  int _quantity = 1;
  int _currentImageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final String str = price.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  void _addToCart() {
    final currentList = List<CartItem>.from(cartItemsNotifier.value);
    final index = currentList.indexWhere(
      (item) => item.product.id == widget.product.id,
    );
    if (index >= 0) {
      currentList[index].quantity += _quantity;
    } else {
      currentList.add(CartItem(product: widget.product, quantity: _quantity));
    }
    cartItemsNotifier.value = currentList;
    final isVI = languageNotifier.value == 'Tiếng Việt';
    showSnackBar(
      context,
      SnackBar(
        content: Text(
          isVI
              ? 'Đã thêm $_quantity "${widget.product.name}" vào giỏ hàng'
              : 'Added $_quantity "${widget.product.name}" to cart',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.displayImages;

    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final isVI = lang == 'Tiếng Việt';

        return Scaffold(
          appBar: AppBar(
            title: Text(isVI ? 'Chi tiết sản phẩm' : 'Product Detail'),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 1.2,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                onPageChanged: (index) =>
                                    setState(() => _currentImageIndex = index),
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: _currentImageIndex == index ? 22 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == index
                                        ? const Color(0xFF880E4F)
                                        : Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating} (${product.reviewCount} ${isVI ? 'đánh giá' : 'reviews'})',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Chip(
                            label: Text(product.category),
                            backgroundColor: const Color(0xFFFCE4EC),
                            side: BorderSide.none,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _formatPrice(product.price),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (product.originalPrice != null &&
                              product.originalPrice! > product.price) ...[
                            Text(
                              _formatPrice(product.originalPrice!),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${product.discountPercent}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Text(
                            isVI ? 'Số lượng:' : 'Quantity:',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFFF48FB1),
                            ),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(
                        isVI ? 'Mô tả sản phẩm' : 'Product Description',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // [THAY THẾ] Hiển thị description thật từ API DummyJSON
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : (isVI
                                  ? 'Không có mô tả chi tiết.'
                                  : 'No detailed description.'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _addToCart,
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Color(0xFF880E4F),
                          ),
                          label: Text(
                            isVI ? 'Thêm vào giỏ' : 'Add to Cart',
                            style: const TextStyle(
                              color: Color(0xFF880E4F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFFF48FB1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _addToCart();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF48FB1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isVI ? 'MUA NGAY' : 'BUY NOW',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
