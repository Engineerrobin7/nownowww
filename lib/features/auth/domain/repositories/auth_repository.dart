import '../../domain/models/auth_user.dart';

abstract class IAuthRepository {
  Stream<AuthUser?> get authStateChanges;
  
  Future<AuthUser?> signInWithEmailAndPassword(String email, String password);
  
  Future<AuthUser?> signUpWithEmailAndPassword(String email, String password);
  
  Future<AuthUser?> signInWithGoogle();
  
  Future<AuthUser?> signInWithApple();
  
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onError,
  });

  Future<AuthUser?> signInWithPhoneNumber(String verificationId, String smsCode);

  Future<void> sendPasswordResetEmail(String email);
  
  Future<void> signOut();
  
  Future<void> deleteAccount();
  
  AuthUser? get currentUser;
}
