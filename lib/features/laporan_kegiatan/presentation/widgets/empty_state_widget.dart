import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/design/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({
    Key? key,
    this.message = 'Tidak ditemukan',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration with documents and magnifying glass
          Container(
            width: 200.w,
            height: 200.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Document icons
                Positioned(
                  left: 20.w,
                  top: 20.h,
                  child: _buildDocumentIcon(
                    size: 40.w,
                    color: primaryColor.withOpacity(0.3),
                    rotation: -0.2,
                  ),
                ),
                Positioned(
                  right: 30.w,
                  top: 40.h,
                  child: _buildDocumentIcon(
                    size: 35.w,
                    color: primaryColor.withOpacity(0.2),
                    rotation: 0.15,
                  ),
                ),
                Positioned(
                  left: 50.w,
                  bottom: 30.h,
                  child: _buildDocumentIcon(
                    size: 30.w,
                    color: primaryColor.withOpacity(0.25),
                    rotation: -0.1,
                  ),
                ),
                // Magnifying glass with X
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '✕',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          24.verticalSpace,
          Text(
            message,
            style: TS.titleMedium.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentIcon({
    required double size,
    required Color color,
    required double rotation,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size * 1.4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: REdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Column(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: REdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 1,
                      ),
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



