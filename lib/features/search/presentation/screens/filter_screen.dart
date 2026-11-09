import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../home/domain/model/category_model.dart';
import '../../domain/model/search_filter_model.dart';
import '../widgets/category_chip_selector_widget.dart';
import '../widgets/filter_bottom_action_bar_widget.dart';
import '../widgets/filter_section_title_widget.dart';
import '../widgets/price_range_inputs_widget.dart';
import '../widgets/sort_option_selector_widget.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final SearchFilterModel initialFilter;

  const FilterScreen({
    super.key,
    this.initialFilter = const SearchFilterModel(),
  });

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  late ProductSortOption _selectedSort;
  String? _selectedCategoryId;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  List<CategoryModel> _categories = const [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialFilter.sortBy;
    _selectedCategoryId = widget.initialFilter.categoryId;
    _minPriceController = TextEditingController(
      text: widget.initialFilter.minPrice != null
          ? widget.initialFilter.minPrice!.toStringAsFixed(0)
          : '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialFilter.maxPrice != null
          ? widget.initialFilter.maxPrice!.toStringAsFixed(0)
          : '',
    );

    _loadCategories();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final useCase = ref.read(DI.getFilterCategoriesUseCaseProvider);
    final result = await useCase();
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoadingCategories = false;
        });
      },
      (categories) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      },
    );
  }

  void _handleReset() {
    setState(() {
      _selectedSort = ProductSortOption.newest;
      _selectedCategoryId = null;
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  void _handleApply() {
    final min = double.tryParse(_minPriceController.text.trim());
    final max = double.tryParse(_maxPriceController.text.trim());

    final filter = SearchFilterModel(
      categoryId: _selectedCategoryId,
      minPrice: min,
      maxPrice: max,
      sortBy: _selectedSort,
    );

    context.pop(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: ColorM.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            size: 22,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Filter & Sort',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _handleReset,
            child: const Text(
              'Reset',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ColorM.primary,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: ColorM.border, height: 1),
        ),
      ),
      bottomNavigationBar: FilterBottomActionBarWidget(onApply: _handleApply),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FilterSectionTitleWidget(title: 'Sort By'),
            const SizedBox(height: 12),
            SortOptionSelectorWidget(
              selectedOption: _selectedSort,
              onSelected: (option) => setState(() => _selectedSort = option),
            ),
            const SizedBox(height: 24),
            const FilterSectionTitleWidget(title: 'Category'),
            const SizedBox(height: 12),
            if (_isLoadingCategories)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              CategoryChipSelectorWidget(
                categories: _categories,
                selectedCategoryId: _selectedCategoryId,
                onSelected: (catId) => setState(() => _selectedCategoryId = catId),
              ),
            const SizedBox(height: 24),
            const FilterSectionTitleWidget(title: 'Price Range'),
            const SizedBox(height: 12),
            PriceRangeInputsWidget(
              minController: _minPriceController,
              maxController: _maxPriceController,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
