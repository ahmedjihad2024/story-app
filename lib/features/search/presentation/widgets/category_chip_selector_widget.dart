import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../home/domain/model/category_model.dart';

class CategoryChipSelectorWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  const CategoryChipSelectorWidget({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final allSelected = selectedCategoryId == null;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('All Categories'),
          selected: allSelected,
          onSelected: (_) => onSelected(null),
          selectedColor: ColorM.primary.withValues(alpha: 0.12),
          backgroundColor: ColorM.white,
          side: BorderSide(
            color: allSelected ? ColorM.primary : ColorM.border,
            width: allSelected ? 1.5 : 1,
          ),
          labelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: allSelected ? FontWeight.w600 : FontWeight.w500,
            color: allSelected ? ColorM.primary : const Color(0xFF334155),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        ...categories.map((cat) {
          final isSelected = selectedCategoryId == cat.id;
          return ChoiceChip(
            label: Text(cat.name),
            selected: isSelected,
            onSelected: (_) => onSelected(isSelected ? null : cat.id),
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
        }),
      ],
    );
  }
}

