// File: lib/lessons/bai5.dart (Đã thêm nút Mua Ngay và Thêm vào Giỏ hàng)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; 
import '../models/lesson.dart'; 
import '../models/product.dart';

class Bai5MainContent extends StatefulWidget {
  const Bai5MainContent({super.key});

  @override
  State<Bai5MainContent> createState() => _Bai5MainContentState();
}

class _Bai5MainContentState extends State<Bai5MainContent> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // --- HÀM GỌI API ---
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    const apiUrl = 'https://fakestoreapi.com/products';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        setState(() {
          _products = jsonList
              .map((json) => Product.fromJson(json as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
        
      } else {
        setState(() {
          _errorMessage = 'Lỗi HTTP: Mã trạng thái ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối hoặc xử lý dữ liệu: $e';
        _isLoading = false;
      });
    }
  }
  
  // --- WIDGET XÂY DỰNG ---
  Widget _buildRatingBar(Rating rating) {
    int fullStars = rating.rate.floor();
    bool hasHalfStar = (rating.rate - fullStars) >= 0.5;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hiển thị sao
        ...List.generate(5, (index) {
          if (index < fullStars) {
            return const Icon(Icons.star, color: Colors.amber, size: 14);
          } else if (index == fullStars && hasHalfStar) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 14);
          } else {
            return Icon(Icons.star_border, color: Colors.grey.shade400, size: 14);
          }
        }),
        const SizedBox(width: 4),
        // Số lượng đánh giá
        Text(
          '(${rating.count})',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Hàm xử lý khi nhấn nút (Tạm thời chỉ hiển thị SnackBar)
  void _showActionSnackBar(String action, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: $productName'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      // ... (Phần xử lý lỗi giữ nguyên)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lỗi Tải Sản Phẩm: $_errorMessage',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchProducts,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Hiển thị Grid View
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cột như trong ảnh
        childAspectRatio: 0.55, // Giảm tỷ lệ này để có thêm chỗ cho 2 nút bấm
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column( // Thay InkWell bằng Column và Wrap InkWell/GestureDetector quanh ảnh
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hình ảnh sản phẩm (có thể click để xem chi tiết ảnh)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _launchURL(product.image); // Mở link ảnh
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Chi tiết sản phẩm
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      
                      // Danh mục
                      Text(
                        product.category,
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                      ),
                      const SizedBox(height: 4),
                      
                      // Giá
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      
                      // Rating (Đánh giá)
                      _buildRatingBar(product.rating),
                    ],
                  ),
                ),

                // --- KHU VỰC 2 BUTTON MỚI ---
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Column(
                    children: [
                      // 1. Mua Ngay (Màu xanh lá)
                      ElevatedButton(
                        onPressed: () => _showActionSnackBar('Mua Ngay', product.title),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen.shade600,
                          minimumSize: const Size(double.infinity, 35),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        child: const Text('MUA NGAY', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 5),
                      
                      // 2. Thêm vào Giỏ hàng (Màu cam)
                      OutlinedButton.icon(
                        onPressed: () => _showActionSnackBar('Đã thêm', product.title),
                        icon: const Icon(Icons.shopping_cart, size: 16, color: Colors.orange),
                        label: const Text('Thêm vào Giỏ hàng', style: TextStyle(color: Colors.orange, fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange, width: 1.5),
                          minimumSize: const Size(double.infinity, 35),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ],
                  ),
                ),
                // -----------------------------
              ],
            ),
          
        );
      },
    );
  }
  
  // Hàm mở URL (giữ nguyên)
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể mở liên kết: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: _buildProductGrid(),
    );
  }
}

// Dữ liệu Bài 5 (Giữ nguyên)
Lesson get bai5Data {
  return Lesson(
    id: 5,
    title: 'Bài 5: Thực hành 29/11',
    content: 'Web API',
    detailWidget: const Bai5MainContent(), 
  );
}