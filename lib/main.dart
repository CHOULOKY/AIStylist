import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_screen.dart';
import 'closet_screen.dart';
import 'recommendation_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'utility.dart';

void main() {
  runApp(const AIStylistApp());
}

class AIStylistApp extends StatelessWidget {
  const AIStylistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      //debugShowCheckedModeBanner: false,
      title: 'AIStylist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

// 📌 GoRouter 설정 (네비게이션)
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildSlidePage(const HomeScreen()),
    ),
    GoRoute(
      path: '/closet',
      pageBuilder: (context, state) => buildSlidePage(const ClosetScreen()),
    ),
    GoRoute(
      path: '/recommend',
      pageBuilder: (context, state) => buildSlidePage(const RecommendationScreen()),
    ),
    GoRoute(
      path: '/history',
      pageBuilder: (context, state) => buildSlidePage(const HistoryScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => buildSlidePage(const ProfileScreen()),
    ),
  ],
);
