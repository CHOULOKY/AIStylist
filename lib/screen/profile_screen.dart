import 'package:aistylist/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/clothdata.dart';
import '../data/userdata.dart';
import '../service/tokenservice.dart';
import '../service/userservice.dart';
import '../utility/appbar.dart';
import '../utility/navigationbar.dart';



const _bodyTypeDisplay = {
  BodyType.SLIM: '마른',
  BodyType.ATHLETIC: '운동',
  BodyType.AVERAGE: '보통',
  BodyType.CHUBBY: '통통',
  BodyType.OVERWEIGHT: '비만',
};

final List<String> _colorOptions = [
  'BLACK','WHITE','BLUE','RED','GREEN','IVORY','BEIGE','LIGHT_GRAY',
  'GRAY','DARK_GRAY','BROWN','ORANGE','YELLOW','PINK','PURPLE',
  'GOLD','SILVER','MULTI','LIGHT_YELLOW','CORAL','DARK_PINK','MINT',
  'OLIVE','DARK_OLIVE','TEAL','KHAKI','CYAN','SKY_BLUE','NAVY',
  'LAVENDER','BURGUNDY','CAMEL','DARK_BROWN','MAGENTA'
];

final List<String> _styleOptions = [
  'CASUAL','FORMAL','COZY','BUSINESS_CASUAL','MODERN','CLASSIC','MINIMAL',
  'BOHEMIAN','LUXURY','SPORTY','ATHLEISURE','AFFORDABLE','TRENDY',
  'MID_RANGE','KID_CORE','BASIC','ARTISTIC','DRESS_UP','HIPSTER',
  'FEMININE','CHIC','STREET','KITSCH','PUNKY','OTHER'
];


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  String _userName = '';
  String _userEmail = '';
  Map<String, dynamic>? _userInfo;    // name, height, bodyType
  Map<String, dynamic>? _userPref;    // preferredStyle, preferredColor, avoidStyle

  @override
  void initState() {
    super.initState();
    _loadAllUserData();
  }

  Future<void> _loadAllUserData() async {
    try {
      final me     = await _userService.getMe();
      final info   = await _userService.getUserInfo();
      final pref   = await _userService.getPreference();
      // mounted 확인
      if (!mounted) return;
      setState(() {
        _userName  = me['name']  as String? ?? '';
        _userEmail = me['email'] as String? ?? '';
        _userInfo  = info;
        _userPref  = pref;
      });
    } catch (e) {
      // 로드 실패 시, 로그나 스낵바 처리
      showSnack(context, '유저 데이터 로드 실패: $e');
    }
  }

  Future<void> _showBodyAndPrefDialog() async {
    // 기존 값으로 초기화
    final heightCtl = TextEditingController(
      text: _userInfo?['height']?.toString() ?? '',
    );

    BodyType selectedBody = BodyType.values.firstWhere(
          (e) => e.name.toLowerCase() == (_userInfo?['bodyType'] as String? ?? '').toLowerCase(),
      orElse: () => BodyType.AVERAGE,
    );

    String prefColorDisplay = _userPref?['preferredColor'] as String? ?? '';
    String selectedColor = _colorOptions.firstWhere(
          (key) => ClothItem.mapColor(key) == prefColorDisplay,
      orElse: () => _colorOptions.first,
    );

    String prefStyleDisplay = _userPref?['preferredStyle'] as String? ?? '';
    String selectedStyle = _styleOptions.firstWhere(
          (key) => ClothItem.mapStyle(key) == prefStyleDisplay,
      orElse: () => _styleOptions.first,
    );

    String prefAvoidDisplay = _userPref?['avoidStyle'] as String? ?? '';
    String selectedAvoid = _styleOptions.firstWhere(
          (key) => ClothItem.mapStyle(key) == prefAvoidDisplay,
      orElse: () => _styleOptions.first,
    );


    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('체형·선호 설정'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // 키 입력
              TextField(
                controller: heightCtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '키 (cm)'),
              ),

              // 체형 선택
              DropdownButtonFormField<BodyType>(
                value: selectedBody,
                decoration: const InputDecoration(labelText: '체형'),
                items: BodyType.values.map((bt) {
                  return DropdownMenuItem(
                    value: bt,
                    child: Text(_bodyTypeDisplay[bt]!),
                  );
                }).toList(),
                onChanged: (bt) {
                  if (bt != null) selectedBody = bt;
                },
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // 선호 색상
              DropdownButtonFormField<String>(
                value: selectedColor,
                decoration: const InputDecoration(labelText: '선호 색상'),
                items: _colorOptions.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(ClothItem.mapColor(c)),
                )).toList(),
                onChanged: (c) {
                  if (c != null) selectedColor = c;
                },
              ),
              const SizedBox(height: 12),

              // 선호 스타일
              DropdownButtonFormField<String>(
                value: selectedStyle,
                decoration: const InputDecoration(labelText: '선호 스타일'),
                items: _styleOptions.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(ClothItem.mapStyle(s)),
                )).toList(),
                onChanged: (s) {
                  if (s != null) selectedStyle = s;
                },
              ),
              const SizedBox(height: 12),

              // 기피 스타일
              DropdownButtonFormField<String>(
                value: selectedAvoid,
                decoration: const InputDecoration(labelText: '기피 스타일'),
                items: _styleOptions.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(ClothItem.mapStyle(s)),
                )).toList(),
                onChanged: (s) {
                  if (s != null) selectedAvoid = s;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
          ElevatedButton(
            onPressed: () async {
              final newHeight = int.tryParse(heightCtl.text) ?? 0;
              if (newHeight <= 0) {
                showSnack(context, '유효한 키를 입력하세요.');
                return;
              }
              Navigator.pop(ctx);
              try {
                // 1) 사용자 정보 저장
                await _userService.saveUserInfo(
                  name: _userName,       // 이름은 변경 없으므로 그대로
                  height: newHeight,
                  bodyType: selectedBody.name,
                );
                // 2) 사용자 선호 저장
                await _userService.savePreference(
                  preferredStyle: selectedStyle,
                  preferredColor: selectedColor,
                  avoidStyle: selectedAvoid,
                );
                // 3) 갱신
                await _loadAllUserData();
                showSnack(context, '설정이 저장되었습니다.');
              } catch (e) {
                showSnack(context, '저장 실패: $e');
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
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
                onTap: _showBodyAndPrefDialog,
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
