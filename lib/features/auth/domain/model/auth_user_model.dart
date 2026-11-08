class AuthUserModel {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? accessToken;

  const AuthUserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.accessToken,
  });

  String get fullName =>
      [firstName, lastName].where((s) => s != null && s.isNotEmpty).join(' ');

  @override
  String toString() =>
      'AuthUserModel(id: $id, email: $email, fullName: $fullName)';
}

