// File: lib/lessons/bai7.dart (ĐÃ SỬA: Loại bỏ hoàn toàn Tiêu đề và Divider)

import 'package:flutter/material.dart';
import '../models/lesson.dart'; 
// Import các phần con
import 'bai7_p1_login.dart';
import 'bai7_p2_profile.dart'; 

// Enum định nghĩa trạng thái của nội dung Body Bài 7
enum Bai7Screen { 
  login,      // Mặc định
  profile,    // Đã đăng nhập thành công
}

class Bai7MainContent extends StatefulWidget {
  const Bai7MainContent({super.key});

  @override
  State<Bai7MainContent> createState() => _Bai7MainContentState(); 
}

class _Bai7MainContentState extends State<Bai7MainContent> {
  // Trạng thái hiện tại
  Bai7Screen _currentScreen = Bai7Screen.login;
  
  // Dữ liệu profile sau khi đăng nhập thành công
  Map<String, dynamic>? _userData;
  
  // Tiêu đề hiển thị (Vẫn giữ biến này cho việc chuyển đổi trạng thái nếu cần debug)

  // --- HÀM XỬ LÝ CHUYỂN TRẠNG THÁI ---
  void _setLoginSuccess(Map<String, dynamic> data) {
    setState(() {
      _userData = data;
      _currentScreen = Bai7Screen.profile;
      
      // LOGIC XỬ LÝ TÊN AN TOÀN HƠN (Không ảnh hưởng đến UI vì đã xóa hiển thị)
      
      
    });
  }

  void _logout() {
    setState(() {
      _userData = null;
      _currentScreen = Bai7Screen.login;
    });
  }
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ĐÃ XÓA: Padding chứa Text Title và Divider
          
          // Nội dung chính
          Expanded(
            child: _currentScreen == Bai7Screen.login
                ? LoginForm(onLoginSuccess: _setLoginSuccess) 
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trang Profile
                      Expanded(
                        child: ProfilePage(
                            userData: _userData!, 
                            onLogout: _logout, 
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

// Dữ liệu Bài 7
Lesson get bai7Data {
  return Lesson(
    id: 7,
    title: 'Bài 7: Thực hành 8/12',
    content: 'Đăng nhập API và Hiển thị Profile',
    detailWidget: const Bai7MainContent(), 
  );
}