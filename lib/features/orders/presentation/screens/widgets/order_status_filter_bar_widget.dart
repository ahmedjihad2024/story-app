import 'package:flutter/material.dart';
import '../../../../../core/enums/order_status.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import 'order_status_badge_widget.dart';

class OrderStatusFilterBarWidget extends StatelessWidget {
  final OrderStatus? selectedStatus;
  final ValueChanged<OrderStatus?> onStatusSelected;

  const OrderStatusFilterBarWidget({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  static final List<OrderStatus?> _filters = [null, ...OrderStatus.values];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorM.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 62,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = _filters[index];
                final isSelected = selectedStatus == status;
                return _OrderFilterChip(
                  status: status,
                  isSelected: isSelected,
                  onTap: () => onStatusSelected(status),
                );
              },
            ),
          ),
          const Divider(height: 1, thickness: 1, color: ColorM.border),
        ],
      ),
    );
  }
}

class _OrderFilterChip extends StatelessWidget {
  final OrderStatus? status;
  final bool isSelected;
  final VoidCallback onTap;

  const _OrderFilterChip({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = status?.uiStyle;
    final label = style?.label ?? 'All';
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 180);

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Filter orders by $label',
      child: Material(
        color: ColorM.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 42),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? ColorM.primary : ColorM.surfaceSecondary,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected ? ColorM.primary : ColorM.border,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: ColorM.primary.withValues(alpha: 0.22),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (style != null) ...[
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isSelected ? ColorM.white : style.foreground,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: FontsM.inter.name,
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeightM.semiBold
                        : FontWeightM.medium,
                    color: isSelected ? ColorM.white : ColorM.gray700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
