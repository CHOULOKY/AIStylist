import 'package:aistylist/screen/auth_screen.dart';
import 'package:aistylist/service/AppLifecycleService.dart';
import 'package:aistylist/service/tokenservice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screen/home_screen.dart';
import 'screen/closet_screen.dart';
import 'screen/aistylist_screen.dart';
import 'screen/calendar_screen.dart';
import 'screen/profile_screen.dart';
import 'utility/utility.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // 앱 라이프사이클 옵저버 등록 (토큰 삭제 기능 활성화)
  AppLifecycleService.instance;

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
    /* // for test
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildSlidePage(const HomeScreen()),
    ),
    */
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildSlidePage(const AuthScreen()),
    ),
    GoRoute(
      path: '/closet',
      pageBuilder: (context, state) => buildSlidePage(const ClosetScreen()),
    ),
    GoRoute(
      path: '/aistylist',
      pageBuilder: (context, state) => buildSlidePage(const AIStylistScreen()),
    ),
    GoRoute(
      path: '/calendar',
      pageBuilder: (context, state) => buildSlidePage(const CalendarScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => buildSlidePage(const ProfileScreen()),
    ),
  ],
);
