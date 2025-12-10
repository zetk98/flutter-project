// File: lib/lessons/bai3_p1_background_color.dart (Đã sửa)

import 'package:flutter/material.dart';

class BackgroundColorChanger extends StatefulWidget {
  const BackgroundColorChanger({super.key});

  @override
  State<BackgroundColorChanger> createState() => _BackgroundColorChangerState();
}

class _BackgroundColorChangerState extends State<BackgroundColorChanger> {
  Color _backgroundColor = Colors.white; 

  final List<Color> _availableColors = [
    Colors.white,
    Colors.red.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
  ];

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn Màu Nền'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: _availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _backgroundColor = color;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black54, width: 2),
                    ),
                    child: color == _backgroundColor 
                        ? const Icon(Icons.check, color: Colors.black) 
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // CHỈ TRẢ VỀ CONTAINER CHỨ KHÔNG TRẢ VỀ SCAFFOLD
    return Container( 
      color: _backgroundColor, 
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _showColorPicker,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Đổi Màu Nền',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Màu hiện tại: ${_backgroundColor.value.toRadixString(16).toUpperCase().substring(2)}',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}