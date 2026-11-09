import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theme/color_manager.dart';

class ProductsGridShimmer extends StatelessWidget {
  const ProductsGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE9EDEE),
        highlightColor: Color(0xFFF7F9FA),
        duration: Duration(milliseconds: 1400),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.62,
        ),
        itemCount: 6,
        itemBuilder: (_, __) {
          return Container(
            decoration: BoxDecoration(
              color: ColorM.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorM.border),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bone(
                      width: 40,
                      height: 16,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const Bone.circle(size: 20),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Bone(
                    width: 120,
                    height: 100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Spacer(),
                const Bone.text(width: 60, fontSize: 11),
                const SizedBox(height: 4),
                const Bone.text(width: 130, fontSize: 14),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Bone.text(width: 50, fontSize: 16),
                    Bone(
                      width: 32,
                      height: 32,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

