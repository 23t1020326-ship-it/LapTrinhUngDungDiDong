import 'package:flutter/material.dart';
import 'app_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final isVI = lang == 'Tiếng Việt';
        final statItems = [
          {'title': isVI ? 'Đơn hàng' : 'Orders', 'value': '1,250', 'icon': Icons.shopping_bag_outlined, 'color': Colors.blue},
          {'title': isVI ? 'Doanh thu' : 'Revenue', 'value': '128.5M', 'icon': Icons.attach_money, 'color': Colors.green},
          {'title': isVI ? 'Khách hàng' : 'Customers', 'value': '3,420', 'icon': Icons.people_outline, 'color': Colors.purple},
          {'title': isVI ? 'Sản phẩm' : 'Products', 'value': '560', 'icon': Icons.inventory_2_outlined, 'color': Colors.orange},
          
        ];

        final recentOrders = [
          {'id': '#ORD-8821', 'customer': 'Nguyễn Văn A', 'amount': '2,450,000 đ', 'date': '02/11/2026', 'status': isVI ? 'Hoàn thành' : 'Completed', 'statusColor': Colors.green},
          {'id': '#ORD-8820', 'customer': 'Trần Thị B', 'amount': '5,200,000 đ', 'date': '02/11/2026', 'status': isVI ? 'Đang xử lý' : 'Processing', 'statusColor': Colors.orange},
          {'id': '#ORD-8819', 'customer': 'Lê Văn C', 'amount': '1,150,000 đ', 'date': '01/11/2026', 'status': isVI ? 'Đang giao' : 'Shipping', 'statusColor': Colors.blue},
          {'id': '#ORD-8818', 'customer': 'Phạm Thị D', 'amount': '890,000 đ', 'date': '01/11/2026', 'status': isVI ? 'Đã hủy' : 'Cancelled', 'statusColor': Colors.red},
        ];

        return Scaffold(
          appBar: AppBar(title: Text(isVI ? 'Tổng quan' : 'Dashboard', style: const TextStyle(fontWeight: FontWeight.bold))),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600 || MediaQuery.of(context).size.width > 600;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isWide ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 1.15 : 1.35,
                      padding: const EdgeInsets.all(16.0),
                      children: statItems.map((item) {
                        final color = item['color'] as Color;
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(radius: 18, backgroundColor: color.withValues(alpha: 0.12), child: Icon(item['icon'] as IconData, color: color, size: 20)),
                                const SizedBox(height: 10),
                                FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(item['value'] as String, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                                const SizedBox(height: 2),
                                FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(item['title'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Text(isVI ? 'Đơn hàng gần đây' : 'Recent Orders', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: Text(isVI ? 'Xem tất cả' : 'See all')),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = recentOrders[index];
                      final statusColor = order['statusColor'] as Color;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const CircleAvatar(radius: 20, backgroundColor: Color(0xFFFCE4EC), child: Icon(Icons.receipt_long, color: Color(0xFF880E4F), size: 20)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${order['id']} - ${order['customer']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text('${order['amount']} • ${order['date']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: statusColor.withValues(alpha: 0.3))),
                                child: Text(order['status'] as String, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: recentOrders.length,
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