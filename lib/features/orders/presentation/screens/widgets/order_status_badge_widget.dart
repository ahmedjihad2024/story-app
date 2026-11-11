import 'package:flutter/material.dart';
import '../../../../../core/enums/order_status.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class OrderStatusStyle {
  final String label;
  final Color foreground;
  final Color background;
  final Color border;
  final IconData icon;

  const OrderStatusStyle({
    required this.label,
    required this.foreground,
    required this.background,
    required this.border,
    required this.icon,
  });
}

extension OrderStatusUiExtension on OrderStatus {
  OrderStatusStyle get uiStyle => switch (this) {
    OrderStatus.pending => const OrderStatusStyle(
      label: 'Pending',
      foreground: Color(0xFFB45309),
      background: Color(0xFFFEF3C7),
      border: Color(0xFFFDE68A),
      icon: Icons.schedule_rounded,
    ),
    OrderStatus.paid => const OrderStatusStyle(
      label: 'Paid',
      foreground: ColorM.primary,
      background: ColorM.primary50,
      border: ColorM.primary200,
      icon: Icons.credit_card_outlined,
    ),
    OrderStatus.shipped => const OrderStatusStyle(
      label: 'Shipped',
      foreground: Color(0xFF4338CA),
      background: Color(0xFFEEF2FF),
      border: Color(0xFFC7D2FE),
      icon: Icons.local_shipping_outlined,
    ),
    OrderStatus.delivered => const OrderStatusStyle(
      label: 'Delivered',
      foreground: Color(0xFF15803D),
      background: Color(0xFFDCFCE7),
      border: Color(0xFFBBF7D0),
      icon: Icons.check_circle_outline_rounded,
    ),
    OrderStatus.cancelled => const OrderStatusStyle(
      label: 'Cancelled',
      foreground: ColorM.error,
      background: Color(0xFFFEE2E2),
      border: Color(0xFFFECACA),
      icon: Icons.cancel_outlined,
    ),
  };
}

class OrderStatusBadgeWidget extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadgeWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final style = status.uiStyle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: style.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 13.5, color: style.foreground),
          const SizedBox(width: 5),
          Text(
            style.label,
            style: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 12,
              fontWeight: FontWeightM.semiBold,
              color: style.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
