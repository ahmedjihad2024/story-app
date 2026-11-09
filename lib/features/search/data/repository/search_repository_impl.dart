import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/error_handler.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../home/data/mapper/home_mapper.dart';
import '../../../home/domain/model/category_model.dart';
import '../../../home/domain/model/product_model.dart';
import '../../domain/repository/search_repository.dart';
import '../data_source/search_remote_data_source.dart';
import '../request/search_products_request.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  const SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(
    SearchProductsRequest request,
  ) async {
    try {
      final rows = await _remoteDataSource.searchProducts(request);
      final products = rows.map((r) => r.toDomain()).toList();
      return Right(products);
    } catch (e) {
      return Left(e.handle);
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final rows = await _remoteDataSource.getCategories();
      final categories = rows.map((r) => r.toDomain()).toList();
      return Right(categories);
    } catch (e) {
      return Left(e.handle);
    }
  }
}

