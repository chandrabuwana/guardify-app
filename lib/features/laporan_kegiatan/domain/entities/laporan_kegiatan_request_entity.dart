/// Request entity untuk API get_rekap laporan kegiatan
class LaporanKegiatanRequestEntity {
  final String idUser;
  final bool withSubordinate;
  final bool isAdmin;
  final String status; // "VERIFIKASI" untuk tab Terverifikasi, "WAITING" untuk tab Menunggu Verifikasi
  final String search; // Search query
  final int start; // Pagination start
  final int length; // Pagination length
  final String? startDate; // Format: yyyy-MM-dd
  final String? endDate; // Format: yyyy-MM-dd
  final List<Map<String, String>>? filter;

  const LaporanKegiatanRequestEntity({
    required this.idUser,
    this.withSubordinate = true,
    this.isAdmin = false,
    this.status = '',
    this.search = '',
    this.start = 1,
    this.length = 10,
    this.startDate,
    this.endDate,
    this.filter,
  });

  Map<String, dynamic> toJson() {
    return {
      'IdUser': idUser,
      'WithSubordinate': withSubordinate,
      'IsAdmin': isAdmin,
      'Status': status,
      'Search': search,
      'Start': start,
      'Length': length,
      'StartDate': startDate,
      'EndDate': endDate,
      'Filter': filter,
    };
  }
}

