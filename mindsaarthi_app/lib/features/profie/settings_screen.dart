import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget tile(String title, String iconPath) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        children: [
          Image.asset(iconPath, height: 20, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      AssetImage("assets/images/user_profile.png"),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "John Doe",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "India",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "General",
              style: TextStyle(color: AppColors.primary),
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  tile("User Profile", "assets/images/profile.png"),
                  const Divider(color: Colors.white12),
                  tile("Notifications", "assets/images/notification.png"),
                  const Divider(color: Colors.white12),
                  tile("Privacy", "assets/images/privacy.png"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Discover more",
              style: TextStyle(color: AppColors.primary),
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  tile("Support & feedback", "assets/images/support.png"),
                  const Divider(color: Colors.white12),
                  tile("Terms & Conditions", "assets/images/terms.png"),
                  const Divider(color: Colors.white12),
                  tile("Privacy Policy", "assets/images/privacy_policy.png"),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: const Text("Log Out", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}