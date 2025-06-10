import 'package:aistylist/data/clothdata.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../service/clothservice.dart';
import '../utility/appbar.dart';
import '../utility/imagecard.dart';
import '../utility/navigationbar.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  final service = ClothService();
  List<ClothItem> items = [];
  //final items = testClosetItems;

  @override
  void initState() {
    super.initState();
    service.fetchItems().then((list) {
      setState(() => items = list);
      print('서버 응답 데이터: $items');
    });
  }

  String selectedCategory = '상의'; // 초기 카테고리
  final categories = ['상의', '하의', '아우터', '신발'];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer( // Drawer 위젯으로 만들기
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Text('메뉴', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                title: const Text('홈'),
                onTap: () => context.push('/closet'),
              ),
              ListTile(
                title: const Text('프로필'),
                onTap: () => context.push('/profile'),
              ),
            ],
          ),
        ),
      ),
      appBar: buildAppBar(context),
      body: Column(
        children: [
          _buildCategorySelector(),
          Expanded(child: _buildGridSection()),
        ],
      ),
      bottomNavigationBar: buildNavigationBar(context, 0),
    );
  }


  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.black : Colors.grey[300],
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: Text(category),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildGridSection() {
    final filteredItems = items.where((item) => item.category == selectedCategory).toList();

    return LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = (constraints.maxWidth / 180).floor(); //.clamp(1, 4);
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = filteredItems[index];
                          // final originalIndex = items.indexOf(item);
                          return ProductCard(
                            id: item.id,
                            image: item.image,
                            category: item.category,
                            color: item.color,
                            seasons: item.seasons,
                            style: item.style,
                          );
                        },
                    childCount: filteredItems.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
              /*
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: buildFooter(),
                ), // 스크롤 맨 아래 footer
              ),

               */
            ],
          );
        }
    );
  }

}
