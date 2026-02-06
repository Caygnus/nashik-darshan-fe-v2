import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/core/keys.dart';
import 'package:nashik/core/theme/colors.dart';

enum SnackbarType { error, success, info, warning }

class Snackbar {
  /// Shows a snackbar with a clean, minimal design
  ///
  /// [message] - The message to display
  /// [type] - The type of snackbar (error, success, info, warning)
  /// [duration] - How long the snackbar should be visible (default: 3 seconds)
  static void show({
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final scaffoldMessenger = scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null) return;

    final (backgroundColor, icon, iconColor) = _getSnackbarConfig(type);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.fixed,
        duration: duration,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }

  /// Shows an error snackbar
  static void showError(String message, {Duration? duration}) {
    show(
      message: message,
      type: SnackbarType.error,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Shows a success snackbar
  static void showSuccess(String message, {Duration? duration}) {
    show(
      message: message,
      type: SnackbarType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Shows an info snackbar
  static void showInfo(String message, {Duration? duration}) {
    show(
      message: message,
      type: SnackbarType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Shows a warning snackbar
  static void showWarning(String message, {Duration? duration}) {
    show(
      message: message,
      type: SnackbarType.warning,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static (Color backgroundColor, IconData icon, Color iconColor)
  _getSnackbarConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return (
          AppColors.errorColor,
          Icons.error_outline_rounded,
          AppColors.white,
        );
      case SnackbarType.success:
        return (
          const Color(0xFF2E7D32), // Green
          Icons.check_circle_outline_rounded,
          AppColors.white,
        );
      case SnackbarType.info:
        return (
          const Color(0xFF1976D2), // Blue
          Icons.info_outline_rounded,
          AppColors.white,
        );
      case SnackbarType.warning:
        return (
          const Color(0xFFF57C00), // Orange
          Icons.warning_amber_rounded,
          AppColors.white,
        );
    }
  }
}
