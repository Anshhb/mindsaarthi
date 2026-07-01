import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindsaarthi_app/core/widgets/app_snackbar.dart';
import 'package:mindsaarthi_app/core/widgets/mind_loader.dart';
import '../../core/colors.dart';
import 'auth_controller.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authControllerProvider.notifier);
    final state = ref.watch(authControllerProvider);

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
                "Mindsaarthi",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              _input(emailController, "Email Address"),
              const SizedBox(height: 15),

              _input(passController, "Password", obscure: true),
              const SizedBox(height: 15),

              _input(confirmController, "Confirm Password", obscure: true),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  if (passController.text != confirmController.text) {
                    AppSnackbar.show(
                      context,
                      message: "Passwords do not match",
                      isError: true,
                    );
                    return;
                  }

                  final (success, msg) = await notifier.signUp(
                    emailController.text.trim(),
                    passController.text.trim(),
                  );

                  if (success) {
                    AppSnackbar.show(context, message: msg, isError: !success);
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      context.go('/user-info');
                    });
                  } else {
                    AppSnackbar.show(context, message: msg, isError: !success);
                  }
                },
                child:
                    state.isLoading
                        ? const PremiumMindLoader(message: "Creating your account...")
                        : const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
              ),

              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("or", style: TextStyle(color: Colors.white54)),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _socialIcon(Icons.phone),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 16,
                      backgroundImage: AssetImage("assets/images/google.png"),
                    ),
                    onPressed: () async {
                      final (success, msg) = await notifier.signUpWithGoogle();

                      if (success) {
                        AppSnackbar.show(
                          context,
                          message: msg,
                          isError: !success,
                        );
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          context.go('/user-info');
                        });
                      } else {
                        AppSnackbar.show(
                          context,
                          message: msg,
                          isError: !success,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  _socialIcon(
                    Icons.phone,
                    onPressed: () {
                      AppSnackbar.show(
                        context,
                        message: "Phone signin coming soon",
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white54),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
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

  Widget _socialIcon(IconData icon, {VoidCallback? onPressed}) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFFD9D9D9), size: 30),
      ),
      onPressed: onPressed,
    );
  }
}
