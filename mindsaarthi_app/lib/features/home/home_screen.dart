import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';
import '../../core/providers/utils_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

Widget moodSelector() {
  final PageController controller = PageController(
    viewportFraction: 0.35,
    initialPage: 0,
  );

  final moods = [
    {"image": "assets/images/emoji2/Angry.png", "label": "Angry", "value": 8},
    {"image": "assets/images/emoji2/Sad.png", "label": "Sad", "value": 6},
    {"image": "assets/images/emoji2/Excited.png", "label": "Okay", "value": 5},
    {"image": "assets/images/emoji2/Chill.png", "label": "Better", "value": 3},
    {"image": "assets/images/emoji2/Happy.png", "label": "Great", "value": 2},
  ];

  int currentPage = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          const SizedBox(height: 20),

          const Text(
            "How are you feeling now?",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 40),

          SizedBox(
            height: 200,
            child: OverflowBox(
              maxHeight: 250,
              child: PageView.builder(
                controller: controller,
                itemCount: moods.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, index) {
                  final isActive = index == currentPage;

                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      double value = 0;

                      if (controller.position.haveDimensions) {
                        value = controller.page! - index;
                      } else {
                        value = (controller.initialPage - index).toDouble();
                      }

                      value = value.clamp(-1, 1);

                      double translateY = -40 * (1 - value.abs());
                      double scale = 1 - (value.abs() * 0.3);

                      return Transform.translate(
                        offset: Offset(0, translateY),
                        child: Transform.scale(
                          scale: scale,
                          child: GestureDetector(
                            onTap: () async {
                              controller.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        (index == currentPage)
                                            ? Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            )
                                            : null,
                                  ),
                                  child: Image.asset(
                                    moods[index]["image"] as String,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            moods[currentPage]["label"] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Champion on daily life",
            style: TextStyle(color: Colors.white54, fontSize: 15),
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              final user = FirebaseAuth.instance.currentUser;

              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .collection("mood")
                  .add({
                    "value": moods[currentPage]["value"],
                    "label": moods[currentPage]["label"],
                    "timestamp": FieldValue.serverTimestamp(),
                  });

              context.push(
                '/ai-response',
                extra: {"mood": moods[currentPage]["label"]},
              );
            },
            child: SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(
                "assets/images/emoji2/Button.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? userName;
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchProfilePicture();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          userName = doc.data()!['name'] ?? '';
        });
      }
    }
  }

  Future<void> _fetchProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          profilePictureUrl = doc.data()!['profilePictureUrl'];
        });
      }
    }
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
              backgroundImage:
                  profilePictureUrl != null && profilePictureUrl!.isNotEmpty
                      ? NetworkImage(profilePictureUrl!) as ImageProvider
                      : const AssetImage("assets/images/user_profile.png"),
              onBackgroundImageError: (exception, stackTrace) {
                print("Error loading profile picture: $exception");
              },
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
                child: Text(
                  "Welcome Back${userName != null && userName!.isNotEmpty ? ' $userName' : ''} !",
                  style: const TextStyle(
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ref
                      .watch(getTodayQuoteProvider)
                      .when(
                        data:
                            (quote) => Text(
                              quote,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        loading:
                            () => const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                        error:
                            (error, stack) => const Text(
                              "Every day is a new opportunity to grow.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
              moodSelector(),
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
                          // gradient: LinearGradient(
                          //   colors: [
                          //     const Color(0xFF8E2DE2),
                          //     const Color(0xFF4A00E0),
                          //   ],
                          // ),
                          gradient: LinearGradient(
                            colors: [Color(0xFF9D4EDD), Color(0xFF5A189A)],
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
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
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
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.push('/vision'),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "Analyze Mood via Face",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => context.push('/video'),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00C9A7), Color(0xFF007A7C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "Analyze Mood via Video",
                        style: TextStyle(color: Colors.white),
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
                  GestureDetector(
                    onTap: () => context.push('/journal-list'),
                    child: Text(
                      "VIEW ALL >",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
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
                            formattedDate =
                                "${ref.watch(monthProvider(date.month))} ${date.day}";
                            formattedTime =
                                "${ref.watch(formatHourProvider(date.hour))}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? "PM" : "AM"}";
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Text(
                                          "Free Write",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
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
}
