import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app_state.dart';
import 'theme/app_colors.dart';
import 'screens/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using current platform options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  // Maintain existing Supabase initialization for complaints and storage
  try {
    await Supabase.initialize(
      url: 'https://cvpfdgyccgponvyastub.supabase.co',
      publishableKey:  'sb_publishable_xebqc_1uYKC4_BBmedIqtg_AK_DA6eM',
    );
  } catch (e) {
    debugPrint('Supabase initialization note: $e');
  }

  runApp(const SaathiApp());
}
class SaathiApp extends StatelessWidget {
  const SaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        final mode = AppState.themeMode.value;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Saathi',
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
            fontFamily: 'Arial',
            scaffoldBackgroundColor: const Color(0xFFFDF6EC),
            cardColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E),
            ),
            fontFamily: 'Arial',
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          home: const AuthGate(),
        );
      },
    );
  }
}
