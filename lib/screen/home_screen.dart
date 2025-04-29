import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../service/authservice.dart';
import '../utility/appbar.dart';
import '../utility/navigationbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  // 회원가입용 컨트롤러
  final TextEditingController _regNameCtrl = TextEditingController();
  final TextEditingController _regEmailCtrl = TextEditingController();
  final TextEditingController _regPwdCtrl = TextEditingController();

  // 로그인용 컨트롤러
  final TextEditingController _loginEmailCtrl = TextEditingController();
  final TextEditingController _loginPwdCtrl = TextEditingController();

  @override
  void dispose() {
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPwdCtrl.dispose();
    _loginEmailCtrl.dispose();
    _loginPwdCtrl.dispose();
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
              const Text('회원가입', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _regNameCtrl,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _regEmailCtrl,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _regPwdCtrl,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _onRegister,
                child: const Text('회원가입'),
              ),
              const Divider(height: 40),
              const Text('로그인', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _loginEmailCtrl,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _loginPwdCtrl,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _onLogin,
                child: const Text('로그인'),
              ),
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
      _showSnack('회원가입 실패: \$e');
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
}
