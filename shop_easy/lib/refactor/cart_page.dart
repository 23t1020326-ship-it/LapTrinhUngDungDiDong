import 'package:flutter/material.dart';
import 'app_state.dart';

class CartPage extends StatelessWidget {
  final VoidCallback? onContinueShopping;
  const CartPage({super.key, this.onContinueShopping});

  String _formatPrice(double price) {
    final String str = price.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  void _removeItem(BuildContext context, int index, CartItem item, bool isVI) {
    final currentList = List<CartItem>.from(cartItemsNotifier.value);
    currentList.removeAt(index);
    cartItemsNotifier.value = currentList;

    showSnackBar(
      context,
      SnackBar(
        content: Text(isVI ? 'Đã xóa "${item.product.name}" khỏi giỏ' : 'Removed "${item.product.name}"'),
        action: SnackBarAction(
          label: isVI ? 'Hoàn tác' : 'Undo',
          onPressed: () {
            final restoredList = List<CartItem>.from(cartItemsNotifier.value);
            restoredList.insert(index, item);
            cartItemsNotifier.value = restoredList;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final isVI = lang == 'Tiếng Việt';

        return Scaffold(
          appBar: AppBar(
            title: ValueListenableBuilder<List<CartItem>>(
              valueListenable: cartItemsNotifier,
              builder: (context, items, _) {
                final totalCount = items.fold(0, (sum, i) => sum + i.quantity);
                return Text(isVI ? 'Giỏ hàng ($totalCount)' : 'Shopping Cart ($totalCount)', style: const TextStyle(fontWeight: FontWeight.bold));
              },
            ),
            actions: [
              ValueListenableBuilder<List<CartItem>>(
                valueListenable: cartItemsNotifier,
                builder: (context, items, _) {
                  if (items.isEmpty) return const SizedBox.shrink();
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: isVI ? 'Xóa tất cả' : 'Clear all',
                    onPressed: () {
                      final previousItems = List<CartItem>.from(cartItemsNotifier.value);
                      cartItemsNotifier.value = [];
                      showSnackBar(
                        context,
                        SnackBar(
                          content: Text(isVI ? 'Đã xóa tất cả sản phẩm' : 'All items cleared'),
                          action: SnackBarAction(label: isVI ? 'Hoàn tác' : 'Undo', onPressed: () => cartItemsNotifier.value = previousItems),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
          body: ValueListenableBuilder<List<CartItem>>(
            valueListenable: cartItemsNotifier,
            builder: (context, items, _) {
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 90, color: Color(0xFFF48FB1)),
                        const SizedBox(height: 16),
                        Text(isVI ? 'Giỏ hàng của bạn đang trống' : 'Your cart is empty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(isVI ? 'Hãy chọn thêm sản phẩm để tiếp tục sắm sửa nhé!' : 'Add items to your cart to keep shopping!', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: onContinueShopping,
                          icon: const Icon(Icons.storefront),
                          label: Text(isVI ? 'Tiếp tục mua sắm' : 'Continue Shopping', style: const TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final double subtotal = items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
              const double freeShippingThreshold = 500000;
              final double shippingFee = subtotal >= freeShippingThreshold ? 0 : 30000;
              final double total = subtotal + shippingFee;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Dismissible(
                          key: ValueKey(item.product.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.delete_outline, color: Colors.white, size: 28),
                              ],
                            ),
                          ),
                          onDismissed: (_) => _removeItem(context, index, item, isVI),
                          child: Card(
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(item.product.imageUrl, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 70, height: 70, color: Colors.grey[300], child: const Icon(Icons.image_not_supported))),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2)),
                                        const SizedBox(height: 6),
                                        Text(_formatPrice(item.product.price), style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, size: 22, color: Colors.grey),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          if (item.quantity > 1) {
                                            final currentList = List<CartItem>.from(cartItemsNotifier.value);
                                            currentList[index].quantity--;
                                            cartItemsNotifier.value = currentList;
                                          } else {
                                            _removeItem(context, index, item, isVI);
                                          }
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, size: 22, color: Color(0xFFF48FB1)),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          final currentList = List<CartItem>.from(cartItemsNotifier.value);
                                          currentList[index].quantity++;
                                          cartItemsNotifier.value = currentList;
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(color: const Color(0xFFFCE4EC), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(children: [Text(isVI ? 'Tạm tính' : 'Subtotal'), const Spacer(), Text(_formatPrice(subtotal), style: const TextStyle(fontWeight: FontWeight.w600))]),
                          const SizedBox(height: 6),
                          Row(children: [Text(isVI ? 'Phí vận chuyển' : 'Shipping fee'), const Spacer(), Text(shippingFee == 0 ? (isVI ? 'Miễn phí' : 'Free') : _formatPrice(shippingFee), style: TextStyle(fontWeight: FontWeight.bold, color: shippingFee == 0 ? Colors.green[700] : Colors.black87))]),
                          if (subtotal < freeShippingThreshold) ...[
                            const SizedBox(height: 4),
                            Align(alignment: Alignment.centerLeft, child: Text(isVI ? '💡 Mua thêm ${_formatPrice(freeShippingThreshold - subtotal)} để được MIỄN PHÍ vận chuyển!' : '💡 Add ${_formatPrice(freeShippingThreshold - subtotal)} more for FREE shipping!', style: const TextStyle(fontSize: 11, color: Color(0xFF880E4F), fontStyle: FontStyle.italic))),
                          ],
                          const Divider(height: 20, thickness: 1),
                          Row(
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(isVI ? 'Tổng cộng' : 'Total', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), Text(_formatPrice(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)))]),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () => showSnackBar(context, SnackBar(content: Text(isVI ? 'Đang chuyển sang màn hình thanh toán...' : 'Proceeding to checkout...'), backgroundColor: const Color(0xFFF48FB1))),
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Text(isVI ? 'Thanh toán' : 'Checkout', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}