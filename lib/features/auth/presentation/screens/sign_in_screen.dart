import 'package:flutter/material.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../widgets/sign_in_footer_widget.dart';
import '../widgets/sign_in_form_widget.dart';
import '../widgets/sign_in_header_widget.dart';
import '../widgets/social_login_buttons_widget.dart';
import '../widgets/social_login_divider_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void _handleForgotPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot Password flow'),
      ),
    );
  }

  void _handleGoogleLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-in clicked'),
      ),
    );
  }

  void _handleAppleLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple Sign-in clicked'),
      ),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    context.goNamed(Routes.signUp);
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
                onForgotPassword: () => _handleForgotPassword(context),
              ),
              const SizedBox(height: 28),
              const SocialLoginDividerWidget(),
              const SizedBox(height: 20),
              SocialLoginButtonsWidget(
                onGoogleTap: () => _handleGoogleLogin(context),
                onAppleTap: () => _handleAppleLogin(context),
              ),
              const SizedBox(height: 32),
              SignInFooterWidget(
                onCreateAccountTap: () => _navigateToSignUp(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
