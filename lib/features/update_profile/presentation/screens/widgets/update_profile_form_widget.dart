import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/extensions/navigation_extension.dart';
import '../../../../../core/shared/features/profile/domain/model/profile_model.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/forms/app_text_form_field.dart';
import '../../riverpod/update_profile_controller.dart';
import '../../riverpod/update_profile_state.dart';
import 'update_profile_avatar_picker_widget.dart';
import 'update_profile_error_banner_widget.dart';
import 'update_profile_name_row_widget.dart';

class UpdateProfileFormWidget extends ConsumerStatefulWidget {
  final ProfileModel? initialProfile;

  const UpdateProfileFormWidget({
    super.key,
    this.initialProfile,
  });

  @override
  ConsumerState<UpdateProfileFormWidget> createState() =>
      _UpdateProfileFormWidgetState();
}

class _UpdateProfileFormWidgetState
    extends ConsumerState<UpdateProfileFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final Listenable _fieldsListenable;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.initialProfile?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.initialProfile?.lastName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialProfile?.email ?? '',
    );
    _fieldsListenable = Listenable.merge([
      _firstNameController,
      _lastNameController,
      _emailController,
    ]);

    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(updateProfileControllerProvider.notifier)
          .initialize(widget.initialProfile);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, String fieldName) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return '$fieldName is required';
    }
    if (name.length < 2) {
      return 'Min 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your email address';
    }
    final emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!emailPattern.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  bool _hasChanges(UpdateProfileState state) {
    if (!state.isInitialized) return false;
    return _firstNameController.text.trim() != state.initialFirstName.trim() ||
        _lastNameController.text.trim() != state.initialLastName.trim() ||
        _emailController.text.trim() != state.initialEmail.trim() ||
        state.pickedImage != null;
  }

  Future<void> _pickAvatar() async {
    FocusScope.of(context).unfocus();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const UpdateProfileImageSourceSheet(),
    );
    if (source == null || !mounted) return;

    await ref.read(updateProfileControllerProvider.notifier).pickImage(source);
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final success =
        await ref.read(updateProfileControllerProvider.notifier).updateProfile(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
            );

    if (!success || !mounted) return;

    final emailPending =
        ref.read(updateProfileControllerProvider).emailConfirmationPending;
    final message = emailPending
        ? 'Profile updated! Please confirm your new email from your inbox.'
        : 'Profile updated successfully!';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorM.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UpdateProfileState>(updateProfileControllerProvider, (
      prev,
      next,
    ) {
      if (prev?.isFetchingInitial == true &&
          !next.isFetchingInitial &&
          next.isInitialized) {
        _firstNameController.text = next.initialFirstName;
        _lastNameController.text = next.initialLastName;
        _emailController.text = next.initialEmail;
      }
    });

    final state = ref.watch(updateProfileControllerProvider);
    final notifier = ref.read(updateProfileControllerProvider.notifier);

    if (state.isFetchingInitial) {
      return const SizedBox(
        height: 320,
        child: Center(
          child: CircularProgressIndicator(color: ColorM.primary),
        ),
      );
    }

    if (!state.isInitialized && state.errorMessage != null) {
      return _UpdateProfileFetchError(
        message: state.errorMessage!,
        onRetry: notifier.loadInitialProfile,
      );
    }

    final isLoading = state.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: UpdateProfileAvatarPickerWidget(
              imageUrl: state.initialImageUrl,
              pickedImageBytes: state.pickedImageBytes,
              enabled: !isLoading,
              onPickTap: _pickAvatar,
              onClearPickedTap: notifier.clearPickedImage,
            ),
          ),
          const SizedBox(height: 28),
          if (state.errorMessage != null)
            UpdateProfileErrorBannerWidget(
              message: state.errorMessage!,
              onDismiss: notifier.clearError,
            ),
          UpdateProfileNameRowWidget(
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            enabled: !isLoading,
            firstNameValidator: (val) => _validateName(val, 'First name'),
            lastNameValidator: (val) => _validateName(val, 'Last name'),
          ),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: _fieldsListenable,
            builder: (context, _) {
              final hasChanges = _hasChanges(state);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextFormField(
                    label: 'Email',
                    hintText: 'alex@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    enabled: !isLoading,
                    validator: _validateEmail,
                    onFieldSubmitted: (_) {
                      if (!isLoading && hasChanges) {
                        _submitForm();
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Changing your email may require confirmation via a verification link.',
                    style: TextStyle(
                      fontFamily: FontsM.inter.name,
                      fontSize: 12,
                      color: ColorM.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    title: 'Save Changes',
                    isLoading: isLoading,
                    onPressed: hasChanges ? _submitForm : null,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UpdateProfileFetchError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _UpdateProfileFetchError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 52,
                color: ColorM.textMuted,
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 14.5,
                  color: ColorM.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

