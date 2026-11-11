import 'package:flutter/foundation.dart';
import '../../../../core/enums/order_status.dart';
import 'order_details_item_model.dart';

class OrderDetailsModel {
  final String id;
  final OrderStatus status;
  final DateTime createdAt;
  final List<OrderDetailsItemModel> items;

  const OrderDetailsModel({
    required this.id,
    required this.status,
    required this.createdAt,
    this.items = const [],
  });

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.count);

  double get subtotal => double.parse(
    items.fold(0.0, (sum, item) => sum + item.totalPrice).toStringAsFixed(2),
  );

  OrderDetailsModel copyWith({
    String? id,
    OrderStatus? status,
    DateTime? createdAt,
    List<OrderDetailsItemModel>? items,
  }) {
    return OrderDetailsModel(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          createdAt == other.createdAt &&
          listEquals(items, other.items);

  @override
  int get hashCode => Object.hash(id, status, createdAt, Object.hashAll(items));

  @override
  String toString() =>
      'OrderDetailsModel(id: $id, status: ${status.value}, items: ${items.length}, subtotal: $subtotal)';
}

