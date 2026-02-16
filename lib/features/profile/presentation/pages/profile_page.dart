import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/auth/auth_guard.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/theme/colors.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';
import 'package:nashik/features/profile/presentation/cubit/profile_cubit.dart';

/// Profile screen: guest sees "Login to access profile"; logged-in user sees data from GET /user/me.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const routeName = 'ProfilePage';
  static const routePath = '/ProfilePage';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return authState.when(
          initial: () => _buildGuestProfile(context),
          loading: () => _buildGuestProfile(context),
          authenticated: (_) => _buildAuthenticatedProfile(context),
          unauthenticated: () => _buildGuestProfile(context),
          error: (_) => _buildGuestProfile(context),
        );
      },
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20.sp,
                color: AppColors.darkText,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
            centerTitle: true,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 64.r,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Login to access profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign in to view your profile, saved itineraries, and wishlist.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    FilledButton(
                      onPressed: () =>
                          context.go(loginPathWithRedirect(AppRoutePaths.profile)),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      buildWhen: (_, state) => true,
      builder: (context, profileState) {
        if (profileState is ProfileInitial || profileState is ProfileLoading) {
          if (profileState is ProfileInitial) {
            context.read<ProfileCubit>().loadUser();
          }
          return Container(
            color: const Color(0xFFF8F8F8),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: AppColors.white,
                  elevation: 0,
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                  ),
                  centerTitle: true,
                ),
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          );
        }
        if (profileState is ProfileError) {
          return Container(
            color: const Color(0xFFF8F8F8),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: AppColors.white,
                  elevation: 0,
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                  ),
                  centerTitle: true,
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        profileState.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (profileState is ProfileLoaded) {
          return Container(
            color: const Color(0xFFF8F8F8),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: AppColors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20.sp,
                      color: AppColors.darkText,
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                  ),
                  centerTitle: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileSummaryCard(
                          context,
                          name: profileState.user.name,
                          phone: profileState.user.phone ?? '',
                        ),
                        SizedBox(height: 16.h),
                        _buildSavedAndWishlistSection(context),
                        SizedBox(height: 16.h),
                        _buildSettingsSection(context),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileSummaryCard(
    BuildContext context, {
    required String name,
    required String phone,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: AppColors.lightGrey,
            child: Icon(
              Icons.person,
              size: 40.r,
              color: AppColors.grey,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'User',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  phone.isNotEmpty ? phone : '—',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.pushNamed(AppRouteNames.editProfile),
            icon: Icon(
              Icons.edit,
              size: 22.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedAndWishlistSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved & Wishlist',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 98.h,
            child: Row(
              children: [
                Expanded(
                  child: _buildWishlistCard(
                  title: 'Saved Itineraries',
                  icon: Icons.bookmark_rounded,
                  iconColor: const Color(0xFF7C6FDB),
                  backgroundColor: const Color(0xFFEDE9FC),
                  onTap: () {
                    context.pushNamed(AppRouteNames.savedItinerariesList);
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildWishlistCard(
                  title: 'Wishlist',
                  icon: Icons.favorite_rounded,
                  iconColor: const Color(0xFFE85D75),
                  backgroundColor: const Color(0xFFFCE8EC),
                  onTap: () => context.pushNamed(AppRouteNames.wishlist),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildWishlistCard(
                  title: 'Spiritual Stories',
                  icon: Icons.menu_book_rounded,
                  iconColor: const Color(0xFF5B8DEE),
                  backgroundColor: const Color(0xFFE8F0FE),
                  onTap: () => context.pushNamed(AppRouteNames.savedSpiritualStories),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 26.sp, color: iconColor),
              SizedBox(height: 8.h),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkText,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
          SizedBox(height: 12.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Navigate to privacy settings
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 22.sp,
                      color: AppColors.darkText,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Privacy Settings',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkText,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await context.read<AuthCubit>().signOut();
                if (context.mounted) context.goNamed(AppRouteNames.home);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 22.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
