// 📌 프로필 및 회원 관리 화면
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("프로필 관리")),
      body: Center(child: Text("회원 정보 및 설정 화면")),
    );
  }
}