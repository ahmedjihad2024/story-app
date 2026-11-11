import 'package:flutter/foundation.dart';
import '../../../../core/enums/order_status.dart';
import 'order_item_model.dart';

class OrderModel {
  final String id;
  final OrderStatus status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.status,
    required this.createdAt,
    this.items = const [],
  });

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.count);

  double get totalPrice => double.parse(
    items.fold(0.0, (sum, item) => sum + item.totalPrice).toStringAsFixed(2),
  );

  OrderModel copyWith({
    String? id,
    OrderStatus? status,
    DateTime? createdAt,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          createdAt == other.createdAt &&
          listEquals(items, other.items);

  @override
  int get hashCode => Object.hash(id, status, createdAt, Object.hashAll(items));

  @override
  String toString() =>
      'OrderModel(id: $id, status: ${status.value}, items: ${items.length}, totalPrice: $totalPrice)';
}

