/// Entity untuk data personil
class Personnel {
  final String id;
  final String nrp;
  final String name;
  final String email;
  final String? photoUrl;
  final String role; // PJO, Deputy, Danton, Anggota
  final String status; // Aktif, Pending, Non Aktif
  final String? updateBy;
  final DateTime? updateDate;
  final String? noKtp;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? pendidikan;
  final String? teleponPribadi;
  final String? teleponDarurat;
  final String? site;
  final String? jabatan;
  final String? atasan;
  final String? namaAtasan;
  final DateTime? tanggalPenerimaanKaryawan;
  final DateTime? masaBerlakuPermit;
  final String? kompetensiPekerjaan;
  final String? wargaNegara;
  final String? provinsi;
  final String? kotaKabupaten;
  final String? kecamatan;
  final String? kelurahan;
  final String? alamatDomisili;
  
  // Documents
  final String? ktpUrl;
  final String? ktaUrl;
  final String? fotoUrl;
  final String? p3tdK3lhUrl;
  final String? p3tdSecurityUrl;
  final String? pernyataanTidakMerokokUrl;

  Personnel({
    required this.id,
    required this.nrp,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    required this.status,
    this.updateBy,
    this.updateDate,
    this.noKtp,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.pendidikan,
    this.teleponPribadi,
    this.teleponDarurat,
    this.site,
    this.jabatan,
    this.atasan,
    this.namaAtasan,
    this.tanggalPenerimaanKaryawan,
    this.masaBerlakuPermit,
    this.kompetensiPekerjaan,
    this.wargaNegara,
    this.provinsi,
    this.kotaKabupaten,
    this.kecamatan,
    this.kelurahan,
    this.alamatDomisili,
    this.ktpUrl,
    this.ktaUrl,
    this.fotoUrl,
    this.p3tdK3lhUrl,
    this.p3tdSecurityUrl,
    this.pernyataanTidakMerokokUrl,
  });
}
