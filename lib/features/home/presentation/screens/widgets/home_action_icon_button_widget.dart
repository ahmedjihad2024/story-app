import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';

class HomeActionIconButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const HomeActionIconButtonWidget({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: ColorM.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorM.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

