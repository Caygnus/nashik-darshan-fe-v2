import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nashik/core/theme/colors.dart';

class BottomBarPage extends StatelessWidget {
  const BottomBarPage({super.key, required this.shell});
  static const routeName = 'BottomBarPage';
  static const routePath = '/BottomBarPage';
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    // Get system navigation bar height
    final systemNavigationBarHeight = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: shell,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: systemNavigationBarHeight),
        child: CurvedNavigationBar(
          index: shell.currentIndex,
          color: AppColors.primary,
          buttonBackgroundColor: AppColors.primary,
          backgroundColor: AppColors.white,
          animationCurve: Curves.ease,
          height: 55.h,
          onTap: (value) => shell.goBranch(value),
          items: [
            // Home Icon
            Icon(IonIcons.home, size: 26.r, color: AppColors.white),
            // Categories Icon
            Icon(IonIcons.grid, size: 26.r, color: AppColors.white),
            // Itinerary Icon
            Icon(HeroIcons.map, size: 26.r, color: AppColors.white),
            // Profile Icon
            Icon(HeroIcons.user, size: 26.r, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
