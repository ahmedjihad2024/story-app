import 'package:flutter/material.dart';

class ProductDetailsDescriptionWidget extends StatelessWidget {
  final String? description;

  const ProductDetailsDescriptionWidget({
    super.key,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description!,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF64748B),
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
