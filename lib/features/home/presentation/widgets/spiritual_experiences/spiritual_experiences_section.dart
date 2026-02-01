import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/router/route_names.dart';

import 'spiritual_experience_card.dart';

/// Spiritual Experiences Section Widget
/// Displays a grid of spiritual experience cards
class SpiritualExperiencesSection extends StatelessWidget {
  const SpiritualExperiencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Spiritual Experiences',
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
              height: 28 / 18, // line height / font size
            ),
          ),
          SizedBox(height: 16.h),
          // 2x2 Grid
          Row(
            children: [
              SpiritualExperienceCard(
                iconPath: 'assets/svg/om.svg',
                title: 'Temple Darshan',
                subtitle: 'Live slots available',
                onTap: () {
                  context.pushNamed(AppRouteNames.templeDarshan);
                },
              ),
              SizedBox(width: 12.w),
              SpiritualExperienceCard(
                iconPath: 'assets/svg/arti.svg',
                title: 'Aarti Timing',
                subtitle: 'Next timing',
                onTap: () {
                  context.pushNamed(AppRouteNames.aartiTiming);
                },
              ),
            ],
          ),
          // TODO: Uncomment when needed
          // SizedBox(height: 12.h),
          // Row(
          //   children: [
          //     const SpiritualExperienceCard(
          //       iconPath: 'assets/svg/person.svg',
          //       title: 'Spiritual Guide',
          //       subtitle: 'Local experts',
          //     ),
          //     SizedBox(width: 12.w),
          //     const SpiritualExperienceCard(
          //       iconPath: 'assets/svg/puja.svg',
          //       title: 'Puja Rituals',
          //       subtitle: 'Book now',
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
