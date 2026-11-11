extension OrderCodeFormatExtension on String {
  String get shortOrderCode {
    final trimmed = trim();
    if (trimmed.length <= 8) return '#${trimmed.toUpperCase()}';
    return '#${trimmed.substring(0, 8).toUpperCase()}';
  }
}

extension OrderDateFormatExtension on DateTime {
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get formattedOrderDate {
    final local = toLocal();
    final month = _months[local.month - 1];
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$month ${local.day}, ${local.year} · $hour12:$minute $period';
  }
}

