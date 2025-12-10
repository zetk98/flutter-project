import 'package:flutter/widgets.dart';

class Lesson {
  final int id;
  final String title;
  final String content;
  final Widget detailWidget; 

  Lesson({required this.id, required this.title, required this.content, required this.detailWidget});
}