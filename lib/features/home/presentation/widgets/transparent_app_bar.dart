import 'dart:ui';

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
class TransparentAppBarWidget extends StatelessWidget {
  final double scrollOffset;
  
  const TransparentAppBarWidget({
    super.key,
    this.scrollOffset = 0.0,
  });

  @override
  Widget build(final BuildContext context) {
    // Determine if scrolling (offset > 0)
    final bool isScrolling = scrollOffset > 0;
    
    // Text and icon colors based on scroll state
    final Color textColor = isScrolling ? Colors.black : Colors.white;
    final Color iconColor = isScrolling ? Colors.black : Colors.white;
    
    // Update system UI overlay style
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                  // Status bar area with blur
                  Container(
                    height: MediaQuery.of(context).padding.top,
                    color: Colors.transparent,
                  ),
                  // App bar content
                  SafeArea(
                    bottom: false, // Don't add bottom padding, we'll handle it
                    child: Container(
                      height: kToolbarHeight + 20.h,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: kToolbarHeight + 20.h,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: isScrolling ? Brightness.dark : Brightness.light,
                          statusBarBrightness: isScrolling ? Brightness.light : Brightness.dark,
                          systemNavigationBarColor: isScrolling 
                              ? const Color(0x4DFFFFFF) 
                              : Colors.transparent,
                          systemNavigationBarIconBrightness: isScrolling ? Brightness.dark : Brightness.light,
                        ),
                        leading: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center, // Vertically center
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Location Icon Column - vertically centered
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center, // Vertically center
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Top row: Icon and "Hi" text side by side
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Location Icon
                                      SvgPicture.asset(
                                        'assets/svg/location.svg',
                                        width: 11.w,
                                        height: 11.h,
                                        colorFilter: ColorFilter.mode(
                                          iconColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 3.w), // Small space between icon and text
                                      // User Greeting
                                      Builder(
                                        builder: (context) {
                                          String userName = 'Ram Lokhande'; // Default name
                                          try {
                                            final authCubit = context.read<AuthCubit>();
                                            final state = authCubit.state;
                                            userName = state.maybeWhen(
                                              authenticated: (user) => user.name,
                                              orElse: () => 'Ram Lokhande',
                                            );
                                          } catch (e) {
                                            // AuthCubit not available, use default
                                            userName = 'Ram Lokhande';
                                          }
                                          return Text(
                                            'Hi, $userName',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600, // SemiBold
                                              color: textColor,
                                              height: 32 / 11, // Line height 32px for 11px font size
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  // Location Text directly below (no spacing)
                                  Transform.translate(
                                    offset: Offset(0, -8.h), // Negative offset to bring text closer, compensating for line height
                                    child: Text(
                                      'Satpur, Nashik',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w300, // Light
                                        color: textColor, // Change to textColor instead of fixed black
                                        height: 1.0, // Tight line height
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        leadingWidth: 200.w,
                        title: const SizedBox.shrink(),
                        actions: [
                          IconButton(
                            icon: Icon(Icons.notifications_outlined, color: iconColor),
                            onPressed: () {
                              // Handle bell icon press
                            },
                          ),
                          SizedBox(width: 8.w),
                        ],
                      ),
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
