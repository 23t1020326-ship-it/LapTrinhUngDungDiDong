import 'package:dio/dio.dart'; // [THÊM] Gọi API /auth/me và bắt lỗi DioException
import 'package:flutter/material.dart';

import 'app_state.dart';

// [THAY THẾ] Chuyển sang StatefulWidget để gọi GET /auth/me khi mở trang
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false; // [THÊM] Trạng thái tải thông tin từ /auth/me
  String? _error; // [THÊM] Lưu thông báo lỗi nếu token hết hạn hoặc mất mạng

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // [THÊM] Tự động gọi GET /auth/me ngay khi vào màn hình Hồ sơ
  }

  // [THÊM] Gửi accessToken qua Header Authorization để lấy thông tin user thật
  Future<void> _fetchProfile() async {
    final token = currentUserNotifier.value?.accessToken ?? '';
    if (token.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await dio.get(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (!mounted) return;

      // Cập nhật thông tin mới nhất từ /auth/me và giữ nguyên accessToken
      currentUserNotifier.value = User.fromJson(
        response.data,
        fallbackToken: token,
      );
    } on DioException catch (e) {
      if (!mounted) return;
      setState(
        () => _error =
            e.response?.data?['message'] ?? 'Không thể tải thông tin hồ sơ',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _logout() {
    currentUserNotifier.value = null;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _statCol(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
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
            title: Text(
              isVI ? 'Hồ sơ cá nhân' : 'Personal Profile',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              // [THÊM] Nút đăng xuất trên AppBar
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: isVI ? 'Đăng xuất' : 'Logout',
                onPressed: _logout,
              ),
            ],
          ),
          // [THAY THẾ] Lắng nghe currentUserNotifier để hiển thị dữ liệu thật từ API
          body: ValueListenableBuilder<User?>(
            valueListenable: currentUserNotifier,
            builder: (context, user, _) {
              if (_isLoading && user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (user == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isVI ? 'Chưa có thông tin đăng nhập' : 'Not logged in',
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _logout,
                        child: Text(
                          isVI ? 'Về trang Đăng nhập' : 'Go to Login',
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isLoading)
                            const LinearProgressIndicator(
                              minHeight: 3,
                            ), // [THÊM] Thanh báo đang đồng bộ /auth/me
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8BBD0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 90,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    0,
                                    179,
                                  ),
                                  //Hiển thị ảnh đại diện thật từ API (user.image)
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage: user.image.isNotEmpty
                                        ? NetworkImage(user.image)
                                        : null,
                                    child: user.image.isEmpty
                                        ? const Icon(Icons.person, size: 40)
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 55),
                          // Tên thật từ API (user.fullName)
                          Text(
                            user.fullName.isNotEmpty
                                ? user.fullName
                                : user.username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Email thật từ API (user.email)
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            // [THAY THẾ] Hiển thị ID, Username và trạng thái Token thật
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    _statCol('#${user.id}', 'User ID'),
                                    _statCol('@${user.username}', 'Username'),
                                    _statCol(
                                      isVI ? 'Đã xác thực' : 'Verified',
                                      'Token',
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _statCol(
                                      '128',
                                      isVI ? 'Bài viết' : 'Posts',
                                    ),
                                    _statCol(
                                      '10.5K',
                                      isVI ? 'Người theo dõi' : 'Followers',
                                    ),
                                    _statCol(
                                      '350',
                                      isVI ? 'Đang theo dõi' : 'Following',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 20.0,
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ElevatedButton(
                                    onPressed: () => showSnackBar(
                                      context,
                                      SnackBar(
                                        content: Text(
                                          isVI
                                              ? 'Đã nhấn theo dõi'
                                              : 'Followed',
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF48FB1),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      isVI ? 'Theo dõi' : 'Follow',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: OutlinedButton(
                                    onPressed: () => showSnackBar(
                                      context,
                                      SnackBar(
                                        content: Text(
                                          isVI
                                              ? 'Đã mở khung nhắn tin'
                                              : 'Message opened',
                                        ),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF880E4F),
                                      side: const BorderSide(
                                        color: Color(0xFFF48FB1),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      isVI ? 'Nhắn tin' : 'Message',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
