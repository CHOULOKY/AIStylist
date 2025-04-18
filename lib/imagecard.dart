// imagecard.dart
import 'package:flutter/material.dart';

import 'data/shareddata.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String brand;
  final String title;
  final bool liked;
  final VoidCallback onLikeToggle;

  const ProductCard({
    super.key,
    required this.image,
    required this.brand,
    required this.title,
    required this.liked,
    required this.onLikeToggle,
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
                child: IconButton(
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : Colors.black54,
                    size: 20,
                  ),
                  onPressed: onLikeToggle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          brand,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(title),
      ],
    );
  }
}
