import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/color_manager.dart';

class OrdersShimmerLoading extends StatelessWidget {
  const OrdersShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE9EDEE),
        highlightColor: Color(0xFFF7F9FA),
        duration: Duration(milliseconds: 1400),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const _OrderShimmerCard(),
      ),
    );
  }
}

class _OrderShimmerCard extends StatelessWidget {
  const _OrderShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorM.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Bone(
                width: 42,
                height: 42,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(width: 120, fontSize: 15),
                    SizedBox(height: 6),
                    Bone.text(width: 150, fontSize: 12),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Bone(
                width: 78,
                height: 26,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Bone(
            width: double.infinity,
            height: 58,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bone.text(width: 64, fontSize: 13),
              Bone.text(width: 72, fontSize: 16),
            ],
          ),
        ],
      ),
    );
  }
}
