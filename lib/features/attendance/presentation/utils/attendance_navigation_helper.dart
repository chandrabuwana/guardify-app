import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../attendance/domain/usecases/get_attendance_status_usecase.dart';
import '../../../attendance/presentation/pages/check_in_page.dart';
import '../../../attendance/presentation/pages/check_out_page.dart';

class AttendanceNavigationHelper {
  static Future<void> navigateToAttendance({
    required BuildContext context,
    required String userId,
    required String namaPersonil,
  }) async {
    try {
      // Get current attendance status
      final getStatusUseCase = getIt<GetAttendanceStatusUseCase>();
      final statusResult = await getStatusUseCase(userId);

      statusResult.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        (status) {
          if (status.status == UserAttendanceStatus.notCheckedIn) {
            // Navigate to Check In page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckInPage(
                  userId: userId,
                  namaPersonil: namaPersonil,
                ),
              ),
            );
          } else if (status.status == UserAttendanceStatus.checkedIn) {
            // Navigate to Check Out page
            final attendanceId = status.currentAttendance?.id ?? '';
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckOutPage(
                  userId: userId,
                  attendanceId: attendanceId,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Anda sudah melakukan check out hari ini'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
