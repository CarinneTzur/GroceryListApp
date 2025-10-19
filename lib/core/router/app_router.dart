import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_setup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/chat/presentation/screens/chat_brief_screen.dart';
import '../../features/recipes/presentation/screens/recipe_search_screen.dart';
import '../../features/meal_plan/presentation/screens/meal_plan_screen.dart';
import '../../features/grocery/presentation/screens/grocery_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isOnAuthPage = state.uri.path.startsWith('/auth');
      final isOnOnboarding = state.uri.path == '/onboarding';
      
      // If not authenticated and not on auth/onboarding pages, redirect to onboarding
      if (!isAuthenticated && !isOnAuthPage && !isOnOnboarding) {
        return '/onboarding';
      }
      
      // If authenticated and on auth pages, redirect to home
      if (isAuthenticated && isOnAuthPage) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Authentication routes
      GoRoute(
        path: '/auth',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      
      // Main app routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      
      GoRoute(
        path: '/chat-brief',
        builder: (context, state) => const ChatBriefScreen(),
      ),
      
      GoRoute(
        path: '/recipes',
        builder: (context, state) => const RecipeSearchScreen(),
      ),
      
      GoRoute(
        path: '/meal-plan',
        builder: (context, state) => const MealPlanScreen(),
      ),
      
      GoRoute(
        path: '/grocery-list',
        builder: (context, state) => const GroceryListScreen(),
      ),
      
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
