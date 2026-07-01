import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsaarthi_app/core/widgets/app_snackbar.dart';
import 'package:mindsaarthi_app/core/widgets/mind_loader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/colors.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final nameController = TextEditingController();
  String? selectedAgeGroup;
  String? selectedGender;
  String? selectedWellnessGoal;
  XFile? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _prefillUserData();
  }

  Future<void> _prefillUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      nameController.text = user.displayName!;
    }
  }

  final List<String> ageGroups = [
    'Under 18',
    '18-25',
    '26-35',
    '36-45',
    '46-55',
    '56-65',
    'Above 65',
  ];

  final List<String> genders = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  final List<String> wellnessGoals = [
    'Reduce stress',
    'Improve mood',
    'Better sleep',
    'Anxiety support',
    'Daily journaling',
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              Image.asset("assets/images/mental_health.png", height: 80),

              const SizedBox(height: 10),

              const Text(
                "Tell us about yourself",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "This helps us personalize your experience",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 40),

              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child:
                        selectedImage != null
                            ? ClipOval(
                              child: Image.file(
                                File(selectedImage!.path),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            )
                            : const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 40,
                            ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _input(nameController, "Full Name"),
              const SizedBox(height: 15),

              _dropdown(
                hint: "Select Age Group",
                value: selectedAgeGroup,
                items: ageGroups,
                onChanged: (value) => setState(() => selectedAgeGroup = value),
              ),
              const SizedBox(height: 15),

              _dropdown(
                hint: "Select Gender",
                value: selectedGender,
                items: genders,
                onChanged: (value) => setState(() => selectedGender = value),
              ),
              const SizedBox(height: 15),

              _dropdown(
                hint: "Select Wellness Goal",
                value: selectedWellnessGoal,
                items: wellnessGoals,
                onChanged:
                    (value) => setState(() => selectedWellnessGoal = value),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: isLoading ? null : _saveUserInfo,
                child:
                    isLoading
                        ? const PremiumMindLoader(message: "Saving your profile...")
                        : const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white),
                        ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(color: Colors.white54)),
      style: const TextStyle(color: Colors.white),
      dropdownColor: AppColors.secondary,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      items:
          items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _saveUserInfo() async {
    if (nameController.text.trim().isEmpty ||
        selectedAgeGroup == null ||
        selectedGender == null ||
        selectedWellnessGoal == null) {
      AppSnackbar.show(
        context,
        message: "Please fill all fields",
        isError: true,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? profilePictureUrl;
        if (selectedImage != null) {
          profilePictureUrl = await _uploadImage();
        }

        final data = {
          "name": nameController.text.trim(),
          "ageGroup": selectedAgeGroup,
          "gender": selectedGender,
          "wellnessGoal": selectedWellnessGoal,
          "updatedAt": FieldValue.serverTimestamp(),
        };

        if (profilePictureUrl != null) {
          data["profilePictureUrl"] = profilePictureUrl;
        }

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(data, SetOptions(merge: true));
      }

      AppSnackbar.show(context, message: "Profile updated successfully");

      await Future.delayed(const Duration(seconds: 1));
      context.go('/');
    } catch (e) {
      print("Error saving user info: $e");
      AppSnackbar.show(
        context,
        message: "Failed to save info: $e",
        isError: true,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<String> _uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    if (selectedImage == null) {
      throw Exception("No image selected");
    }

    final file = File(selectedImage!.path);
    final supabase = Supabase.instance.client;

    final filePath = '${user.uid}.jpg';

    await supabase.storage
        .from('profile-pictures')
        .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

    final publicUrl = supabase.storage
        .from('profile-pictures')
        .getPublicUrl(filePath);

    return publicUrl;
  }
}
