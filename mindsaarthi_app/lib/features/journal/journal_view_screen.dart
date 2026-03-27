import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/colors.dart';

class JournalViewScreen extends StatefulWidget {
  final String text;
  final DateTime? timestamp;

  const JournalViewScreen({
    super.key,
    required this.text,
    this.timestamp,
  });

  @override
  State<JournalViewScreen> createState() => _JournalViewScreenState();
}

class _JournalViewScreenState extends State<JournalViewScreen> {
  int selectedTab = 0;

  String getFormattedDate() {
    final date = widget.timestamp ?? DateTime.now();
    return DateFormat('MMMM d, yyyy').format(date);
  }

  String getFormattedTime() {
    final date = widget.timestamp ?? DateTime.now();
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
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
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white),
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
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      getFormattedDate(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      getFormattedTime(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _buildTab("JOURNAL ENTRY", 0),
                    const SizedBox(width: 20),
                    _buildTab("AI ANALYSIS", 1),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: selectedTab == 0
                  ? _buildJournalContent()
                  : _buildComingSoon(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isActive = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white54,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2,
            width: 120,
            color: isActive ? Colors.white : Colors.transparent,
          ),
        ],
      ),
    );
  }
  Widget _buildJournalContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildComingSoon() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.auto_awesome, color: Colors.white54, size: 40),
          SizedBox(height: 10),
          Text(
            "AI Analysis Coming Soon",
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}