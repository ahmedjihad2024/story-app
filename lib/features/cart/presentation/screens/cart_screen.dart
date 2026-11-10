import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/network/failure_message.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/shared/features/cart/domain/model/cart_item_model.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../riverpod/cart_screen_controller.dart';
import '../riverpod/cart_screen_state.dart';
import 'widgets/cart_empty_widget.dart';
import 'widgets/cart_error_widget.dart';
import 'widgets/cart_item_card_widget.dart';
import 'widgets/cart_shimmer_loading.dart';
import 'widgets/cart_summary_bottom_bar_widget.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final success = await ref
        .read(cartScreenControllerProvider.notifier)
        .refresh();
    if (!mounted) return;

    if (success) {
      _refreshController.refreshCompleted(resetFooterState: true);
    } else {
      _refreshController.refreshFailed();
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

  Future<void> _handleIncrement(CartItemModel item) async {
    final result = await ref
        .read(cartScreenControllerProvider.notifier)
        .incrementItem(item);
    if (result == null || !mounted) return;

    result.fold(
      (failure) => _showErrorSnackBar(failure.message),
      (_) {},
    );
  }

  Future<void> _handleDecrement(CartItemModel item) async {
    final result = await ref
        .read(cartScreenControllerProvider.notifier)
        .decrementItem(item);
    if (result == null || !mounted) return;

    result.fold(
      (failure) => _showErrorSnackBar(failure.message),
      (_) {},
    );
  }

  Future<void> _handleRemove(CartItemModel item) async {
    final result = await ref
        .read(cartScreenControllerProvider.notifier)
        .removeItem(item);
    if (result == null || !mounted) return;

    result.fold(
      (failure) => _showErrorSnackBar(failure.message),
      (_) {},
    );
  }

  Future<void> _handleWishlistToggle(CartItemModel item) async {
    final result = await ref
        .read(cartScreenControllerProvider.notifier)
        .toggleFavorite(item);
    if (result == null || !mounted) return;

    result.fold(
      (failure) => _showErrorSnackBar(failure.message),
      (_) {},
    );
  }

  Future<void> _handleClearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _ClearCartConfirmDialog(),
    );
    if (confirmed != true || !mounted) return;

    final result = await ref
        .read(cartScreenControllerProvider.notifier)
        .clearCart();
    if (result == null || !mounted) return;

    result.fold(
      (failure) => _showErrorSnackBar(failure.message),
      (_) {},
    );
  }

  void _handleCheckout(CartScreenState state) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Checkout with ${state.totalUnits} ${state.totalUnits == 1 ? 'item' : 'items'} (\$${state.subtotal.toStringAsFixed(2)})',
        ),
        backgroundColor: ColorM.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleShopNow() {
    if (context.canPop) {
      context.pop();
    } else {
      context.goNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartScreenControllerProvider);

    ref.listen<CartScreenState>(cartScreenControllerProvider, (prev, next) {
      if (next.isSuccess &&
          next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        _showErrorSnackBar(next.errorMessage!);
      }
    });

    final showBottomBar = state.isSuccess && state.items.isNotEmpty;

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
          state.totalUnits > 0 ? 'My Cart (${state.totalUnits})' : 'My Cart',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 18,
            fontWeight: FontWeightM.bold,
            color: ColorM.textPrimary,
          ),
        ),
        actions: [
          if (state.isSuccess && state.items.isNotEmpty)
            TextButton(
              onPressed: _handleClearCart,
              style: TextButton.styleFrom(
                foregroundColor: ColorM.error,
              ),
              child: Text(
                'Clear',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 13.5,
                  fontWeight: FontWeightM.semiBold,
                ),
              ),
            ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: ColorM.border,
          ),
        ),
      ),
      bottomNavigationBar: showBottomBar
          ? CartSummaryBottomBarWidget(
              totalUnits: state.totalUnits,
              subtotal: state.subtotal,
              totalSavings: state.totalSavings,
              onCheckout: () => _handleCheckout(state),
            )
          : null,
      body: StateRender(
        reqState: state.reqState,
        idle: (context) => const CartShimmerLoading(),
        loading: (context) => const CartShimmerLoading(),
        error: (context) => CartErrorWidget(
          message: state.errorMessage ?? 'Failed to load cart',
          onRetry: () => ref.read(cartScreenControllerProvider.notifier).loadCart(),
        ),
        empty: (context) => CustomizedSmartRefresh(
          controller: _refreshController,
          onRefresh: _handleRefresh,
          enableRefresh: true,
          enableLoading: false,
          child: CartEmptyWidget(onShopNow: _handleShopNow),
        ),
        success: (context) => CustomizedSmartRefresh(
          controller: _refreshController,
          onRefresh: _handleRefresh,
          enableRefresh: true,
          enableLoading: false,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartItemCardWidget(
                item: item,
                onIncrement: () => _handleIncrement(item),
                onDecrement: () => _handleDecrement(item),
                onRemove: () => _handleRemove(item),
                onWishlistToggle: () => _handleWishlistToggle(item),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ClearCartConfirmDialog extends StatelessWidget {
  const _ClearCartConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorM.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Clear Cart?',
        style: TextStyle(
          fontFamily: FontsM.inter.name,
          fontSize: 18,
          fontWeight: FontWeightM.bold,
          color: ColorM.textPrimary,
        ),
      ),
      content: Text(
        'Are you sure you want to remove all items from your cart?',
        style: TextStyle(
          fontFamily: FontsM.inter.name,
          fontSize: 14,
          color: ColorM.textSecondary,
          height: 1.45,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: ColorM.error,
          ),
          child: const Text('Clear'),
        ),
      ],
    );
  }
}

