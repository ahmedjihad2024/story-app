class OrderIdModel {
  final String orderId;

  const OrderIdModel({required this.orderId});

  OrderIdModel copyWith({String? orderId}) {
    return OrderIdModel(orderId: orderId ?? this.orderId);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderIdModel &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId;

  @override
  int get hashCode => orderId.hashCode;

  @override
  String toString() => 'OrderIdModel(orderId: $orderId)';
}

