// ignore_for_file: experimental_member_use

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/supabase_schema.g.dart';
import '../../domain/model/product_filter_type.dart';
import '../request/get_products_request.dart';

abstract class ProductsApiService {
  Future<List<ProductsRow>> getProducts(GetProductsRequest request);
}

class ProductsApiServiceImpl implements ProductsApiService {
  final SupabaseClient sb;

  ProductsApiServiceImpl([SupabaseClient? client])
      : sb = client ?? Supabase.instance.client;

  @override
  Future<List<ProductsRow>> getProducts(GetProductsRequest request) async {
    final from = request.page * request.limit;
    final to = from + request.limit - 1;

    var query = sb.table(Products.table).selectOnly([
      Products.table.allColumns,
      Products.favorites.select([Favorites.productId]),
    ]);

    if (request.filterType.isCategory && request.categoryId != null) {
      query = query.where(Products.categoryId.eq(request.categoryId!));
    }

    var sortedQuery = switch (request.filterType) {
      ProductFilterType.featured => query.order(Products.createdAt.desc()),
      ProductFilterType.popular => query.order(Products.salesCount.desc()),
      ProductFilterType.category => query.order(Products.createdAt.desc()),
    };

    final userId = sb.auth.currentUser?.id;
    if (userId != null) {
      sortedQuery = sortedQuery.embedded(
        Products.favorites,
        (fav) => fav.where(Favorites.userId.eq(userId)),
      );
    }

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
}
