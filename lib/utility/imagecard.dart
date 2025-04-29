// imagecard.dart
import 'package:flutter/material.dart';

import '../data/clothdata.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String image;
  final String category;
  final String color;
  final String season;
  final String style;

  const ProductCard({
    super.key,
    required this.id,
    required this.image,
    required this.category,
    required this.color,
    required this.season,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                image,
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(id.toString()),
      ],
    );
  }
}
