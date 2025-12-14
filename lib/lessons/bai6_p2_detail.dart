// File: lib/lessons/bai6_p2_detail.dart

import 'package:flutter/material.dart';
import '../models/news_article.dart';

class NewsArticleDetail extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onBack;
  final Function(String) onLaunchUrl;

  const NewsArticleDetail({
    super.key,
    required this.article,
    required this.onBack,
    required this.onLaunchUrl,
  });

  // Helper function để định dạng ngày/giờ
  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'Không rõ ngày';
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return '${dateTime.hour}:${dateTime.minute} ngày ${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lọc nội dung tin tức (thường kết thúc bằng [...])
    String displayContent = article.content ?? article.description;
    if (displayContent.endsWith('[...]')) {
        displayContent = displayContent.substring(0, displayContent.length - 5).trim();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nút Quay lại
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Quay lại Danh sách'),
          ),
        ),
        
        // Nội dung chi tiết cuộn
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text(
                  article.title,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Thông tin tác giả/ngày
                Text(
                  'Tác giả: ${article.author ?? 'Ẩn danh'} | Đăng lúc: ${_formatDate(article.publishedAt)}',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                
                // Hình ảnh
                if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      article.urlToImage!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink(); // Ẩn nếu không tải được ảnh
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                
                // Nội dung đầy đủ
                Text(
                  displayContent,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                
                // Nội dung mô tả (nếu không có content)
                if (article.content == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      '(${article.description})',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey.shade500),
                    ),
                  ),
                
                const SizedBox(height: 30),
                
                // Nút chuyển đến trang web gốc
                ElevatedButton.icon(
                  onPressed: () => onLaunchUrl(article.url),
                  icon: const Icon(Icons.public, color: Colors.white),
                  label: const Text('Đọc tin tức gốc', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}