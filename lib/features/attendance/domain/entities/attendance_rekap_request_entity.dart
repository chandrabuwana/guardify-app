/// Request entity untuk rekapitulasi kehadiran
class AttendanceRekapRequestEntity {
  final String idUser;
  final bool withSubordinate;
  final bool isAdmin;
  final String status; // Filter by status
  final String search; // Search query
  final DateTime? startDate; // Filter by start date
  final DateTime? endDate; // Filter by end date
  final int start; // Pagination start
  final int length; // Pagination length
  final String shiftName;
  final String jabatan;
  final bool isOvertime;

  const AttendanceRekapRequestEntity({
    required this.idUser,
    this.withSubordinate = false,
    this.isAdmin = false,
    this.status = '',
    this.search = '',
    this.startDate,
    this.endDate,
    this.start = 1,
    this.length = 10,
    this.shiftName = '',
    this.jabatan = '',
    this.isOvertime = false,
  });

  Map<String, dynamic> toJson() {
    final filters = <Map<String, dynamic>>[];
    if (status.trim().isNotEmpty) {
      filters.add({'Field': 'status', 'Search': status.trim()});
    }
    if (search.trim().isNotEmpty) {
      filters.add({'Field': 'search', 'Search': search.trim()});
    }

    final json = <String, dynamic>{
      'IdUser': idUser,
      'WithSubordinate': withSubordinate,
      'IsAdmin': isAdmin,
      'Search': search,
      'StartDate': startDate != null ? _formatDate(startDate!) : null,
      'EndDate': endDate != null ? _formatDate(endDate!) : null,
      'Start': start,
      'Length': length,
      'ShiftName': shiftName,
      'Jabatan': jabatan,
      'IsOvertime': isOvertime,
    };

    final normalizedStatus = status.trim().toUpperCase();
    if (normalizedStatus.isNotEmpty && normalizedStatus != 'WAITING') {
      json['Status'] = status.trim();
    }

    return json;
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    final millisecond = date.millisecond.toString().padLeft(3, '0');
    return '$year-$month-${day}T$hour:$minute:$second.$millisecond';
  }
}

