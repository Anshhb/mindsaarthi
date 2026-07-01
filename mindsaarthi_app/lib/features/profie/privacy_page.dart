import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
        title: const Text("Privacy", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Privacy Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Control your privacy settings. Manage who can see your profile, data sharing, and more.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Placeholder options
              SwitchListTile(
                title: const Text(
                  "Profile Visibility",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Make your profile visible to others",
                  style: TextStyle(color: Colors.white70),
                ),
                value: true, // Placeholder
                onChanged: (bool value) {
                  // Handle toggle
                },
                activeColor: AppColors.primary,
              ),
              SwitchListTile(
                title: const Text(
                  "Data Sharing",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Allow sharing of anonymized data for improvements",
                  style: TextStyle(color: Colors.white70),
                ),
                value: false, // Placeholder
                onChanged: (bool value) {
                  // Handle toggle
                },
                activeColor: AppColors.primary,
              ),
              // Add more as needed
            ],
          ),
        ),
      ),
    );
  }
}
