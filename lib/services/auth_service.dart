import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Centralized service for Firebase Authentication operations.
/// Follows the existing service pattern in lib/services/ without duplicating UI logic.
class AuthService {
  // Singleton pattern for easy and consistent access throughout the app
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of user authentication state changes.
  /// Automatically emits whenever a user logs in or logs out.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Currently authenticated Firebase user (null if not logged in).
  User? get currentUser => _auth.currentUser;

  /// Whether a user is currently signed in.
  bool get isAuthenticated => _auth.currentUser != null;

  /// Sign in with Email and Password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential;
    } catch (e) {
      debugPrint('AuthService.signInWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  /// Register / Sign Up with Email, Password and optional Display Name
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update user display name if provided
      if (displayName != null && displayName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
        await credential.user?.reload();
      }

      return credential;
    } catch (e) {
      debugPrint('AuthService.signUpWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  /// Send password reset instructions to the given email address
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      debugPrint('AuthService.sendPasswordResetEmail error: $e');
      rethrow;
    }
  }

  /// Change / update current user password with re-authentication
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found.',
      );
    }

    try {
      // Re-authenticate user before changing sensitive password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword.trim(),
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword.trim());
    } catch (e) {
      debugPrint('AuthService.updatePassword error: $e');
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('AuthService.signOut error: $e');
      rethrow;
    }
  }

  /// Translates FirebaseAuthException and generic errors into user-friendly messages.
  static String getFriendlyErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not formatted correctly.';
        case 'user-disabled':
          return 'This user account has been disabled. Please contact support.';
        case 'user-not-found':
          return 'No account found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Invalid email or password. Please verify your details.';
        case 'email-already-in-use':
          return 'An account already exists with this email address. Please sign in instead.';
        case 'weak-password':
          return 'The password is too weak. Please use at least 6 characters.';
        case 'operation-not-allowed':
          return 'Email/Password sign-in is not enabled in Firebase Console.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please wait a few moments and try again.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';
        case 'requires-recent-login':
          return 'This operation is sensitive and requires recent login. Please log in again.';
        default:
          return error.message ?? 'Authentication error occurred (${error.code}).';
      }
    }
    return error.toString();
  }
}
