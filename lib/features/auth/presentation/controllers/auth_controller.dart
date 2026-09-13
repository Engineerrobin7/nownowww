import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import '../providers/auth_providers.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  String _mapError(dynamic e) {
    if (e is FirebaseAuthException) {
      return e.message ?? 'An unknown error occurred';
    }
    return e.toString();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signUpWithEmailAndPassword(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signInWithApple();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String) onCodeSent,
  ) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).verifyPhoneNumber(
            phoneNumber: phoneNumber,
            onCodeSent: (id) {
              state = const AsyncValue.data(null);
              onCodeSent(id);
            },
            onError: (err) {
              state = AsyncValue.error(err, StackTrace.current);
            },
          );
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }

  Future<void> signInWithPhoneNumber(String verificationId, String smsCode) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signInWithPhoneNumber(verificationId, smsCode);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        // Set offline before signing out
        await ref.read(userRepositoryProvider).updatePresence(user.uid, false);
      }
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(_mapError(e), st);
    }
  }
}
