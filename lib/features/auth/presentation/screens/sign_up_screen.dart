import 'package:flutter/material.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../widgets/sign_up_footer_widget.dart';
import '../widgets/sign_up_form_widget.dart';
import '../widgets/sign_up_header_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;

  Future<void> _handleSignUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account created for $firstName!'),
        backgroundColor: ColorM.success,
      ),
    );
  }

  void _navigateToSignIn() {
    Navigator.pushNamed(context, Routes.signIn);
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
              SignUpFormWidget(
                isLoading: _isLoading,
                onSignUp: _handleSignUp,
              ),
              const SizedBox(height: 32),
              SignUpFooterWidget(
                onSignInTap: _navigateToSignIn,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
