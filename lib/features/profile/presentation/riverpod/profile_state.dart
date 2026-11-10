import 'package:image_picker/image_picker.dart';
import '../../../../core/enums/req_state.dart';

class ProfileState {
  final ReqState reqState;
  final String? errorMessage;
  final String firstName;
  final String lastName;
  final String email;
  final String? imageUrl;
  final XFile? image;
  final bool isSigningOut;
  final String? signOutError;

  const ProfileState({
    this.reqState = ReqState.idle,
    this.errorMessage,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.imageUrl,
    this.image,
    this.isSigningOut = false,
    this.signOutError,
  });

  String get fullName =>
      [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

  String get displayName => fullName.isNotEmpty ? fullName : email;

  ProfileState copyWith({
    ReqState? reqState,
    String? errorMessage,
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    bool clearImageUrl = false,
    XFile? image,
    bool clearImage = false,
    bool? isSigningOut,
    String? signOutError,
    bool clearSignOutError = false,
  }) {
    return ProfileState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      image: clearImage ? null : (image ?? this.image),
      isSigningOut: isSigningOut ?? this.isSigningOut,
      signOutError: clearSignOutError
          ? null
          : (signOutError ?? this.signOutError),
    );
  }

  bool get isLoading => reqState.isLoading;
  bool get isSuccess => reqState.isSuccess;
  bool get isError => reqState.isError;
  bool get isIdle => reqState.isIdle;
}
