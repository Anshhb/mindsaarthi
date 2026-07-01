import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Notification Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Manage your notification preferences here. You can enable or disable notifications for various app features.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Placeholder switches or options
              SwitchListTile(
                title: const Text(
                  "Push Notifications",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Receive push notifications for updates",
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
                  "Email Notifications",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Receive email updates",
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
