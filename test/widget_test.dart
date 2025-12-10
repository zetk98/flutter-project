import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screen.dart'; // Đã sửa import

void main() {
  // Kiểm tra chức năng điều hướng và Drawer trên Mobile
  testWidgets('Mobile: Ứng dụng hiển thị Drawer và điều hướng sang trang chi tiết', (WidgetTester tester) async {
    // Đặt kích thước cửa sổ test nhỏ (giả lập Mobile)
    tester.binding.window.physicalSizeTestValue = const Size(300, 600);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(); 
    
    // 1. Kiểm tra tiêu đề chính và nút Menu (Drawer) - Đã cập nhật tên
    expect(find.text('Bùi Minh Tuấn App'), findsOneWidget); 
    expect(find.byIcon(Icons.menu), findsOneWidget); 

    // 2. Mở Drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle(); 

    // 3. Kiểm tra danh sách bài học xuất hiện trong Drawer
    expect(find.text('Bài 2'), findsOneWidget);

    // 4. Click vào Bài 2
    await tester.tap(find.widgetWithText(ListTile, 'Bài 2'));
    await tester.pumpAndSettle(); 

    // 5. Kiểm tra đã chuyển sang màn hình chi tiết Bài 2
    expect(find.text('Bài 2: Các Widget cơ bản'), findsOneWidget); 
    
    addTearDown(() {
      tester.binding.window.clearAllTestValues();
    });
  });

  // Kiểm tra chức năng chuyển bài học trên màn hình lớn (Split View)
  testWidgets('Desktop: Chuyển đổi nội dung bài học trong Split View', (WidgetTester tester) async {
    // Đặt kích thước cửa sổ test lớn (giả lập Desktop/Tablet)
    tester.binding.window.physicalSizeTestValue = const Size(1000, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(); 

    // 1. Kiểm tra Bài 1 là nội dung mặc định và đang được chọn
    expect(find.text('Bài 1: Thực hành 6/10'), findsOneWidget); 
    expect(find.text('Đang chọn'), findsOneWidget); 

    // 2. Click vào Bài 2 trong danh sách bên trái
    await tester.tap(find.widgetWithText(ListTile, 'Bài 2'));
    await tester.pump(); 

    // 3. Kiểm tra nội dung đã chuyển sang Bài 2
    expect(find.text('Bài 2: Các Widget cơ bản'), findsOneWidget);
    
    addTearDown(() {
      tester.binding.window.clearAllTestValues();
    });
  });
}