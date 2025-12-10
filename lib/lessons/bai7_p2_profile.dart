// File: lib/lessons/bai7_p2_profile.dart (FULL CODE ĐÃ SỬA LỖI NULL AN TOÀN)

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.userData,
    required this.onLogout,
  });

  // Helper function để lấy giá trị String an toàn, tránh lỗi Null
  String _getStringValue(String key) {
    // Lấy giá trị từ Map, đảm bảo nó là String (hoặc null), sau đó cung cấp 'N/A' nếu null
    return userData[key]?.toString() ?? 'N/A';
  }

  // --- WIDGET XÂY DỰNG CHI TIẾT DỮ LIỆU ---
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade600, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy các giá trị cần thiết, sử dụng helper function để AN TOÀN TRÁNH NULL
    final String firstName = _getStringValue('firstName');
    final String lastName = _getStringValue('lastName');
    final String username = _getStringValue('username');
    final String email = _getStringValue('email');
    final String gender = _getStringValue('gender');
    // Xử lý an toàn cho trường image (có thể là null)
    final String image = userData['image']?.toString() ?? 'https://i.imgur.com/7yYjA02.png'; 
    
    // Gộp tên đầy đủ
    final String fullName = '$firstName $lastName';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần Avatar và Tên
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 30),
            color: Colors.blue.shade700,
            width: double.infinity,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(image),
                ),
                const SizedBox(height: 10),
                Text(
                  fullName,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  '@$username',
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade200),
                ),
              ],
            ),
          ),
          
          // Chi tiết tài khoản
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chi tiết tài khoản',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const Divider(height: 20, thickness: 1),
                
                _buildDetailRow(Icons.person, 'Tên người dùng', fullName),
                _buildDetailRow(Icons.verified_user, 'Username', username),
                _buildDetailRow(Icons.email, 'Email', email),
                _buildDetailRow(Icons.people, 'Giới tính', gender),
                
                const SizedBox(height: 40),

                // Nút Đăng xuất
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onLogout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Đăng xuất', style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}