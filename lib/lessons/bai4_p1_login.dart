// File: lib/lessons/bai4_p1_login.dart (ĐÃ SỬA: DÙNG VALIDATOR VÀ LOẠI BỎ SNACKBAR)

import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // GlobalKey cần thiết để truy cập và validate form
  final _formKey = GlobalKey<FormState>(); 
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Biến để lưu trữ thông báo thành công (chỉ khi thành công)
  String? _successMessage; 

  void _login() {
    // 1. Kiểm tra validator của tất cả các TextFormField
    if (_formKey.currentState!.validate()) {
      // Nếu validator trả về null (thành công)
      final username = _usernameController.text.trim();
      
      // Xử lý logic đăng nhập
      setState(() {
        _successMessage = 'Đăng nhập thành công với Username: $username!';
      });
      
      // Xóa các controller sau khi thành công (tùy chọn)
      // _usernameController.clear();
      // _passwordController.clear();
      
    } else {
      // Nếu validate thất bại (có lỗi hiển thị ngay dưới trường), reset thông báo thành công
      setState(() {
        _successMessage = null;
      });
    }
  }

  // Phương thức validator cho Tên đăng nhập
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bạn phải điền Tên đăng nhập.';
    }
    return null; // Trả về null nghĩa là không có lỗi
  }

  // Phương thức validator cho Mật khẩu
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bạn phải điền Mật khẩu.';
    }
    return null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'ĐĂNG NHẬP HỆ THỐNG',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                
                // Hiển thị thông báo thành công ngay dưới tiêu đề
                if (_successMessage != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade400)
                    ),
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else const SizedBox(height: 30),

                // Tên đăng nhập
                TextFormField(
                  controller: _usernameController,
                  validator: _validateUsername, // Gắn validator cho trường này
                  decoration: const InputDecoration(
                    labelText: 'Tên đăng nhập',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Mật khẩu
                TextFormField(
                  controller: _passwordController,
                  validator: _validatePassword, // Gắn validator cho trường này
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),

                // Nút Login
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}