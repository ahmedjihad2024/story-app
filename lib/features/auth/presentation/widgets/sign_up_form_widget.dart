import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/forms/app_text_form_field.dart';
import '../riverpod/sign_up_controller.dart';
import 'sign_up_name_row_widget.dart';

class SignUpFormWidget extends ConsumerStatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  ConsumerState<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends ConsumerState<SignUpFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final success = await ref.read(signUpControllerProvider.notifier).signUp(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: ColorM.success,
        ),
      );
      context.goNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = ref.watch(
      signUpControllerProvider.select((s) => s.errorMessage),
    );
    final isLoading = ref.watch(
      signUpControllerProvider.select((s) => s.reqState.isLoading),
    );
    final notifier = ref.read(signUpControllerProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorM.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: ColorM.error,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        color: ColorM.error,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: ColorM.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: notifier.clearError,
                  ),
                ],
              ),
            ),
          ],
          SignUpNameRowWidget(
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            firstNameValidator: (val) => _validateName(val, 'First name'),
            lastNameValidator: (val) => _validateName(val, 'Last name'),
          ),
          const SizedBox(height: 24),
          AppTextFormField(
            label: 'Email',
            hintText: 'alex@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          const SizedBox(height: 24),
          AppTextFormField(
            label: 'Password',
            hintText: '••••••••',
            controller: _passwordController,
            isPassword: true,
            textInputAction: TextInputAction.next,
            validator: _validatePassword,
          ),
          const SizedBox(height: 24),
          AppTextFormField(
            label: 'Confirm Password',
            hintText: '••••••••',
            controller: _confirmPasswordController,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: _validateConfirmPassword,
            onFieldSubmitted: (_) => _submitForm(),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            title: 'Create Account',
            isLoading: isLoading,
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}
