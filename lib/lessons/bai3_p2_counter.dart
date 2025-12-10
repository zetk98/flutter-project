// File: lib/lessons/bai3_p2_counter.dart (Đã sửa)

import 'package:flutter/material.dart';

class SimpleCounter extends StatefulWidget {
  const SimpleCounter({super.key});

  @override
  State<SimpleCounter> createState() => _SimpleCounterState();
}

class _SimpleCounterState extends State<SimpleCounter> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // CHỈ TRẢ VỀ CENTER CHỨ KHÔNG TRẢ VỀ SCAFFOLD
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Hiển thị số đếm
          Text(
            '$_counter',
            style: TextStyle(
              fontSize: 80, 
              fontWeight: FontWeight.bold, 
              color: _counter == 0 ? Colors.grey : Colors.blue.shade800
            ),
          ),
          const SizedBox(height: 70), 

          // 3 Button: Giảm, Reset, Tăng
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Button Giảm
              FloatingActionButton(
                onPressed: _decrementCounter,
                tooltip: 'Giảm',
                heroTag: 'decrement',
                backgroundColor: Colors.orange,
                child: const Icon(Icons.remove, color: Colors.white),
              ),
              const SizedBox(width: 20),

              // Button Reset (Đặt lại về 0)
              ElevatedButton.icon(
                onPressed: _resetCounter,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('RESET', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(width: 20),

              // Button Tăng
              FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Tăng',
                heroTag: 'increment',
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}