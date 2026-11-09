import 'package:flutter/material.dart';

class ProductDetailsRatingWidget extends StatelessWidget {
  final double rating;

  const ProductDetailsRatingWidget({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          if (rating >= starValue) {
            return const Icon(
              Icons.star_rounded,
              size: 20,
              color: Color(0xFFFBBF24),
            );
          } else if (rating >= starValue - 0.5) {
            return const Icon(
              Icons.star_half_rounded,
              size: 20,
              color: Color(0xFFFBBF24),
            );
          } else {
            return const Icon(
              Icons.star_rounded,
              size: 20,
              color: Color(0xFFE2E8F0),
            );
          }
        }),
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
