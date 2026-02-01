import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';

import '../../../places/data/repositories/place_repository_impl.dart';
import '../../../places/domain/entities/category.dart';
import '../../../places/domain/repositories/place_repository.dart';
import '../../../places/presentation/widgets/event_card.dart';
import '../widgets/spiritual_circuit_card.dart';

// Helper function to safely get Poppins font with fallback
TextStyle _getPoppinsStyle({
  required double fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
}) {
  // Use system font as fallback when Google Fonts fails
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color,
    height: height,
    fontFamily: 'Roboto', // System fallback
  );
}

// Helper function to safely get Montserrat font with fallback
TextStyle _getMontserratStyle({
  required double fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
}) {
  // Use system font as fallback when Google Fonts fails
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color,
    height: height,
    fontFamily: 'Roboto', // System fallback
  );
}

/// Category Page
/// Main page showing all categories, accessible from bottom navigation bar
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final PlaceRepository _repository;
  List<Category> _categories = [];
  bool _isLoading = true;
  final Set<String> _favoriteCategories = {}; // Track favorite categories

  @override
  void initState() {
    super.initState();
    _repository = PlaceRepositoryImpl(); // TODO: Inject via DI
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);

    try {
      final categories = await _repository.getCategories();
      debugPrint('✅ Loaded ${categories.length} categories');

      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading categories: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _categories = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏗️ CategoryPage build: isLoading=$_isLoading, categories=${_categories.length}');
    
    // Test widget to ensure something renders
    if (_categories.isEmpty && !_isLoading) {
      debugPrint('⚠️ No categories but not loading - showing empty state');
    }
    
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(56.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Text(
                  'Categories',
                  style: _getPoppinsStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                    height: 28 / 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
            ),
          ),
          Expanded(
            child: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (_categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'No categories found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: _loadCategories,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          debugPrint('📦 Building content with ${_categories.length} categories');
          
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 14.h),
                // Event Card Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Builder(
                    builder: (context) {
                      try {
                        return EventCard(
                          onBookNow: () {
                            debugPrint('Book Now tapped');
                          },
                        );
                      } catch (e, stackTrace) {
                        debugPrint('❌ Error building EventCard: $e');
                        debugPrint('Stack: $stackTrace');
                        return Container(
                          width: 352.w,
                          height: 135.h,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text('Event Card Error', style: TextStyle(fontSize: 12.sp)),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 32.h),
                // Categories Grid and Spiritual Circuit Card in same padding
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (context) {
                          try {
                            debugPrint('🔨 Building grid with ${_categories.length} items');
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero, // Remove any default padding
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 168 / 233, // 168x233 aspect ratio
                              ),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                if (index >= _categories.length) {
                                  debugPrint('⚠️ Index $index out of bounds (${_categories.length})');
                                  return const SizedBox.shrink();
                                }
                                try {
                                  final category = _categories[index];
                                  debugPrint('🎴 Building card $index: ${category.name}');
                                  return _buildCategoryCard(category);
                                } catch (e, stackTrace) {
                                  debugPrint('❌ Error building card $index: $e');
                                  debugPrint('Stack: $stackTrace');
                                  return Container(
                                    width: 168.w,
                                    height: 233.h,
                                    color: Colors.red[100],
                                    child: Center(
                                      child: Text('Error', style: TextStyle(fontSize: 10.sp)),
                                    ),
                                  );
                                }
                              },
                            );
                          } catch (e, stackTrace) {
                            debugPrint('❌ Error building grid: $e');
                            debugPrint('Stack: $stackTrace');
                            return Container(
                              height: 200.h,
                              color: Colors.orange[100],
                              child: Center(
                                child: Text('Grid Error: $e', style: TextStyle(fontSize: 12.sp)),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12.h), // Minimal spacing between grid and card
                      // Spiritual Circuit Card - appears directly below category cards
                      SpiritualCircuitCard(
                        onBookTour: () {
                          debugPrint('Book tour tapped');
                          // TODO: Navigate to tour booking page
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 85.h), // Bottom padding to prevent overlap with bottom nav bar
              ],
            ),
          );
        },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    try {
      final isFavorite = _favoriteCategories.contains(category.id);
      
      return InkWell(
      onTap: () {
        context.pushNamed(
          AppRouteNames.categoryDetail,
          pathParameters: {'categoryId': category.id},
        );
      },
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        width: 168.w,
        height: 233.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.r),
          color: const Color(0xFFF3F4F6), // Fallback color
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.r),
          child: Stack(
            children: [
              // Background Image
              Image.asset(
                category.imagePath,
                width: 168.w,
                height: 233.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image fails to load
                  return Container(
                    width: 168.w,
                    height: 233.h,
                    color: const Color(0xFFF3F4F6),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 40.sp,
                    ),
                  );
                },
              ),
              // Linear gradient overlay (0% to 50% black)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0), // 0% black at top
                      Colors.black.withValues(alpha: 0.5), // 50% black at bottom
                    ],
                  ),
                ),
              ),
              // Favorite icon (top right)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isFavorite) {
                        _favoriteCategories.remove(category.id);
                      } else {
                        _favoriteCategories.add(category.id);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(9999.r),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              // Bottom content
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon container (left bottom)
                    Container(
                      width: 31.w,
                      height: 31.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBAC9FF),
                        borderRadius: BorderRadius.circular(9999.r),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          category.iconPath,
                          width: 16.w,
                          height: 16.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Category Name
                    Text(
                      category.name,
                      style: _getPoppinsStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600, // SemiBold
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // Sub heading (description)
                    Text(
                      category.description,
                      style: _getMontserratStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400, // Regular
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    } catch (e, stackTrace) {
      debugPrint('❌ Error building category card: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return a placeholder card if there's an error
      return Container(
        width: 168.w,
        height: 233.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.r),
          color: const Color(0xFFF3F4F6),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 32.sp, color: Colors.grey),
              SizedBox(height: 8.h),
              Text(
                'Error',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }
}
