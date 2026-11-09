import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/api/auth_api_service.dart';
import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/home/data/data_source/home_remote_data_source.dart';
import '../../features/home/data/api/home_api_services.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/domain/usecase/get_home_data_usecase.dart';

class DI {
  static late final ProviderContainer container;

  // --- Supabase Client ---
  static final supabaseClientProvider =
      Provider<SupabaseClient>((ref) => Supabase.instance.client);

  // --- Auth API Service ---
  static final authApiServiceProvider = Provider<AuthApiService>(
    (ref) => AuthApiServiceImpl(ref.read(supabaseClientProvider)),
  );

  // --- Auth Data Sources ---
  static final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
    (ref) => AuthRemoteDataSourceImpl(ref.read(authApiServiceProvider)),
  );

  // --- Auth Repositories ---
  static final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)),
  );

  // --- Auth UseCases ---
  static final loginUseCaseProvider = Provider<LoginUseCase>(
    (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
  );

  static final registerUseCaseProvider = Provider<RegisterUseCase>(
    (ref) => RegisterUseCase(ref.read(authRepositoryProvider)),
  );

  // --- Home API Service ---
  static final homeApiServiceProvider = Provider<HomeApiServices>(
    (ref) => HomeApiServicesImpl(ref.read(supabaseClientProvider)),
  );

  // --- Home Data Sources ---
  static final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>(
    (ref) => HomeRemoteDataSourceImpl(ref.read(homeApiServiceProvider)),
  );

  // --- Home Repositories ---
  static final homeRepositoryProvider = Provider<HomeRepository>(
    (ref) => HomeRepositoryImpl(ref.read(homeRemoteDataSourceProvider)),
  );

  // --- Home UseCases ---
  static final getHomeDataUseCaseProvider = Provider<GetHomeDataUseCase>(
    (ref) => GetHomeDataUseCase(ref.read(homeRepositoryProvider)),
  );

  /// Call this in your main.dart before runApp()
  static Future<void> init({ProviderContainer? container}) async {
    DI.container = container ?? ProviderContainer();
  }
}

extension DIAuthExtension on DI {
  SupabaseClient get supabaseClient =>
      DI.container.read(DI.supabaseClientProvider);
  AuthApiService get authApiService =>
      DI.container.read(DI.authApiServiceProvider);
  AuthRemoteDataSource get authRemoteDataSource =>
      DI.container.read(DI.authRemoteDataSourceProvider);
  AuthRepository get authRepository =>
      DI.container.read(DI.authRepositoryProvider);
  LoginUseCase get loginUseCase => DI.container.read(DI.loginUseCaseProvider);
  RegisterUseCase get registerUseCase =>
      DI.container.read(DI.registerUseCaseProvider);
}

extension DIHomeExtension on DI {
  HomeApiServices get homeApiService =>
      DI.container.read(DI.homeApiServiceProvider);
  HomeRemoteDataSource get homeRemoteDataSource =>
      DI.container.read(DI.homeRemoteDataSourceProvider);
  HomeRepository get homeRepository =>
      DI.container.read(DI.homeRepositoryProvider);
  GetHomeDataUseCase get getHomeDataUseCase =>
      DI.container.read(DI.getHomeDataUseCaseProvider);
}
