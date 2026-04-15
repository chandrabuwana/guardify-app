/// Entity untuk item rekapitulasi kehadiran
class AttendanceRekapEntity {
  final String? idAttendance;
  final DateTime shiftDate;
  final String shiftName;
  final bool isOvertime;
  final String? status; // CheckIn, null, etc
  final String statusAttendance; // Masuk, Terlambat, Tidak Masuk
  final String statusCarryOver; // Selesai, Belum Selesai
  final String patrol; // Selesai (5/5), Belum Mulai, Belum Selesai 1/2
  final DateTime? checkIn;
  final DateTime? checkOut;

  const AttendanceRekapEntity({
    this.idAttendance,
    required this.shiftDate,
    required this.shiftName,
    required this.isOvertime,
    this.status,
    required this.statusAttendance,
    required this.statusCarryOver,
    required this.patrol,
    this.checkIn,
    this.checkOut,
  });

  /// Get status badge text - langsung dari API Status field tanpa mapping
  String get statusBadgeText {
    // Langsung tampilkan status dari API, jika null tampilkan default
    return status ?? 'Waiting';
  }

  /// Get status badge color - berdasarkan status dari API
  String get statusBadgeColor {
    if (status == null) {
      // Jika status null dan idAttendance null, berarti verified
      if (idAttendance == null) {
        return 'verified';
      }
      // Jika status null tapi ada idAttendance, berarti waiting
      return 'waiting';
    }
    
    // Mapping status dari API ke warna badge
    final statusUpper = status!.toUpperCase();
    
    switch (statusUpper) {
      case 'CHECKIN':
      case 'CHECK_IN':
        return 'waiting'; // Blue
      case 'WAITING':
        return 'waiting'; // Blue
      case 'VERIFIED':
      case 'VERIFIKASI':
        return 'verified'; // Light blue
      case 'REVISION':
      case 'REVISI':
        return 'revision'; // Orange
      default:
        return 'waiting'; // Default blue
    }
  }

  /// Get border color based on status
  String get borderColor {
    final normalizedStatus = statusAttendance.toLowerCase();
    if (normalizedStatus == 'tidak masuk' || normalizedStatus == 'absent') {
      return 'red';
    }
    if (normalizedStatus == 'terlambat' || normalizedStatus == 'late') {
      return 'orange';
    }
    if ((normalizedStatus == 'masuk' || normalizedStatus == 'present') && status == null && idAttendance != null) {
      return 'blue';
    }
    return 'gray'; // Default gray border
  }

  /// Format work hours
  String get workHours {
    if (checkIn == null || checkOut == null) {
      return '-';
    }
    final checkInTime = '${checkIn!.hour.toString().padLeft(2, '0')}.${checkIn!.minute.toString().padLeft(2, '0')}';
    final checkOutTime = '${checkOut!.hour.toString().padLeft(2, '0')}.${checkOut!.minute.toString().padLeft(2, '0')}';
    return '$checkInTime - $checkOutTime';
  }

  /// Format pending tasks status
  String get pendingTasksStatus {
    return statusCarryOver == 'Selesai' ? 'Selesai' : '-';
  }

  /// Format patrol status
  String get patrolStatus {
    if (patrol == 'Belum Mulai') {
      return '-';
    }
    return patrol;
  }

  /// Format overtime status
  String get overtimeStatus {
    return isOvertime ? 'Ya' : 'Tidak';
  }

  /// Get formatted status attendance - maps Indonesian to English if needed
  String get formattedStatusAttendance {
    // Map Indonesian status to English
    switch (statusAttendance) {
      case 'Masuk':
        return 'Present';
      case 'Terlambat':
        return 'Late';
      case 'Tidak Masuk':
        return 'Absent';
      case 'Izin':
        return 'Leave';
      case 'Sakit':
        return 'Sick';
      default:
        // If already in English or unknown, return as is
        return statusAttendance;
    }
  }
}

