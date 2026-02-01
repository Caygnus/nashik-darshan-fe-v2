import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/core/theme/colors.dart';

/// Tab index to route path so the router location stays in sync when switching tabs.
const List<String> _tabPaths = [
  AppRoutePaths.itinerary,
  AppRoutePaths.category,
  AppRoutePaths.home,
  AppRoutePaths.events,
  AppRoutePaths.profile,
];

class BottomBarPage extends StatelessWidget {
  const BottomBarPage({super.key, required this.shell});
  static const routeName = 'BottomBarPage';
  static const routePath = '/BottomBarPage';
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 BottomBarPage: currentIndex=${shell.currentIndex}');

    return Scaffold(
      body: shell,
      extendBody: true,
      floatingActionButton: null,
      bottomNavigationBar: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        alignment: Alignment.bottomCenter,
        child: CurvedNavigationBar(
          index: shell.currentIndex,
          color: AppColors.primary,
          buttonBackgroundColor: AppColors.primary,
          backgroundColor: AppColors.white,
          animationCurve: Curves.ease,
          height: 60.h,
          onTap: (value) {
            debugPrint('🔍 BottomBarPage: Tapped index=$value');
            // Navigate to the tab's route so the branch shows its page (fixes blank profile tab).
            if (value >= 0 && value < _tabPaths.length) {
              context.go(_tabPaths[value]);
            }
            shell.goBranch(value);
          },
          items: [
            // Itinerary Icon (Index 0)
            Icon(HeroIcons.map, size: 26.r, color: AppColors.white),
            // Categories Icon (Index 1)
            Icon(IonIcons.grid, size: 26.r, color: AppColors.white),
            // Home Icon (Index 2) - Center position, main screen
            Icon(IonIcons.home, size: 26.r, color: AppColors.white),
            // Events Icon (Index 3)
            Icon(IonIcons.calendar, size: 26.r, color: AppColors.white),
            // Profile Icon (Index 4)
            Icon(HeroIcons.user, size: 26.r, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
