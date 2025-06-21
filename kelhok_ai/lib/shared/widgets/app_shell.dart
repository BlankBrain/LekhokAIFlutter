import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import "../../features/auth/providers/simple_auth_provider.dart";
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/story_generation/screens/backend_story_screen.dart';
import '../../features/characters/screens/characters_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import 'k_bottom_navigation.dart';

// Current tab provider
final currentTabProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(simpleAuthProvider);
    final currentTab = ref.watch(currentTabProvider);

    // Show loading indicator while checking authentication
    if (authState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.karigorGold),
          ),
        ),
      );
    }

    // Show login screen if not authenticated
    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }

    // Show main app if authenticated
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: IndexedStack(
        index: currentTab,
        children: const [
          DashboardScreen(),
          BackendStoryScreen(),
          CharactersScreen(),
          HistoryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: KBottomNavigation(
        currentIndex: currentTab,
        onTap: (index) {
          ref.read(currentTabProvider.notifier).state = index;
        },
      ),
    );
  }
} 