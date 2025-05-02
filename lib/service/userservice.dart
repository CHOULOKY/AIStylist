import 'dart:convert';
import 'package:http/http.dart' as http;

import 'authservice.dart';
import 'constants.dart';
import '../utility/utility.dart';

class UserService {
  final AuthService _auth = AuthService();

  static final String _baseUrl = '${ApiConstants.baseUrl}/users';
  static final Uri _meUri = Uri.parse('$_baseUrl/me');
  static final Uri _infoUri = Uri.parse('$_baseUrl/info');
  static final Uri _prefUri = Uri.parse('$_baseUrl/preferences');

  /// ─ GET /users/me ───────────────────────────────────────
  /// JWT 헤더를 포함해 현재 로그인한 사용자의 이메일과 이름을 조회
  Future<Map<String, dynamic>> getMe() async {
    final headers = await _auth.getAuthHeaders();
    final res = await http.get(_meUri, headers: headers);
    if (res.statusCode == 200) {
      return ResponseDecoder.decodeJson(res);
      //return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('getMe 실패 (${res.statusCode}): ${res.body}');
  }

  /// ─ POST /users/info ───────────────────────────────────
  /// 사용자 정보 저장 또는 수정 (name, height, bodyType)
  Future<void> saveUserInfo({
    required String name,
    required int height,
    required String bodyType,
  }) async {
    final headers = await _auth.getAuthHeaders();
    final res = await http.post(
      _infoUri,
      headers: headers,
      body: jsonEncode({
        'name': name,
        'height': height,
        'bodyType': bodyType,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('saveUserInfo 실패 (${res.statusCode}): ${res.body}');
    }
  }

  /// ─ GET /users/info ────────────────────────────────────
  /// 저장된 사용자 정보를 조회
  Future<Map<String, dynamic>> getUserInfo() async {
    final headers = await _auth.getAuthHeaders();
    final res = await http.get(_infoUri, headers: headers);
    if (res.statusCode == 200) {
      // bodyBytes를 utf8로 직접 디코딩
      return ResponseDecoder.decodeJson(res);
      //return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('getUserInfo 실패 (${res.statusCode}): ${res.body}');
  }

  /// ─ POST /users/preferences ────────────────────────────
  /// 사용자 선호 정보 저장 또는 수정
  Future<void> savePreference({
    required String preferredStyle,
    required String preferredColor,
    required String avoidStyle,
  }) async {
    final headers = await _auth.getAuthHeaders();
    final res = await http.post(
      _prefUri,
      headers: headers,
      body: jsonEncode({
        'preferredStyle': preferredStyle,
        'preferredColor': preferredColor,
        'avoidStyle': avoidStyle,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('savePreference 실패 (${res.statusCode}): ${res.body}');
    }
  }

  /// ─ GET /users/preferences ─────────────────────────────
  /// 저장된 사용자 선호 정보를 조회
  Future<Map<String, dynamic>> getPreference() async {
    final headers = await _auth.getAuthHeaders();
    final res = await http.get(_prefUri, headers: headers);
    if (res.statusCode == 200) {
      return ResponseDecoder.decodeJson(res);
      //return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('getPreference 실패 (${res.statusCode}): ${res.body}');
  }
}
