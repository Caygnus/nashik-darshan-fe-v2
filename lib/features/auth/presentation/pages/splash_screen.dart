import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/theme/colors.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';

/// Splash screen shown on app start. Resolves auth state (session restore).
/// Guest mode: unauthenticated users go to home to browse; only protected
/// routes/actions will prompt for login.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const routeName = 'SplashScreen';
  static const routePath = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          authenticated: (_) {
            if (context.mounted) context.goNamed(AppRouteNames.home);
          },
          unauthenticated: () {
            if (context.mounted) context.goNamed(AppRouteNames.home);
          },
          error: (_) {
            if (context.mounted) context.goNamed(AppRouteNames.home);
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (MediaQuery.of(context).size.height > 300) ...[
                  Image.asset(
                    'assets/logo/app-logo.png',
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.temple_hindu,
                      size: 80.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
                Text(
                  'Nashik Darshan',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Discover the beauty of Nashik',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: 32.h),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
