import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';

class FilterBottomActionBarWidget extends StatelessWidget {
  final VoidCallback onApply;

  const FilterBottomActionBarWidget({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: ColorM.white,
        border: Border(
          top: BorderSide(color: ColorM.border),
        ),
      ),
      child: SizedBox(
        height: 48,
        child: FilledButton(
          onPressed: onApply,
          style: FilledButton.styleFrom(
            backgroundColor: ColorM.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Apply Filter',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ColorM.white,
            ),
          ),
        ),
      ),
    );
  }
}

