import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: backgroundColor ?? const Color(0xFFE74C3C),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: (backgroundColor ?? const Color(0xFFE74C3C))
                      .withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 24.r,
            ),
          ),
          8.verticalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
