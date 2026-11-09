import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../home/domain/model/product_model.dart';
import '../../data/request/get_products_request.dart';
import '../repository/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductModel>>> call(GetProductsRequest request) {
    return _repository.getProducts(request);
  }
}

