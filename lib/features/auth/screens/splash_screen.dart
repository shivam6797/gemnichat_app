import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/core/constant/app_colors.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_bloc.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_event.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// Dispatch event to check auth status
    context.read<AuthBloc>().add(AppStarted());
  }

  void _navigateAfterDelay(AuthState state) {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (state is Authenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated ||
              state is Unauthenticated ||
              state is AuthFailure) {
            _navigateAfterDelay(state);
          }
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: size.width > 600 ? 500 : double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'GemniChat',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Smart AI Chat Assistant',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
