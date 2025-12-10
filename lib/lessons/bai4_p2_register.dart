// File: lib/lessons/bai4_p2_register.dart (BẢN SỬA MỚI: Lỗi Checkbox hiển thị dưới Checkbox)

import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _gender;
  bool _agreedToTerms = false;
  
  String? _successMessage;
  
  // Biến mới để quản lý lỗi của Checkbox
  String? _termsError; 

  // --- LOGIC VALIDATOR ---
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Bạn phải điền $fieldName.';
    }
    return null;
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bạn phải điền Email.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  // --- LOGIC ĐĂNG KÝ ---
  void _register() {
    // 1. Kiểm tra Checkbox trước để thiết lập _termsError
    if (!_agreedToTerms) {
      _termsError = 'Bạn phải chấp nhận điều khoản dịch vụ.';
    } else {
      _termsError = null;
    }
    
    // 2. Validate các trường Form (kiểm tra TextFormField validators)
    // Dùng && để đảm bảo cả Form và Checkbox đều hợp lệ
    if (_formKey.currentState!.validate() && _termsError == null) {
      // Nếu thành công tất cả (Form + Checkbox)
      setState(() {
        _successMessage = 'Đăng ký thành công cho tài khoản: ${_usernameController.text}';
      });
      
      // Xóa các trường sau khi đăng ký (tùy chọn)
      _usernameController.clear();
      _passwordController.clear();
      _emailController.clear();
      _phoneController.clear();
      _gender = null;
      _agreedToTerms = false;
      _formKey.currentState!.reset(); 
      
    } else {
      // Nếu validate thất bại, reset thông báo thành công
      setState(() {
        _successMessage = null;
        // Bắt buộc gọi setState() để cập nhật hiển thị lỗi termsError
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: 500, 
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
                  'ĐĂNG KÝ TÀI KHOẢN MỚI',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                  textAlign: TextAlign.center,
                ),

                // --- THÔNG BÁO THÀNH CÔNG ---
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
                
                // Tên đăng nhập (Bắt buộc)
                TextFormField(
                  controller: _usernameController,
                  validator: (value) => _validateRequired(value, 'Tên đăng nhập'),
                  decoration: const InputDecoration(
                    labelText: 'Tên đăng nhập *',
                    prefixIcon: Icon(Icons.person_add),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Mật khẩu (Bắt buộc)
                TextFormField(
                  controller: _passwordController,
                  validator: (value) => _validateRequired(value, 'Mật khẩu'),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu *',
                    prefixIcon: Icon(Icons.lock_open),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Email (Bắt buộc và format)
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Số điện thoại (Tùy chọn)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Giới tính (Dropdown - Tùy chọn)
                DropdownButtonFormField<String>(
                  value: _gender,
                  hint: const Text('Chọn Giới tính'),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.wc),
                    border: OutlineInputBorder(),
                  ),
                  items: ['Nam', 'Nữ', 'Khác']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Chấp nhận điều khoản (Bắt buộc)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _agreedToTerms = newValue ?? false;
                              // Xóa lỗi ngay khi người dùng tương tác lại
                              _termsError = null; 
                            });
                          },
                        ),
                        const Flexible(
                          child: Text('Tôi đồng ý với các điều khoản dịch vụ *'),
                        ),
                      ],
                    ),
                    // Hiển thị lỗi Checkbox tại đây
                    if (_termsError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                        child: Text(
                          _termsError!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 40),

                // Nút Đăng ký
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text(
                    'Đăng ký tài khoản',
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