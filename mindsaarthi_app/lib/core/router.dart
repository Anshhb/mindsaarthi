import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindsaarthi_app/features/ai/ai_response_screen.dart';
import 'package:mindsaarthi_app/features/journal/journal_entry_screen.dart';
import 'package:mindsaarthi_app/features/journal/journal_new_screen.dart';
import 'package:mindsaarthi_app/features/journal/journal_success_screen.dart';
import 'package:mindsaarthi_app/features/journal/journal_view_screen.dart';
import 'package:mindsaarthi_app/features/journal/journal_list_screen.dart';
import 'package:mindsaarthi_app/features/profie/settings_screen.dart';
import 'package:mindsaarthi_app/features/profie/user_profile_screen.dart';
import 'package:mindsaarthi_app/features/relax/relax_screen.dart';
import 'package:mindsaarthi_app/features/vision/video_screen.dart';
import 'package:mindsaarthi_app/features/vision/vision_screen.dart';
import 'package:mindsaarthi_app/main_shell.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/reset_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/user_info_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/auth/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/onboarding',

    redirect: (context, state) async {
      final auth = authState;

      if (auth.isLoading) return null;

      final user = auth.value;
      final isLoggedIn = user != null;
      final location = state.uri.toString();

      final isOnboarding = location == '/onboarding';
      final isAuthRoute =
          location == '/login' || location == '/signup' || location == '/reset';
      final isUserInfo = location == '/user-info';

      if (!isLoggedIn) {
        if (!isAuthRoute && !isOnboarding) {
          return '/login';
        }
      }
      if (isLoggedIn) {
        final doc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();

        final data = doc.data();
        final profileComplete =
            doc.exists &&
            data != null &&
            (data["name"]?.toString().isNotEmpty ?? false) &&
            (data["ageGroup"]?.toString().isNotEmpty ?? false) &&
            (data["gender"]?.toString().isNotEmpty ?? false) &&
            (data["wellnessGoal"]?.toString().isNotEmpty ?? false);

        if (!profileComplete && !isUserInfo) {
          return '/user-info';
        }

        if (profileComplete && (isAuthRoute || isOnboarding || isUserInfo)) {
          return '/';
        }
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(path: '/user-info', builder: (_, __) => const UserInfoScreen()),
      GoRoute(path: '/', builder: (_, __) => const MainShell()),

      GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),

      GoRoute(path: '/login', builder: (_, __) => LoginScreen()),

      GoRoute(path: '/signup', builder: (_, __) => SignupScreen()),

      GoRoute(path: '/reset', builder: (_, __) => ResetScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(
        path: '/user-profile',
        builder: (_, __) => const UserProfileScreen(),
      ),
      GoRoute(path: '/relax', builder: (_, __) => const RelaxScreen()),
      GoRoute(
        path: '/journal-entry',
        builder: (_, __) => const JournalEntryScreen(),
      ),

      GoRoute(
        path: '/journal-success',
        builder: (_, __) => const JournalSuccessScreen(),
      ),

      GoRoute(
        path: '/journal-list',
        builder: (_, __) => const JournalListScreen(),
      ),

      GoRoute(
        path: '/journal-view',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return JournalViewScreen(
            text: data["text"],
            timestamp: data["timestamp"]?.toDate(),
          );
        },
      ),
      GoRoute(path: '/vision', builder: (_, __) => const VisionScreen()),

      GoRoute(path: '/video', builder: (_, __) => const VideoScreen()),
      GoRoute(
        path: '/ai-response',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return AIResponseScreen(mood: data["mood"]);
        },
      ),
      GoRoute(
        path: '/journal-new',
        builder: (_, __) => const JournalNewScreen(),
      ),
    ],
  );
});
