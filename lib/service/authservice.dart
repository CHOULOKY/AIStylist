import 'dart:convert';
import 'package:aistylist/service/tokenservice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AuthService {
  static final String _baseUrl = '${ApiConstants.baseUrl}/users';
  static final Uri _registerUri = Uri.parse('$_baseUrl/register');
  static final Uri _loginUri = Uri.parse('$_baseUrl/login');

  // 회원가입 Post
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await http.post(
      _registerUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 409) {
      throw Exception('이미 등록된 이메일입니다.');
    } else {
      throw Exception('회원가입 실패 (${response.statusCode}): ${response.body}');
    }
  }

  // 로그인 Post
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      _loginUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;

      TokenService.saveToken(token);
    } else {
      throw Exception('로그인 실패 (${response.statusCode}): ${response.body}');
    }
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await TokenService.getToken() ?? '';

    return {
      'Content-Type': 'application/json',
      if (token != '') 'Authorization': 'Bearer $token',
    };
  }
}
