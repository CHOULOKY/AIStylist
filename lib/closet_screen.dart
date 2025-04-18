import 'package:aistylist/data/shareddata.dart';
import 'package:flutter/material.dart';

import 'appbar.dart';
import 'footer.dart';
import 'imagecard.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  final items = closetItems;
  void toggleLike(int index) {
    setState(() {
      items[index]['liked'] = !items[index]['liked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _buildGridSection(),
    );
  }

  Widget _buildGridSection() {
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
                    childCount: items.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: buildFooter(),
                ), // 스크롤 맨 아래 footer
              ),
            ],
          );
        }
    );
  }

  Widget _buildProductCard(int index) {
    final item = items[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    item['liked'] ? Icons.favorite : Icons.favorite_border,
                    color: item['liked'] ? Colors.red : Colors.black54,
                    size: 20,
                  ),
                  onPressed: () => toggleLike(index),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),
        Text(
          item['brand'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(item['title']),
        Text(
          item['price'],
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
