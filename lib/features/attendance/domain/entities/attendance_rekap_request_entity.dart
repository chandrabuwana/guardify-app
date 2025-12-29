/// Request entity untuk rekapitulasi kehadiran
class AttendanceRekapRequestEntity {
  final String idUser;
  final bool withSubordinate;
  final String status; // Filter by status
  final String search; // Search query
  final int start; // Pagination start
  final int length; // Pagination length

  const AttendanceRekapRequestEntity({
    required this.idUser,
    this.withSubordinate = false,
    this.status = '',
    this.search = '',
    this.start = 0,
    this.length = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'IdUser': idUser,
      'WithSubordinate': withSubordinate,
      'Status': status,
      'Search': search,
      'Start': start,
      'Length': length,
    };
  }
}

