import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../home/domain/model/category_model.dart';
import '../../../home/domain/model/product_model.dart';
import '../../data/request/search_products_request.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ProductModel>>> searchProducts(
    SearchProductsRequest request,
  );
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}

