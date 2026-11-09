import '../../../../core/network/supabase_schema.g.dart';
import '../api/products_api_service.dart';
import '../request/get_products_request.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductsRow>> getProducts(GetProductsRequest request);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final ProductsApiService _apiService;

  const ProductsRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ProductsRow>> getProducts(GetProductsRequest request) {
    return _apiService.getProducts(request);
  }
}

