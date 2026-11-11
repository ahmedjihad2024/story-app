enum OrderStatus {
  pending('pending'),
  paid('paid'),
  shipped('shipped'),
  delivered('delivered'),
  cancelled('cancelled');

  const OrderStatus(this.value);

  final String value;

  static OrderStatus fromValue(String value) =>
      OrderStatus.values.firstWhere(
        (s) => s.value == value,
        orElse: () => throw ArgumentError('Unknown order status: $value'),
      );
}