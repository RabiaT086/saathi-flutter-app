import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final universityIdController = TextEditingController();
  final emergencyNameController = TextEditingController();
  final emergencyNumberController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _isLoading = false;

  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
  final phoneRegex = RegExp(r'^(?:\+92|0092|0)?3[0-9]{9}$');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    universityIdController.dispose();
    emergencyNameController.dispose();
    emergencyNumberController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final universityId = universityIdController.text.trim();
    final emergencyName = emergencyNameController.text.trim();
    final emergencyNumber = emergencyNumberController.text.trim();

    // Validation checks
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.')),
      );
      return;
    }

    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters long.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    if (universityId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your student / university ID.')),
      );
      return;
    }

    if (emergencyNumber.isNotEmpty && !phoneRegex.hasMatch(emergencyNumber.replaceAll(RegExp(r'\s+|-'), ''))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid emergency phone number (e.g., 03001234567).')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await SupabaseService.signUpStudent(
        email: email,
        password: password,
        fullName: name,
        universityId: universityId,
        emergencyName: emergencyName.isNotEmpty ? emergencyName : null,
        emergencyPhone: emergencyNumber.isNotEmpty ? emergencyNumber : null,
      );

      if (!mounted) return;

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please log in.'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Sign up failed. Please try again.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(AppText.of(context, 'join_saathi'), style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.of(context, 'signup_subtitle'),
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 25),

                  _label(AppText.of(context, 'full_name')),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Areesha Naz'),
                  ),
                  const SizedBox(height: 18),

                  _label(AppText.of(context, 'university_email')),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'name@fuuast.edu.pk', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 18),

                  _label(AppText.of(context, 'password')),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: AppText.of(context, 'at_least_6_chars'),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  _label(AppText.of(context, 'confirm_password')),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: AppText.of(context, 'reenter_password'),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  _label(AppText.of(context, 'student_university_id')),
                  TextField(
                    controller: universityIdController,
                    decoration: const InputDecoration(hintText: 'e.g. FUU-CS-2022-114', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 18),

                  _label(AppText.of(context, 'emergency_contact_name')),
                  TextField(
                    controller: emergencyNameController,
                    decoration: InputDecoration(hintText: AppText.of(context, 'relation_hint'), border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 18),

                  _label(AppText.of(context, 'emergency_contact_number')),
                  TextField(
                    controller: emergencyNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: '0300 1234567', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : createAccount,
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
                          : Text(AppText.of(context, 'create_account'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          children: [
                            TextSpan(text: AppText.of(context, 'already_registered')),
                            TextSpan(
                              text: AppText.of(context, 'login'),
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
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
