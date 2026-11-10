class FavoriteStatus {
  final bool isInFavorite;

  const FavoriteStatus({
    required this.isInFavorite,
  });

  FavoriteStatus copyWith({
    bool? isInFavorite,
  }) {
    return FavoriteStatus(
      isInFavorite: isInFavorite ?? this.isInFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteStatus &&
          runtimeType == other.runtimeType &&
          isInFavorite == other.isInFavorite;

  @override
  int get hashCode => isInFavorite.hashCode;

  @override
  String toString() => 'FavoriteStatus(isInFavorite: $isInFavorite)';
}

