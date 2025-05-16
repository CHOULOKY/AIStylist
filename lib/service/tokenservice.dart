import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _tokenKey = 'jwt_token';

  /// 저장된 JWT 토큰을 get
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// 토큰이 있으면 true, 없으면 false
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// 토큰을 저장
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// 토큰을 제거(로그아웃)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
