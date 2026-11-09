import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/color_manager.dart';

class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE9EDEE),
        highlightColor: Color(0xFFF7F9FA),
        duration: Duration(milliseconds: 1400),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Bar Shimmer
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bone.text(width: 120, fontSize: 24),
                    Row(
                      children: [
                        Bone.circle(size: 38),
                        SizedBox(width: 8),
                        Bone.circle(size: 38),
                        SizedBox(width: 8),
                        Bone.circle(size: 38),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Search Bar Shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Bone(
                  height: 48,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(height: 20),

              // 3. Categories Header & Items Shimmer (Horizontal)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bone.text(width: 100, fontSize: 18),
                    Bone.text(width: 50, fontSize: 13),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 96,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (_, _) {
                    return const SizedBox(
                      width: 68,
                      child: Column(
                        children: [
                          Bone.circle(size: 56),
                          SizedBox(height: 8),
                          Bone.text(width: 48, fontSize: 12),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 4. Hero Promo Banner Shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Bone(
                  height: 160,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              const SizedBox(height: 20),

              // 5. Featured Section Shimmer (Horizontal)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bone.text(width: 90, fontSize: 18),
                    Bone.text(width: 50, fontSize: 13),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (_, _) {
                    return Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: ColorM.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ColorM.border),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone(
                            width: 136,
                            height: 130,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          const SizedBox(height: 10),
                          const Bone.text(width: 100, fontSize: 14),
                          const SizedBox(height: 6),
                          const Bone.text(width: 60, fontSize: 14),
                          const Spacer(),
                          Bone(
                            width: double.infinity,
                            height: 28,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 6. Popular Now Section Shimmer (Horizontal)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bone.text(width: 110, fontSize: 18),
                    Bone.text(width: 50, fontSize: 13),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 310,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (_, _) {
                    return Container(
                      width: 180,
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
                              width: 130,
                              height: 110,
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
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
