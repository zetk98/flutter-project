// File: lib/lessons/bai4.dart

import 'package:flutter/material.dart';
import '../models/lesson.dart'; 

// Import các phần con
import 'bai4_p1_login.dart';
import 'bai4_p2_register.dart';

// Enum để định nghĩa các trạng thái hiển thị của Bài 4
enum Bai4Screen { 
  menu, 
  part1, // Đăng nhập
  part2, // Đăng ký
}

class Bai4MainContent extends StatefulWidget {
  const Bai4MainContent({super.key});

  @override
  State<Bai4MainContent> createState() => _Bai4MainContentState(); 
}

class _Bai4MainContentState extends State<Bai4MainContent> {
  Bai4Screen _currentScreen = Bai4Screen.menu;

  void _navigateTo(Bai4Screen screen, String title) {
    setState(() {
      _currentScreen = screen;
    });
  }

  // --- WIDGET CHUNG: Nút Back ---
  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 24.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: TextButton.icon(
          onPressed: () => _navigateTo(Bai4Screen.menu, 'Menu Chính'),
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          label: const Text('Quay lại Menu Bài 4', style: TextStyle(fontSize: 16, color: Colors.blue)),
        ),
      ),
    );
  }

  // --- WIDGET MENU CHÍNH ---
  Widget _buildMenuScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tiêu đề Menu
          Text(
            '', 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 40),
          
          // Nút 1. Đăng nhập
          _buildMenuButton(
            screen: Bai4Screen.part1, 
            title: '', 
            label: 'Đăng nhập (Login)'
          ),
          const SizedBox(height: 15),

          // Nút 2. Đăng ký
          _buildMenuButton(
            screen: Bai4Screen.part2, 
            title: '', 
            label: 'Đăng ký (Register)'
          ),
        ],
      ),
    );
  }
  
  // Helper cho các nút Menu
  Widget _buildMenuButton({required Bai4Screen screen, required String title, required String label}) {
    return SizedBox(
      width: 300, 
      child: ElevatedButton(
        onPressed: () => _navigateTo(screen, title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.green.shade50,
          foregroundColor: Colors.green.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // --- PHƯƠNG THỨC BUILD CHÍNH ---
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: _currentScreen == Bai4Screen.menu 
          ? _buildMenuScreen() 
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nút Back
                _buildBackButton(),
                
                // Nội dung chi tiết được chọn
                Expanded(
                  child: _getDetailWidget(_currentScreen),
                ),
              ],
            ),
    );
  }
  
  // Trả về Widget chi tiết tương ứng
  Widget _getDetailWidget(Bai4Screen screen) {
    switch (screen) {
      case Bai4Screen.part1:
        return const LoginForm(); // Tên class sẽ tạo ở file bai4_p1_login.dart
      case Bai4Screen.part2:
        return const RegisterForm(); // Tên class sẽ tạo ở file bai4_p2_register.dart
      case Bai4Screen.menu:
      return Container();
    }
  }
}

// Dữ liệu Bài 4
Lesson get bai4Data {
  return Lesson(
    id: 4,
    title: 'Bài 4: Thực hành 17/11',
    content: 'Form Đăng nhập và Đăng ký',
    detailWidget: const Bai4MainContent(), 
  );
}