import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../home/domain/model/product_model.dart';
import '../../data/request/get_products_request.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts(
    GetProductsRequest request,
  );
}

