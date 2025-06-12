import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../service/authservice.dart';
import '../service/clothservice.dart';
import '../service/userservice.dart';
import '../utility/appbar.dart';
import '../utility/navigationbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ClothService _clothService = ClothService();

  // 회원가입용 컨트롤러
  final TextEditingController _regNameCtrl = TextEditingController();
  final TextEditingController _regEmailCtrl = TextEditingController();
  final TextEditingController _regPwdCtrl = TextEditingController();

  // 로그인용 컨트롤러
  final TextEditingController _loginEmailCtrl = TextEditingController();
  final TextEditingController _loginPwdCtrl = TextEditingController();

  // 사용자 정보 입력용 컨트롤러
  final TextEditingController _infoNameCtrl = TextEditingController();
  final TextEditingController _infoHeightCtrl = TextEditingController();
  final TextEditingController _infoBodyTypeCtrl = TextEditingController();

  // 선호 정보 입력용 컨트롤러
  final TextEditingController _prefStyleCtrl = TextEditingController();
  final TextEditingController _prefColorCtrl = TextEditingController();
  final TextEditingController _prefAvoidCtrl = TextEditingController();

  void dispose() {
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPwdCtrl.dispose();
    _loginEmailCtrl.dispose();
    _loginPwdCtrl.dispose();
    _infoNameCtrl.dispose();
    _infoHeightCtrl.dispose();
    _infoBodyTypeCtrl.dispose();
    _prefStyleCtrl.dispose();
    _prefColorCtrl.dispose();
    _prefAvoidCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 회원가입 섹션
              const Text('회원가입', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: _regNameCtrl, decoration: const InputDecoration(labelText: '이름')),
              const SizedBox(height: 8),
              TextField(controller: _regEmailCtrl, decoration: const InputDecoration(labelText: '이메일'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 8),
              TextField(controller: _regPwdCtrl, decoration: const InputDecoration(labelText: '비밀번호'), obscureText: true),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _onRegister, child: const Text('회원가입')),
              const Divider(height: 40),

              // 로그인 섹션
              const Text('로그인', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: _loginEmailCtrl, decoration: const InputDecoration(labelText: '이메일'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 8),
              TextField(controller: _loginPwdCtrl, decoration: const InputDecoration(labelText: '비밀번호'), obscureText: true),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _onLogin, child: const Text('로그인')),
              const Divider(height: 40),

              // API 테스트 섹션
              const Text('API 테스트', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // GET /users/me
              ElevatedButton(onPressed: _onGetMe, child: const Text('GET /users/me')),
              const SizedBox(height: 12),

              // POST /users/info 입력 폼
              const Text('POST /users/info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: _infoNameCtrl, decoration: const InputDecoration(labelText: '이름')),
              const SizedBox(height: 8),
              TextField(controller: _infoHeightCtrl, decoration: const InputDecoration(labelText: '키'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: _infoBodyTypeCtrl, decoration: const InputDecoration(labelText: '체형')),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _onPostInfo, child: const Text('전송')),
              const SizedBox(height: 16),

              // GET /users/info
              ElevatedButton(onPressed: _onGetInfo, child: const Text('GET /users/info')),
              const SizedBox(height: 16),

              // POST /users/preferences 입력 폼
              const Text('POST /users/preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: _prefStyleCtrl, decoration: const InputDecoration(labelText: '선호 스타일')),
              const SizedBox(height: 8),
              TextField(controller: _prefColorCtrl, decoration: const InputDecoration(labelText: '선호 색상')),
              const SizedBox(height: 8),
              TextField(controller: _prefAvoidCtrl, decoration: const InputDecoration(labelText: '비선호 스타일')),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _onPostPref, child: const Text('전송')),
              const SizedBox(height: 16),

              // GET /users/preferences
              ElevatedButton(onPressed: _onGetPref, child: const Text('GET /users/preferences')),
              const SizedBox(height: 16),

              // GET /clothes
              ElevatedButton(onPressed: _onGetClothes, child: const Text('GET /clothes')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildNavigationBar(context, 2),
    );
  }

  Future<void> _onRegister() async {
    final name = _regNameCtrl.text.trim();
    final email = _regEmailCtrl.text.trim();
    final pwd = _regPwdCtrl.text;
    if (name.isEmpty || email.isEmpty || pwd.isEmpty) {
      _showSnack('모든 필드를 입력해주세요');
      return;
    }
    try {
      await _authService.register(email: email, password: pwd, name: name);
      _showSnack('회원가입 성공');
    } catch (e) {
      _showSnack('회원가입 실패: $e');
    }
  }

  Future<void> _onLogin() async {
    final email = _loginEmailCtrl.text.trim();
    final pwd = _loginPwdCtrl.text;
    if (email.isEmpty || pwd.isEmpty) {
      _showSnack('이메일과 비밀번호를 입력해주세요');
      return;
    }
    try {
      await _authService.login(email: email, password: pwd);
      _showSnack('로그인 성공');
      // 예: 로그인 후 홈 이외 다른 화면으로 이동
      // context.go('/closet');
    } catch (e) {
      _showSnack('로그인 실패: \$e');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _onGetMe() async {
    try {
      final data = await _userService.getMe();
      _showDialog('GET /users/me', data.toString());
    } catch (e) {
      _showSnack('오류: $e');
    }
  }

  // POST /users/info
  Future<void> _onPostInfo() async {
    final name = _infoNameCtrl.text.trim();
    final height = int.tryParse(_infoHeightCtrl.text.trim());
    final bodyType = _infoBodyTypeCtrl.text.trim();
    if (name.isEmpty || height == null || bodyType.isEmpty) {
      _showSnack('정보를 모두 입력해주세요');
      return;
    }
    try {
      await _userService.saveUserInfo(name: name, height: height, bodyType: bodyType);
      _showSnack('POST /users/info 성공');
    } catch (e) {
      _showSnack('오류: \$e');
    }
  }

  Future<void> _onGetInfo() async {
    try {
      final data = await _userService.getUserInfo();
      _showDialog('GET /users/info', data.toString());
    } catch (e) {
      _showSnack('오류: $e');
    }
  }

  // POST /users/preferences
  Future<void> _onPostPref() async {
    final style = _prefStyleCtrl.text.trim();
    final color = _prefColorCtrl.text.trim();
    final avoid = _prefAvoidCtrl.text.trim();
    if (style.isEmpty || color.isEmpty || avoid.isEmpty) {
      _showSnack('선호 정보를 모두 입력해주세요');
      return;
    }
    try {
      await _userService.savePreference(preferredStyle: style, preferredColor: color, avoidStyle: avoid);
      _showSnack('POST /users/preferences 성공');
    } catch (e) {
      _showSnack('오류: \$e');
    }
  }

  Future<void> _onGetPref() async {
    try {
      final data = await _userService.getPreference();
      _showDialog('GET /users/preferences', data.toString());
    } catch (e) {
      _showSnack('오류: $e');
    }
  }

  Future<void> _onGetClothes() async {
    try {
      final items = await _clothService.fetchItems();
      _showDialog('GET /clothes', '총 ${items.length}개 아이템');
    } catch (e) {
      _showSnack('오류: $e');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
}
