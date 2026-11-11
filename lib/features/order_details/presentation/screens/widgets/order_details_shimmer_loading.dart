import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/color_manager.dart';

class OrderDetailsShimmerLoading extends StatelessWidget {
  const OrderDetailsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE9EDEE),
        highlightColor: Color(0xFFF7F9FA),
        duration: Duration(milliseconds: 1400),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _HeaderShimmerCard(),
          SizedBox(height: 18),
          Bone.text(width: 96, fontSize: 15),
          SizedBox(height: 12),
          _ItemShimmerCard(),
          SizedBox(height: 12),
          _ItemShimmerCard(),
          SizedBox(height: 18),
          _SummaryShimmerCard(),
        ],
      ),
    );
  }
}

class _HeaderShimmerCard extends StatelessWidget {
  const _HeaderShimmerCard();

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
                width: 44,
                height: 44,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(width: 130, fontSize: 16),
                    SizedBox(height: 6),
                    Bone.text(width: 160, fontSize: 12),
                  ],
                ),
              ),
              Bone(
                width: 78,
                height: 26,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Bone(
            width: double.infinity,
            height: 44,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }
}

class _ItemShimmerCard extends StatelessWidget {
  const _ItemShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorM.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(
            width: 82,
            height: 82,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(width: 68, fontSize: 11),
                SizedBox(height: 8),
                Bone.text(width: 180, fontSize: 14),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bone.text(width: 58, fontSize: 12),
                    Bone.text(width: 64, fontSize: 15),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryShimmerCard extends StatelessWidget {
  const _SummaryShimmerCard();

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
          const Bone.text(width: 120, fontSize: 15),
          const SizedBox(height: 14),
          Bone(
            width: double.infinity,
            height: 40,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bone.text(width: 100, fontSize: 13),
              Bone.text(width: 64, fontSize: 14),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bone.text(width: 56, fontSize: 16),
              Bone.text(width: 80, fontSize: 19),
            ],
          ),
        ],
      ),
    );
  }
}

