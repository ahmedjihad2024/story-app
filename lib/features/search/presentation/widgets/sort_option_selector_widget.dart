import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../domain/model/search_filter_model.dart';

class SortOptionSelectorWidget extends StatelessWidget {
  final ProductSortOption selectedOption;
  final ValueChanged<ProductSortOption> onSelected;

  const SortOptionSelectorWidget({
    super.key,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ProductSortOption.values.map((option) {
        final isSelected = selectedOption == option;
        return ChoiceChip(
          label: Text(option.label),
          selected: isSelected,
          onSelected: (_) => onSelected(option),
          selectedColor: ColorM.primary.withValues(alpha: 0.12),
          backgroundColor: ColorM.white,
          side: BorderSide(
            color: isSelected ? ColorM.primary : ColorM.border,
            width: isSelected ? 1.5 : 1,
          ),
          labelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? ColorM.primary : const Color(0xFF334155),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }).toList(),
    );
  }
}

