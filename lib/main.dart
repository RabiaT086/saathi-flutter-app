import 'package:flutter/material.dart';
import 'app_state.dart';
import 'theme/app_colors.dart';
import 'screens/welcome_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> main() async {
  await Supabase.initialize(
    url: 'https://cvpfdgyccgponvyastub.supabase.co',
    anonKey: 'sb_publishable_xebqc_1uYKC4_BBmedIqtg_AK_DA6eM',
  );
  runApp(const SaathiApp());
}
class SaathiApp extends StatelessWidget {
  const SaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppState.themeMode,
      builder: (context, mode, _) {
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
            scaffoldBackgroundColor: AppColors.background,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
            ),
            fontFamily: 'Arial',
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
