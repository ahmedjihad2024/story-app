import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import '../../domain/model/promo_banner_model.dart';

class HeroPromoBannerWidget extends StatefulWidget {
  final List<PromoBannerModel> banners;
  final void Function(PromoBannerModel)? onShopNowPressed;

  const HeroPromoBannerWidget({
    super.key,
    this.banners = PromoBannerModel.sampleBanners,
    this.onShopNowPressed,
  });

  @override
  State<HeroPromoBannerWidget> createState() => _HeroPromoBannerWidgetState();
}

class _HeroPromoBannerWidgetState extends State<HeroPromoBannerWidget> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return CarouselSlider.builder(
      itemCount: widget.banners.length,
      options: CarouselOptions(
        height: 160,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: widget.banners.length > 1,
        autoPlay: widget.banners.length > 1,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 700),
        autoPlayCurve: Curves.easeInOutCubic,
        enlargeCenterPage: false,
        onPageChanged: (index, _) {
          setState(() => _activeIndex = index);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final banner = widget.banners[index];
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                offset: const Offset(0, 8),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background promotional image with gradient overlay
              Positioned.fill(
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    banner.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFF0F172A).withValues(alpha: 0.95),
                        const Color(0xFF0F172A).withValues(alpha: 0.60),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          banner.tag,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeightM.bold,
                            color: Color(0xFFCBD5E1),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeightM.bold,
                            color: ColorM.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeightM.regular,
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => widget.onShopNowPressed?.call(banner),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: ColorM.white,
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  banner.buttonText,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeightM.semiBold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  'assets/svg/arrow_right.svg',
                                  width: 14,
                                  height: 14,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF0F172A),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Page Indicator Dots animated like Dokkan
                        if (widget.banners.length > 1)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(widget.banners.length, (dotIndex) {
                              final isCurrent = dotIndex == _activeIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                margin: EdgeInsets.only(
                                  right: dotIndex < widget.banners.length - 1
                                      ? 4
                                      : 0,
                                ),
                                width: isCurrent ? 16 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? ColorM.white
                                      : ColorM.white.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                              );
                            }),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
