// 📌 데일리 룩 추천 화면
import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("데일리 룩 추천")),
      body: Center(child: Text("GPT API를 활용한 코디 추천")),
    );
  }
}