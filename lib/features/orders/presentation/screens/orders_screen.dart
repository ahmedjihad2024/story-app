import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/order_status.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../riverpod/orders_controller.dart';
import '../riverpod/orders_state.dart';
import 'widgets/order_card_widget.dart';
import 'widgets/order_status_filter_bar_widget.dart';
import 'widgets/orders_empty_widget.dart';
import 'widgets/orders_error_widget.dart';
import 'widgets/orders_shimmer_loading.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final success = await ref
        .read(ordersControllerProvider.notifier)
        .refresh();
    if (!mounted) return;

    if (success) {
      _refreshController.refreshCompleted(resetFooterState: true);
    } else {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _handleLoadMore() async {
    final hasMore = await ref
        .read(ordersControllerProvider.notifier)
        .loadMore();
    if (!mounted) return;

    if (hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  void _handleStatusSelected(OrderStatus? status) {
    _refreshController.resetNoData();
    ref.read(ordersControllerProvider.notifier).selectStatus(status);
  }

  void _handleEmptyAction(OrderStatus? selectedStatus) {
    if (selectedStatus != null) {
      _handleStatusSelected(null);
      return;
    }

    if (context.canPop) {
      context.pop();
    } else {
      context.goNamed(Routes.home);
    }
  }

  void _showErrorSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorM.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordersControllerProvider);

    ref.listen<OrdersState>(ordersControllerProvider, (prev, next) {
      if (next.isSuccess &&
          next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        _showErrorSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: ColorM.background,
      appBar: AppBar(
        backgroundColor: ColorM.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: ColorM.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Orders',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 18,
            fontWeight: FontWeightM.bold,
            color: ColorM.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          OrderStatusFilterBarWidget(
            selectedStatus: state.selectedStatus,
            onStatusSelected: _handleStatusSelected,
          ),
          Expanded(
            child: StateRender(
              reqState: state.reqState,
              idle: (context) => const OrdersShimmerLoading(),
              loading: (context) => const OrdersShimmerLoading(),
              error: (context) => OrdersErrorWidget(
                message: state.errorMessage ?? 'Failed to load orders',
                onRetry: () =>
                    ref.read(ordersControllerProvider.notifier).loadOrders(),
              ),
              empty: (context) => CustomizedSmartRefresh(
                controller: _refreshController,
                onRefresh: _handleRefresh,
                enableRefresh: true,
                enableLoading: false,
                child: OrdersEmptyWidget(
                  selectedStatus: state.selectedStatus,
                  onAction: () => _handleEmptyAction(state.selectedStatus),
                ),
              ),
              success: (context) => CustomizedSmartRefresh(
                controller: _refreshController,
                onRefresh: _handleRefresh,
                onLoading: _handleLoadMore,
                enableRefresh: true,
                enableLoading: state.hasMore,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: state.orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return OrderCardWidget(
                      key: ValueKey(order.id),
                      order: order,
                      onTap: () => context.pushNamed(
                        Routes.orderDetails,
                        arguments: order.id,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

