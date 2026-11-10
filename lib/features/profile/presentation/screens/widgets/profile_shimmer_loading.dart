import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/color_manager.dart';

class ProfileShimmerLoading extends StatelessWidget {
  const ProfileShimmerLoading({super.key});

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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Bone.text(width: 90, fontSize: 26),
          const SizedBox(height: 18),
          Row(
            children: [
              Bone(
                width: 72,
                height: 72,
                borderRadius: BorderRadius.circular(22),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.text(width: 140, fontSize: 19),
                  SizedBox(height: 8),
                  Bone.text(width: 96, fontSize: 12),
                  SizedBox(height: 8),
                  Bone.text(width: 160, fontSize: 13),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Bone(
            width: double.infinity,
            height: 44,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < 5; i++) ...[
            Container(
              height: 66,
              decoration: BoxDecoration(
                color: ColorM.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Bone(
                    width: 42,
                    height: 42,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bone.text(width: 120, fontSize: 14),
                      SizedBox(height: 6),
                      Bone.text(width: 160, fontSize: 12),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

