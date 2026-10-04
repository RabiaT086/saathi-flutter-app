import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../services/shake_detection_service.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'emergency_screen.dart';

/// Wraps the three main tabs (Home, AI Assistant, Profile) behind a single
/// persistent bottom navigation bar. Uses a nested Navigator for the Home
/// tab so sub-screens (My Cases, Report, Emergency, etc.) keep the bottom
/// navigation bar visible at all times.
/// Also hosts the Phone Shake Detector (FR-04) for immediate emergency triggering.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;
  final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Start listening for shake events across the student shell
    ShakeDetectionService.startListening(
      onShakeTriggered: () {
        if (!mounted) return;
        // Navigate or pop to emergency screen with automatic trigger
        homeNavigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const EmergencyScreen(autoTriggerFromShake: true),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    ShakeDetectionService.stopListening();
    super.dispose();
  }

  void goToTab(int index) {
    if (index == currentIndex && index == 0) {
      homeNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() {
      currentIndex = index;
    });
  }

  void _handlePop(bool didPop) {
    if (didPop) return;
    if (currentIndex != 0) {
      goToTab(0);
      return;
    }
    if (homeNavigatorKey.currentState?.canPop() == true) {
      homeNavigatorKey.currentState?.pop();
    }
  }

  late final List<Widget> tabs = [
    Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => HomeScreen(onOpenAIAssistant: () => goToTab(1)),
        );
      },
    ),
    ChatScreen(onBackToHome: () => goToTab(0)),
    ProfileScreen(onBackToHome: () => goToTab(0)),
  ];

  @override
  Widget build(BuildContext context) {
    final bool canPop = currentIndex == 0 && !(homeNavigatorKey.currentState?.canPop() ?? false);

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) => _handlePop(didPop),
      child: AnimatedBuilder(
        animation: AppState.listenable,
        builder: (context, _) {
          return Scaffold(
            body: IndexedStack(index: currentIndex, children: tabs),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: goToTab,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted,
              backgroundColor: AppColors.cardBackground,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: AppText.of(context, 'home')),
                BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline_rounded), label: AppText.of(context, 'ai_assistant')),
                BottomNavigationBarItem(icon: const Icon(Icons.person_outline_rounded), label: AppText.of(context, 'profile')),
              ],
            ),
          );
        },
      ),
    );
  }
}