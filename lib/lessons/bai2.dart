import 'package:flutter/material.dart';
import '../models/lesson.dart'; 

// --- 3 LINK ẢNH KHÁCH SẠN CÔNG KHAI KHÁC NHAU ---
const List<String> hotelImageUrls = [
  'assets/images/hotel1.jpg', 
  'assets/images/hotel2.jpg', 
  'assets/images/hotel3.jpg', 
];

// --- DỮ LIỆU TĨNH MÔ PHỎNG KHÁCH SẠN ---
const List<Map<String, dynamic>> hotelData = [
  {
    'title': 'aNhill Boutique',
    'rating': 9.5,
    'review_text': 'Xuất sắc',
    'review_count': 95,
    'price': 'US\$109',
    'location': 'Huế · Cách bạn 0,6km',
    'room_info': '1 suite riêng tư: 1 giường',
    'extra_info': 'Đã bao gồm thuế và phí',
    'is_breakfast': true,
    'is_host': false,
    'is_booking_only': false,
    'stars': 5, 
    'image_index': 0, // Dùng ảnh thứ 1
  },
  {
    'title': 'An Nam Hue Boutique',
    'rating': 9.2,
    'review_text': 'Tuyệt hảo',
    'review_count': 34,
    'price': 'US\$20',
    'location': 'Cư Chỉnh · Cách bạn 0,9km',
    'room_info': '1 phòng khách sạn: 1 giường', 
    'extra_info': 'Đã bao gồm thuế và phí',
    'is_breakfast': true,
    'is_host': false,
    'is_booking_only': false,
    'stars': 0,
    'image_index': 1, // Dùng ảnh thứ 2
  },
  {
    'title': 'Huế Jade Hill Villa',
    'rating': 8.0,
    'review_text': 'Rất tốt',
    'review_count': 1,
    'price': 'US\$285',
    'location': 'Cư Chỉnh · Cách bạn 1,3km',
    'room_info': '1 biệt thự nguyên căn – 1.000 m²: 4 giường · 3 phòng ngủ',
    'extra_info': 'Không cần thanh toán trước',
    'is_breakfast': false,
    'is_host': true,
    'is_booking_only': true,
    'stars': 0,
    'image_index': 2, // Dùng ảnh thứ 3
  },
];

// --- WIDGET CARD MÔ PHỎNG KHÁCH SẠN ---
Widget buildHotelCard(Map<String, dynamic> data) {
  Color getRatingColor(double rating) {
    if (rating >= 9.0) return Colors.green.shade600;
    if (rating >= 8.0) return Colors.orange.shade700;
    return Colors.yellow.shade800;
  }
  
  Widget buildStars(int stars) {
    if (stars == 0) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(stars, (index) => const Icon(Icons.star, color: Colors.yellow, size: 14)),
    );
  }

  // Lấy URL ảnh dựa trên index trong dữ liệu
  final String imageUrl = hotelImageUrls[data['image_index'] as int];

  return Container(
    margin: const EdgeInsets.only(bottom: 16.0),
    padding: const EdgeInsets.only(bottom: 16.0),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))
    ),
    
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Cột 1: Ảnh và "Bao bữa sáng"
        Stack(
          children: [
            // SỬ DỤNG IMAGE.NETWORK VỚI URL ĐÃ CHỌN
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl, // URL riêng cho từng mục
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                // Fallback nếu ảnh lỗi
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120, height: 120, color: Colors.grey.shade300, 
                  child: const Center(child: Text('Lỗi ảnh', style: TextStyle(fontSize: 12))),
                ),
              ),
            ),
            // Tag "Bao bữa sáng"
            if (data['is_breakfast'] as bool)
              Positioned(
                top: 0, left: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                  ),
                  child: const Text('Bao bữa sáng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12.0),

        // Cột 2: Thông tin chi tiết
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Tiêu đề và biểu tượng trái tim (Căn phải)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] as String,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (data['is_host'] as bool)
                          const Text(
                            'Được quản lý bởi một host cá nhân',
                            style: TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 4.0),
              
              // Rating và Sao
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: getRatingColor(data['rating'] as double),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${data['rating']}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${data['review_text']} · ${data['review_count']} đánh giá',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 6),
                  buildStars(data['stars'] as int), 
                ],
              ),
              const SizedBox(height: 8.0),
              
              // Vị trí
              Row(
                children: [
                  Text(data['location'] as String, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 8.0),

              // Thông tin phòng & Giá (Căn phải)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin phòng (Đã căn phải)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // THÔNG TIN PHÒNG CĂN PHẢI
                          Text(
                            data['room_info'] as String,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 8.0),
                          // Giá
                          Text(
                            data['price'] as String,
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.blue.shade800
                            ),
                          ),
                          Text(
                            data['extra_info'] as String,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          // Chi tiết Booking.com
                          if (data['is_booking_only'] as bool)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Chỉ còn 1 căn với giá này trên Booking.com',
                                    style: TextStyle(fontSize: 12, color: Colors.red.shade700, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// --- WIDGET CHÍNH CHO NỘI DUNG BÀI 2 ---
class Bai2Content extends StatelessWidget {
  const Bai2Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. THANH TÌM KIẾM/VỊ TRÍ MÔ PHỎNG
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
          color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh địa chỉ/ngày tháng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      const SizedBox(width: 10),
                      const Text(
                        'Xung quanh vị trí hiện tại',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Text(
                    '23 thg 10 – 24 thg 10',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Số lượng kết quả
              const Text(
                '757 chỗ nghỉ',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        
        // 2. THANH TASKBAR LỌC/SẮP XẾP
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {}, 
                icon: const Icon(Icons.sort, size: 18, color: Colors.black54), 
                label: const Text('Sắp xếp', style: TextStyle(color: Colors.black54))
              ),
              TextButton.icon(
                onPressed: () {}, 
                icon: const Icon(Icons.filter_list, size: 18, color: Colors.black54), 
                label: const Text('Lọc', style: TextStyle(color: Colors.black54))
              ),
              TextButton.icon(
                onPressed: () {}, 
                icon: const Icon(Icons.map_outlined, size: 18, color: Colors.black54), 
                label: const Text('Bản đồ', style: TextStyle(color: Colors.black54))
              ),
            ],
          ),
        ),
        
        // 3. DANH SÁCH KHÁCH SẠN
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: hotelData.length,
            itemBuilder: (context, index) {
              final data = hotelData[index];
              return buildHotelCard(data); 
            },
          ),
        ),
      ],
    );
  }
}

// Dữ liệu Bài 2
Lesson get bai2Data {
  return Lesson(
    id: 2,
    title: 'Bài 2: Thực hành 27/10',
    content: 'Hiển thị khách sạn',
    detailWidget: const Bai2Content(),
  );
}