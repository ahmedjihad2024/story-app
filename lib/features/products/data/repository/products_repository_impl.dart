import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/error_handler.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../home/data/mapper/home_mapper.dart';
import '../../../home/domain/model/product_model.dart';
import '../../domain/repository/products_repository.dart';
import '../data_source/products_remote_data_source.dart';
import '../request/get_products_request.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  const ProductsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts(
    GetProductsRequest request,
  ) async {
    try {
      final rows = await _remoteDataSource.getProducts(request);
      final products = rows.map((r) => r.toDomain()).toList();
      return Right(products);
    } catch (e) {
      return Left(e.handle);
    }
  }
}

