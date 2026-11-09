import 'package:flutter/material.dart';
import '../../../../core/widgets/images/app_cached_image.dart';

class ProductDetailsImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? imageAsset;

  const ProductDetailsImageWidget({
    super.key,
    this.imageUrl,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    Widget? fallbackWidget;
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      fallbackWidget = Image.asset(
        imageAsset!,
        fit: BoxFit.contain,
        height: 280,
        width: double.infinity,
      );
    }

    return Container(
      width: double.infinity,
      height: 320,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      alignment: Alignment.center,
      child: Hero(
        tag: 'product_image_${imageUrl ?? imageAsset ?? ""}',
        child: AppCachedImage(
          imageUrl: imageUrl,
          fallback: fallbackWidget,
          fit: BoxFit.contain,
          height: 280,
          width: double.infinity,
        ),
      ),
    );
  }
}
