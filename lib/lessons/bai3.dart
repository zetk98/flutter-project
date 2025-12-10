// File: lib/lessons/bai3.dart (BẢN SỬA MỚI: XÓA TIÊU ĐỀ)

import 'package:flutter/material.dart';
import '../models/lesson.dart'; 

// Import các phần con
import 'bai3_p1_background_color.dart';
import 'bai3_p2_counter.dart';
import 'bai3_p3_timer.dart';

// Enum để định nghĩa các trạng thái hiển thị của Bài 3
enum Bai3Screen { 
  menu, 
  part1, 
  part2, 
  part3 
}

class Bai3MainContent extends StatefulWidget {
  const Bai3MainContent({super.key});

  @override
  State<Bai3MainContent> createState() => _Bai3MainContentState(); 
}

class _Bai3MainContentState extends State<Bai3MainContent> {
  Bai3Screen _currentScreen = Bai3Screen.menu;

  void _navigateTo(Bai3Screen screen, String title) {
    setState(() {
      _currentScreen = screen;
    });
  }

  // --- WIDGET CHUNG: Nút Back ---
  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 24.0, bottom: 8.0), // Giảm khoảng cách dưới
      child: Align(
        alignment: Alignment.topLeft,
        child: TextButton.icon(
          onPressed: () => _navigateTo(Bai3Screen.menu, 'Menu Chính'),
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          label: const Text('Quay lại Menu Bài 3', style: TextStyle(fontSize: 16, color: Colors.blue)),
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
            'Chọn một Widget để xem chi tiết',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 40),
          
          // Nút 1. Đổi Màu Nền
          _buildMenuButton(
            screen: Bai3Screen.part1, 
            title: 'Phần 1: Đổi Màu Nền', 
            label: '1. Đổi Màu Nền'
          ),
          const SizedBox(height: 15),

          // Nút 2. Máy Đếm Cơ Bản
          _buildMenuButton(
            screen: Bai3Screen.part2, 
            title: 'Phần 2: Máy Đếm Cơ Bản', 
            label: '2. Máy Đếm Cơ Bản'
          ),
          const SizedBox(height: 15),
          
          // Nút 3. Máy Đếm Giây
          _buildMenuButton(
            screen: Bai3Screen.part3, 
            title: 'Phần 3: Máy Đếm Giây', 
            label: '3. Máy Đếm Giây'
          ),
        ],
      ),
    );
  }
  
  // Helper cho các nút Menu
  Widget _buildMenuButton({required Bai3Screen screen, required String title, required String label}) {
    return SizedBox(
      width: 300, 
      child: ElevatedButton(
        onPressed: () => _navigateTo(screen, title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.blue.shade50,
          foregroundColor: Colors.blue.shade800,
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
    // Trả về một Container/Column để hiển thị nội dung Body
    return Container(
      color: Colors.white, // Nền trắng cho toàn bộ khu vực Body
      child: _currentScreen == Bai3Screen.menu 
          ? _buildMenuScreen() // Trạng thái Menu
          : Column( // Trạng thái Chi tiết (Full View)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nút Back
                _buildBackButton(),
                
                // Nội dung chi tiết được chọn (Chiếm hết phần còn lại)
                Expanded(
                  child: _getDetailWidget(_currentScreen),
                ),
              ],
            ),
    );
  }
  
  // Trả về Widget chi tiết tương ứng
  Widget _getDetailWidget(Bai3Screen screen) {
    switch (screen) {
      case Bai3Screen.part1:
        return const BackgroundColorChanger();
      case Bai3Screen.part2:
        return const SimpleCounter();
      case Bai3Screen.part3:
        return const SimpleTimer();
      case Bai3Screen.menu:
      return Container(); // Không bao giờ xảy ra trong logic này
    }
  }
}

// Dữ liệu Bài 3
Lesson get bai3Data {
  return Lesson(
    id: 3,
    title: 'Bài 3: Thực hành 10/11',
    content: 'Đổi màu nền, Bộ đếm, Máy đếm giây',
    detailWidget: const Bai3MainContent(),
  );
}