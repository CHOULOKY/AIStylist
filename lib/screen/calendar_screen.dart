import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utility/appbar.dart';
import '../utility/navigationbar.dart';
import '../service/calendarservice.dart';
import '../service/authservice.dart';
import '../data/calendardata.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarService _calendarService = CalendarService();
  final AuthService _authService = AuthService();

  Map<DateTime, CalendarEntryDto> _recommendations = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecommendationsForMonth(_focusedDay);
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  Future<void> _loadRecommendationsForMonth(DateTime month) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final headers = await _authService.getJsonHeaders();
      if (headers == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final startDate = DateTime.utc(month.year, month.month, 1);
      final endDate = DateTime.utc(month.year, month.month + 1, 0);

      final fetchedEntries = await _calendarService.getEntriesByMonth(
        headers: headers,
        startDate: startDate,
        endDate: endDate,
      );

      _recommendations.clear();
      for (var entry in fetchedEntries) {
        final date = _normalizeDate(DateTime.parse(entry.date));
        _recommendations[date] = entry;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('캘린더 데이터 로드 실패: $e')),
      );
      debugPrint('Error loading calendar data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget? _buildEventMarker(BuildContext context, DateTime date, List<dynamic> events) {
    final normalizedDate = _normalizeDate(date);
    final CalendarEntryDto? entryDto = _recommendations[normalizedDate];

    if (entryDto != null) {
      Map<String, dynamic>? recommendationData;
      try {
        recommendationData = jsonDecode(entryDto.recommendation) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Error parsing recommendation JSON for date ${entryDto.date} in marker: $e');
        return null;
      }

      List<String> imageUrls = [];

      if (recommendationData['top'] != null && recommendationData['top']['imageUrl'] != null) {
        imageUrls.add(recommendationData['top']['imageUrl']);
      }
      if (recommendationData['bottom'] != null && recommendationData['bottom']['imageUrl'] != null) {
        imageUrls.add(recommendationData['bottom']['imageUrl']);
      }
      if (recommendationData['outer'] != null && recommendationData['outer']['imageUrl'] != null) {
        imageUrls.add(recommendationData['outer']['imageUrl']);
      }
      if (recommendationData['shoes'] != null && recommendationData['shoes']['imageUrl'] != null) {
        imageUrls.add(recommendationData['shoes']['imageUrl']);
      }

      if (imageUrls.isNotEmpty) {
        return Positioned(
          right: 1,
          bottom: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: imageUrls.take(3).map((url) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 1.0),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 1),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 14),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    }
    return null;
  }

  void _showRecommendationDialog(CalendarEntryDto entryDto) {
    final int entryId = entryDto.id;

    Map<String, dynamic> recommendation;
    try {
      recommendation = jsonDecode(entryDto.recommendation) as Map<String, dynamic>;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('추천 JSON 파싱 오류: $e')),
      );
      return;
    }

    Future<void> _deleteRecommendation() async {
      Navigator.of(context).pop();

      setState(() {
        _isLoading = true;
      });

      try {
        final headers = await _authService.getJsonHeaders();
        if (headers == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인이 필요합니다. (삭제 불가)')),
          );
          setState(() => _isLoading = false);
          return;
        }

        final res = await http.delete(
          Uri.parse('http://localhost:8080/calendar/recommendations/$entryId'),
          headers: headers,
        );

        if (res.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('추천 항목이 성공적으로 삭제되었습니다.')),
          );
          _loadRecommendationsForMonth(_focusedDay);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 실패: ${res.statusCode} - ${res.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 중 오류 발생: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    final reason = recommendation['reason'] ?? '추천 이유가 없습니다.';
    final top = recommendation['top'];
    final bottom = recommendation['bottom'];
    final outer = recommendation['outer'];
    final shoes = recommendation['shoes'];

    Widget _buildDialogClothItem(Map? item, String label) {
      if (item == null || item['imageUrl'] == null || item['imageUrl'].isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        children: [
          CachedNetworkImage(
            imageUrl: item['imageUrl'],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox(
              width: 100, height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => const SizedBox(
              width: 100, height: 100,
              child: Center(child: Icon(Icons.broken_image, size: 50)),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          titlePadding: const EdgeInsets.all(0),
          title: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘의 AI 추천 코디',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  reason,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildDialogClothItem(top, '상의'),
                    _buildDialogClothItem(bottom, '하의'),
                    _buildDialogClothItem(outer, '아우터'),
                    _buildDialogClothItem(shoes, '신발'),
                  ].where((widget) => widget != const SizedBox.shrink()).toList(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _deleteRecommendation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('삭제하기', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TableCalendar(
                daysOfWeekHeight: 20,
                rowHeight: 60,
                locale: 'ko_KR',
                firstDay: DateTime(2000, 1, 1),
                lastDay: DateTime(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  final normalizedSelectedDay = _normalizeDate(selectedDay);
                  final CalendarEntryDto? selectedDayEntry = _recommendations[normalizedSelectedDay];
                  if (selectedDayEntry != null) {
                    _showRecommendationDialog(selectedDayEntry);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${DateFormat('yyyy년 MM월 dd일').format(selectedDay)}에는 저장된 추천이 없습니다.')),
                    );
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  _loadRecommendationsForMonth(focusedDay);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMMM(locale).format(date),
                  leftChevronIcon: const Icon(Icons.chevron_left),
                  rightChevronIcon: const Icon(Icons.chevron_right),
                ),
                calendarFormat: CalendarFormat.month,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    return _buildEventMarker(context, date, events);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildNavigationBar(context, 3),
    );
  }
}
