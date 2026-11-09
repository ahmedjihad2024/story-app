import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/extensions/supabase_extensions.dart';
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

    PostgrestFilterBuilder<PostgrestList> query = sb.from('products').select();

    if (request.filterType.isCategory && request.categoryId != null) {
      query = query.eq('category_id', request.categoryId!);
    }

    final PostgrestTransformBuilder<PostgrestList> sortedQuery =
        switch (request.filterType) {
      ProductFilterType.featured => query.order('created_at', ascending: false),
      ProductFilterType.popular => query.order('sales_count', ascending: false),
      ProductFilterType.category => query.order('created_at', ascending: false),
    };

    final response = await sortedQuery.range(from, to);
    return response.toRows(ProductsRow.new);
  }
}

