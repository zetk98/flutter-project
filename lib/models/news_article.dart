// File: lib/models/news_article.dart

class NewsArticle {
  final String title;
  final String description;
  final String url; // Dùng để mở trang web gốc
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final String? author;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.author,
  });

  // Hàm factory để tạo đối tượng NewsArticle từ Map JSON
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String? ?? 'Không có Tiêu đề',
      description: json['description'] as String? ?? 'Không có nội dung mô tả',
      url: json['url'] as String? ?? '', // URL là bắt buộc
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
    );
  }
}