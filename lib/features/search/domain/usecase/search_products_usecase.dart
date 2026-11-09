import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../home/domain/model/product_model.dart';
import '../../data/request/search_products_request.dart';
import '../repository/search_repository.dart';

class SearchProductsUseCase {
  final SearchRepository _repository;

  const SearchProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductModel>>> call(
    SearchProductsRequest request,
  ) {
    return _repository.searchProducts(request);
  }
}

