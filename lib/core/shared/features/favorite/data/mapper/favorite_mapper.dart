import '../../domain/model/favorite_status.dart';
import '../response/favorite_status_response.dart';

extension FavoriteStatusResponseMapper on FavoriteStatusResponse {
  FavoriteStatus toDomain() {
    return FavoriteStatus(isInFavorite: isInFavorite);
  }
}

