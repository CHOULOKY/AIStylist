import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/clothdata.dart';
import '../utility/utility.dart';
import 'authservice.dart';
import 'constants.dart';

class ClothService {
  final AuthService _auth = AuthService();  // ① AuthService 인스턴스

  // API 기본 URL
  static final Uri _clothBaseUrl =
  Uri.parse('${ApiConstants.baseUrl}/clothes');

  /// 전체 아이템 가져오기
  Future<List<ClothItem>> fetchItems() async {
    // ② AuthService.getAuthHeaders() 호출
    final headers = await _auth.getJsonHeaders();
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

  // 아이템 등록
  Future<bool> addClothItem({
    required File imageFile,
    required String category,
    required String color,
    required String season,
    required String style,
  }) async {
    // 1) 토큰 헤더 준비
    final headers = await _auth.getMultipartHeaders();
    // 2) MultipartRequest 생성
    final request = http.MultipartRequest('POST', _clothBaseUrl)
      ..headers.addAll(headers);

    // 3) 이미지 파일 파트 추가
    final mimeType = lookupMimeType(imageFile.path) ?? 'application/octet-stream';
    final mimeParts = mimeType.split('/');
    request.files.add(
      http.MultipartFile(
        'image', // 키: @RequestPart("image") 와 매핑
        imageFile.openRead(), // 파일 스트림: HTTP 바디에 스트리밍 업로드
        await imageFile.length(), // 스트림으로부터 읽어올 전체 바이트 크기
        filename: basename(imageFile.path), // 업로드할 파일의 원본 파일명
        contentType: MediaType(mimeParts[0], mimeParts[1]), // Content-Type: image/png
      ),
    );

    // 4) 다른 필드들 추가
    request.fields['category'] = category;
    request.fields['color']    = color;
    request.fields['season']   = season;
    request.fields['style']    = style;

    // 5) 전송 및 응답 처리
    final streamedResponse = await request.send();
    final res = await http.Response.fromStream(streamedResponse);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      throw Exception('옷 등록 실패: ${res.statusCode} ${res.body}');
    }
  }

}
