import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import 'welcome_screen.dart';
import 'main_shell.dart';

/// AuthGate listens to Firebase auth state changes in real time.
/// - If the user is authenticated: routes to [MainShell] (home/dashboard).
/// - If the user is not authenticated: routes to [WelcomeScreen].
/// - Handles session persistence across app restarts seamlessly.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // While Firebase is checking persisted authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  SizedBox(height: 24),
                  CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                ],
              ),
            ),
          );
        }

        // If authenticated user exists, show MainShell
        if (snapshot.hasData && snapshot.data != null) {
          return const MainShell();
        }

        // If logged out or unauthenticated, show WelcomeScreen
        return const WelcomeScreen();
      },
    );
  }
}
