import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/journal_service.dart';

class JournalNewScreen extends StatefulWidget {
  const JournalNewScreen({super.key});

  @override
  State<JournalNewScreen> createState() => _JournalNewScreenState();
}

class _JournalNewScreenState extends State<JournalNewScreen> {
  final controller = TextEditingController();
  bool isSaving = false;

  int get charCount => controller.text.trim().length;

  @override
  Widget build(BuildContext context) {
    const int minChars = 30;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9D4EDD), Color(0xFF5A189A)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Let’s add your mind note",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Write what you feel. No judgment.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        controller: controller,
                        maxLines:23,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Start writing here...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Text(
                          "${controller.text.trim().length}/30",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap:
                  charCount < minChars || isSaving
                      ? null
                      : () async {
                        setState(() => isSaving = true);
                        await JournalService.saveEntry(controller.text);
                        if (!mounted) return;
                        context.go('/journal-success');
                      },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: charCount < minChars
                      ? const LinearGradient(
                          colors: [Color(0xFF333333), Color(0xFF555555)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF9D4EDD), Color(0xFF5A189A)],
                        ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Entry",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
