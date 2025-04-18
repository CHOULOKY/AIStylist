import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'appbar.dart';
import 'navigationbar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
              child: TableCalendar(
                daysOfWeekHeight: 20,
                rowHeight: 60,
                locale: 'ko_KR',
                firstDay: DateTime(2000),
                lastDay: DateTime(2030),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMMM(locale).format(date), // 2025년 4월
                  leftChevronIcon: Icon(Icons.chevron_left),
                  rightChevronIcon: Icon(Icons.chevron_right),
                  //leftChevronVisible: false,
                  //rightChevronVisible: false,
                ),
                calendarFormat: CalendarFormat.month,
              ),
            ),
            /*
            const SizedBox(height: 20),
            if (_selectedDay != null)
              Text(
                '선택한 날짜: ${DateFormat('yyyy년 MM월 dd일').format(_selectedDay!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

             */
          ],
        ),
      ),
      bottomNavigationBar: buildNavigationBar(context, 3),
    );
  }
}
