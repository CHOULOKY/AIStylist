import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📌 상단 네비게이션 바
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: const Color(0xFFF5F5F5),
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.menu, color: Colors.grey, size: 25),
      onPressed: () {}, // 메뉴 열기
    ),
    title: GestureDetector(
      onTap: () {
        context.push('/'); // 📌 홈으로 이동
      },
      child: const Text(
        "Open Fashion",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.grey, size: 25),
        onPressed: () {
          context.push('/recommend');
        }, // 추천 이동
      ),
      IconButton(
        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 25),
        onPressed: () {
          context.push('/closet');
        }, // 옷장 이동
      ),
    ],
  );
}
