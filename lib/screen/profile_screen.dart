import 'package:aistylist/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../service/tokenservice.dart';
import '../service/userservice.dart';
import '../utility/appbar.dart';
import '../utility/navigationbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final data = await _userService.getMe();
      // mounted 확인
      if (!mounted) return;
      setState(() {
        _userName = data['name'] as String? ?? 'null';
        _userEmail = data['email'] as String? ?? 'null';
      });
    } catch (e) {
      // 로드 실패 시, 로그나 스낵바 처리
      showSnack(context, 'getMe 실패: $e');
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 사용자 정보 카드 ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.black54,
                      // backgroundImage: NetworkImage('https://...'), // 실제 프로필 이미지가 있다면
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _userEmail,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        // 프로필 수정 로직
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- Your Orders / Wishlist ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _IconLabelButton(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Your Orders',
                    onTap: () {
                      // 주문 내역
                    },
                  ),
                  _IconLabelButton(
                    icon: Icons.favorite_border,
                    label: 'Wishlist',
                    onTap: () {
                      // 위시리스트
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- 사용자 설정 섹션 ---
              const Text(
                '사용자 설정',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildListTile(
                icon: Icons.location_on_outlined,
                text: '위치 설정',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.monitor_weight_outlined,
                text: '체형 정보 설정',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.notifications_outlined,
                text: '알림',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.language,
                text: '언어',
                trailing: const Text('한글', style: TextStyle(color: Colors.black54)),
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // --- 고객지원 섹션 ---
              const Text(
                '고객지원',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildListTile(
                icon: Icons.campaign_outlined,
                text: '공지사항',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.headset_mic_outlined,
                text: '고객센터',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.help_outline,
                text: '자주 묻는 질문',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.logout,
                text: '로그아웃',
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('정말 로그아웃하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('로그아웃'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await TokenService.clearToken();
                    if (mounted) {
                      context.push('/'); // 로그인 화면으로 이동 (스택 제거)
                      showSnack(context, '로그아웃 되었습니다.');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildNavigationBar(context, 4), // 마이페이지 인덱스
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String text,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black54),
          title: Text(text),
          trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.black54),
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconLabelButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
