import 'package:flutter/material.dart';

class ProductDetailsPriceWidget extends StatelessWidget {
  final double price;
  final double originalPrice;
  final String discountPercentage;

  const ProductDetailsPriceWidget({
    super.key,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        discountPercentage.isNotEmpty &&
        discountPercentage != '0%' &&
        originalPrice > price;
    final savings = originalPrice - price;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 6,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF020617),
          ),
        ),
        if (hasDiscount) ...[
          Text(
            '\$${originalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
              color: Color(0xFF94A3B8),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Save \$${savings.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF059669),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

