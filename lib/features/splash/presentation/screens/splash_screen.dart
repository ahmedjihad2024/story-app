import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Smooth delay for splash animation
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    if (isLoggedIn) {
      context.goNamed(Routes.home);
    } else {
      context.goNamed(Routes.signIn);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Brand Logo Box
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: ColorM.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ColorM.primary.withValues(alpha: 0.35),
                        offset: const Offset(0, 10),
                        blurRadius: 24,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/svg/storey_logo.svg',
                    width: 44,
                    height: 44,
                    colorFilter: const ColorFilter.mode(
                      ColorM.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'STOREY',
                  style: TextStyle(
                    fontFamily: FontsM.inter.name,
                    fontSize: 28,
                    fontWeight: FontWeightM.extraBold,
                    letterSpacing: 1.2,
                    color: ColorM.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Premium Tech & Lifestyle Store',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeightM.medium,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: ColorM.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

