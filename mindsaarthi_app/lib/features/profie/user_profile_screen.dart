import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsaarthi_app/core/widgets/app_snackbar.dart';
import '../../core/colors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final nameController = TextEditingController();
  String? selectedAgeGroup;
  String? selectedGender;
  String? selectedWellnessGoal;
  XFile? selectedImage;
  String? profilePictureUrl;
  bool isLoading = true;
  bool isSaving = false;

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
          nameController.text = doc.data()!['name'] ?? '';
          selectedAgeGroup = doc.data()!['ageGroup'];
          selectedGender = doc.data()!['gender'];
          selectedWellnessGoal = doc.data()!['wellnessGoal'];
          profilePictureUrl = doc.data()!['profilePictureUrl'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<String?> _uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    if (selectedImage == null) {
      return null;
    }

    final file = File(selectedImage!.path);
    final ref = FirebaseStorage.instance.ref().child(
      'profile_pictures/${user.uid}.jpg',
    );
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _saveUserProfile() async {
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

    setState(() => isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? newProfilePictureUrl = profilePictureUrl;
        if (selectedImage != null) {
          newProfilePictureUrl = await _uploadImage();
        }

        final data = {
          "name": nameController.text.trim(),
          "ageGroup": selectedAgeGroup,
          "gender": selectedGender,
          "wellnessGoal": selectedWellnessGoal,
          "updatedAt": FieldValue.serverTimestamp(),
        };

        if (newProfilePictureUrl != null) {
          data["profilePictureUrl"] = newProfilePictureUrl;
        }

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(data, SetOptions(merge: true));

        AppSnackbar.show(context, message: "Profile updated successfully");

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      print("Error saving profile: $e");
      AppSnackbar.show(
        context,
        message: "Failed to update profile: $e",
        isError: true,
      );
    } finally {
      setState(() => isSaving = false);
    }
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
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white24,
                            backgroundImage:
                                selectedImage != null
                                    ? FileImage(File(selectedImage!.path))
                                        as ImageProvider
                                    : (profilePictureUrl != null &&
                                            profilePictureUrl!.isNotEmpty
                                        ? NetworkImage(profilePictureUrl!)
                                        : const AssetImage(
                                          "assets/images/user_profile.png",
                                        )),
                            child:
                                selectedImage == null &&
                                        (profilePictureUrl == null ||
                                            profilePictureUrl!.isEmpty)
                                    ? const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 40,
                                    )
                                    : null,
                            onBackgroundImageError: (exception, stackTrace) {
                              print(
                                "Error loading profile picture: $exception",
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Full Name",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _input(nameController, "Enter your full name"),
                      const SizedBox(height: 20),
                      const Text(
                        "Age Group",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _dropdown(
                        hint: "Select Age Group",
                        value: selectedAgeGroup,
                        items: ageGroups,
                        onChanged:
                            (value) => setState(() => selectedAgeGroup = value),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Gender",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _dropdown(
                        hint: "Select Gender",
                        value: selectedGender,
                        items: genders,
                        onChanged:
                            (value) => setState(() => selectedGender = value),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Wellness Goal",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _dropdown(
                        hint: "Select Wellness Goal",
                        value: selectedWellnessGoal,
                        items: wellnessGoals,
                        onChanged:
                            (value) =>
                                setState(() => selectedWellnessGoal = value),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: isSaving ? null : _saveUserProfile,
                          child:
                              isSaving
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    "Save Changes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
