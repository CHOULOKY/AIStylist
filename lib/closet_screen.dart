import 'package:aistylist/data/shareddata.dart';
import 'package:flutter/material.dart';

import 'appbar.dart';
import 'imagecard.dart';
import 'navigationbar.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  final items = closetItems;
  String selectedCategory = '입을 옷'; // 초기 카테고리
  final categories = ['입을 옷', '안 입을 옷', '세탁 중'];

  void toggleLike(int index) {
    setState(() {
      items[index]['liked'] = !items[index]['liked'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
    final filteredItems = items.where((item) => item['category'] == selectedCategory).toList();

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
                          final originalIndex = items.indexOf(item);
                          return ProductCard(
                            image: item['image'],
                            brand: item['brand'],
                            title: item['title'],
                            liked: item['liked'],
                            onLikeToggle: () => toggleLike(originalIndex),
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
