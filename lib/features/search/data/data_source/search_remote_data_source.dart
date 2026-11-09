import '../../../../core/network/supabase_schema.g.dart';
import '../api/search_api_service.dart';
import '../request/search_products_request.dart';

abstract class SearchRemoteDataSource {
  Future<List<ProductsRow>> searchProducts(SearchProductsRequest request);
  Future<List<CategoryRow>> getCategories();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final SearchApiService _apiService;

  const SearchRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ProductsRow>> searchProducts(SearchProductsRequest request) {
    return _apiService.searchProducts(request);
  }

  @override
  Future<List<CategoryRow>> getCategories() {
    return _apiService.getCategories();
  }
}

