import 'package:image_picker/image_picker.dart';

class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final XFile? image;

  const UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.image,
  });

  bool get isEmpty =>
      firstName == null && lastName == null && email == null && image == null;

  UpdateProfileRequest copyWith({
    String? firstName,
    String? lastName,
    String? email,
    XFile? image,
  }) {
    return UpdateProfileRequest(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateProfileRequest &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          image?.path == other.image?.path;

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      (image?.path).hashCode;
}
