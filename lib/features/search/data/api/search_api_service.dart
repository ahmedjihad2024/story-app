import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/extensions/supabase_extensions.dart';
import '../../../../core/network/supabase_schema.g.dart';
import '../../domain/model/search_filter_model.dart';
import '../request/search_products_request.dart';

abstract class SearchApiService {
  Future<List<ProductsRow>> searchProducts(SearchProductsRequest request);
  Future<List<CategoryRow>> getCategories();
}

class SearchApiServiceImpl implements SearchApiService {
  final SupabaseClient sb;

  SearchApiServiceImpl([SupabaseClient? client])
      : sb = client ?? Supabase.instance.client;

  @override
  Future<List<ProductsRow>> searchProducts(SearchProductsRequest request) async {
    PostgrestFilterBuilder<PostgrestList> query = sb.from('products').select();

    final term = request.query.trim();
    if (term.isNotEmpty) {
      query = query.or('name.ilike.%$term%,brand.ilike.%$term%');
    }

    final filter = request.filter;
    if (filter.categoryId != null && filter.categoryId!.isNotEmpty) {
      query = query.eq('category_id', filter.categoryId!);
    }

    if (filter.minPrice != null) {
      query = query.gte('price', filter.minPrice!);
    }

    if (filter.maxPrice != null) {
      query = query.lte('price', filter.maxPrice!);
    }

    final PostgrestTransformBuilder<PostgrestList> sortedQuery =
        switch (filter.sortBy) {
      ProductSortOption.newest => query.order('created_at', ascending: false),
      ProductSortOption.popular => query.order('sales_count', ascending: false),
      ProductSortOption.priceLowToHigh => query.order('price', ascending: true),
      ProductSortOption.priceHighToLow =>
        query.order('price', ascending: false),
    };

    final from = request.page * request.limit;
    final to = from + request.limit - 1;

    final response = await sortedQuery.range(from, to);
    return response.toRows(ProductsRow.new);
  }

  @override
  Future<List<CategoryRow>> getCategories() async {
    final response = await sb.from('category').select().order('name');
    return response.toRows(CategoryRow.new);
  }
}

