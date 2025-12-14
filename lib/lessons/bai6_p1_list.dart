// File: lib/lessons/bai6_p1_list.dart

import 'package:flutter/material.dart';
import '../models/news_article.dart';

class NewsArticleList extends StatelessWidget {
  final List<NewsArticle> articles;
  final Function(NewsArticle) onSelectArticle;

  const NewsArticleList({
    super.key,
    required this.articles,
    required this.onSelectArticle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            
            // Thumbnail (Hiển thị ảnh nếu có)
            leading: article.urlToImage != null && article.urlToImage!.isNotEmpty
                ? SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
                      },
                    ),
                  )
                : const Icon(Icons.article, size: 40, color: Colors.blue),

            title: Text(
              article.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Nội dung ngắn
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                article.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            
            onTap: () => onSelectArticle(article),
          ),
        );
      },
    );
  }
}