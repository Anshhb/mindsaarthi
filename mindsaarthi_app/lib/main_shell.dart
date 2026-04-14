import 'package:flutter/material.dart';
import 'package:mindsaarthi_app/features/mood_ai/mood_ai_screen.dart';
import 'features/home/home_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/analytics/analytics_screen.dart';
import 'core/widgets/bottom_navbar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final pages = const [HomeScreen(), ChatScreen(), AnalyticsScreen(), MoodAIScreen()];

  void onTabChange(int i) {
    setState(() => index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          pages[index],

          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: BottomNavbar(currentIndex: index, onTap: onTabChange),
          ),
        ],
      ),
    );
  }
}
