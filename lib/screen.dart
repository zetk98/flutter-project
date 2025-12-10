import 'package:flutter/material.dart';
import 'lessons/bai1.dart'; 
import 'lessons/bai2.dart';
import 'lessons/bai3.dart';
import 'lessons/bai4.dart';
import 'lessons/bai7.dart';
import 'models/lesson.dart';

// TẬP HỢP TẤT CẢ CÁC BÀI HỌC VÀO MỘT DANH SÁCH DUY NHẤT
List<Lesson> get allLessons => [
  bai1Data,
  bai2Data,
  bai3Data,
  bai4Data,
  bai7Data,
];


// ----------- ỨNG DỤNG CHÍNH VÀ ROUTES -----------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bùi Minh Tuấn App', 
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/lesson-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return LessonDetailScreen(lessonId: args);
        },
      },
    );
  }
}


// ----------- MÀN HÌNH CHÍNH (HOMESCREEN) -----------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedLessonId = allLessons.first.id; 

  Lesson _getSelectedLesson() {
    return allLessons.firstWhere(
      (lesson) => lesson.id == _selectedLessonId,
      orElse: () => allLessons.first,
    );
  }

  void _selectLesson(BuildContext context, Lesson lesson, bool isMobile) {
    if (isMobile) {
      Navigator.of(context).pop(); 
      Navigator.of(context).pushNamed(
        '/lesson-detail',
        arguments: lesson.id,
      );
    } else {
      setState(() {
        _selectedLessonId = lesson.id;
      });
    }
  }

  // **********************************************
  // ** HÀM SỬA ĐỔI: HIỂN THỊ TITLE VÀ CONTENT **
  // **********************************************
  Widget _buildLessonList(BuildContext context, bool isMobile) {
    return ListView.builder(
      itemCount: allLessons.length,
      itemBuilder: (ctx, index) {
        final lesson = allLessons[index];
        final isSelected = !isMobile && lesson.id == _selectedLessonId;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ListTile cho Tiêu đề (Title)
            ListTile(
              selected: isSelected,
              title: Text(
                lesson.title, 
                style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              ),
              onTap: () => _selectLesson(context, lesson, isMobile),
            ),
            
            // 2. Padding/Text cho Nội dung (Content)
            if (lesson.content.isNotEmpty)
              Padding(
                // Căn chỉnh để Text Content nằm dưới Title một chút
                padding: const EdgeInsets.fromLTRB(20.0, 0, 16.0, 8.0), 
                child: Text(
                  lesson.content, // <--- HIỂN THỊ CONTENT
                  style: TextStyle(
                    fontSize: 13, 
                    color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
                  ),
                ),
              ),
            
            const Divider(height: 1, thickness: 0.5),
          ],
        );
      },
    );
  }
  // **********************************************
  
  // ***** SỬA LỖI UNBOUNDED HEIGHT TRONG SPLIT VIEW *****
  Widget _buildDetailContent() {
    final Lesson lesson = _getSelectedLesson();

    // Dùng Padding bọc Column để căn chỉnh nội dung
    return Padding(
      // Padding top 16.0 để căn ngang hàng với tiêu đề "Danh Mục"
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ***** BỌC lesson.detailWidget TRONG EXPANDED *****
          Expanded( 
            child: lesson.detailWidget, // Đây là nội dung chi tiết của bài học
          ),
          const SizedBox(height: 20),
          // Tóm tắt (Text không cuộn)
          Text(
            '${lesson.content}',
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    const double splitViewBreakpoint = 600.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < splitViewBreakpoint;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bùi Minh Tuấn App'),
      ),
      
      // Drawer (Mobile)
      drawer: isMobile
          ? Drawer(
              child: Column(
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Center(
                      child: Text('Mục lục Bài học', style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  Expanded(
                    child: _buildLessonList(context, isMobile),
                  ),
                ],
              ),
            )
          : null, 

      // Body (Split View cho Desktop/Tablet)
      body: isMobile
          ? const Center(child: Text('Mở Menu (Drawer) để chọn bài học'))
          : Row(
              children: <Widget>[
                // Cột bên trái: Danh sách bài học (25% màn hình)
                SizedBox(
                  width: screenWidth * 0.25, 
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey, width: 1)),
                      color: Color(0xFFF0F0F0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          child: Text(
                            'Danh Mục', 
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          ),
                        ),
                        Expanded(
                          child: _buildLessonList(context, isMobile),
                        ),
                      ],
                    ),
                  ),
                ),
                // Cột bên phải: Nội dung chi tiết (75% màn hình)
                Expanded(
                  child: _buildDetailContent(), 
                ),
              ],
            ),
    );
  }
}

// ----------- MÀN HÌNH CHI TIẾT (DÙNG CHO MOBILE) -----------
class LessonDetailScreen extends StatelessWidget {
  final int lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  Lesson _findLessonById() {
    return allLessons.firstWhere(
      (lesson) => lesson.id == lessonId,
      orElse: () => Lesson(id: 999, title: 'Lỗi', content: 'Bài học không tìm thấy', detailWidget: const Center(child: Text('Lỗi tải dữ liệu'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Lesson selectedLesson = _findLessonById();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedLesson.title),
      ),
      body: SingleChildScrollView( // Giữ SingleChildScrollView cho Mobile Detail
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              selectedLesson.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            selectedLesson.detailWidget, 
            const SizedBox(height: 20),
            Text(
              '${selectedLesson.content}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}