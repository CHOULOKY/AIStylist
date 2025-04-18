import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aistylist/data/shareddata.dart';

import 'appbar.dart';
import 'footer.dart';
import 'imagecard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> categories = ["All", "Apparel", "Dress", "Tshirt", "Bag"];

  final items = closetItems;
  void toggleLike(int index) {
    setState(() {
      items[index]['liked'] = !items[index]['liked'];
    });
  }

  /*
  int _selectedRouteIndex = 0;
  final List<String> _routes = ['/', '/closet', '/recommend', '/history', '/profile'];
  void _onItemTapped(int index) {
    setState(() {
      _selectedRouteIndex = index;
    });
    context.go(_routes[index]);
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainBanner(),
            const SizedBox(height: 50),
            _buildNewArrivalSection(),
            const SizedBox(height: 50),
            buildFollowUsSection(),
            buildFooter(),
          ],
        ),
      ),
    );
  }

  // 📌 메인 배너 영역
  Widget _buildMainBanner() {
    return Stack(
      children: [
        // 배경 이미지
        SizedBox(
          width: double.infinity,
          height: 600,
          child: Image.asset(
            'assets/images/testbanner.jpg', // 실제 이미지 경로로 변경
            fit: BoxFit.cover,
          ),
        ),

        // 텍스트 & 버튼
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "LUXURY FASHION\n& ACCESSORIES",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
                ),
                onPressed: () {
                  context.push('/recommend'); // 📌 버튼 클릭 시 /recommend로 이동
                },
                child: const Text("EXPLORE COLLECTION", style: TextStyle(
                    color: Colors.white, fontSize: 16, letterSpacing: 1.2)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 📌 NEW ARRIVAL 섹션
  Widget _buildNewArrivalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NEW ARRIVAL 타이틀 + 구분선
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "NEW ARRIVAL",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.normal, letterSpacing: 4),
              ),
            ],
          ),

          const SizedBox(height: 4), // 텍스트와 구분선 간격 조정

          // 📌 연한 구분선 추가
          Container(
            height: 1,
            color: Colors.grey.withValues(alpha: (0.3 * 255)),
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),

          const SizedBox(height: 20),

          // 📌 카테고리 필터
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(categories.length, (index) {
              bool isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 10),

          // 📌 반응형 그리드 레이아웃
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = (constraints.maxWidth / 180).floor();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4, // 예제용 4개 아이템
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // 📌 화면 크기에 따라 컬럼 개수 조정
                  childAspectRatio: 0.7, // 카드 비율 조정
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ProductCard(
                    image: item['image'],
                    brand: item['brand'],
                    title: item['title'],
                    price: item['price'],
                    liked: item['liked'],
                    onLikeToggle: () => toggleLike(index),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
