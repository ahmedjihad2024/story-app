import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../model/home_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> getHomeData();
}
