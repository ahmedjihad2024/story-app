// ignore_for_file: experimental_member_use

import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../response/cart_item_response.dart';

abstract class CartApiService {
  Future<List<CartItemResponse>> getCart();
  Future<int> addToCart({required String productId, int count = 1});
  Future<int> updateItemCount({required String productId, required int count});
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
}

class CartApiServiceImpl implements CartApiService {
  final SupabaseClient _sb;

  CartApiServiceImpl([SupabaseClient? client])
    : _sb = client ?? Supabase.instance.client;

  String _requireUserId() {
    final userId = _sb.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('User not signed in.');
    }
    return userId;
  }

  @override
  Future<List<CartItemResponse>> getCart() async {
    final userId = _requireUserId();

    final rows = await _sb
        .table(Cart.table)
        .selectOnly([
          Cart.count,
          Cart.products.select([
            Products.id,
            Products.name,
            Products.brand,
            Products.imageUrl,
            Products.price,
            Products.discountPercentage,
            Products.favorites.select([Favorites.productId]),
          ]),
        ])
        .where(Cart.userId.eq(userId))
        .requiring(Cart.products)
        .embedded(
          Cart.products,
          (product) => product.embedded(
            Products.favorites,
            (fav) => fav.where(Favorites.userId.eq(userId)),
          ),
        )
        .order(Cart.createdAt.desc())
        .order(Cart.productId.asc());

    return rows
        .map(CartItemResponse.fromPartialRow)
        .whereType<CartItemResponse>()
        .toList();
  }

  @override
  Future<int> addToCart({required String productId, int count = 1}) async {
    if (count < 1) {
      throw ArgumentError.value(count, 'count', 'Count must be at least 1.');
    }

    final userId = _requireUserId();
    final filter = Cart.userId.eq(userId) & Cart.productId.eq(productId);

    final existing = await _sb
        .table(Cart.table)
        .selectOnly([Cart.count])
        .where(filter)
        .maybeSingle();

    if (existing != null) {
      final updatedCount = existing.read(Cart.count) + count;
      await _sb
          .table(Cart.table)
          .update(CartUpdate(count: updatedCount))
          .where(filter);
      return updatedCount;
    }

    await _sb
        .table(Cart.table)
        .insert(CartInsert(userId: userId, productId: productId, count: count));
    return count;
  }

  @override
  Future<int> updateItemCount({
    required String productId,
    required int count,
  }) async {
    if (count < 1) {
      await removeFromCart(productId);
      return 0;
    }

    final userId = _requireUserId();
    await _sb
        .table(Cart.table)
        .update(CartUpdate(count: count))
        .where(Cart.userId.eq(userId) & Cart.productId.eq(productId));
    return count;
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final userId = _requireUserId();
    await _sb
        .table(Cart.table)
        .delete()
        .where(Cart.userId.eq(userId) & Cart.productId.eq(productId));
  }

  @override
  Future<void> clearCart() async {
    final userId = _requireUserId();
    await _sb.table(Cart.table).delete().where(Cart.userId.eq(userId));
  }
}
