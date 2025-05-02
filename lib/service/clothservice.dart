import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/clothdata.dart';
import '../utility/utility.dart';
import 'authservice.dart';
import 'constants.dart';

class DbService {
  final AuthService _auth = AuthService();  // ① AuthService 인스턴스

  // API 기본 URL
  static final Uri _clothBaseUrl =
  Uri.parse('${ApiConstants.baseUrl}/clothes');

  /// 전체 아이템 가져오기
  Future<List<ClothItem>> fetchItems() async {
    // ② AuthService.getAuthHeaders() 호출
    final headers = await _auth.getAuthHeaders();
    final res = await http.get(_clothBaseUrl, headers: headers);

    if (res.statusCode == 200) {
      // UTF‑8로 디코딩하고 JSON 배열로 파싱
      final List<dynamic> body = ResponseDecoder.decodeListJson(res);
      return body.map((e) => ClothItem.fromJson(e)).toList();
      //final List body = jsonDecode(res.body);
      //return body.map((e) => ClothItem.fromJson(e)).toList();
    }
    throw Exception('Failed to load items (${res.statusCode})');
  }
}
