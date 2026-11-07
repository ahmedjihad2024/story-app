import 'package:flutter/material.dart';
import '../../domain/model/category_model.dart';
import 'category_item_widget.dart';
import 'home_section_header_widget.dart';

class CategoriesSectionWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final void Function(CategoryModel)? onCategorySelected;
  final VoidCallback? onSeeAllPressed;

  const CategoriesSectionWidget({
    super.key,
    this.categories = CategoryModel.sampleCategories,
    this.onCategorySelected,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        HomeSectionHeaderWidget(
          title: 'Categories',
          onActionPressed: onSeeAllPressed,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((cat) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CategoryItemWidget(
                  category: cat,
                  onTap: () => onCategorySelected?.call(cat),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

