/// Request entity untuk API get_rekap laporan kegiatan
class LaporanKegiatanRequestEntity {
  final String idUser;
  final bool withSubordinate;
  final String status; // "VERIFIKASI" untuk tab Terverifikasi, "WAITING" untuk tab Menunggu Verifikasi
  final String search; // Search query
  final int start; // Pagination start
  final int length; // Pagination length

  const LaporanKegiatanRequestEntity({
    required this.idUser,
    this.withSubordinate = true,
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

