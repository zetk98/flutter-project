// File: lib/lessons/bai7_p1_login.dart (ĐÃ SỬA: Loại bỏ SnackBar Đăng nhập thành công)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Định nghĩa callback khi đăng nhập thành công
typedef LoginSuccessCallback = void Function(Map<String, dynamic> userData);

class LoginForm extends StatefulWidget {
  final LoginSuccessCallback onLoginSuccess;
  
  const LoginForm({super.key, required this.onLoginSuccess});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  // Đặt giá trị mặc định cho tài khoản emilys
  final TextEditingController _usernameController = TextEditingController(text: 'emilys');
  final TextEditingController _passwordController = TextEditingController(text: 'emilyspass');
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  
  String? _apiErrorMessage; // Biến hiển thị lỗi API

  // --- HÀM VALIDATION ---
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Bạn phải điền $fieldName.';
    }
    return null;
  }
  // ----------------------

  // Hàm lấy chi tiết Profile (Bước 2): SỬ DỤNG USER ID
  Future<Map<String, dynamic>?> _fetchUserProfile(int userId) async {
    debugPrint('--- [API BƯỚC 2] BẮT ĐẦU LẤY PROFILE SỬ DỤNG ID: $userId ---');
    
    // Sử dụng endpoint /users/$id (Thường không yêu cầu Bearer Token)
    final response = await http.get(
      Uri.parse('https://dummyjson.com/users/$userId'), 
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> profileData = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('[API BƯỚC 2] THÀNH CÔNG: Dữ liệu Profile đã nhận: ${profileData.keys}');
      return profileData;
    } else {
      debugPrint('[API BƯỚC 2] THẤT BẠI: Mã trạng thái ${response.statusCode}');
      debugPrint('[API BƯỚC 2] LỖI LẤY PROFILE. Thông báo lỗi: ${response.body}');
      return null;
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
        setState(() {
            _apiErrorMessage = null; 
        });
        return;
    }

    setState(() {
      _isLoading = true;
      _apiErrorMessage = null; 
    });

    const String loginApiUrl = 'https://dummyjson.com/auth/login';
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    
    debugPrint('\n--- BẮT ĐẦU ĐĂNG NHẬP (CHIẾN LƯỢC MỚI) ---');
    debugPrint('[ĐẦU VÀO] Tài khoản: $username, Mật khẩu: $password');

    try {
      // BƯỚC 1: GỌI API ĐĂNG NHẬP (Lấy ID)
      debugPrint('[API BƯỚC 1] GỌI ĐĂNG NHẬP: $loginApiUrl');
      final loginResponse = await http.post(
        Uri.parse(loginApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (!mounted) return; 

      final Map<String, dynamic> loginResponseData = jsonDecode(loginResponse.body);
      debugPrint('[API BƯỚC 1] Phản hồi Status Code: ${loginResponse.statusCode}');

      if (loginResponse.statusCode == 200) {
        debugPrint('[API BƯỚC 1] THÀNH CÔNG');
        // Lấy ID an toàn
        final int? userId = loginResponseData['id'] as int?;
        
        debugPrint('[API BƯỚC 1] Dữ liệu nhận được: ID=${userId != null ? userId : 'NULL'}');

        if (userId == null) {
            setState(() {
                _apiErrorMessage = 'Đăng nhập thành công, nhưng User ID bị thiếu. Không thể lấy Profile.';
            });
            debugPrint('[LỖI TRỌNG YẾU] Thiếu User ID.');
            return;
        }
        
        // BƯỚC 2: LẤY DỮ LIỆU PROFILE CHI TIẾT (Chỉ truyền ID)
        final Map<String, dynamic>? userDetails = await _fetchUserProfile(userId);
        
        if (!mounted) return;

        if (userDetails != null) {
          debugPrint('[API KẾT THÚC] Đăng nhập & Lấy Profile THÀNH CÔNG.');
          widget.onLoginSuccess(userDetails);
          
          // ĐÃ LOẠI BỎ: SnackBar đăng nhập thành công
          
        } else {
          // Xảy ra khi Bước 1 thành công nhưng Bước 2 thất bại 
          setState(() {
            _apiErrorMessage = 'Lỗi truy xuất Profile: ID hợp lệ nhưng không lấy được chi tiết profile.';
          });
          debugPrint('[API BƯỚC 2] THẤT BẠI: userDetails là NULL.');
        }
      } else {
        // Đăng nhập thất bại (Ví dụ: 400 Invalid credentials)
        final String errorMessage = loginResponseData['message']?.toString() ?? 'Lỗi đăng nhập không xác định.';
        setState(() {
           _apiErrorMessage = 'Đăng nhập thất bại: $errorMessage';
        });
        debugPrint('[API BƯỚC 1] THẤT BẠI. Thông báo: $errorMessage');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _apiErrorMessage = 'Lỗi kết nối hoặc định dạng dữ liệu: Vui lòng kiểm tra kết nối mạng.';
      });
      debugPrint('[LỖI NGOẠI LỆ] Lỗi trong quá trình xử lý: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('--- KẾT THÚC XỬ LÝ ĐĂNG NHẬP ---');
    }
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
          width: 450, 
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
                  'ĐĂNG NHẬP',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Cập nhật thông báo tài khoản mẫu
                const Text(
                  'Sử dụng tài khoản mẫu: "emilys" / "emilyspass"',
                  style: TextStyle(color: Colors.orange, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                
                // Hiển thị lỗi API
                if (_apiErrorMessage != null) ...[
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade400)
                    ),
                    child: Text(
                      _apiErrorMessage!,
                      style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 30),

                // Tên đăng nhập
                TextFormField(
                  controller: _usernameController,
                  validator: (value) => _validateRequired(value, 'Tài khoản'),
                  decoration: const InputDecoration(
                    labelText: 'Tài khoản (Username)',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                
                // Mật khẩu
                TextFormField(
                  controller: _passwordController,
                  validator: (value) => _validateRequired(value, 'Mật khẩu'),
                  obscureText: !_isPasswordVisible, 
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu (Password)',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                
                // Nút Đăng nhập
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Đăng nhập', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}