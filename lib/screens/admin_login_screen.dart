import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/supabase_service.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  // Login fields
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final loginAuthorityIdController = TextEditingController();
  bool loginPasswordHidden = true;
  bool isLoggingIn = false;

  // Sign up fields
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupAuthorityIdController = TextEditingController();
  final signupDeptController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmController = TextEditingController();
  bool signupPasswordHidden = true;
  bool signupConfirmHidden = true;
  bool isSigningUp = false;

  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    loginEmailController.text = 'admin@fuuast.edu.pk';
    loginAuthorityIdController.text = 'AUTH-7821';
    loginPasswordController.text = 'admin123';
  }

  @override
  void dispose() {
    tabController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    loginAuthorityIdController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupAuthorityIdController.dispose();
    signupDeptController.dispose();
    signupPasswordController.dispose();
    signupConfirmController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();
    final authId = loginAuthorityIdController.text.trim();

    if (authId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Authority ID.')),
      );
      return;
    }

    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid official email.')),
      );
      return;
    }

    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters.')),
      );
      return;
    }

    setState(() => isLoggingIn = true);

    try {
      final res = await SupabaseService.signInAdmin(
        email: email,
        password: password,
        authorityId: authId,
      );

      if (!mounted) return;

      if (res['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Admin authentication failed.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoggingIn = false);
      }
    }
  }

  Future<void> handleSignup() async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final authId = signupAuthorityIdController.text.trim();
    final dept = signupDeptController.text.trim();
    final password = signupPasswordController.text.trim();
    final confirm = signupConfirmController.text.trim();

    if (name.isEmpty || email.isEmpty || authId.isEmpty || dept.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid official email.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters long.')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() => isSigningUp = true);

    try {
      final res = await SupabaseService.signUpStudent(
        email: email,
        password: password,
        fullName: name,
        universityId: authId,
      );

      if (!mounted) return;

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authority account created successfully. Please log in.'),
            backgroundColor: Colors.green,
          ),
        );
        tabController.animateTo(0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Registration failed.'), backgroundColor: AppColors.danger),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSigningUp = false);
      }
    }
  }

  void showForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Password'),
        content: const Text('Password reset instructions will be sent to your registered authority email once the backend is connected.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  InputDecoration fieldDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 34),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Authority Portal', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 4),
              const Text('For campus security & anti-harassment committee', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
              const SizedBox(height: 24),

              // Tab bar
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: TabBar(
                  controller: tabController,
                  indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.primaryDark,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Login'),
                    Tab(text: 'Sign Up'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 520,
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // LOGIN TAB
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(controller: loginAuthorityIdController, decoration: fieldDecoration('Authority ID')),
                          const SizedBox(height: 12),
                          TextField(
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: fieldDecoration('Official Email'),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: loginPasswordController,
                            obscureText: loginPasswordHidden,
                            decoration: fieldDecoration(
                              'Password',
                              suffixIcon: IconButton(
                                icon: Icon(loginPasswordHidden ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
                                onPressed: () => setState(() => loginPasswordHidden = !loginPasswordHidden),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(onPressed: showForgotPassword, child: const Text('Forgot password?')),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoggingIn ? null : handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: isLoggingIn
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SIGN UP TAB
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(controller: signupNameController, decoration: fieldDecoration('Full Name')),
                          const SizedBox(height: 12),
                          TextField(controller: signupAuthorityIdController, decoration: fieldDecoration('Authority ID')),
                          const SizedBox(height: 12),
                          TextField(
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: fieldDecoration('Official Email'),
                          ),
                          const SizedBox(height: 12),
                          TextField(controller: signupDeptController, decoration: fieldDecoration('Department / Designation')),
                          const SizedBox(height: 12),
                          TextField(
                            controller: signupPasswordController,
                            obscureText: signupPasswordHidden,
                            decoration: fieldDecoration(
                              'Password',
                              suffixIcon: IconButton(
                                icon: Icon(signupPasswordHidden ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
                                onPressed: () => setState(() => signupPasswordHidden = !signupPasswordHidden),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: signupConfirmController,
                            obscureText: signupConfirmHidden,
                            decoration: fieldDecoration(
                              'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(signupConfirmHidden ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
                                onPressed: () => setState(() => signupConfirmHidden = !signupConfirmHidden),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isSigningUp ? null : handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: isSigningUp
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
