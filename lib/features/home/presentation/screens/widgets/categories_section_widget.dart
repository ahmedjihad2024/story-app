import 'package:flutter/material.dart';
import '../../../domain/model/category_model.dart';
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: HomeSectionHeaderWidget(
            title: 'Categories',
            onActionPressed: null,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 96,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return SizedBox(
                key: ValueKey(cat.id),
                width: 68,
                child: CategoryItemWidget(
                  category: cat,
                  onTap: () => onCategorySelected?.call(cat),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
