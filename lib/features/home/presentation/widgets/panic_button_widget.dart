import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/red_card_widget.dart';

class PanicButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const PanicButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: RedCardWidget(
        title: 'PANIC BUTTON',
        isFullWidth: true,
        height: 80.h, // Explicit height for panic button
        onTap: onPressed,
      ),
    );
  }
}
