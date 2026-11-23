import 'package:flutter/material.dart';
import 'app_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _statCol(String number, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(number, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
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
            title: Text(isVI ? 'Hồ sơ cá nhân' : 'Personal Profile', style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(icon: const Icon(Icons.settings_outlined), tooltip: isVI ? 'Cài đặt' : 'Settings', onPressed: () => Navigator.pushNamed(context, '/settings'))
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8BBD0),
                              image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800'), fit: BoxFit.cover),
                            ),
                          ),
                          const Positioned(
                            top: 90,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(radius: 45, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300')),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 55),
                      const Text('Huỳnh Lượng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(isVI ? 'Lập trình viên Mobile' : 'Mobile Developer', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 16),
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Row(
                          children: [
                            _statCol('128', isVI ? 'Bài viết' : 'Posts'),
                            _statCol('10.5K', isVI ? 'Người theo dõi' : 'Followers'),
                            _statCol('350', isVI ? 'Đang theo dõi' : 'Following'),
                          ],
                        ),
                      ),
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () => showSnackBar(context, SnackBar(content: Text(isVI ? 'Đã nhấn theo dõi' : 'Followed'))),
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF48FB1), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(isVI ? 'Theo dõi' : 'Follow', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: () => showSnackBar(context, SnackBar(content: Text(isVI ? 'Đã mở khung nhắn tin' : 'Message opened'))),
                                style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF880E4F), side: const BorderSide(color: Color(0xFFF48FB1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(isVI ? 'Nhắn tin' : 'Message', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}