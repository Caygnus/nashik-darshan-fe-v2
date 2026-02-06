import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/theme/colors.dart';

/// Edit Profile screen: profile summary card, form fields (name, contact, email), Save Changes button.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  static const routeName = 'EditProfilePage';
  static const routePath = '/profile/edit';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Shailesh Birajdar');
    _countryCodeController = TextEditingController(text: '+91');
    _phoneController = TextEditingController(text: '98765 43210');
    _emailController = TextEditingController(text: 'birajdarshailesh7@gmail.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Persist profile and pop
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.sp,
            color: AppColors.darkText,
          ),
          onPressed: () => context.pop(),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileSummaryCard(),
              SizedBox(height: 24.h),
              _buildFormSection(),
              SizedBox(height: 28.h),
              _buildSaveButton(),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSummaryCard() {
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
                  _nameController.text.isEmpty ? 'Your name' : _nameController.text,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _phoneController.text.isEmpty
                      ? 'Your number'
                      : '${_countryCodeController.text} ${_phoneController.text}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit,
            size: 22.sp,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Your Full name'),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: _nameController,
          hint: 'Enter your full name',
          keyboardType: TextInputType.name,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your full name' : null,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: 20.h),
        _buildLabel('Your Contact Number'),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCountryCodeField(),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: _phoneController,
                hint: '98765 43210',
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter contact number' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _buildLabel('Email Address'),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: _emailController,
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Enter your email';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) return 'Enter a valid email';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.grey,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 16.sp,
        color: AppColors.darkText,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.hintText,
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
      ),
    );
  }

  Widget _buildCountryCodeField() {
    return Container(
      width: 88.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🇮🇳', style: TextStyle(fontSize: 18.sp)),
          SizedBox(width: 6.w),
          Text(
            '+91',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkText,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _saveChanges,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Save Changes',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.roboto().fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
