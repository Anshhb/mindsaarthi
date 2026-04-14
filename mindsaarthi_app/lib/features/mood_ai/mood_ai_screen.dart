import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoodAIScreen extends StatelessWidget {
  const MoodAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Mood Analysis",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Understand your emotions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Analyze your mood using AI-powered vision tools",
              style: TextStyle(color: Colors.white54),
            ),

            const SizedBox(height: 30),

            // FACE ANALYSIS CARD
            _featureCard(
              context,
              title: "Face Analysis",
              subtitle: "Detect mood through facial expressions",
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ),
              icon: Icons.face,
              onTap: () => context.push('/vision'),
            ),

            const SizedBox(height: 20),

            // VIDEO ANALYSIS CARD
            _featureCard(
              context,
              title: "Video Analysis",
              subtitle: "Analyze mood from recorded/live video",
              gradient: LinearGradient(
                colors: [Color(0xFF00C9A7), Color(0xFF007A7C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              icon: Icons.videocam,
              onTap: () => context.push('/video'),
            ),
          ],
        ),
      ),
    );
  }

  //  gradient: const LinearGradient(
  // colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
  // ),
  Widget _featureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
