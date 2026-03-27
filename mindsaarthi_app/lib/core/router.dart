import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindsaarthi_app/features/journal/journal_entry_screen.dart';
import 'package:mindsaarthi_app/features/journal/journal_success_screen.dart';
import 'package:mindsaarthi_app/features/journal/journal_view_screen.dart';
import 'package:mindsaarthi_app/features/profie/settings_screen.dart';
import 'package:mindsaarthi_app/features/relax/relax_screen.dart';
import 'package:mindsaarthi_app/main_shell.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/reset_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/auth/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/onboarding',

    redirect: (context, state) {
      final auth = authState;

      if (auth.isLoading) return null;

      final isLoggedIn = auth.value != null;
      final location = state.uri.toString();

      final isOnboarding = location == '/onboarding';
      final isAuthRoute =
          location == '/login' || location == '/signup' || location == '/reset';

      if (isLoggedIn && isOnboarding) {
        return '/';
      }

      if (!isLoggedIn && !isAuthRoute && !isOnboarding) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(path: '/', builder: (_, __) => const MainShell()),

      GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),

      GoRoute(path: '/login', builder: (_, __) => LoginScreen()),

      GoRoute(path: '/signup', builder: (_, __) => SignupScreen()),

      GoRoute(path: '/reset', builder: (_, __) => ResetScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
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
        path: '/journal-view',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return JournalViewScreen(
            text: data["text"],
            timestamp: data["timestamp"]?.toDate(),
          );
        },
      ),
    ],
  );
});
