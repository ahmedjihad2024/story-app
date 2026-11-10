// ignore_for_file: experimental_member_use

import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:storey_app/core/shared/features/favorite/data/response/favorite_status_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../request/get_favorites_request.dart';

abstract class FavoriteApiService {
  Future<FavoriteStatusResponse> addToFavorite(String productId);
  Future<FavoriteStatusResponse> removeFromFavorite(String productId);
  Future<List<ProductsRow>> getFavorites([
    GetFavoritesRequest request = const GetFavoritesRequest(),
  ]);
}

class FavoriteApiServiceImpl implements FavoriteApiService {
  final SupabaseClient _sb;

  FavoriteApiServiceImpl([SupabaseClient? client])
    : _sb = client ?? Supabase.instance.client;

  @override
  Future<FavoriteStatusResponse> addToFavorite(String productId) async {
    await _sb
        .table(Favorites.table)
        .insert(FavoritesInsert(productId: productId));
    return FavoriteStatusResponse(isInFavorite: true);
  }

  @override
  Future<FavoriteStatusResponse> removeFromFavorite(String productId) async {
    var filter = Favorites.productId.eq(productId);
    final userId = _sb.auth.currentUser?.id;
    if (userId != null) {
      filter = filter & Favorites.userId.eq(userId);
    }

    await _sb.table(Favorites.table).delete().where(filter);
    return FavoriteStatusResponse(isInFavorite: false);
  }

  @override
  Future<List<ProductsRow>> getFavorites([
    GetFavoritesRequest request = const GetFavoritesRequest(),
  ]) async {
    final from = request.page * request.limit;
    final to = from + request.limit - 1;

    var query = _sb.table(Favorites.table).selectOnly([
      Favorites.products.select(),
    ]);

    final userId = _sb.auth.currentUser?.id;
    if (userId != null) {
      query = query.where(Favorites.userId.eq(userId));
    }

    final response = await query
        .requiring(Favorites.products)
        .order(Favorites.createdAt.desc())
        .order(Favorites.productId.asc())
        .range(from, to);

    return response
        .map((row) => row.read(Favorites.products)?.toRow(Products.table))
        .whereType<ProductsRow>()
        .map((product) => ProductsRow({
              ...product.toJson(),
              'is_favorite': true,
            }))
        .toList();
  }
}
