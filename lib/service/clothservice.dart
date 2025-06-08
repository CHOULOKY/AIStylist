import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../data/clothdata.dart';
import '../utility/utility.dart';
import 'authservice.dart';
import 'constants.dart';

class ClothService {
  final AuthService _auth = AuthService();  // ① AuthService 인스턴스

  // API 기본 URL
  static final Uri _clothBaseUrl = Uri.parse('${ApiConstants.baseUrl}/clothes');

  static final _categoryDisplay = {
    'TOP': '상의',
    'BOTTOM': '하의',
    'OUTER': '아우터',
    'SHOES': '신발',
  };

  static final _colorDisplay = {
    'WHITE': '흰색',
    'IVORY': '아이보리',
    'BEIGE': '베이지',
    'LIGHT_GRAY': '연회색',
    'GRAY': '진회색',
    'BLACK': '검정',
    'LIGHT_YELLOW': '연노랑',
    'YELLOW': '노랑',
    'ORANGE': '주황',
    'CORAL': '코랄',
    'RED': '빨강',
    'PINK': '분홍',
    'DARK_PINK': '진분홍',
    'MINT': '연두',
    'GREEN': '초록',
    'OLIVE': '올리브',
    'DARK_OLIVE': '다크올리브',
    'TEAL': '청록',
    'KHAKI': '카키',
    'CYAN': '시안',
    'SKY_BLUE': '하늘색',
    'BLUE': '파랑',
    'NAVY': '네이비',
    'LAVENDER': '라벤더',
    'PURPLE': '보라',
    'BURGUNDY': '버건디',
    'CAMEL': '카멜',
    'BROWN': '갈색',
    'DARK_BROWN': '다크브라운',
    'MAGENTA': '마젠타',
    'GOLD': '골드',
    'SILVER': '실버',
    'MULTI': '다채색',
  };

  static final _seasonDisplay = {
    'SPRING': '봄',
    'SUMMER': '여름',
    'FALL': '가을',
    'WINTER': '겨울',
    'ALL': '모두',
  };

  static final _styleDisplay = {
    'CASUAL': '캐주얼',
    'COZY': '코지',
    'BUSINESS_CASUAL': '비즈니스 캐주얼',
    'FORMAL': '포멀',
    'MODERN': '모던',
    'CLASSIC': '클래식',
    'MINIMAL': '미니멀',
    'BOHEMIAN': '보헤미안',
    'LUXURY': '럭셔리',
    'SPORTY': '스포티',
    'ATHLEISURE': '애슬레저',
    'AFFORDABLE': '저렴한',
    'TRENDY': '트렌디',
    'MID_RANGE': '중저가',
    'KID_CORE': '키드코어',
    'BASIC': '베이직',
    'ARTISTIC': '아티스틱',
    'DRESS_UP': '드레스업',
    'HIPSTER': '힙스터',
    'FEMININE': '페미닌',
    'CHIC': '시크',
    'STREET': '스트릿',
    'KITSCH': '키치',
    'PUNKY': '펑키',
    'OTHER': '기타',
  };



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
    File? imageFile,
    Uint8List? webImageData,
    required String category,
    required String color,
    //required String season,
    required List<String> seasons,
    required String style,
  }) async {
    final headers = await _auth.getMultipartHeaders();
    // print('헤더 확인: $headers');
    final request = http.MultipartRequest('POST', _clothBaseUrl)
      ..headers.addAll(headers);

    // 플랫폼 분기: 웹이면 Uint8List, 아니면 File
    if (kIsWeb && webImageData != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          webImageData,
          filename: 'upload.png',
          contentType: MediaType('image', 'png'), // 적절한 타입 설정
        ),
      );
    } else if (!kIsWeb && imageFile != null) {
      final mimeType = lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      final mimeParts = mimeType.split('/');
      request.files.add(
        http.MultipartFile(
          'image',
          imageFile.openRead(),
          await imageFile.length(),
          filename: basename(imageFile.path),
          contentType: MediaType(mimeParts[0], mimeParts[1]),
        ),
      );
    } else {
      throw Exception('이미지 파일이 제공되지 않았습니다.');
    }

    request.fields['category'] = _categoryDisplay[category] ?? category;
    request.fields['color']    = _colorDisplay[color] ?? color;
    //request.fields['season'] = season;
    for (final s in seasons) {
      final disp = _seasonDisplay[s] ?? s;
      request.files.add(
        // name="seasons" form-field, text/plain by default
        http.MultipartFile.fromString('seasons', disp),
      );
    }
    request.fields['style']    = _styleDisplay[style] ?? style;

    final streamedResponse = await request.send();
    final res = await http.Response.fromStream(streamedResponse);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      throw Exception('옷 등록 실패: ${res.statusCode} ${res.body}');
    }
  }


}
