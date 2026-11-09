import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import 'home_state.dart';

class HomeController extends Notifier<HomeState> {

  @override
  HomeState build() {
    // Kick off data load as soon as the controller is created.
    Future.microtask(loadData);
    return const HomeState();
  }

  Future<void> loadData() async {
    state = state.copyWith(reqState: ReqState.loading, errorMessage: null);

    final useCase = ref.read(DI.getHomeDataUseCaseProvider);
    final result = await useCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          reqState: ReqState.error,
          errorMessage: failure.message,
        );
      },
      (homeModel) {
        state = state.copyWith(
          reqState: ReqState.success,
          data: homeModel,
          errorMessage: null,
        );
      },
    );
  }

  /// Called by SmartRefresh pull-to-refresh.
  Future<void> refresh() => loadData();
}

final homeControllerProvider =
    NotifierProvider.autoDispose<HomeController, HomeState>(HomeController.new);

