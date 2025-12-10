// File: lib/lessons/bai3_p3_timer.dart (Đã sửa và giảm cỡ chữ)

import 'package:flutter/material.dart';
import 'dart:async';

class SimpleTimer extends StatefulWidget {
  const SimpleTimer({super.key});

  @override
  State<SimpleTimer> createState() => _SimpleTimerState();
}

class _SimpleTimerState extends State<SimpleTimer> {
  // Giảm thời gian mặc định xuống 2 phút để demo nhanh hơn
  Duration _duration = const Duration(minutes: 2); 
  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning || _duration.inSeconds <= 0) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        _stopTimer();
        // Cần đảm bảo context vẫn hợp lệ khi hiển thị SnackBar
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('HẾT GIỜ!'), duration: Duration(seconds: 2)),
            );
        }
      } else {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _editTime() async {
    _stopTimer(); 
    
    final controller = TextEditingController(text: _duration.inSeconds.toString());
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nhập thời gian (giây)'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Tổng số giây đếm ngược'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                final seconds = int.tryParse(controller.text) ?? 0;
                if (seconds > 0) {
                  setState(() {
                    _duration = Duration(seconds: seconds);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // CHỈ TRẢ VỀ CENTER CHỨ KHÔNG TRẢ VỀ SCAFFOLD
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Hiển thị thời gian (Đã giảm fontSize xuống 60 để tránh tràn)
          Text(
            _formatDuration(_duration),
            style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w100, color: Colors.black87),
          ),
          const SizedBox(height: 30),

          // Dòng hiển thị trạng thái
          Text(
            _isRunning ? 'ĐANG ĐẾM NGƯỢC...' : 'ĐÃ DỪNG',
            style: TextStyle(fontSize: 16, color: _isRunning ? Colors.green.shade600 : Colors.red.shade600),
          ),
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Button Sửa thời gian
              OutlinedButton.icon(
                onPressed: _editTime,
                icon: const Icon(Icons.edit, color: Colors.blue),
                label: const Text('Sửa Thời Gian', style: TextStyle(fontSize: 16, color: Colors.blue)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
              const SizedBox(width: 20),

              // Button Đếm/Dừng
              ElevatedButton.icon(
                onPressed: _isRunning ? _stopTimer : _startTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
                label: Text(_isRunning ? 'Dừng' : 'Đếm', style: const TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRunning ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}