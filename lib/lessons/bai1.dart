import 'package:flutter/material.dart';
import '../models/lesson.dart'; // <--- Đã chuyển import sang models

// --- CẤU TRÚC DỮ LIỆU TĨNH KHÓA HỌC ---
const List<Map<String, dynamic>> rawCourseData = [
  {
    'title': 'XML và ứng dụng - Nhóm 1',
    'code': '2025-2026.1.TIN4583.001',
    'students': 58,
    'color': 0xFFF9A825, // Màu vàng (amber)
  },
  {
    'title': 'Lập trình ứng dụng cho các t...',
    'code': '2025-2026.1.TIN4403.006',
    'students': 55,
    'color': 0xFFE53935, // Màu đỏ (red)
  },
  {
    'title': 'Lập trình ứng dụng cho các t...',
    'code': '2025-2026.1.TIN4403.005',
    'students': 52,
    'color': 0xFFEF5350, // Màu đỏ nhạt
  },
  {
    'title': 'Lập trình ứng dụng cho các t...',
    'code': '2025-2026.1.TIN4403.004',
    'students': 50,
    'color': 0xFF1976D2, // Màu xanh dương (blue)
  },
  {
    'title': 'Lập trình ứng dụng cho các t...',
    'code': '2025-2026.1.TIN4403.003',
    'students': 52,
    'color': 0xFF455A64, // Màu xanh xám đậm (blue grey)
  },
];

// --- WIDGET CARD MÔ PHỎNG KHÓA HỌC ---
Widget buildCourseCard(Map<String, dynamic> data) {
  final Color baseColor = Color(data['color'] as int);

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    
    child: Container(
      height: 120, 
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor, baseColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Hàng trên: Tiêu đề và nút Menu (ba chấm)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
            
            // Hàng dưới: Mã khóa học và Số học viên
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['code'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data['students']} học viên',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// --- WIDGET CHÍNH CHO NỘI DUNG BÀI 1 ---
class Bai1Content extends StatelessWidget {
  const Bai1Content({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), 
      itemCount: rawCourseData.length,
      itemBuilder: (context, index) {
        final data = rawCourseData[index];
        return buildCourseCard(data); 
      },
    );
  }
}

// Dữ liệu Bài 1
Lesson get bai1Data {
  return Lesson(
    id: 1,
    title: 'Bài 1: Thưc hành 6/10',
    content: 'Hiển thị classroom',
    detailWidget: const Bai1Content(),
  );
}