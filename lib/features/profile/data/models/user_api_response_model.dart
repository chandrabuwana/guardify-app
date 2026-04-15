import 'package:json_annotation/json_annotation.dart';
import 'profile_user_model.dart';

part 'user_api_response_model.g.dart';

/// Model untuk role dari API
@JsonSerializable()
class RoleApiModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Nama')
  final String nama;

  const RoleApiModel({
    required this.id,
    required this.nama,
  });

  factory RoleApiModel.fromJson(Map<String, dynamic> json) =>
      _$RoleApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleApiModelToJson(this);
}

/// Model untuk data user dari API
@JsonSerializable()
class UserApiDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String username;

  @JsonKey(name: 'Password')
  final String? password;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Email')
  final String? email;

  @JsonKey(name: 'Mail')
  final String? mail;

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

  @JsonKey(name: 'NamaAtasan')
  final String? namaAtasan;

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

  @JsonKey(name: 'Token')
  final String? token;

  @JsonKey(name: 'IsLockout')
  final bool? isLockout;

  @JsonKey(name: 'AccessFailedCount')
  final int? accessFailedCount;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'Nrk')
  final String? nrk;

  @JsonKey(name: 'PersonnelNo')
  final String? personnelNo;

  @JsonKey(name: 'Roles')
  final List<RoleApiModel> roles;

  const UserApiDataModel({
    required this.id,
    required this.username,
    this.password,
    required this.fullname,
    this.email,
    this.mail,
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
    this.namaAtasan,
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
    this.token,
    this.isLockout,
    this.accessFailedCount,
    this.active,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
    this.nrk,
    this.personnelNo,
    this.roles = const <RoleApiModel>[],
  });

  factory UserApiDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserApiDataModelFromJson(json);
    } catch (_) {
      final rawRoles = json['Roles'];
      final roles = rawRoles is List
          ? rawRoles
              .whereType<Map<String, dynamic>>()
              .map(RoleApiModel.fromJson)
              .toList()
          : const <RoleApiModel>[];

      return UserApiDataModel(
        id: json['Id']?.toString() ?? '',
        username: json['Username']?.toString() ?? '',
        password: json['Password']?.toString(),
        fullname: json['Fullname']?.toString() ?? '',
        email: json['Email']?.toString(),
        mail: json['Mail']?.toString(),
        phoneNumber: json['PhoneNumber']?.toString(),
        noNrp: json['NoNrp']?.toString(),
        noKtp: json['NoKtp']?.toString(),
        tempatLahir: json['TempatLahir']?.toString(),
        tanggalLahir: json['TanggalLahir']?.toString(),
        jenisKelamin: json['JenisKelamin']?.toString(),
        pendidikan: json['Pendidikan']?.toString(),
        teleponPribadi: json['TeleponPribadi']?.toString(),
        teleponDarurat: json['TeleponDarurat']?.toString(),
        site: json['Site']?.toString(),
        jabatan: json['Jabatan']?.toString(),
        idAtasan: json['IdAtasan']?.toString(),
        namaAtasan: json['NamaAtasan']?.toString(),
        tanggalPenerimaan: json['TanggalPenerimaan']?.toString(),
        masaBerlakuPermit: json['MasaBerlakuPermit']?.toString(),
        kompetensiPekerjaan: json['KompetensiPekerjaan']?.toString(),
        urlKtp: json['UrlKtp']?.toString(),
        urlKta: json['UrlKta']?.toString(),
        urlFoto: json['UrlFoto']?.toString(),
        p3tdK3lh: json['P3tdK3lh']?.toString(),
        p3tdSecurity: json['P3tdSecurity']?.toString(),
        urlPernyataanTidakMerokok: json['UrlPernyataanTidakMerokok']?.toString(),
        wargaNegara: json['WargaNegara']?.toString(),
        provinsi: json['Provinsi']?.toString(),
        kotaKabupaten: json['KotaKabupaten']?.toString(),
        kecamatan: json['Kecamatan']?.toString(),
        kelurahan: json['Kelurahan']?.toString(),
        alamatDomisili: json['AlamatDomisili']?.toString(),
        feedback: json['Feedback']?.toString(),
        status: json['Status']?.toString(),
        token: json['Token']?.toString(),
        isLockout: json['IsLockout'] is bool ? json['IsLockout'] as bool : null,
        accessFailedCount: json['AccessFailedCount'] is num
            ? (json['AccessFailedCount'] as num).toInt()
            : null,
        active: json['Active'] is bool ? json['Active'] as bool : null,
        createBy: json['CreateBy']?.toString(),
        createDate: json['CreateDate']?.toString(),
        updateBy: json['UpdateBy']?.toString(),
        updateDate: json['UpdateDate']?.toString(),
        nrk: json['Nrk']?.toString(),
        personnelNo: json['PersonnelNo']?.toString(),
        roles: roles,
      );
    }
  }

  Map<String, dynamic> toJson() => _$UserApiDataModelToJson(this);

  /// Convert to ProfileUserModel with proper null handling
  ProfileUserModel toProfileUserModel() {
    DateTime? parsedTanggalLahir;
    DateTime? parsedTanggalPenerimaan;
    DateTime? parsedMasaBerlakuPermit;

    try {
      if (tanggalLahir != null && tanggalLahir!.isNotEmpty) {
        parsedTanggalLahir = DateTime.parse(tanggalLahir!);
      }
    } catch (e) {
      // Ignore parse error
    }

    try {
      if (tanggalPenerimaan != null && tanggalPenerimaan!.isNotEmpty) {
        parsedTanggalPenerimaan = DateTime.parse(tanggalPenerimaan!);
      }
    } catch (e) {
      // Ignore parse error
    }

    try {
      if (masaBerlakuPermit != null && masaBerlakuPermit!.isNotEmpty) {
        parsedMasaBerlakuPermit = DateTime.parse(masaBerlakuPermit!);
      }
    } catch (e) {
      // Ignore parse error
    }

    return ProfileUserModel(
      id: id,
      nrp: noNrp ?? username,
      noKtp: noKtp ?? '-',
      name: fullname,
      email: (email ?? mail ?? '-'),
      tempatLahir: tempatLahir ?? '-',
      tanggalLahir: parsedTanggalLahir ?? DateTime.now(),
      jenisKelamin: jenisKelamin ?? '-',
      pendidikan: pendidikan ?? '-',
      teleponPribadi: teleponPribadi ?? phoneNumber ?? '-',
      teleponDarurat: teleponDarurat ?? '-',
      site: site ?? '-',
      jabatan: jabatan ?? (roles.isNotEmpty ? roles.first.nama : '-'),
      atasan: idAtasan ?? '-',
      namaAtasan: namaAtasan,
      tglPenerimaanKaryawan: parsedTanggalPenerimaan ?? DateTime.tryParse(createDate ?? '') ?? DateTime.now(),
      masaBerlakuPermit: parsedMasaBerlakuPermit ?? DateTime.now().add(const Duration(days: 365)),
      kompetensiPekerjaan: kompetensiPekerjaan ?? '-',
      wargaNegara: wargaNegara ?? '-',
      provinsi: provinsi ?? '-',
      kotaKabupaten: kotaKabupaten ?? '-',
      kecamatan: kecamatan ?? '-',
      kelurahan: kelurahan ?? '-',
      alamatDomisili: alamatDomisili ?? '-',
      profileImageUrl: urlFoto,
      documents: {
        'ktp': urlKtp ?? '',
        'kta': urlKta ?? '',
        'foto': urlFoto ?? '',
        'p3td_k3lh': p3tdK3lh ?? '',
        'p3td_security': p3tdSecurity ?? '',
        'pernyataan_tidak_merokok': urlPernyataanTidakMerokok ?? '',
      },
    );
  }
}

/// Model untuk response dari User API
@JsonSerializable()
class UserApiResponseModel {
  @JsonKey(name: 'Data')
  final UserApiDataModel? data;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String description;

  const UserApiResponseModel({
    this.data,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory UserApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiResponseModelToJson(this);
}
