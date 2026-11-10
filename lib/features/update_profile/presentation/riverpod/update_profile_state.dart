import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../../../core/enums/req_state.dart';

class UpdateProfileState {
  final ReqState reqState;
  final bool isInitialized;
  final bool isFetchingInitial;
  final String? errorMessage;
  final String initialFirstName;
  final String initialLastName;
  final String initialEmail;
  final String? initialImageUrl;
  final XFile? pickedImage;
  final Uint8List? pickedImageBytes;
  final bool emailConfirmationPending;

  const UpdateProfileState({
    this.reqState = ReqState.idle,
    this.isInitialized = false,
    this.isFetchingInitial = false,
    this.errorMessage,
    this.initialFirstName = '',
    this.initialLastName = '',
    this.initialEmail = '',
    this.initialImageUrl,
    this.pickedImage,
    this.pickedImageBytes,
    this.emailConfirmationPending = false,
  });

  UpdateProfileState copyWith({
    ReqState? reqState,
    bool? isInitialized,
    bool? isFetchingInitial,
    String? errorMessage,
    String? initialFirstName,
    String? initialLastName,
    String? initialEmail,
    String? initialImageUrl,
    bool clearInitialImageUrl = false,
    XFile? pickedImage,
    Uint8List? pickedImageBytes,
    bool clearPickedImage = false,
    bool? emailConfirmationPending,
  }) {
    return UpdateProfileState(
      reqState: reqState ?? this.reqState,
      isInitialized: isInitialized ?? this.isInitialized,
      isFetchingInitial: isFetchingInitial ?? this.isFetchingInitial,
      errorMessage: errorMessage,
      initialFirstName: initialFirstName ?? this.initialFirstName,
      initialLastName: initialLastName ?? this.initialLastName,
      initialEmail: initialEmail ?? this.initialEmail,
      initialImageUrl:
          clearInitialImageUrl ? null : (initialImageUrl ?? this.initialImageUrl),
      pickedImage: clearPickedImage ? null : (pickedImage ?? this.pickedImage),
      pickedImageBytes: clearPickedImage
          ? null
          : (pickedImageBytes ?? this.pickedImageBytes),
      emailConfirmationPending:
          emailConfirmationPending ?? this.emailConfirmationPending,
    );
  }

  bool get isLoading => reqState.isLoading;
  bool get isSuccess => reqState.isSuccess;
  bool get isError => reqState.isError;
}

