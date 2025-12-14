// File: lib/models/product.dart

// --- 1. MODEL CHO RATING (Đánh giá) ---
class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      // Chuyển đổi an toàn: Nếu là int thì chuyển sang double
      rate: json['rate'] is num ? json['rate'].toDouble() : 0.0,
      count: json['count'] as int? ?? 0,
    );
  }
}

// --- 2. MODEL CHO PRODUCT (Sản phẩm) ---
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Xử lý các trường có thể null hoặc kiểu dữ liệu khác
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Không có Tiêu đề',
      price: json['price'] is num ? json['price'].toDouble() : 0.0,
      description: json['description'] as String? ?? 'Không có mô tả',
      category: json['category'] as String? ?? 'Unknown',
      image: json['image'] as String? ?? '',
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>? ?? {}),
    );
  }
}