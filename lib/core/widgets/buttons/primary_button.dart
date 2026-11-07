import 'package:flutter/material.dart';
import '../../theme/color_manager.dart';
import '../../theme/fonts_manager.dart';
import '../../theme/sizes_manager.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? SizeM.buttonHeight;
    final effectiveRadius = borderRadius ?? SizeM.buttonBorderRadius;
    final effectiveBg = backgroundColor ?? ColorM.primary;
    final effectiveText = textColor ?? ColorM.white;

    return Container(
      width: width ?? double.infinity,
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveRadius),
        boxShadow: onPressed != null && !isLoading
            ? [
                BoxShadow(
                  color: const Color(0xFFBFDBFE).withValues(alpha: 0.6),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
                BoxShadow(
                  color: const Color(0xFFBFDBFE).withValues(alpha: 0.4),
                  offset: const Offset(0, 10),
                  blurRadius: 15,
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: effectiveText,
          disabledBackgroundColor: effectiveBg.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveText),
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 16,
                  fontWeight: FontWeightM.bold,
                  color: effectiveText,
                ),
              ),
      ),
    );
  }
}
