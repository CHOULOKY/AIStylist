// imagecard.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/clothdata.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String image;
  final String category;
  final String color;
  final List<String> seasons;
  final String style;

  const ProductCard({
    super.key,
    required this.id,
    required this.image,
    required this.category,
    required this.color,
    required this.seasons,
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
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (_, __) => Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => Center(child: Icon(Icons.broken_image)),
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
