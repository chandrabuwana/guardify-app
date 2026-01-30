import 'package:json_annotation/json_annotation.dart';
import 'personnel_model.dart';

part 'personnel_list_response_model.g.dart';

/// Response model for getting personnel detail (single personnel)
@JsonSerializable()
class PersonnelDetailResponseModel {
  @JsonKey(name: 'Data')
  final PersonnelApiModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  PersonnelDetailResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory PersonnelDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonnelDetailResponseModelToJson(this);
}

@JsonSerializable()
class PersonnelListResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<PersonnelApiModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Description')
  final String? description;

  PersonnelListResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    this.message,
    this.description,
  });

  factory PersonnelListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonnelListResponseModelToJson(this);
}

@JsonSerializable()
class PersonnelApiModel {
  @JsonKey(name: 'Id')
  final String? id;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  @JsonKey(name: 'Email')
  final String? email;

  @JsonKey(name: 'PhoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'NoNrp')
  final String? noNrp;

  @JsonKey(name: 'NoKtp')
  final String? noKtp;

  @JsonKey(name: 'TempatLahir')
  final String? tempatLahir;

  @JsonKey(name: 'TanggalLahir')
  final String? tanggalLahir;

  @JsonKey(name: 'JenisKelamin')
  final String? jenisKelamin;

  @JsonKey(name: 'Pendidikan')
  final String? pendidikan;

  @JsonKey(name: 'TeleponPribadi')
  final String? teleponPribadi;

  @JsonKey(name: 'TeleponDarurat')
  final String? teleponDarurat;

  @JsonKey(name: 'Site')
  final String? site;

  @JsonKey(name: 'Jabatan')
  final String? jabatan;

  @JsonKey(name: 'IdAtasan')
  final String? idAtasan;

  @JsonKey(name: 'TanggalPenerimaan')
  final String? tanggalPenerimaan;

  @JsonKey(name: 'MasaBerlakuPermit')
  final String? masaBerlakuPermit;

  @JsonKey(name: 'KompetensiPekerjaan')
  final String? kompetensiPekerjaan;

  @JsonKey(name: 'UrlKtp')
  final String? urlKtp;

  @JsonKey(name: 'UrlKta')
  final String? urlKta;

  @JsonKey(name: 'UrlFoto')
  final String? urlFoto;

  @JsonKey(name: 'P3tdK3lh')
  final String? p3tdK3lh;

  @JsonKey(name: 'P3tdSecurity')
  final String? p3tdSecurity;

  @JsonKey(name: 'UrlPernyataanTidakMerokok')
  final String? urlPernyataanTidakMerokok;

  @JsonKey(name: 'WargaNegara')
  final String? wargaNegara;

  @JsonKey(name: 'Provinsi')
  final String? provinsi;

  @JsonKey(name: 'KotaKabupaten')
  final String? kotaKabupaten;

  @JsonKey(name: 'Kecamatan')
  final String? kecamatan;

  @JsonKey(name: 'Kelurahan')
  final String? kelurahan;

  @JsonKey(name: 'AlamatDomisili')
  final String? alamatDomisili;

  @JsonKey(name: 'Feedback')
  final String? feedback;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  PersonnelApiModel({
    this.id,
    this.username,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.noNrp,
    this.noKtp,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.pendidikan,
    this.teleponPribadi,
    this.teleponDarurat,
    this.site,
    this.jabatan,
    this.idAtasan,
    this.tanggalPenerimaan,
    this.masaBerlakuPermit,
    this.kompetensiPekerjaan,
    this.urlKtp,
    this.urlKta,
    this.urlFoto,
    this.p3tdK3lh,
    this.p3tdSecurity,
    this.urlPernyataanTidakMerokok,
    this.wargaNegara,
    this.provinsi,
    this.kotaKabupaten,
    this.kecamatan,
    this.kelurahan,
    this.alamatDomisili,
    this.feedback,
    this.status,
    this.createDate,
    this.updateBy,
    this.updateDate,
  });

  factory PersonnelApiModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonnelApiModelToJson(this);

  // Convert to domain entity
  PersonnelModel toPersonnelModel() {
    return PersonnelModel(
      id: id ?? '',
      nrp: noNrp ?? username ?? '',
      name: fullname ?? '',
      email: email ?? '',
      photoUrl: urlFoto,
      role: jabatan ?? 'Anggota',
      status: status ?? 'Unknown',
      updateBy: updateBy,
      updateDate: updateDate != null ? DateTime.tryParse(updateDate!) : null,
      noKtp: noKtp,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir != null ? DateTime.tryParse(tanggalLahir!) : null,
      jenisKelamin: jenisKelamin,
      pendidikan: pendidikan,
      teleponPribadi: teleponPribadi ?? phoneNumber,
      teleponDarurat: teleponDarurat,
      site: site,
      jabatan: jabatan,
      atasan: idAtasan,
      tanggalPenerimaanKaryawan:
          tanggalPenerimaan != null ? DateTime.tryParse(tanggalPenerimaan!) : null,
      masaBerlakuPermit:
          masaBerlakuPermit != null ? DateTime.tryParse(masaBerlakuPermit!) : null,
      kompetensiPekerjaan: kompetensiPekerjaan,
      wargaNegara: wargaNegara,
      provinsi: provinsi,
      kotaKabupaten: kotaKabupaten,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
      alamatDomisili: alamatDomisili,
      ktpUrl: urlKtp,
      ktaUrl: urlKta,
      fotoUrl: urlFoto,
      p3tdK3lhUrl: p3tdK3lh,
      p3tdSecurityUrl: p3tdSecurity,
      pernyataanTidakMerokokUrl: urlPernyataanTidakMerokok,
    );
  }
}
