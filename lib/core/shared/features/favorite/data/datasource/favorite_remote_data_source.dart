import 'package:storey_app/core/network/supabase_schema.g.dart';
import '../api/favorite_api_service.dart';
import '../request/get_favorites_request.dart';
import '../response/favorite_status_response.dart';

abstract class FavoriteRemoteDataSource {
  Future<FavoriteStatusResponse> addToFavorite(String productId);
  Future<FavoriteStatusResponse> removeFromFavorite(String productId);
  Future<List<ProductsRow>> getFavorites([
    GetFavoritesRequest request = const GetFavoritesRequest(),
  ]);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final FavoriteApiService _apiService;

  const FavoriteRemoteDataSourceImpl(this._apiService);

  @override
  Future<FavoriteStatusResponse> addToFavorite(String productId) {
    return _apiService.addToFavorite(productId);
  }

  @override
  Future<FavoriteStatusResponse> removeFromFavorite(String productId) {
    return _apiService.removeFromFavorite(productId);
  }

  @override
  Future<List<ProductsRow>> getFavorites([
    GetFavoritesRequest request = const GetFavoritesRequest(),
  ]) {
    return _apiService.getFavorites(request);
  }
}

