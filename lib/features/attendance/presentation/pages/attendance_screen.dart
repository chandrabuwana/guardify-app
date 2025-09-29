import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_form_widget.dart';
import '../widgets/attendance_header_widget.dart';
import '../widgets/location_detection_widget.dart';
import '../widgets/validation_dialog_widget.dart';
import '../widgets/success_dialog_widget.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_validation_rules.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceType attendanceType;
  final ShiftType shiftType;
  final String userId;
  final String userName;
  final String guardLocation;

  const AttendanceScreen({
    super.key,
    required this.attendanceType,
    required this.shiftType,
    required this.userId,
    required this.userName,
    required this.guardLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AttendanceBloc>()..add(const AttendanceInitialEvent()),
      child: _AttendanceScreenView(
        attendanceType: attendanceType,
        shiftType: shiftType,
        userId: userId,
        userName: userName,
        guardLocation: guardLocation,
      ),
    );
  }
}

class _AttendanceScreenView extends StatelessWidget {
  final AttendanceType attendanceType;
  final ShiftType shiftType;
  final String userId;
  final String userName;
  final String guardLocation;

  const _AttendanceScreenView({
    required this.attendanceType,
    required this.shiftType,
    required this.userId,
    required this.userName,
    required this.guardLocation,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      enableScrolling: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mulai Bekerja',
          style: TS.titleLarge.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      child: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceValidationSuccess) {
            _showValidationDialog(context, state.message, true);
          } else if (state is AttendanceValidationError) {
            _showValidationDialog(context, state.message, false);
          } else if (state is AttendanceSubmissionSuccess) {
            _showSuccessDialog(context, state.message);
          } else if (state is AttendanceSubmissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading ||
              state is AttendanceSubmissionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: REdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with scanner frame
                AttendanceHeaderWidget(
                  userName: userName,
                  attendanceType: attendanceType,
                ),

                20.verticalSpace,

                // Location detection widget
                LocationDetectionWidget(
                  targetLocation: guardLocation,
                  onLocationDetected: (lat, lng, locationName) {
                    context.read<AttendanceBloc>().add(
                          LocationDetectedEvent(
                            latitude: lat,
                            longitude: lng,
                            locationName: locationName,
                          ),
                        );
                  },
                ),

                20.verticalSpace,

                // Form fields
                AttendanceFormWidget(
                  onFormChanged: (fieldName, value) {
                    context.read<AttendanceBloc>().add(
                          AttendanceFormFieldChangedEvent(
                            fieldName: fieldName,
                            value: value,
                          ),
                        );
                  },
                  onPhotoCaptured: (photoPath) {
                    context.read<AttendanceBloc>().add(
                          PhotoCapturedEvent(photoPath),
                        );
                  },
                  onPhotoRemoved: () {
                    context.read<AttendanceBloc>().add(
                          const PhotoRemovedEvent(),
                        );
                  },
                ),

                40.verticalSpace,

                // Action buttons
                _buildActionButtons(context, state),

                20.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AttendanceState state) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: REdgeInsets.symmetric(vertical: 15),
              elevation: 0,
            ),
            child: Text(
              'KEMBALI',
              style: TS.labelLarge.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        20.horizontalSpace,
        Expanded(
          child: ElevatedButton(
            onPressed: state is AttendanceFormState && state.isFormValid
                ? () => _handleContinue(context, state)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: REdgeInsets.symmetric(vertical: 15),
              elevation: 0,
            ),
            child: Text(
              'LANJUT',
              style: TS.labelLarge.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleContinue(BuildContext context, AttendanceFormState state) {
    // First validate time and location
    context.read<AttendanceBloc>().add(
          ValidateTimeAndLocationEvent(
            shiftType: shiftType,
            guardLocation: guardLocation,
            currentLocation: state.currentLocation,
            userRole: UserRole.member, // This should come from user session
          ),
        );
  }

  void _showValidationDialog(
      BuildContext context, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ValidationDialogWidget(
        message: message,
        isSuccess: isSuccess,
        onConfirm: () {
          Navigator.of(context).pop();
          if (isSuccess) {
            // Show confirmation dialog for proceeding with attendance
            _showSubmissionConfirmationDialog(context);
          }
        },
      ),
    );
  }

  void _showSubmissionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: const BoxDecoration(
                color: Color(0xFFB71C1C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            20.verticalSpace,
            Text(
              'Apakah Anda yakin\nmengirim laporan bekerja?',
              textAlign: TextAlign.center,
              style: TS.titleMedium.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Submit attendance
                    context.read<AttendanceBloc>().add(
                          SubmitAttendanceEvent(
                            type: attendanceType,
                            shiftType: shiftType,
                            userId: userId,
                            userName: userName,
                            guardLocation: guardLocation,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: REdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    'Ya',
                    style: TS.labelLarge.copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              10.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB71C1C),
                    side: const BorderSide(color: Color(0xFFB71C1C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: REdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Tidak',
                    style: TS.labelLarge.copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialogWidget(
        message: message,
        onConfirm: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Go back to home
        },
      ),
    );
  }
}
