import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/error_handler.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../domain/model/order_details_model.dart';
import '../../domain/repository/order_details_repository.dart';
import '../data_source/order_details_remote_data_source.dart';
import '../mapper/order_details_mapper.dart';
import '../response/order_details_response.dart';

class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  final OrderDetailsRemoteDataSource _remoteDataSource;

  const OrderDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, OrderDetailsModel>> getOrderById(String orderId) {
    return fastHandler<OrderDetailsResponse, OrderDetailsModel>(
      request: () => _remoteDataSource.getOrderById(orderId),
      mapper: (response) => response.toDomain(),
    );
  }
}

