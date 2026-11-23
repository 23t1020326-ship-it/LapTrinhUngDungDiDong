import 'package:flutter/material.dart';

class UserCardPage extends StatelessWidget {
  const UserCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin sinh viên'),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 26, // Viền ngoài
                      backgroundColor: Colors.white,
                      child: const CircleAvatar(
                        radius: 24, // Ảnh đại diện bên trong
                        backgroundImage: NetworkImage(
                          'https://picsum.photos/id/1018/800/500',
                        ),
                      ),
                    ),
                    title: const Text(
                      'Huỳnh Lượng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('23T1020326@husc.edu.vn'),
                    trailing: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.phone, color: Colors.blue),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đang gọi cho Huỳnh Lượng...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nhập số điện thoại',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
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