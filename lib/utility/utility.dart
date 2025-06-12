import 'dart:convert';
import 'package:http/http.dart' show Response;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

// 슬라이드 애니메이션 함수
CustomTransitionPage buildSlidePage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // 오른쪽 → 왼쪽 슬라이드
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

// url 링크 함수
Widget buildLinkedWidget(Widget widget, String url) {
  return GestureDetector(
    onTap: () => _launchExternalUrl(url),
    child: widget,
  );
}
Future<void> _launchExternalUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint("Could not launch $url");
  }
}

// 구분선 함수
Widget buildDivider() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _dividerLine(),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Icon(Icons.diamond, size: 8, color: Colors.grey),
      ),
      _dividerLine(),
    ],
  );
}
Widget _dividerLine() =>
    Container(width: 100, height: 1, color: Colors.grey.withValues(alpha: (0.3 * 255)));

/// HTTP 응답을 UTF-8로 디코딩하고 JSON으로 변환하는 도우미 클래스
class ResponseDecoder {
  /// Response의 바이트를 UTF-8로 디코딩한 뒤 JSON object(Map)로 반환
  static Map<String, dynamic> decodeJson(Response response) {
    final jsonString = utf8.decode(response.bodyBytes);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Response의 바이트를 UTF-8로 디코딩한 뒤 JSON 배열(List)로 반환
  static List<dynamic> decodeListJson(Response response) {
    final jsonString = utf8.decode(response.bodyBytes);
    return jsonDecode(jsonString) as List<dynamic>;
  }
}

void showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}
