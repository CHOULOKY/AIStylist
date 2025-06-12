import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 추가
import '../service/authservice.dart'; // AuthService 임포트
import '../data/calendardata.dart'; // 새로 만든 CalendarEntryDto 임포트

class CalendarService {
  final AuthService _auth = AuthService();

  static final Uri _calendarBaseUrl = Uri.parse('http://localhost:8080/calendar/recommendations');

  // 특정 월의 추천 데이터를 가져오는 메서드 (헤더 포함)
  Future<List<CalendarEntryDto>> getEntriesByMonth({required Map<String, String> headers, required DateTime startDate, required DateTime endDate}) async {
    final String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    final Uri uri = Uri.parse('$_calendarBaseUrl?startDate=$formattedStartDate&endDate=$formattedEndDate');
    
    final res = await http.get(uri, headers: headers);

    if (res.statusCode == 200) {
      final List<dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      return body.map((e) => CalendarEntryDto.fromJson(e)).toList();
    }
    throw Exception('Failed to load calendar entries (${res.statusCode}): ${res.body}');
  }

  // TODO: 필요하다면, 다른 캘린더 관련 서비스 메서드 (예: 저장, 업데이트 등)도 여기에 추가해주세요.
  // 이 메서드들은 인증 헤더를 받아 사용해야 합니다.
}
