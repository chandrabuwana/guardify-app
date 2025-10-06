import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';

/// Widget untuk menampilkan item menu di halaman profil
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: (titleColor ?? primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: titleColor ?? primaryColor,
                size: 20.w,
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Title
            Expanded(
              child: Text(
                title,
                style: TS.bodyLarge.copyWith(
                  color: titleColor ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}