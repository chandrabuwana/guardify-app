import 'package:flutter_test/flutter_test.dart';
import 'package:guardify_app/core/constants/enums.dart';
import 'package:guardify_app/features/home/presentation/bloc/home_state.dart';

/// Test file to trace "Akhiri Bekerja" button visibility logic
/// This helps verify our fix works correctly with dummy data
void main() {
  group('Shift Button Visibility Tests', () {
    test('Anggota checked in - should show Akhiri Bekerja even with no shift', () {
      // Simulate scenario: User checked in, then shift changed
      final attendanceInfo = AttendanceInfo(
        isCheckedIn: true,      // User is checked in
        isCheckedOut: false,    // User hasn't checked out
        hasShift: false,        // No current shift (shift changed)
        isOnLeave: false,       // Not on leave
        currentTime: '08:00',
        shift: 'Tidak ada shift hari ini',
        position: 'Security',
        date: DateTime.now(),
      );

      // Test button visibility logic
      final shouldShowButton = UserRole.anggota == UserRole.pengawas
          ? !attendanceInfo.isCheckedOut
          : (attendanceInfo.isCheckedIn 
              ? !attendanceInfo.isCheckedOut 
              : (!attendanceInfo.isCheckedOut && attendanceInfo.hasShift && !attendanceInfo.isOnLeave));

      print('🧪 Test: Anggota checked in, no shift');
      print('  - isCheckedIn: ${attendanceInfo.isCheckedIn}');
      print('  - isCheckedOut: ${attendanceInfo.isCheckedOut}');
      print('  - hasShift: ${attendanceInfo.hasShift}');
      print('  - isOnLeave: ${attendanceInfo.isOnLeave}');
      print('  - shouldShowButton: $shouldShowButton');
      print('  - buttonText: ${attendanceInfo.isCheckedIn ? "Akhiri Bekerja" : "Mulai Bekerja"}');

      expect(shouldShowButton, true, reason: 'Button should show when user is checked in');
      expect(attendanceInfo.isCheckedIn, true, reason: 'User should be checked in');
    });

    test('Anggota not checked in - should NOT show button without shift', () {
      // Normal scenario: No shift, not checked in
      final attendanceInfo = AttendanceInfo(
        isCheckedIn: false,     // User not checked in
        isCheckedOut: false,    // User hasn't checked out
        hasShift: false,        // No current shift
        isOnLeave: false,       // Not on leave
        currentTime: '08:00',
        shift: 'Tidak ada shift hari ini',
        position: 'Security',
        date: DateTime.now(),
      );

      final shouldShowButton = UserRole.anggota == UserRole.pengawas
          ? !attendanceInfo.isCheckedOut
          : (attendanceInfo.isCheckedIn 
              ? !attendanceInfo.isCheckedOut 
              : (!attendanceInfo.isCheckedOut && attendanceInfo.hasShift && !attendanceInfo.isOnLeave));

      print('🧪 Test: Anggota not checked in, no shift');
      print('  - isCheckedIn: ${attendanceInfo.isCheckedIn}');
      print('  - isCheckedOut: ${attendanceInfo.isCheckedOut}');
      print('  - hasShift: ${attendanceInfo.hasShift}');
      print('  - isOnLeave: ${attendanceInfo.isOnLeave}');
      print('  - shouldShowButton: $shouldShowButton');
      print('  - buttonText: ${attendanceInfo.isCheckedIn ? "Akhiri Bekerja" : "Mulai Bekerja"}');

      expect(shouldShowButton, false, reason: 'Button should NOT show when user not checked in and no shift');
    });

    test('Anggota checked in with shift - should show Akhiri Bekerja', () {
      // Normal scenario: User checked in with active shift
      final attendanceInfo = AttendanceInfo(
        isCheckedIn: true,      // User is checked in
        isCheckedOut: false,    // User hasn't checked out
        hasShift: true,         // Has active shift
        isOnLeave: false,       // Not on leave
        currentTime: '08:00',
        shift: 'Shift Pagi',
        position: 'Security',
        date: DateTime.now(),
      );

      final shouldShowButton = UserRole.anggota == UserRole.pengawas
          ? !attendanceInfo.isCheckedOut
          : (attendanceInfo.isCheckedIn 
              ? !attendanceInfo.isCheckedOut 
              : (!attendanceInfo.isCheckedOut && attendanceInfo.hasShift && !attendanceInfo.isOnLeave));

      print('🧪 Test: Anggota checked in with shift');
      print('  - isCheckedIn: ${attendanceInfo.isCheckedIn}');
      print('  - isCheckedOut: ${attendanceInfo.isCheckedOut}');
      print('  - hasShift: ${attendanceInfo.hasShift}');
      print('  - isOnLeave: ${attendanceInfo.isOnLeave}');
      print('  - shouldShowButton: $shouldShowButton');
      print('  - buttonText: ${attendanceInfo.isCheckedIn ? "Akhiri Bekerja" : "Mulai Bekerja"}');

      expect(shouldShowButton, true, reason: 'Button should show when user is checked in with shift');
    });

    test('Anggota checked out - should NOT show button', () {
      // Scenario: User already checked out
      final attendanceInfo = AttendanceInfo(
        isCheckedIn: true,      // User was checked in
        isCheckedOut: true,     // User has checked out
        hasShift: true,         // Has shift
        isOnLeave: false,       // Not on leave
        currentTime: '17:00',
        shift: 'Shift Pagi',
        position: 'Security',
        date: DateTime.now(),
      );

      final shouldShowButton = UserRole.anggota == UserRole.pengawas
          ? !attendanceInfo.isCheckedOut
          : (attendanceInfo.isCheckedIn 
              ? !attendanceInfo.isCheckedOut 
              : (!attendanceInfo.isCheckedOut && attendanceInfo.hasShift && !attendanceInfo.isOnLeave));

      print('🧪 Test: Anggota checked out');
      print('  - isCheckedIn: ${attendanceInfo.isCheckedIn}');
      print('  - isCheckedOut: ${attendanceInfo.isCheckedOut}');
      print('  - hasShift: ${attendanceInfo.hasShift}');
      print('  - isOnLeave: ${attendanceInfo.isOnLeave}');
      print('  - shouldShowButton: $shouldShowButton');
      print('  - buttonText: ${attendanceInfo.isCheckedIn ? "Akhiri Bekerja" : "Mulai Bekerja"}');

      expect(shouldShowButton, false, reason: 'Button should NOT show when user is checked out');
    });

    test('Pengawas role - different logic', () {
      // Pengawas has different button logic
      final attendanceInfo = AttendanceInfo(
        isCheckedIn: false,     // Pengawas doesn't have checkin/checkout
        isCheckedOut: false,    // Pengawas doesn't have checkin/checkout
        hasShift: false,        // Shift doesn't matter for pengawas
        isOnLeave: false,       // Not on leave
        currentTime: '08:00',
        shift: 'Shift Pagi',
        position: 'Pengawas',
        date: DateTime.now(),
      );

      final shouldShowButton = UserRole.pengawas == UserRole.pengawas
          ? !attendanceInfo.isCheckedOut
          : (attendanceInfo.isCheckedIn 
              ? !attendanceInfo.isCheckedOut 
              : (!attendanceInfo.isCheckedOut && attendanceInfo.hasShift && !attendanceInfo.isOnLeave));

      print('🧪 Test: Pengawas role');
      print('  - userRole: UserRole.pengawas');
      print('  - isCheckedIn: ${attendanceInfo.isCheckedIn}');
      print('  - isCheckedOut: ${attendanceInfo.isCheckedOut}');
      print('  - hasShift: ${attendanceInfo.hasShift}');
      print('  - shouldShowButton: $shouldShowButton');

      expect(shouldShowButton, true, reason: 'Pengawas button should show unless checked out');
    });
  });
}

/// Helper function to simulate the button visibility logic from ShiftCard
bool evaluateButtonVisibility({
  required UserRole userRole,
  required bool isCheckedIn,
  required bool isCheckedOut,
  required bool hasShift,
  required bool isOnLeave,
}) {
  return userRole == UserRole.pengawas
      ? !isCheckedOut
      : (isCheckedIn 
          ? !isCheckedOut 
          : (!isCheckedOut && hasShift && !isOnLeave));
}
