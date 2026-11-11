class OrderIdResponse {
  final String orderId;

  const OrderIdResponse({required this.orderId});

  factory OrderIdResponse.fromJson(Map<String, dynamic> json) {
    return OrderIdResponse(orderId: json['order_id'] as String);
  }
}

