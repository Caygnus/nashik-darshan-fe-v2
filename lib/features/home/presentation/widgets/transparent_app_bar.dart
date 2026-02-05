import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';

/// Transparent AppBar Widget
/// Displays a transparent app bar with location info and user greeting
/// Changes background to white with blur when scrolling
class TransparentAppBarWidget extends StatefulWidget {
  final double scrollOffset;

  const TransparentAppBarWidget({
    super.key,
    this.scrollOffset = 0.0,
  });

  @override
  State<TransparentAppBarWidget> createState() => _TransparentAppBarWidgetState();
}

class _TransparentAppBarWidgetState extends State<TransparentAppBarWidget> {
  bool? _lastAppliedScrolling;

  void _updateSystemUIIfNeeded(bool isScrolling) {
    if (isScrolling == _lastAppliedScrolling) return;
    _lastAppliedScrolling = isScrolling;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isScrolling ? Brightness.dark : Brightness.light,
        statusBarBrightness: isScrolling ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isScrolling
            ? const Color(0x4DFFFFFF)
            : Colors.transparent,
        systemNavigationBarIconBrightness: isScrolling ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isScrolling = widget.scrollOffset > 0;

    // Text and icon colors based on scroll state
    final Color textColor = isScrolling ? Colors.black : Colors.white;
    final Color iconColor = isScrolling ? Colors.black : Colors.white;

    // Only update system UI when scroll state actually changes to avoid flicker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSystemUIIfNeeded(isScrolling);
    });

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isScrolling ? 4.0 : 0.0,
              sigmaY: isScrolling ? 4.0 : 0.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isScrolling 
                    ? const Color(0x4DFFFFFF) // #FFFFFF4D when scrolling (30% opacity white)
                    : Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status bar inset only
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  // Compact app bar row: top-aligned, reduced height
                  SizedBox(
                    height: 48.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Leading: location icon + Hi user + location text (top-aligned)
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, top: 6.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/location.svg',
                                width: 11.w,
                                height: 11.h,
                                colorFilter: ColorFilter.mode(
                                  iconColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Builder(
                                    builder: (context) {
                                      String userName = 'Ram Lokhande';
                                      try {
                                        final authCubit = context.read<AuthCubit>();
                                        final state = authCubit.state;
                                        userName = state.maybeWhen(
                                          authenticated: (user) => user.name,
                                          orElse: () => 'Ram Lokhande',
                                        );
                                      } catch (e, stackTrace) {
                                        if (kDebugMode) {
                                          debugPrint(
                                            'TransparentAppBar: AuthCubit not available, using default name. '
                                            'Error: $e\n$stackTrace',
                                          );
                                        }
                                        userName = 'Ram Lokhande';
                                      }
                                      return Text(
                                        'Hi, $userName',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                          height: 32 / 13, // 32px line height for 13sp font
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Satpur, Nashik',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w300,
                                      color: textColor,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Bell icon top-aligned
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, right: 8.w),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                            icon: Icon(Icons.notifications_outlined, size: 24.sp, color: iconColor),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
