import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/theme/colors.dart';

/// Traveler type option for personalization.
class TravelerType {
  const TravelerType({
    required this.id,
    required this.label,
    required this.icon,
  });
  final String id;
  final String label;
  final IconData icon;
}

/// Page shown after signup to collect language and traveler type preferences.
/// Matches design: Welcome header, hero image, "Personalize Your Journey" card
/// with language dropdown and traveler type grid, then "Start Your Nashik Journey" CTA.
class PersonalizeJourneyPage extends StatefulWidget {
  const PersonalizeJourneyPage({super.key});

  @override
  State<PersonalizeJourneyPage> createState() => _PersonalizeJourneyPageState();
}

class _PersonalizeJourneyPageState extends State<PersonalizeJourneyPage> {
  static const List<String> _languages = ['English', 'Marathi', 'Hindi'];
  static const List<TravelerType> _travelerTypes = [
    TravelerType(id: 'family', label: 'Family', icon: Icons.family_restroom),
    TravelerType(id: 'solo', label: 'Solo', icon: Icons.person_outline),
    TravelerType(id: 'couple', label: 'Couple', icon: Icons.favorite_border),
    TravelerType(id: 'adventure', label: 'Adventure', icon: Icons.hiking),
    TravelerType(id: 'pilgrim', label: 'Pilgrim', icon: Icons.self_improvement),
    TravelerType(id: 'foodie', label: 'Foodie', icon: Icons.restaurant),
  ];

  String _selectedLanguage = _languages.first;
  String? _selectedTravelerTypeId;

  void _onStartJourney() {
    // TODO: Persist _selectedLanguage and _selectedTravelerTypeId (e.g. SharedPreferences or user profile)
    context.goNamed(AppRouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 12.h),
              // Header
              Text(
                'Welcome to Nashik Darshan',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Discover the beauty of Nashik',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              // Hero image
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  'assets/images/home-hero.png',
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h),
              // Personalize card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
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
                    // Section title with icon
                    Row(
                      children: [
                        Icon(
                          Icons.settings_suggest,
                          color: AppColors.primary,
                          size: 26.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Personalize Your Journey',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    // Preferred Language
                    Text(
                      'Preferred Language',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLanguage,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkText, size: 24.sp),
                          items: _languages.map((lang) {
                            return DropdownMenuItem<String>(
                              value: lang,
                              child: Text(
                                lang,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.darkText,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedLanguage = value);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    // Traveler type
                    Text(
                      'What type of traveler are you?',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 1.1,
                      children: _travelerTypes.map((type) {
                        final isSelected = _selectedTravelerTypeId == type.id;
                        return _TravelerTypeChip(
                          type: type,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedTravelerTypeId =
                                  _selectedTravelerTypeId == type.id ? null : type.id;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 28.h),
                    // Start journey button - gradient
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              Color(0xFFFFB366),
                              Color(0xFFFFD700),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: ElevatedButton(
                          onPressed: _onStartJourney,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Start Your Nashik Journey',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: Text(
                        "Start your journey to explore Nashik's hidden gems",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.grey,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _TravelerTypeChip extends StatelessWidget {
  const _TravelerTypeChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final TravelerType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type.icon,
                color: AppColors.primary,
                size: 28.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
