import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/color_manager.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? fallback;
  final bool isCircle;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallback,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = isCircle
        ? BorderRadius.circular(999)
        : (borderRadius ?? BorderRadius.zero);

    final url = imageUrl?.trim();
    final isValidUrl = url != null &&
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));

    if (!isValidUrl) {
      return _AppCachedImageFallback(
        radius: effectiveRadius,
        width: width,
        height: height,
        fallback: fallback,
      );
    }

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, _) => Container(
          width: width,
          height: height,
          color: const Color(0xFFF1F5F9),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorM.primary,
            ),
          ),
        ),
        errorWidget: (context, _, __) => _AppCachedImageFallback(
          radius: effectiveRadius,
          width: width,
          height: height,
          fallback: fallback,
        ),
      ),
    );
  }
}

class _AppCachedImageFallback extends StatelessWidget {
  final BorderRadius radius;
  final double? width;
  final double? height;
  final Widget? fallback;

  const _AppCachedImageFallback({
    required this.radius,
    this.width,
    this.height,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (fallback != null) return fallback!;

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFFF1F5F9),
        alignment: Alignment.center,
        child: Container(
          width: 38,
          height: 38,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorM.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/svg/storey_logo.svg',
            colorFilter: const ColorFilter.mode(
              ColorM.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

