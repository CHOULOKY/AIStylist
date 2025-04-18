// 📌 착장 히스토리 화면
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("착장 히스토리")),
      body: Center(child: Text("추천된 착장을 캘린더 형식으로 저장")),
    );
  }
}