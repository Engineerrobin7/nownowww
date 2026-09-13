import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nownowww/features/auth/presentation/controllers/auth_controller.dart';
import 'package:nownowww/features/auth/presentation/widgets/social_auth_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().split(':').last.trim()),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 80),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: Column(
                          children: [
                            Text(
                              'Welcome to',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'NOWNOWWW',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Share what you need.\nShare what you\'re thinking.\nNothing else.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 60),
                      if (authState.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                      else ...[
                        SocialAuthButton(
                          label: 'Continue with Google',
                          icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.white),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          onPressed: () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
                        ),
                        const SizedBox(height: 12),
                    SocialAuthButton(
                      label: 'Continue with Apple',
                      icon: const Icon(Icons.apple, color: Colors.black, size: 26),
                      onPressed: () => ref.read(authControllerProvider.notifier).signInWithApple(),
                    ),
                        const SizedBox(height: 12),
                        SocialAuthButton(
                          label: 'Continue with Email',
                          icon: const Icon(Icons.mail_outline, color: Colors.black),
                          onPressed: () => context.push('/signup'),
                        ),
                        const SizedBox(height: 12),
                    SocialAuthButton(
                      label: 'Continue with Phone',
                      icon: const Icon(Icons.phone_outlined, color: Colors.black),
                      onPressed: () => context.push('/login-phone'),
                    ),
                      ],
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('or', style: TextStyle(color: Colors.grey[400])),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text.rich(
                        TextSpan(
                          text: 'By continuing, you agree to our\n',
                          children: [
                            WidgetSpan(
                              child: InkWell(
                                onTap: () => context.push('/terms'),
                                child: const Text(
                                  'Terms of Service',
                                  style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 12),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            WidgetSpan(
                              child: InkWell(
                                onTap: () => context.push('/privacy'),
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?", style: TextStyle(color: Colors.grey[600])),
                          TextButton(
                            onPressed: () => context.push('/login-email'),
                            child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
