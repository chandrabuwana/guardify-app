import '../../domain/entities/profile_user.dart';

/// Data model untuk ProfileUser yang dapat di-serialize ke/dari JSON
class ProfileUserModel extends ProfileUser {
  const ProfileUserModel({
    required super.id,
    required super.nrp,
    required super.noKtp,
    required super.name,
    required super.tempatLahir,
    required super.tanggalLahir,
    required super.jenisKelamin,
    required super.pendidikan,
    required super.teleponPribadi,
    required super.teleponDarurat,
    required super.site,
    required super.jabatan,
    required super.atasan,
    required super.tglPenerimaanKaryawan,
    required super.masaBerlakuPermit,
    required super.kompetensiPekerjaan,
    required super.wargaNegara,
    required super.provinsi,
    required super.kotaKabupaten,
    required super.kecamatan,
    required super.kelurahan,
    required super.alamatDomisili,
    super.profileImageUrl,
    super.documents,
  });

  /// Create ProfileUserModel dari JSON
  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      id: json['id'] as String,
      nrp: json['nrp'] as String,
      noKtp: json['no_ktp'] as String,
      name: json['name'] as String,
      tempatLahir: json['tempat_lahir'] as String,
      tanggalLahir: DateTime.parse(json['tanggal_lahir'] as String),
      jenisKelamin: json['jenis_kelamin'] as String,
      pendidikan: json['pendidikan'] as String,
      teleponPribadi: json['telepon_pribadi'] as String,
      teleponDarurat: json['telepon_darurat'] as String,
      site: json['site'] as String,
      jabatan: json['jabatan'] as String,
      atasan: json['atasan'] as String,
      tglPenerimaanKaryawan: DateTime.parse(json['tgl_penerimaan_karyawan'] as String),
      masaBerlakuPermit: DateTime.parse(json['masa_berlaku_permit'] as String),
      kompetensiPekerjaan: json['kompetensi_pekerjaan'] as String,
      wargaNegara: json['warga_negara'] as String,
      provinsi: json['provinsi'] as String,
      kotaKabupaten: json['kota_kabupaten'] as String,
      kecamatan: json['kecamatan'] as String,
      kelurahan: json['kelurahan'] as String,
      alamatDomisili: json['alamat_domisili'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      documents: json['documents'] != null 
          ? Map<String, String>.from(json['documents'] as Map)
          : null,
    );
  }

  /// Convert ProfileUserModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nrp': nrp,
      'no_ktp': noKtp,
      'name': name,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir.toIso8601String(),
      'jenis_kelamin': jenisKelamin,
      'pendidikan': pendidikan,
      'telepon_pribadi': teleponPribadi,
      'telepon_darurat': teleponDarurat,
      'site': site,
      'jabatan': jabatan,
      'atasan': atasan,
      'tgl_penerimaan_karyawan': tglPenerimaanKaryawan.toIso8601String(),
      'masa_berlaku_permit': masaBerlakuPermit.toIso8601String(),
      'kompetensi_pekerjaan': kompetensiPekerjaan,
      'warga_negara': wargaNegara,
      'provinsi': provinsi,
      'kota_kabupaten': kotaKabupaten,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'alamat_domisili': alamatDomisili,
      'profile_image_url': profileImageUrl,
      'documents': documents,
    };
  }

  /// Create ProfileUserModel dari ProfileUser entity
  factory ProfileUserModel.fromEntity(ProfileUser entity) {
    return ProfileUserModel(
      id: entity.id,
      nrp: entity.nrp,
      noKtp: entity.noKtp,
      name: entity.name,
      tempatLahir: entity.tempatLahir,
      tanggalLahir: entity.tanggalLahir,
      jenisKelamin: entity.jenisKelamin,
      pendidikan: entity.pendidikan,
      teleponPribadi: entity.teleponPribadi,
      teleponDarurat: entity.teleponDarurat,
      site: entity.site,
      jabatan: entity.jabatan,
      atasan: entity.atasan,
      tglPenerimaanKaryawan: entity.tglPenerimaanKaryawan,
      masaBerlakuPermit: entity.masaBerlakuPermit,
      kompetensiPekerjaan: entity.kompetensiPekerjaan,
      wargaNegara: entity.wargaNegara,
      provinsi: entity.provinsi,
      kotaKabupaten: entity.kotaKabupaten,
      kecamatan: entity.kecamatan,
      kelurahan: entity.kelurahan,
      alamatDomisili: entity.alamatDomisili,
      profileImageUrl: entity.profileImageUrl,
      documents: entity.documents,
    );
  }

  /// Convert ProfileUserModel ke ProfileUser entity
  ProfileUser toEntity() {
    return ProfileUser(
      id: id,
      nrp: nrp,
      noKtp: noKtp,
      name: name,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
      jenisKelamin: jenisKelamin,
      pendidikan: pendidikan,
      teleponPribadi: teleponPribadi,
      teleponDarurat: teleponDarurat,
      site: site,
      jabatan: jabatan,
      atasan: atasan,
      tglPenerimaanKaryawan: tglPenerimaanKaryawan,
      masaBerlakuPermit: masaBerlakuPermit,
      kompetensiPekerjaan: kompetensiPekerjaan,
      wargaNegara: wargaNegara,
      provinsi: provinsi,
      kotaKabupaten: kotaKabupaten,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
      alamatDomisili: alamatDomisili,
      profileImageUrl: profileImageUrl,
      documents: documents,
    );
  }
}