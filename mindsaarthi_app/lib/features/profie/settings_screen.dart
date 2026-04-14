import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? userName = "Loading...";
  String? userAgeGroup;
  String? userGender;
  String? profilePictureUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          userName = doc.data()!['name'] ?? 'User';
          userAgeGroup = doc.data()!['ageGroup'];
          userGender = doc.data()!['gender'];
          profilePictureUrl = doc.data()!['profilePictureUrl'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  String _getGenderAbbreviation(String? gender) {
    if (gender == null) return '';
    if (gender.toLowerCase() == 'male') return 'M';
    if (gender.toLowerCase() == 'female') return 'F';
    if (gender.toLowerCase() == 'non-binary') return 'NB';
    return gender.substring(0, 1).toUpperCase();
  }

  String _getAgeFromAgeGroup(String? ageGroup) {
    if (ageGroup == null) return '';
    final ages = ageGroup.split('-');
    if (ages.isNotEmpty) return ages.first.replaceAll('Under ', '');
    return '';
  }

  Widget tile(String title, String iconPath) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        children: [
          Image.asset(iconPath, height: 20, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    final age = _getAgeFromAgeGroup(userAgeGroup);
    final genderAbbr = _getGenderAbbreviation(userGender);
    final userInfo =
        '$age${age.isNotEmpty && genderAbbr.isNotEmpty ? ', ' : ''}$genderAbbr';

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white24,
          backgroundImage:
              profilePictureUrl != null && profilePictureUrl!.isNotEmpty
                  ? NetworkImage(profilePictureUrl!) as ImageProvider
                  : const AssetImage("assets/images/user_profile.png"),
          onBackgroundImageError:
              profilePictureUrl != null
                  ? (exception, stackTrace) {
                    print("Error loading profile picture: $exception");
                  }
                  : null,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              if (userInfo.isNotEmpty)
                Text(
                  userInfo,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
            ],
          ),
        ),
      ],
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
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
                : _buildUserHeader(),

            const SizedBox(height: 25),

            const Text("General", style: TextStyle(color: AppColors.primary)),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/user-profile'),
                    child: tile("User Profile", "assets/images/profile.png"),
                  ),
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
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
