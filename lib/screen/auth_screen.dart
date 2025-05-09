import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../service/authservice.dart';
import '../service/clothservice.dart';
import '../service/userservice.dart';
import '../utility/utility.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final DbService _dbService = DbService();


  bool _isSignIn = true;

  // Obscure toggles
  bool _obscureSignInPassword = true;
  bool _obscureSignUpPassword = true;
  bool _obscureSignUpConfirmPassword = true;

  // Sign In controllers
  final TextEditingController _signInEmailCtrl = TextEditingController();
  final TextEditingController _signInPwdCtrl = TextEditingController();

  // Sign Up controllers
  final TextEditingController _signUpNameCtrl = TextEditingController();
  final TextEditingController _signUpEmailCtrl = TextEditingController();
  final TextEditingController _signUpPwdCtrl = TextEditingController();
  final TextEditingController _signUpConfirmPwdCtrl = TextEditingController();

  @override
  void dispose() {
    _signInEmailCtrl.dispose();
    _signInPwdCtrl.dispose();
    _signUpNameCtrl.dispose();
    _signUpEmailCtrl.dispose();
    _signUpPwdCtrl.dispose();
    _signUpConfirmPwdCtrl.dispose();
    super.dispose();
  }

  void _toggleMode(bool signInSelected) {
    setState(() {
      _isSignIn = signInSelected;
      // Clear all inputs when toggling
      _signInEmailCtrl.clear();
      _signInPwdCtrl.clear();
      _signUpNameCtrl.clear();
      _signUpEmailCtrl.clear();
      _signUpPwdCtrl.clear();
      _signUpConfirmPwdCtrl.clear();
      // Reset obscures
      _obscureSignInPassword = true;
      _obscureSignUpPassword = true;
      _obscureSignUpConfirmPassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(30.0);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              // Title
              Text(
                'Closet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Toggle
              Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _toggleMode(true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isSignIn ? Colors.grey[300] : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('Sign In', style: TextStyle(
                              color: _isSignIn ? Colors.black : Colors.black.withOpacity(0.4),
                              fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _toggleMode(false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_isSignIn ? Colors.grey[300] : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('Sign Up', style: TextStyle(
                              color: !_isSignIn ? Colors.black : Colors.black.withOpacity(0.4),
                              fontSize: 16, fontWeight: FontWeight.w600)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Form fields
              if (_isSignIn) ..._buildSignIn(),
              if (!_isSignIn) ..._buildSignUp(),
              const SizedBox(height: 34),
              // Action Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {_isSignIn ? _onSignIn() : _onSignUp();},
                child: Text(_isSignIn ? 'Sign In' : 'Sign Up', style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              if (_isSignIn)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
                ),
              const SizedBox(height: 12),
              const Divider(height: 10),
              const SizedBox(height: 32),
              // Continue with Google
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.google, size: 25, color: Colors.black),
                  const SizedBox(width: 8),
                  const Text('Continue with Google', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSignIn() {
    return [
      const Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: _signInEmailCtrl,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Enter Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: _signInPwdCtrl,
        obscureText: _obscureSignInPassword,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(_obscureSignInPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureSignInPassword = !_obscureSignInPassword),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildSignUp() {
    return [
      const Text('Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: _signUpNameCtrl,
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'Enter Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      const SizedBox(height: 16),
      const Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: _signUpEmailCtrl,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Enter Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: _signUpPwdCtrl,
        obscureText: _obscureSignUpPassword,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(_obscureSignUpPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureSignUpPassword = !_obscureSignUpPassword),
          ),
        ),
      ),
      const SizedBox(height: 16),
      const Text('Confirm Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: _signUpConfirmPwdCtrl,
        obscureText: _obscureSignUpConfirmPassword,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Re-enter Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(_obscureSignUpConfirmPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureSignUpConfirmPassword = !_obscureSignUpConfirmPassword),
          ),
        ),
      ),
    ];
  }

  Future<void> _onSignUp() async {
    final name = _signUpNameCtrl.text.trim();
    final email = _signUpEmailCtrl.text.trim();
    final pwd = _signUpPwdCtrl.text;
    final confirmPwd = _signUpConfirmPwdCtrl.text;
    if (name.isEmpty || email.isEmpty || pwd.isEmpty || confirmPwd.isEmpty) {
      showSnack(context, '모든 필드를 입력해주세요');
      return;
    } else if(pwd != confirmPwd) {
      showSnack(context, '비밀번호가 일치하지 않습니다.');
      return;
    }
    try {
      await _authService.register(email: email, password: pwd, name: name);
      if (!mounted) return;
      showSnack(context, '회원가입 성공');
      context.push('/');
    } catch (e) {
      showSnack(context, '회원가입 실패: $e');
    }
  }

  Future<void> _onSignIn() async {
    final email = _signInEmailCtrl.text.trim();
    final pwd = _signInPwdCtrl.text;
    if (email.isEmpty || pwd.isEmpty) {
      showSnack(context, '이메일과 비밀번호를 입력해주세요');
      return;
    }
    try {
      await _authService.login(email: email, password: pwd);
      if (!mounted) return;
      showSnack(context, '로그인 성공');
      context.push('/closet');
    } catch (e) {
      showSnack(context, '로그인 실패: $e');
    }
  }
}
