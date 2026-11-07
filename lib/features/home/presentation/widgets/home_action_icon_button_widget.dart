import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';

class HomeActionIconButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HomeActionIconButtonWidget({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
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
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

