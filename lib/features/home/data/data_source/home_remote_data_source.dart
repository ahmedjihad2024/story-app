import '../api/home_api_services.dart';
import '../response/home_response.dart';

abstract class HomeRemoteDataSource {
  Future<HomeData> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HomeApiServices _apiService;

  HomeRemoteDataSourceImpl(this._apiService);

  @override
  Future<HomeData> getHomeData() {
    return _apiService.homeData();
  }
}
