// File: lib/lessons/bai6.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // Thư viện để mở URL
import '../models/lesson.dart'; 
import '../models/news_article.dart';
import 'bai6_p1_list.dart';
import 'bai6_p2_detail.dart';

// Enum định nghĩa trạng thái của nội dung Body Bài 6
enum Bai6Screen { 
  list,      // Mặc định, hiển thị danh sách tin tức
  detail,    // Hiển thị chi tiết một tin tức
}

class Bai6MainContent extends StatefulWidget {
  const Bai6MainContent({super.key});

  @override
  State<Bai6MainContent> createState() => _Bai6MainContentState(); 
}

class _Bai6MainContentState extends State<Bai6MainContent> {
  Bai6Screen _currentScreen = Bai6Screen.list;
  List<NewsArticle> _newsArticles = [];
  NewsArticle? _selectedArticle;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  // --- HÀM GỌI API ---
  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    const apiKey = '0eb9f6b3fe6d4f01898e281130700aab';
    const apiUrl = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'ok' && data['articles'] != null) {
          final List<dynamic> articlesJson = data['articles'];
          
          setState(() {
            // Lọc bỏ những bài báo thiếu tiêu đề hoặc mô tả
            _newsArticles = articlesJson
                .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
                .where((article) => article.title != 'Không có Tiêu đề' && article.description != 'Không có nội dung mô tả')
                .toList();
            _isLoading = false;
          });
          
        } else {
          // Xử lý lỗi từ API (ví dụ: API key bị giới hạn, hết quota)
          setState(() {
            _errorMessage = data['message'] as String? ?? 'Lỗi không xác định từ News API.';
            _isLoading = false;
          });
        }
      } else {
        // Lỗi HTTP (404, 500,...)
        setState(() {
          _errorMessage = 'Lỗi HTTP: Mã trạng thái ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Lỗi mạng hoặc lỗi parsing
      setState(() {
        _errorMessage = 'Lỗi kết nối hoặc xử lý dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  // --- HÀM CHUYỂN STATE ---
  void _selectArticle(NewsArticle article) {
    setState(() {
      _selectedArticle = article;
      _currentScreen = Bai6Screen.detail;
    });
  }

  void _goBackToList() {
    setState(() {
      _selectedArticle = null;
      _currentScreen = Bai6Screen.list;
    });
  }
  
  // Hàm mở URL (sử dụng package url_launcher)
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở URL: $url')),
      );
    }
  }

  // --- WIDGET XÂY DỰNG ---
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lỗi Tải Tin Tức: $_errorMessage',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchNews,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentScreen == Bai6Screen.list) {
      return NewsArticleList(
        articles: _newsArticles, 
        onSelectArticle: _selectArticle,
      );
    } else if (_currentScreen == Bai6Screen.detail && _selectedArticle != null) {
      return NewsArticleDetail(
        article: _selectedArticle!,
        onBack: _goBackToList,
        onLaunchUrl: _launchURL,
      );
    }
    return const Center(child: Text('Không tìm thấy nội dung hiển thị.'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề (Giống Bài 7 đã sửa, không tiêu đề lớn)
          
          // Nội dung chính
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}

// Dữ liệu Bài 6
Lesson get bai6Data {
  return Lesson(
    id: 6,
    title: 'Bài 6: Thực hành 1/12',
    content: 'News API',
    detailWidget: const Bai6MainContent(), 
  );
}