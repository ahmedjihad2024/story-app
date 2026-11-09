import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/forms/app_text_form_field.dart';
import '../riverpod/sign_in_controller.dart';

class SignInFormWidget extends ConsumerStatefulWidget {
  final VoidCallback onForgotPassword;

  const SignInFormWidget({
    super.key,
    required this.onForgotPassword,
  });

  @override
  ConsumerState<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends ConsumerState<SignInFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    final emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!emailPattern.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final success = await ref.read(signInControllerProvider.notifier).signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully signed in!'),
          backgroundColor: ColorM.success,
        ),
      );
      context.goNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = ref.watch(
      signInControllerProvider.select((s) => s.errorMessage),
    );
    final isLoading = ref.watch(
      signInControllerProvider.select((s) => s.reqState.isLoading),
    );
    final notifier = ref.read(signInControllerProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
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
          AppTextFormField(
            label: 'Email',
            hintText: 'alex@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            label: 'Password',
            hintText: '••••••••••',
            controller: _passwordController,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            onFieldSubmitted: (_) => _submitForm(),
          ),
          // const SizedBox(height: 16),
          // RememberMeAndForgotPasswordWidget(
          //   onForgotPassword: widget.onForgotPassword,
          // ),
          const SizedBox(height: 24),
          PrimaryButton(
            title: 'Sign In',
            isLoading: isLoading,
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}
