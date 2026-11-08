import 'package:flutter/material.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../widgets/sign_up_footer_widget.dart';
import '../widgets/sign_up_form_widget.dart';
import '../widgets/sign_up_header_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _navigateToSignIn(BuildContext context) {
    context.goNamed(Routes.signIn);
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
              const SizedBox(height: 8),
              const SignUpHeaderWidget(),
              const SizedBox(height: 40),
              const SignUpFormWidget(),
              const SizedBox(height: 32),
              SignUpFooterWidget(
                onSignInTap: () => _navigateToSignIn(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
