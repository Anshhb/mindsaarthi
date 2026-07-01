import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindsaarthi_app/core/widgets/mind_loader.dart';
import '../../services/journal_service.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  bool hasNavigated = false;
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();

    sheetController.addListener(() {
      if (sheetController.size > 0.75 && !hasNavigated) {
        hasNavigated = true;

        context.push('/journal-new').then((_) {
          hasNavigated = false;

          sheetController.jumpTo(0.18);
        });
      }
    });

    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final fetched = await JournalService.getSuggestions();
    setState(() {
      suggestions = fetched;
    });
  }

  Widget suggestedTopics() {
    if (suggestions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: PremiumMindLoader(message: "Fetching some inspiration for your journal entry..."),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suggested Topics",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 300 + (index * 100)),
                tween: Tween(begin: 0.8, end: 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF0F2027).withOpacity(0.8),
                        const Color(0xFF203A43).withOpacity(0.8),
                      ],
                    ),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_border, color: Colors.orange),

                      const SizedBox(height: 12),

                      Expanded(
                        child: Text(
                          suggestions[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget mindNoteSlider() {
    return DraggableScrollableSheet(
      controller: sheetController,
      initialChildSize: 0.18,
      minChildSize: 0.18,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1C1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 10),

                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Swipe up to add your mind note",
                  style: TextStyle(color: Colors.white54),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD2A8FF), Color(0xFF9D4EDD)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 80,
                        child: Image.asset(
                          "assets/images/emoji2/Chill.png",
                          height: 120,
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Mind Note",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A0A0E), Color(0xFF121212)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Let’s add your\nmind note",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Swipe up on the bottom card to start a new journal entry.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: suggestedTopics(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: mindNoteSlider()),
        ],
      ),
    );
  }
}
