import 'package:flutter/material.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../widgets/sign_in_footer_widget.dart';
import '../widgets/sign_in_form_widget.dart';
import '../widgets/sign_in_header_widget.dart';
import '../widgets/social_login_buttons_widget.dart';
import '../widgets/social_login_divider_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;

  Future<void> _handleSignIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome back, $email!'),
        backgroundColor: ColorM.success,
      ),
    );
    Navigator.pushReplacementNamed(context, Routes.home);
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot Password flow'),
      ),
    );
  }

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-in clicked'),
      ),
    );
  }

  void _handleAppleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple Sign-in clicked'),
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.pushReplacementNamed(context, Routes.signUp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorM.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const SignInHeaderWidget(),
              const SizedBox(height: 28),
              SignInFormWidget(
                isLoading: _isLoading,
                onSignIn: _handleSignIn,
                onForgotPassword: _handleForgotPassword,
              ),
              const SizedBox(height: 28),
              const SocialLoginDividerWidget(),
              const SizedBox(height: 20),
              SocialLoginButtonsWidget(
                onGoogleTap: _handleGoogleLogin,
                onAppleTap: _handleAppleLogin,
              ),
              const SizedBox(height: 32),
              SignInFooterWidget(
                onCreateAccountTap: _navigateToSignUp,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
