import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/forms/app_text_form_field.dart';
import 'remember_me_and_forgot_password_widget.dart';

class SignInFormWidget extends StatefulWidget {
  final void Function({
    required String email,
    required String password,
    required bool rememberMe,
  }) onSignIn;

  final VoidCallback onForgotPassword;
  final bool isLoading;

  const SignInFormWidget({
    super.key,
    required this.onSignIn,
    required this.onForgotPassword,
    this.isLoading = false,
  });

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your username or email';
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

  void _submitForm() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _errorMessage = 'Please complete all required fields.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    widget.onSignIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorMessage != null) ...[
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
                      _errorMessage!,
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
                    onPressed: () {
                      setState(() => _errorMessage = null);
                    },
                  ),
                ],
              ),
            ),
          ],
          AppTextFormField(
            label: 'Username or Email',
            hintText: 'emilys',
            controller: _emailController,
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
          const SizedBox(height: 16),
          RememberMeAndForgotPasswordWidget(
            rememberMe: _rememberMe,
            onRememberMeChanged: (val) {
              setState(() => _rememberMe = val ?? false);
            },
            onForgotPassword: widget.onForgotPassword,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            title: 'Sign In',
            isLoading: widget.isLoading,
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}

