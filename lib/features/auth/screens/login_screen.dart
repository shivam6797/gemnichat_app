import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemnichat_app/core/constant/app_colors.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_bloc.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_event.dart';
import 'package:gemnichat_app/features/auth/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/home');
        } else if (state is AuthFailure) {
          final errorMessage = state.message.isNotEmpty
              ? state.message
              : "Login failed. Please try again.";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },

      child: Scaffold(
        body: Center(
          child: Container(
            width: size.width > 600 ? 500 : double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_rounded, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                Text(
                  'GemniChat',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your personal AI assistant',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.asset('assets/icons/google.png', height: 24),
                    label: Text(
                      'Continue with Google',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(SignInWithGooglePressed());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'We never post anything without permission.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black38,
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
