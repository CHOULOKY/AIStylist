import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📌 하단 네비게이션 바 항목 모델
class BottomNavItem {
  final IconData iconData;
  final IconData activeIconData;
  final String label;

  BottomNavItem({
    required this.iconData,
    required this.activeIconData,
    required this.label,
  });
}

// 📌 바텀 네비게이션 항목 정의
final List<BottomNavItem> bottomNavItems = [
  BottomNavItem(
    iconData: Icons.checkroom_outlined,
    activeIconData: Icons.checkroom,
    label: '옷장',
  ),
  BottomNavItem(
    iconData: Icons.tag_faces_outlined,
    activeIconData: Icons.tag_faces,
    label: 'AI',
  ),
  BottomNavItem(
    iconData: Icons.add_circle_outline,
    activeIconData: Icons.add_circle,
    label: '', // 중앙 + 버튼은 라벨 없음
  ),
  BottomNavItem(
    iconData: Icons.calendar_month_outlined,
    activeIconData: Icons.calendar_month,
    label: '캘린더',
  ),
  BottomNavItem(
    iconData: Icons.person_outline,
    activeIconData: Icons.person,
    label: '마이페이지',
  ),
];

// 📌 하단 네비게이션 바 위젯 함수
BottomNavigationBar buildNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    currentIndex: currentIndex,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black54,
    //showSelectedLabels: false,
    //showUnselectedLabels: false,
    enableFeedback: false,
    iconSize: 35.0,
    onTap: (index) {
      switch (index) {
        case 0:
          context.push('/closet');
          break;
        case 1:
          context.push('/aistylist');
          break;
        case 2:
          context.push('/closet'); // 중앙 + 버튼
          break;
        case 3:
          context.push('/calendar');
          break;
        case 4:
          context.push('/profile');
          break;
      }
    },
    items: bottomNavItems.asMap().entries.map((entry) {
      int index = entry.key;
      BottomNavItem item = entry.value;

      // 중앙 버튼이면 특별히 크게 그리고 항상 진하게
      if (index == 2) {
        return BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 52, color: Colors.black),
          activeIcon: Icon(Icons.add_circle, size: 52, color: Colors.black),
          label: '',
        );
      }

      return BottomNavigationBarItem(
        icon: Icon(item.iconData),
        activeIcon: Icon(item.activeIconData),
        label: item.label,
      );
    }).toList(),
  );
}
