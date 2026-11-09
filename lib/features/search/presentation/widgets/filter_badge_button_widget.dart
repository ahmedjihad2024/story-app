import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';

class FilterBadgeButtonWidget extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback onPressed;

  const FilterBadgeButtonWidget({
    super.key,
    required this.activeFilterCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: activeFilterCount > 0
                  ? ColorM.primary.withValues(alpha: 0.1)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: activeFilterCount > 0
                  ? Border.all(color: ColorM.primary, width: 1.5)
                  : null,
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 20,
              color: activeFilterCount > 0
                  ? ColorM.primary
                  : const Color(0xFF334155),
            ),
          ),
        ),
        if (activeFilterCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: ColorM.primary,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$activeFilterCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ColorM.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

