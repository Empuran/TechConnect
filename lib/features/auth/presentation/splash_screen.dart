import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:nila/core/theme/app_theme.dart';
import 'package:nila/features/auth/presentation/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _moonController;
  late AnimationController _textController;
  late Animation<double> _moonScale;
  late Animation<double> _moonOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _moonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _moonScale = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _moonController, curve: Curves.elasticOut));
    _moonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _moonController, curve: const Interval(0.0, 0.5)));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_textController);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _moonController.forward().then((_) {
      _textController.forward();
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pushReplacement(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ));
        }
      });
    });
  }

  @override
  void dispose() {
    _moonController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Moon Icon
            AnimatedBuilder(
              animation: _moonController,
              builder: (_, __) => Opacity(
                opacity: _moonOpacity.value,
                child: Transform.scale(
                  scale: _moonScale.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 30, spreadRadius: 5),
                      ],
                    ),
                    child: const Icon(Icons.nightlight_round, color: Colors.white, size: 52),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Wordmark
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Column(
                  children: [
                    Text('nila', style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 48,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    )),
                    const SizedBox(height: 8),
                    Text(
                      'Find your moon',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        letterSpacing: 2,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
