import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

/// Wraps the three main tabs (Home, AI Assistant, Profile) behind a single
/// bottom navigation bar, matching the Saathi prototype's tab structure.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  void goToTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  late final List<Widget> tabs = [
    HomeScreen(onOpenAIAssistant: () => goToTab(1)),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isUrdu,
      builder: (context, _, __) {
        return Scaffold(
          body: IndexedStack(index: currentIndex, children: tabs),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: goToTab,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: AppText.of(context, 'home')),
              BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline_rounded), label: AppText.of(context, 'ai_assistant')),
              BottomNavigationBarItem(icon: const Icon(Icons.person_outline_rounded), label: AppText.of(context, 'profile')),
            ],
          ),
        );
      },
    );
  }
}
