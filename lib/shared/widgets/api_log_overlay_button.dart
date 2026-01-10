import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/design/colors.dart';
import 'api_log_viewer_dialog.dart';

/// Floating overlay button untuk membuka API log viewer
/// Button ini akan selalu tampil di semua screen untuk debugging
class ApiLogOverlayButton extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ApiLogOverlayButton({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80.h,
      right: 16.w,
      child: FloatingActionButton(
        onPressed: () {
          final navigatorContext = navigatorKey.currentContext;
          if (navigatorContext != null) {
            ApiLogViewerDialog.show(navigatorContext);
          }
        },
        backgroundColor: primaryColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.bug_report, color: Colors.white),
            // Badge dengan jumlah logs (optional, bisa di-enable jika perlu)
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: Container(
            //     padding: EdgeInsets.all(4.w),
            //     decoration: BoxDecoration(
            //       color: errorColor,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Text(
            //       '5',
            //       style: TextStyle(color: Colors.white, fontSize: 10.sp),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
