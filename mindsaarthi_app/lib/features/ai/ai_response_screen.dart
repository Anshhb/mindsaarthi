import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindsaarthi_app/services/ai_service.dart';

class AIResponseScreen extends StatefulWidget {
  final String mood;

  const AIResponseScreen({super.key, required this.mood});

  @override
  State<AIResponseScreen> createState() => _AIResponseScreenState();
}

class _AIResponseScreenState extends State<AIResponseScreen> {
  String reply = "";
  List<String> actions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAI();
  }

  Future<void> fetchAI() async {
  try {
    final res = await AIService.getAIResponse(widget.mood);

    setState(() {
      reply = res["reply"];
      actions = List<String>.from(res["actions"]);
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      reply = "Something went wrong. Try again.";
      actions = ["Retry", "Take a deep breath"];
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Mind Matters",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 💬 AI REPLY CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withOpacity(0.8),
                          Colors.blue.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      reply,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Suggested Actions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...actions.map((action) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                action,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const Spacer(),

                  // 🔘 CTA BUTTON
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C9A7), Color(0xFF007F5F)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}