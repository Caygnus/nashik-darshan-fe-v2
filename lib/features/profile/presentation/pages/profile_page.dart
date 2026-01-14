import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/presentation/widgets/app_text.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/theme/colors.dart';
import 'package:nashik/core/utils/loading_overlay.dart';
import 'package:nashik/core/utils/snackbar.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: H2('Logout'),
          content: BodyText('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: BodyText(
                'Cancel',
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().signOut();
              },
              child: BodyText(
                'Logout',
                color: AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          authenticated: (_) {},
          unauthenticated: () {
            context.goNamed(AppRouteNames.login);
          },
          error: (String message) {
            Snackbar.showError(message);
          },
        );
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          return LoadingOverlay(
            isLoading: isLoading,
            message: isLoading ? 'Logging out...' : null,
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.darkText,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: H1('Profile'),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: AppColors.darkText,
                    onPressed: () {},
                  ),
                ],
              ),
              body: SafeArea(
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      authenticated: (user) =>
                          _buildProfileContent(context, user),
                      orElse: () => Center(
                        child: BodyText('Please log in to view your profile'),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    // Mock data
    const templesVisited = 12;
    const spotsExplored = 8;
    const tripsCompleted = 5;
    const savedItineraries = 5;
    const wishlistPlaces = 10;
    const jyotirlingasVisited = 3;
    const totalJyotirlingas = 12;
    const badgesEarned = 2;
    const dishesTried = 7;
    const totalDishes = 10;
    const greenPoints = 850;
    const tripStreak = 7;
    const streakProgress = 0.75;

    final recentTrips = [
      {
        'name': 'Trimbakeshwar Temple',
        'date': 'Aug 15, 2024',
        'image': Icons.temple_buddhist,
      },
      {
        'name': 'Sula Vineyards',
        'date': 'Jul 28, 2024',
        'image': Icons.wine_bar,
      },
      {
        'name': 'Pandav Leni Caves',
        'date': 'Jul 10, 2024',
        'image': Icons.landscape,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                // Profile Avatar
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 36.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H1(user.name, maxLines: 1),
                      SizedBox(height: 6.h),
                      BodyText(
                        'Spiritual Explorer',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 14.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4.w),
                                Caption(
                                  'Marathi',
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: BodyText(
                              user.phone ?? '+91 98765 43210',
                              color: AppColors.grey,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.edit,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Travel Stats Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H2('Travel Stats'),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.temple_buddhist,
                        count: templesVisited,
                        label: 'Temples Visited',
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.landscape,
                        count: spotsExplored,
                        label: 'Spots Explored',
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.luggage,
                        count: tripsCompleted,
                        label: 'Trips Completed',
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Recent Trips Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    H2('Recent Trips'),
                    TextButton(
                      onPressed: () {},
                      child: BodyText(
                        'View All',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ...recentTrips.asMap().entries.map((entry) {
                  final index = entry.key;
                  final trip = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < recentTrips.length - 1 ? 16.h : 0,
                    ),
                    child: _buildTripItem(
                      name: trip['name'] as String,
                      date: trip['date'] as String,
                      icon: trip['image'] as IconData,
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Saved & Wishlist Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    label: ButtonText('$savedItineraries Saved Itineraries'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    label: ButtonText('$wishlistPlaces Wishlist Places'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Nashik Journey Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H2('Nashik Journey'),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.temple_buddhist,
                  label: 'Pilgrimage Tracker',
                  subtitle:
                      '$jyotirlingasVisited of $totalJyotirlingas Jyotirlingas visited',
                  progress: jyotirlingasVisited / totalJyotirlingas,
                  progressText:
                      '${((jyotirlingasVisited / totalJyotirlingas) * 100).toInt()}%',
                  iconColor: AppColors.primary,
                ),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.emoji_events,
                  label: 'Festival Badges',
                  subtitle: '$badgesEarned badges earned',
                  badges: List.generate(badgesEarned, (index) => Colors.amber),
                  iconColor: Colors.amber,
                ),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.restaurant,
                  label: 'Food Journey',
                  subtitle: '$dishesTried local dishes tried',
                  progress: dishesTried / totalDishes,
                  progressText:
                      '${((dishesTried / totalDishes) * 100).toInt()}%',
                  iconColor: Colors.red,
                ),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.eco,
                  label: 'Green Points',
                  subtitle: 'Eco-friendly travel score',
                  points: greenPoints,
                  iconColor: Colors.green,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Achievements Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H2('Achievements'),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildAchievementBadge(
                        icon: Icons.workspace_premium,
                        label: 'Temple Explorer',
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildAchievementBadge(
                        icon: Icons.restaurant,
                        label: 'Foodie',
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildAchievementBadge(
                        icon: Icons.eco,
                        label: 'Eco Traveler',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Settings Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H2('Settings'),
                SizedBox(height: 16.h),
                _buildSettingItem(Icons.privacy_tip, 'Privacy Settings'),
                _buildSettingItem(
                  Icons.language,
                  'Language',
                  subtitle: 'English',
                ),
                _buildSettingItem(Icons.accessibility, 'Accessibility'),
                _buildSettingItem(Icons.download, 'Export Data'),
                _buildSettingItem(
                  Icons.delete_outline,
                  'Delete Account',
                  textColor: AppColors.red,
                ),
                SizedBox(height: 8.h),
                _buildSettingItem(
                  Icons.logout,
                  'Logout',
                  textColor: AppColors.red,
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Trip Streak Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    H2('Trip Streak', color: Colors.white),
                    H2('$tripStreak Days', color: Colors.white),
                  ],
                ),
                SizedBox(height: 10.h),
                BodyText(
                  'Keep exploring Nashik!',
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: streakProgress,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 8.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    BodyText(
                      '${(streakProgress * 100).toInt()}%',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
          ),
          child: Icon(icon, color: color, size: 28.sp),
        ),
        SizedBox(height: 8.h),
        H1(count.toString(), maxLines: 1, textAlign: TextAlign.center),
        SizedBox(height: 4.h),
        Caption(
          label,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTripItem({
    required String name,
    required String date,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 28.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H3(name, maxLines: 1),
              SizedBox(height: 6.h),
              Subtitle(date),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: AppColors.grey, size: 24.sp),
      ],
    );
  }

  Widget _buildJourneyItem({
    required IconData icon,
    required String label,
    required String subtitle,
    double? progress,
    String? progressText,
    int? points,
    List<Color>? badges,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H3(label, maxLines: 1),
                  SizedBox(height: 6.h),
                  Subtitle(subtitle),
                ],
              ),
            ),
            if (progress != null && progressText != null)
              BodyText(progressText, fontWeight: FontWeight.bold)
            else if (points != null)
              H3(points.toString(), color: Colors.green)
            else if (badges != null)
              Row(
                children: badges
                    .map(
                      (color) => Container(
                        margin: EdgeInsets.only(left: 4.w),
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        if (progress != null) ...[
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: iconColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              minHeight: 6.h,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: color, size: 32.sp),
        ),
        SizedBox(height: 8.h),
        Caption(
          label,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title, {
    String? subtitle,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? AppColors.grey, size: 24.sp),
            SizedBox(width: 16.w),
            Expanded(child: H3(title, color: textColor ?? AppColors.darkText)),
            if (subtitle != null)
              BodyText(
                subtitle,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
