// 📌 프로필 및 회원 관리 화면
import 'package:flutter/material.dart';

import '../utility/appbar.dart';
import '../utility/navigationbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
      bottomNavigationBar: buildNavigationBar(context, 2),
    );
  }
}
