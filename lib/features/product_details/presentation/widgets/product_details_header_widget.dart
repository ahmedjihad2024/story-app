import 'package:flutter/material.dart';

class ProductDetailsHeaderWidget extends StatelessWidget {
  final String brand;
  final String title;
  final String discountPercentage;

  const ProductDetailsHeaderWidget({
    super.key,
    required this.brand,
    required this.title,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        discountPercentage.isNotEmpty && discountPercentage != '0%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDiscount) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              discountPercentage,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF43F5E),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (brand.isNotEmpty) ...[
          Text(
            brand,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

