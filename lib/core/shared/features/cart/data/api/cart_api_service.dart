// ignore_for_file: experimental_member_use

import 'package:storey_app/core/extensions/supabase_extensions.dart';
import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CartApiService {
  Future<int> addToCart({required String productId, int count = 1});
  Future<int> updateItemCount({required String productId, required int count});
  Future<void> removeFromCart(String productId);
}

class CartApiServiceImpl implements CartApiService {
  final SupabaseClient _sb;

  CartApiServiceImpl([SupabaseClient? client])
    : _sb = client ?? Supabase.instance.client;

  @override
  Future<int> addToCart({required String productId, int count = 1}) async {
    if (count < 1) {
      throw ArgumentError.value(count, 'count', 'Count must be at least 1.');
    }

    final userId = _sb.requireUserId();
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

    final userId = _sb.requireUserId();
    await _sb
        .table(Cart.table)
        .update(CartUpdate(count: count))
        .where(Cart.userId.eq(userId) & Cart.productId.eq(productId));
    return count;
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final userId = _sb.requireUserId();
    await _sb
        .table(Cart.table)
        .delete()
        .where(Cart.userId.eq(userId) & Cart.productId.eq(productId));
  }
}
