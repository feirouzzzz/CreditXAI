import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/application_summary_screen.dart';
import 'screens/form_screen.dart';
import 'screens/score_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/onboarding_explainable_screen.dart';
import 'screens/onboarding_ethics_screen.dart';
import 'screens/financials_step_screen.dart';
import 'screens/summary_score_screen.dart';
import 'screens/onboarding_privacy_screen.dart';
import 'screens/verification_screen.dart';
import 'screens/credentials_screen.dart';
import 'screens/score_gauge_screen.dart';
import 'screens/results_detailed_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_applications_screen.dart';
import 'screens/admin_application_detail.dart';

/// Centralized router builder using GoRouter and Riverpod for navigation.

class AppRouter {
  // kept for compatibility if needed
  static GoRouter router(WidgetRef ref) => ref.watch(routerProvider);
}

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (c, s) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'onboardingExplainable',
        path: '/onboarding/explainable',
        builder: (c, s) => const ExplainableOnboardingScreen(),
      ),
      GoRoute(
        name: 'onboardingEthics',
        path: '/onboarding/ethics',
        builder: (c, s) => const OnboardingEthicsScreen(),
      ),
      GoRoute(
        name: 'onboardingPrivacy',
        path: '/onboarding/privacy',
        builder: (c, s) => const OnboardingPrivacyScreen(),
      ),
      GoRoute(
        name: 'onboardingConsent',
        path: '/onboarding/consent',
        builder: (c, s) => const ConsentScreen(),
      ),
      GoRoute(
        name: 'financialsStep',
        path: '/user/financials',
        builder: (c, s) => const FinancialsStepScreen(),
      ),
      GoRoute(
        name: 'verification',
        path: '/user/verification',
        builder: (c, s) => const VerificationScreen(),
      ),
      GoRoute(
        name: 'credentials',
        path: '/auth/register',
        builder: (c, s) => const CredentialsScreen(),
      ),
      GoRoute(
        name: 'scoreGauge',
        path: '/user/score-gauge',
        builder: (c, s) => const ScoreGaugeScreen(),
      ),
      GoRoute(
        name: 'scoreSummary',
        path: '/user/score-summary',
        builder: (c, s) => const SummaryScoreScreen(),
      ),
      GoRoute(
        name: 'resultsDetailed',
        path: '/user/results-detailed',
        builder: (c, s) => const ResultsDetailedScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (c, s) => const LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (c, s) => const LoginScreen(),
      ),
      GoRoute(
        name: 'userHome',
        path: '/user/home',
        builder: (c, s) => const UserHomeScreen(),
      ),
      GoRoute(
        name: 'userNew',
        path: '/user/new-application',
        builder: (c, s) => const CreditApplicationFormScreen(),
      ),
      GoRoute(
        name: 'userScore',
        path: '/user/score-result',
        builder: (c, s) => const ScoreResultScreen(),
      ),
      GoRoute(
        name: 'userProfile',
        path: '/user/profile',
        builder: (c, s) => const ProfileScreen(),
      ),
      GoRoute(
        name: 'appSummary',
        path: '/user/application-summary',
        builder: (c, s) => const ApplicationSummaryScreen(),
      ),

      // Admin tree
      GoRoute(
        name: 'adminLogin',
        path: '/admin/login',
        builder: (c, s) => const AdminLoginScreen(),
      ),
      GoRoute(
        name: 'adminDashboard',
        path: '/admin/dashboard',
        builder: (c, s) => const AdminDashboardWideScreen(),
      ),
      GoRoute(
        name: 'adminApplications',
        path: '/admin/applications',
        builder: (c, s) => const AdminApplicationsScreen(),
      ),
      GoRoute(
        name: 'adminApplicationDetail',
        path: '/admin/applications/:id',
        builder: (c, s) {
          final id = s.params['id']!;
          return AdminApplicationDetailScreen(applicationId: id);
        },
      ),
    ],
  ),
);
