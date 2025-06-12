// lib/service/app_lifecycle_service.dart

import 'package:flutter/widgets.dart';
import 'package:aistylist/service/tokenservice.dart';

/// 앱 라이프사이클을 감지해, 완전 종료(detached) 시 토큰을 삭제
class AppLifecycleService with WidgetsBindingObserver {
  AppLifecycleService._() {
    WidgetsBinding.instance.addObserver(this);
  }

  static final AppLifecycleService instance = AppLifecycleService._();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      TokenService.clearToken();
    }
  }

  /// 필요 시 옵저버 해제
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
