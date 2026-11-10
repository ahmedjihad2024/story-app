import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/api/auth_api_service.dart';
import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/auth/domain/usecase/sign_out_usecase.dart';
import '../../features/home/data/data_source/home_remote_data_source.dart';
import '../../features/home/data/api/home_api_services.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/domain/usecase/get_home_data_usecase.dart';
import '../../features/products/data/api/products_api_service.dart';
import '../../features/products/data/data_source/products_remote_data_source.dart';
import '../../features/products/data/repository/products_repository_impl.dart';
import '../../features/products/domain/repository/products_repository.dart';
import '../../features/products/domain/usecase/get_products_usecase.dart';
import '../../features/search/data/api/search_api_service.dart';
import '../../features/search/data/data_source/search_remote_data_source.dart';
import '../../features/search/data/repository/search_repository_impl.dart';
import '../../features/search/domain/repository/search_repository.dart';
import '../../features/search/domain/usecase/get_filter_categories_usecase.dart';
import '../../features/search/domain/usecase/search_products_usecase.dart';
import '../shared/features/cart/data/api/cart_api_service.dart';
import '../shared/features/cart/data/datasource/cart_remote_data_source.dart';
import '../shared/features/cart/data/repository/cart_repository_impl.dart';
import '../shared/features/cart/domain/repository/cart_repository.dart';
import '../shared/features/cart/domain/usecase/add_to_cart_usecase.dart';
import '../shared/features/cart/domain/usecase/clear_cart_usecase.dart';
import '../shared/features/cart/domain/usecase/get_cart_usecase.dart';
import '../shared/features/cart/domain/usecase/remove_from_cart_usecase.dart';
import '../shared/features/cart/domain/usecase/update_cart_item_count_usecase.dart';
import '../shared/features/favorite/data/api/favorite_api_service.dart';
import '../shared/features/favorite/data/datasource/favorite_remote_data_source.dart';
import '../shared/features/favorite/data/repository/favorite_repository_impl.dart';
import '../shared/features/favorite/domain/repository/favorite_repository.dart';
import '../shared/features/favorite/domain/usecase/add_to_favorite_usecase.dart';
import '../shared/features/favorite/domain/usecase/get_favorites_usecase.dart';
import '../shared/features/favorite/domain/usecase/remove_from_favorite_usecase.dart';
import '../shared/features/profile/data/api/profile_api_service.dart';
import '../shared/features/profile/data/datasource/profile_remote_data_source.dart';
import '../shared/features/profile/data/repository/profile_repository_impl.dart';
import '../shared/features/profile/domain/repository/profile_repository.dart';
import '../shared/features/profile/domain/usecase/get_profile_usecase.dart';
import '../shared/features/profile/domain/usecase/update_profile_usecase.dart';

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

  static final signOutUseCaseProvider = Provider<SignOutUseCase>(
    (ref) => SignOutUseCase(ref.read(authRepositoryProvider)),
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

  // --- Products Feature ---
  static final productsApiServiceProvider = Provider<ProductsApiService>(
    (ref) => ProductsApiServiceImpl(ref.read(supabaseClientProvider)),
  );

  static final productsRemoteDataSourceProvider =
      Provider<ProductsRemoteDataSource>(
    (ref) => ProductsRemoteDataSourceImpl(ref.read(productsApiServiceProvider)),
  );

  static final productsRepositoryProvider = Provider<ProductsRepository>(
    (ref) => ProductsRepositoryImpl(ref.read(productsRemoteDataSourceProvider)),
  );

  static final getProductsUseCaseProvider = Provider<GetProductsUseCase>(
    (ref) => GetProductsUseCase(ref.read(productsRepositoryProvider)),
  );

  // --- Search Feature ---
  static final searchApiServiceProvider = Provider<SearchApiService>(
    (ref) => SearchApiServiceImpl(ref.read(supabaseClientProvider)),
  );

  static final searchRemoteDataSourceProvider =
      Provider<SearchRemoteDataSource>(
    (ref) => SearchRemoteDataSourceImpl(ref.read(searchApiServiceProvider)),
  );

  static final searchRepositoryProvider = Provider<SearchRepository>(
    (ref) => SearchRepositoryImpl(ref.read(searchRemoteDataSourceProvider)),
  );

  static final searchProductsUseCaseProvider = Provider<SearchProductsUseCase>(
    (ref) => SearchProductsUseCase(ref.read(searchRepositoryProvider)),
  );

  static final getFilterCategoriesUseCaseProvider =
      Provider<GetFilterCategoriesUseCase>(
    (ref) => GetFilterCategoriesUseCase(ref.read(searchRepositoryProvider)),
  );

  // --- Favorite Feature ---
  static final favoriteApiServiceProvider = Provider<FavoriteApiService>(
    (ref) => FavoriteApiServiceImpl(ref.read(supabaseClientProvider)),
  );

  static final favoriteRemoteDataSourceProvider =
      Provider<FavoriteRemoteDataSource>(
    (ref) => FavoriteRemoteDataSourceImpl(ref.read(favoriteApiServiceProvider)),
  );

  static final favoriteRepositoryProvider = Provider<FavoriteRepository>(
    (ref) => FavoriteRepositoryImpl(ref.read(favoriteRemoteDataSourceProvider)),
  );

  static final addToFavoriteUseCaseProvider = Provider<AddToFavoriteUseCase>(
    (ref) => AddToFavoriteUseCase(ref.read(favoriteRepositoryProvider)),
  );

  static final removeFromFavoriteUseCaseProvider =
      Provider<RemoveFromFavoriteUseCase>(
    (ref) => RemoveFromFavoriteUseCase(ref.read(favoriteRepositoryProvider)),
  );

  static final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>(
    (ref) => GetFavoritesUseCase(ref.read(favoriteRepositoryProvider)),
  );

  // --- Profile Feature ---
  static final profileApiServiceProvider = Provider<ProfileApiService>(
    (ref) => ProfileApiServiceImpl(ref.read(supabaseClientProvider)),
  );

  static final profileRemoteDataSourceProvider =
      Provider<ProfileRemoteDataSource>(
    (ref) => ProfileRemoteDataSourceImpl(ref.read(profileApiServiceProvider)),
  );

  static final profileRepositoryProvider = Provider<ProfileRepository>(
    (ref) => ProfileRepositoryImpl(ref.read(profileRemoteDataSourceProvider)),
  );

  static final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
    (ref) => GetProfileUseCase(ref.read(profileRepositoryProvider)),
  );

  static final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
    (ref) => UpdateProfileUseCase(ref.read(profileRepositoryProvider)),
  );

  // --- Cart Feature ---
  static final cartApiServiceProvider = Provider<CartApiService>(
    (ref) => CartApiServiceImpl(ref.read(supabaseClientProvider)),
  );

  static final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>(
    (ref) => CartRemoteDataSourceImpl(ref.read(cartApiServiceProvider)),
  );

  static final cartRepositoryProvider = Provider<CartRepository>(
    (ref) => CartRepositoryImpl(ref.read(cartRemoteDataSourceProvider)),
  );

  static final getCartUseCaseProvider = Provider<GetCartUseCase>(
    (ref) => GetCartUseCase(ref.read(cartRepositoryProvider)),
  );

  static final addToCartUseCaseProvider = Provider<AddToCartUseCase>(
    (ref) => AddToCartUseCase(ref.read(cartRepositoryProvider)),
  );

  static final updateCartItemCountUseCaseProvider =
      Provider<UpdateCartItemCountUseCase>(
    (ref) => UpdateCartItemCountUseCase(ref.read(cartRepositoryProvider)),
  );

  static final removeFromCartUseCaseProvider = Provider<RemoveFromCartUseCase>(
    (ref) => RemoveFromCartUseCase(ref.read(cartRepositoryProvider)),
  );

  static final clearCartUseCaseProvider = Provider<ClearCartUseCase>(
    (ref) => ClearCartUseCase(ref.read(cartRepositoryProvider)),
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
  SignOutUseCase get signOutUseCase =>
      DI.container.read(DI.signOutUseCaseProvider);
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

extension DIFavoriteExtension on DI {
  FavoriteApiService get favoriteApiService =>
      DI.container.read(DI.favoriteApiServiceProvider);
  FavoriteRemoteDataSource get favoriteRemoteDataSource =>
      DI.container.read(DI.favoriteRemoteDataSourceProvider);
  FavoriteRepository get favoriteRepository =>
      DI.container.read(DI.favoriteRepositoryProvider);
  AddToFavoriteUseCase get addToFavoriteUseCase =>
      DI.container.read(DI.addToFavoriteUseCaseProvider);
  RemoveFromFavoriteUseCase get removeFromFavoriteUseCase =>
      DI.container.read(DI.removeFromFavoriteUseCaseProvider);
  GetFavoritesUseCase get getFavoritesUseCase =>
      DI.container.read(DI.getFavoritesUseCaseProvider);
}

extension DIProfileExtension on DI {
  ProfileApiService get profileApiService =>
      DI.container.read(DI.profileApiServiceProvider);
  ProfileRemoteDataSource get profileRemoteDataSource =>
      DI.container.read(DI.profileRemoteDataSourceProvider);
  ProfileRepository get profileRepository =>
      DI.container.read(DI.profileRepositoryProvider);
  GetProfileUseCase get getProfileUseCase =>
      DI.container.read(DI.getProfileUseCaseProvider);
  UpdateProfileUseCase get updateProfileUseCase =>
      DI.container.read(DI.updateProfileUseCaseProvider);
}

extension DICartExtension on DI {
  CartApiService get cartApiService => DI.container.read(DI.cartApiServiceProvider);
  CartRemoteDataSource get cartRemoteDataSource =>
      DI.container.read(DI.cartRemoteDataSourceProvider);
  CartRepository get cartRepository => DI.container.read(DI.cartRepositoryProvider);
  GetCartUseCase get getCartUseCase => DI.container.read(DI.getCartUseCaseProvider);
  AddToCartUseCase get addToCartUseCase =>
      DI.container.read(DI.addToCartUseCaseProvider);
  UpdateCartItemCountUseCase get updateCartItemCountUseCase =>
      DI.container.read(DI.updateCartItemCountUseCaseProvider);
  RemoveFromCartUseCase get removeFromCartUseCase =>
      DI.container.read(DI.removeFromCartUseCaseProvider);
  ClearCartUseCase get clearCartUseCase =>
      DI.container.read(DI.clearCartUseCaseProvider);
}
