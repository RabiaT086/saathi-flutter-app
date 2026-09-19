import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../services/supabase_service.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'main_shell.dart';
import 'admin_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool _isLoading = false;

  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await SupabaseService.signInStudent(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (res['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainShell()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Login failed. Please check your credentials.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void loginAsAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_outlined, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppText.of(context, 'welcome_back'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppText.of(context, 'sign_in_subtitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppText.of(context, 'university_email'), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'name@example.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppText.of(context, 'password'), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        AppText.of(context, 'forgot_password'),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(AppText.of(context, 'login'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(text: AppText.of(context, 'no_account')),
                          TextSpan(
                            text: AppText.of(context, 'create_account'),
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.cardBorder),
                  const SizedBox(height: 10),
                  Text(AppText.of(context, 'authorised_authority'), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  TextButton(
                    onPressed: loginAsAdmin,
                    child: Text(
                      AppText.of(context, 'admin_login'),
                      style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
