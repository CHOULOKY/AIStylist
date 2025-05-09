import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📌 상단 네비게이션 바
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.menu, color: Colors.white, size: 25),
      onPressed: () {}, // 메뉴 열기
    ),
    title: GestureDetector(
      onTap: () {
        context.push('/closet'); // 📌 홈으로 이동
      },
      child: const Text(
        "AI Stylist",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.account_circle, color: Colors.white, size: 25),
        onPressed: () {
          context.push('/profile'); // 📌 프로필 이동
        }, // 추천 이동
      ),
    ],
  );
}
