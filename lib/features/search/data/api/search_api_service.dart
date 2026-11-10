// ignore_for_file: experimental_member_use

import 'package:supabase_flutter/supabase_flutter.dart';
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
    var query = sb.table(Products.table).selectOnly([
      Products.table.allColumns,
      Products.favorites.select([Favorites.productId]),
    ]);

    final term = request.query.trim();
    if (term.isNotEmpty) {
      query = query.where(
        Products.name.ilike('%$term%') | Products.brand.ilike('%$term%'),
      );
    }

    final filter = request.filter;
    if (filter.categoryId != null && filter.categoryId!.isNotEmpty) {
      query = query.where(Products.categoryId.eq(filter.categoryId!));
    }

    if (filter.minPrice != null) {
      query = query.where(Products.price.gte(filter.minPrice!));
    }

    if (filter.maxPrice != null) {
      query = query.where(Products.price.lte(filter.maxPrice!));
    }

    var sortedQuery = switch (filter.sortBy) {
      ProductSortOption.newest => query.order(Products.createdAt.desc()),
      ProductSortOption.popular => query.order(Products.salesCount.desc()),
      ProductSortOption.priceLowToHigh => query.order(Products.price.asc()),
      ProductSortOption.priceHighToLow => query.order(Products.price.desc()),
    };

    final userId = sb.auth.currentUser?.id;
    if (userId != null) {
      sortedQuery = sortedQuery.embedded(
        Products.favorites,
        (fav) => fav.where(Favorites.userId.eq(userId)),
      );
    }

    final from = request.page * request.limit;
    final to = from + request.limit - 1;

    final rows = await sortedQuery.range(from, to);
    return rows.map((row) {
      final isFavorite = row.read(Products.favorites).isNotEmpty;
      final product = row.toRow(Products.table);
      return ProductsRow({
        ...product.toJson(),
        'is_favorite': isFavorite,
      });
    }).toList();
  }

  @override
  Future<List<CategoryRow>> getCategories() async {
    return sb.table(Category.table).select().order(Category.name.asc());
  }
}
