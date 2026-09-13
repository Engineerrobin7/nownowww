import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nownowww/features/auth/presentation/controllers/auth_controller.dart';
import 'package:nownowww/features/auth/presentation/widgets/auth_text_field.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _verifyPhone() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    ref.read(authControllerProvider.notifier).verifyPhoneNumber(
      phone,
      (id) => setState(() {
        _verificationId = id;
        _codeSent = true;
      }),
    );
  }

  void _signIn() {
    if (_verificationId == null) return;
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    ref.read(authControllerProvider.notifier).signInWithPhoneNumber(
          _verificationId!,
          code,
        );
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _codeSent ? 'Enter Code' : 'Phone Login',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _codeSent
                    ? 'We sent a 6-digit code to ${_phoneController.text}'
                    : 'Enter your phone number to continue',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 48),
              if (!_codeSent)
                AuthTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  hintText: '+1 123 456 7890',
                  keyboardType: TextInputType.phone,
                )
              else
                AuthTextField(
                  controller: _codeController,
                  labelText: 'Verification Code',
                  hintText: '123456',
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : (_codeSent ? _signIn : _verifyPhone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _codeSent ? 'Verify & Login' : 'Send Code',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              if (_codeSent)
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _codeSent = false),
                    child: const Text('Change Phone Number', style: TextStyle(color: Colors.black)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
