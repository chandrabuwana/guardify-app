import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';

class ValidationDialogWidget extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback onConfirm;

  const ValidationDialogWidget({
    super.key,
    required this.message,
    required this.isSuccess,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      contentPadding: REdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green : const Color(0xFFB71C1C),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check : Icons.close,
              color: Colors.white,
              size: 30.r,
            ),
          ),
          20.verticalSpace,
          Text(
            message,
            textAlign: TextAlign.center,
            style: TS.titleMedium.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          30.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSuccess ? Colors.green : const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: REdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Text(
                'OK',
                style: TS.labelLarge.copyWith(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
