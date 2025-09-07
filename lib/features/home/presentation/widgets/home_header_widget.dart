import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String greeting;
  final String userName;
  final String subtitle;

  const HomeHeaderWidget({
    super.key,
    required this.greeting,
    required this.userName,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          4.verticalSpace,
          Text(
            userName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          4.verticalSpace,
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
