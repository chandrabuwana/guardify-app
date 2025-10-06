import 'package:equatable/equatable.dart';

/// Entity untuk data profil user
class ProfileUser extends Equatable {
  final String id;
  final String nrp;
  final String noKtp;
  final String name;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final String pendidikan;
  final String teleponPribadi;
  final String teleponDarurat;
  final String site;
  final String jabatan;
  final String atasan;
  final DateTime tglPenerimaanKaryawan;
  final DateTime masaBerlakuPermit;
  final String kompetensiPekerjaan;
  final String wargaNegara;
  final String provinsi;
  final String kotaKabupaten;
  final String kecamatan;
  final String kelurahan;
  final String alamatDomisili;
  final String? profileImageUrl;
  final Map<String, String>? documents;

  const ProfileUser({
    required this.id,
    required this.nrp,
    required this.noKtp,
    required this.name,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.pendidikan,
    required this.teleponPribadi,
    required this.teleponDarurat,
    required this.site,
    required this.jabatan,
    required this.atasan,
    required this.tglPenerimaanKaryawan,
    required this.masaBerlakuPermit,
    required this.kompetensiPekerjaan,
    required this.wargaNegara,
    required this.provinsi,
    required this.kotaKabupaten,
    required this.kecamatan,
    required this.kelurahan,
    required this.alamatDomisili,
    this.profileImageUrl,
    this.documents,
  });

  @override
  List<Object?> get props => [
        id,
        nrp,
        noKtp,
        name,
        tempatLahir,
        tanggalLahir,
        jenisKelamin,
        pendidikan,
        teleponPribadi,
        teleponDarurat,
        site,
        jabatan,
        atasan,
        tglPenerimaanKaryawan,
        masaBerlakuPermit,
        kompetensiPekerjaan,
        wargaNegara,
        provinsi,
        kotaKabupaten,
        kecamatan,
        kelurahan,
        alamatDomisili,
        profileImageUrl,
        documents,
      ];

  /// Copy with method untuk membuat instance baru dengan perubahan tertentu
  ProfileUser copyWith({
    String? id,
    String? nrp,
    String? noKtp,
    String? name,
    String? tempatLahir,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? pendidikan,
    String? teleponPribadi,
    String? teleponDarurat,
    String? site,
    String? jabatan,
    String? atasan,
    DateTime? tglPenerimaanKaryawan,
    DateTime? masaBerlakuPermit,
    String? kompetensiPekerjaan,
    String? wargaNegara,
    String? provinsi,
    String? kotaKabupaten,
    String? kecamatan,
    String? kelurahan,
    String? alamatDomisili,
    String? profileImageUrl,
    Map<String, String>? documents,
  }) {
    return ProfileUser(
      id: id ?? this.id,
      nrp: nrp ?? this.nrp,
      noKtp: noKtp ?? this.noKtp,
      name: name ?? this.name,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      pendidikan: pendidikan ?? this.pendidikan,
      teleponPribadi: teleponPribadi ?? this.teleponPribadi,
      teleponDarurat: teleponDarurat ?? this.teleponDarurat,
      site: site ?? this.site,
      jabatan: jabatan ?? this.jabatan,
      atasan: atasan ?? this.atasan,
      tglPenerimaanKaryawan: tglPenerimaanKaryawan ?? this.tglPenerimaanKaryawan,
      masaBerlakuPermit: masaBerlakuPermit ?? this.masaBerlakuPermit,
      kompetensiPekerjaan: kompetensiPekerjaan ?? this.kompetensiPekerjaan,
      wargaNegara: wargaNegara ?? this.wargaNegara,
      provinsi: provinsi ?? this.provinsi,
      kotaKabupaten: kotaKabupaten ?? this.kotaKabupaten,
      kecamatan: kecamatan ?? this.kecamatan,
      kelurahan: kelurahan ?? this.kelurahan,
      alamatDomisili: alamatDomisili ?? this.alamatDomisili,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      documents: documents ?? this.documents,
    );
  }
}