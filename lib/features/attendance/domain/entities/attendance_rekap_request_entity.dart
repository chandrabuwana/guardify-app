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
    final filters = <Map<String, dynamic>>[];
    if (status.trim().isNotEmpty) {
      filters.add({'Field': 'status', 'Search': status.trim()});
    }
    if (search.trim().isNotEmpty) {
      filters.add({'Field': 'search', 'Search': search.trim()});
    }

    return {
      'IdUser': idUser,
      'WithSubordinate': withSubordinate,
      'Status': status,
      'Search': search,
      'Filter': filters,
      'Sort': {
        'Field': '',
        'Type': 0,
      },
      'Start': start,
      'Length': length,
    };
  }
}

