import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Danh sách hình ảnh minh họa
  final List<String> imageUrls = const [
    'https://picsum.photos/id/1018/800/500',
    'https://picsum.photos/id/1015/800/500',
    'https://picsum.photos/id/1019/800/500',
    'https://picsum.photos/id/1025/800/500',
    'https://picsum.photos/id/1039/800/500',
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Phần danh sách hình ảnh cuộn ngang (ListView.builder)
    Widget imageSection = SizedBox(
      height: 440, // Chiều cao cố định cho khung cuộn
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Hướng cuộn ngang
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            width: 620, // Chiều rộng của mỗi bức ảnh
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Bo tròn góc ảnh
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );

    // 2. Phần tiêu đề (Title Section)
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Gia Lai',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  'Pleiku, Gia Lai',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const SizedBox(width: 4),
          const Text('41'),
        ],
      ),
    );

    // Hàm phụ trợ tạo từng cột nút bấm (Icon + Text)
    Column buildButtonColumn(Color color, IconData icon, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    Color primaryColor = Theme.of(context).primaryColor;

    // 3. Phần các nút chức năng (Button Section)
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButtonColumn(primaryColor, Icons.call, 'CALL'),
        buildButtonColumn(primaryColor, Icons.near_me, 'ROUTE'),
        buildButtonColumn(primaryColor, Icons.share, 'SHARE'),
      ],
    );

    // 4. Phần văn bản mô tả (Text Section)
    Widget textSection = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Gia Lai là một tỉnh nằm ở khu vực Tây Nguyên, '
        'Việt Nam và là tỉnh có diện tích lớn thứ hai cả nước. '
        'Trung tâm hành chính của tỉnh là thành phố Pleiku. '
        'Gia Lai nổi tiếng với nhiều cảnh quan thiên nhiên như Biển Hồ (T\'Nơng), núi lửa Chư Đăng Ya và các đồi chè xanh mướt.',
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Chi tiết địa điểm'),
      ),
      body: ListView(
        children: [
          imageSection,
          titleSection,
          buttonSection,
          textSection,
        ],
      ),
    );
  }
}