class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? imageUrl;

  const ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.imageUrl,
  });

  String get fullName =>
      [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

  ProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    bool clearImageUrl = false,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      imageUrl.hashCode;

  @override
  String toString() =>
      'ProfileModel(id: $id, fullName: $fullName, email: $email, imageUrl: $imageUrl)';
}

