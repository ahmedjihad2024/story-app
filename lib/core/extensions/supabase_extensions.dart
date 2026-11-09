extension RowsParsing on Object? {
  List<T> toRows<T>(T Function(Map<String, dynamic>) from) {
    if (this is! List) return const [];
    final list = this as List;
    final results = <T>[];
    for (final item in list) {
      if (item is Map) {
        results.add(from(item.cast<String, dynamic>()));
      }
    }
    return results;
  }
}
