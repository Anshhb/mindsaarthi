import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getTodayQuote() {
    final quotes = [
      "Happiness is a choice. Always choose it.",
      "You are stronger than you think.",
      "Every day is a fresh start.",
      "Your mental health matters.",
      "Small steps lead to big changes.",
    ];

    final day = DateTime.now().day;
    return quotes[day % quotes.length];
  }

  String _month(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[m - 1];
  }

  String _formatHour(int h) {
    final hour = h % 12 == 0 ? 12 : h % 12;
    return hour.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/mental_health.png", height: 28),
            const SizedBox(width: 8),
            const Text(
              "Mindsaarthi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage("assets/images/user_profile.png"),
            ),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
          
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: const Text(
                  "Welcome Back !",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
          
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: const Text(
                  "Thought of the day",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 10),
          
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(55),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    getTodayQuote(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              moodCard(3),
              const SizedBox(height: 20),
              checkIn(),
              const SizedBox(height: 30),
          
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push('/journal-entry'),
                      child: Container(
                        height: 120,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF8E2DE2),
                              const Color(0xFF4A00E0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.menu_book, color: Colors.white),
                            ),
                            Text(
                              "New Entry",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Write your thoughts",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2193b0),
                            const Color(0xFF6dd5ed),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Plan Day",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Schedule your activities",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          
              const SizedBox(height: 30),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Entries",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "VIEW ALL >",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          
              const SizedBox(height: 16),
          
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("journal")
                        .orderBy("timestamp", descending: true)
                        .limit(3)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
          
                  final docs = snapshot.data!.docs;
          
                  return Column(
                    children:
                        docs.map((doc) {
                          final timestamp = doc["timestamp"] as Timestamp?;
                          final date = timestamp?.toDate();
          
                          String formattedDate = "";
                          String formattedTime = "";
          
                          if (date != null) {
                            formattedDate = "${_month(date.month)} ${date.day}";
                            formattedTime =
                                "${_formatHour(date.hour)}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? "PM" : "AM"}";
                          }
          
                          return GestureDetector(
                            onTap:
                                () => context.push(
                                  '/journal-view',
                                  extra: {
                                    "text": doc["text"],
                                    "timestamp": doc["timestamp"],
                                  },
                                ),
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            formattedTime,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          "Free Write",
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    doc["text"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moodCard(double avgRisk) {
    String emoji;
    String label;

    if (avgRisk < 3) {
      emoji = "😊";
      label = "Good";
    } else if (avgRisk < 6) {
      emoji = "😐";
      label = "Moderate";
    } else {
      emoji = "😞";
      label = "Stressed";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget checkIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How are you feeling today?",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _emojiButton("😊", 2),
            _emojiButton("😐", 5),
            _emojiButton("😞", 8),
          ],
        ),
      ],
    );
  }

  Widget _emojiButton(String emoji, int value) {
    return GestureDetector(
      onTap: () async {
        final user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("mood")
            .add({"value": value, "timestamp": FieldValue.serverTimestamp()});
      },
      child: Text(emoji, style: const TextStyle(fontSize: 28)),
    );
  }
}
