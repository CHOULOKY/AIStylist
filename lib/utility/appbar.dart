import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📌 상단 네비게이션 바
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    leading: Builder(
      builder: (innerContext) {
        return IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 25),
          onPressed: () {
            // Builder가 제공하는 innerContext는 Scaffold의 하위이므로
            // 이 컨텍스트를 사용해야 openDrawer()가 동작
            Scaffold.of(innerContext).openDrawer();
          },
        );
      },
    ),
    title: GestureDetector(
      onTap: () => context.push('/closet'),
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
    /*
    actions: [
      IconButton(
        icon: const Icon(Icons.account_circle, color: Colors.white, size: 25),
        onPressed: () => context.push('/profile'),
      ),
    ],
    */
  );
}
