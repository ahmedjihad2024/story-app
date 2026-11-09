import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../home/domain/model/category_model.dart';
import '../repository/search_repository.dart';

class GetFilterCategoriesUseCase {
  final SearchRepository _repository;

  const GetFilterCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryModel>>> call() {
    return _repository.getCategories();
  }
}

