import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';
import '../../services/journal_service.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final controller = TextEditingController();

  int get charCount {
    final text = controller.text.trim();
    if (text.isEmpty) return 0;
    return text.length;
  }

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    const int minChars = 30;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/blue_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Free Write Entry",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: const [
                    Icon(Icons.access_time, color: Colors.white70, size: 16),
                    SizedBox(width: 6),
                    Text(
                      "Write freely for 5 minutes",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06), 
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Today's Thoughts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Let your thoughts flow freely. There's no right or wrong way to journal - every word you write is a step towards better self-understanding.",
                      style: TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: null,
                        expands: true,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Start writing here...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          charCount < minChars
                              ? "Write ${minChars - charCount} more characters"
                              : "Great progress!",
                          style: const TextStyle(color: Colors.white70),
                        ),

                        ElevatedButton.icon(
                          onPressed: charCount < minChars || isSaving
                              ? null
                              : () async {
                                  setState(() => isSaving = true);

                                  await JournalService.saveEntry(controller.text);

                                  context.go('/journal-success');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor:
                                Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.send, color: Colors.white, size: 18),
                          label: isSaving
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "SAVE ENTRY",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}