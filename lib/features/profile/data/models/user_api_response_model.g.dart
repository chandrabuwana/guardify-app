// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleApiModel _$RoleApiModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RoleApiModel',
      json,
      ($checkedConvert) {
        final val = RoleApiModel(
          id: $checkedConvert('Id', (v) => v as String),
          nama: $checkedConvert('Nama', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': 'Id', 'nama': 'Nama'},
    );

Map<String, dynamic> _$RoleApiModelToJson(RoleApiModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Nama': instance.nama,
    };

UserApiDataModel _$UserApiDataModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserApiDataModel',
      json,
      ($checkedConvert) {
        final val = UserApiDataModel(
          id: $checkedConvert('Id', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String),
          password: $checkedConvert('Password', (v) => v as String?),
          fullname: $checkedConvert('Fullname', (v) => v as String),
          email: $checkedConvert('Email', (v) => v as String?),
          mail: $checkedConvert('Mail', (v) => v as String?),
          phoneNumber: $checkedConvert('PhoneNumber', (v) => v as String?),
          noNrp: $checkedConvert('NoNrp', (v) => v as String?),
          noKtp: $checkedConvert('NoKtp', (v) => v as String?),
          tempatLahir: $checkedConvert('TempatLahir', (v) => v as String?),
          tanggalLahir: $checkedConvert('TanggalLahir', (v) => v as String?),
          jenisKelamin: $checkedConvert('JenisKelamin', (v) => v as String?),
          pendidikan: $checkedConvert('Pendidikan', (v) => v as String?),
          teleponPribadi:
              $checkedConvert('TeleponPribadi', (v) => v as String?),
          teleponDarurat:
              $checkedConvert('TeleponDarurat', (v) => v as String?),
          site: $checkedConvert('Site', (v) => v as String?),
          jabatan: $checkedConvert('Jabatan', (v) => v as String?),
          idAtasan: $checkedConvert('IdAtasan', (v) => v as String?),
          tanggalPenerimaan:
              $checkedConvert('TanggalPenerimaan', (v) => v as String?),
          masaBerlakuPermit:
              $checkedConvert('MasaBerlakuPermit', (v) => v as String?),
          kompetensiPekerjaan:
              $checkedConvert('KompetensiPekerjaan', (v) => v as String?),
          urlKtp: $checkedConvert('UrlKtp', (v) => v as String?),
          urlKta: $checkedConvert('UrlKta', (v) => v as String?),
          urlFoto: $checkedConvert('UrlFoto', (v) => v as String?),
          p3tdK3lh: $checkedConvert('P3tdK3lh', (v) => v as String?),
          p3tdSecurity: $checkedConvert('P3tdSecurity', (v) => v as String?),
          urlPernyataanTidakMerokok:
              $checkedConvert('UrlPernyataanTidakMerokok', (v) => v as String?),
          wargaNegara: $checkedConvert('WargaNegara', (v) => v as String?),
          provinsi: $checkedConvert('Provinsi', (v) => v as String?),
          kotaKabupaten: $checkedConvert('KotaKabupaten', (v) => v as String?),
          kecamatan: $checkedConvert('Kecamatan', (v) => v as String?),
          kelurahan: $checkedConvert('Kelurahan', (v) => v as String?),
          alamatDomisili:
              $checkedConvert('AlamatDomisili', (v) => v as String?),
          feedback: $checkedConvert('Feedback', (v) => v as String?),
          status: $checkedConvert('Status', (v) => v as String),
          token: $checkedConvert('Token', (v) => v as String),
          isLockout: $checkedConvert('IsLockout', (v) => v as bool),
          accessFailedCount:
              $checkedConvert('AccessFailedCount', (v) => (v as num).toInt()),
          active: $checkedConvert('Active', (v) => v as bool),
          createBy: $checkedConvert('CreateBy', (v) => v as String),
          createDate: $checkedConvert('CreateDate', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          nrk: $checkedConvert('Nrk', (v) => v as String?),
          personnelNo: $checkedConvert('PersonnelNo', (v) => v as String?),
          roles: $checkedConvert(
              'Roles',
              (v) => (v as List<dynamic>)
                  .map((e) => RoleApiModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'username': 'Username',
        'password': 'Password',
        'fullname': 'Fullname',
        'email': 'Email',
        'mail': 'Mail',
        'phoneNumber': 'PhoneNumber',
        'noNrp': 'NoNrp',
        'noKtp': 'NoKtp',
        'tempatLahir': 'TempatLahir',
        'tanggalLahir': 'TanggalLahir',
        'jenisKelamin': 'JenisKelamin',
        'pendidikan': 'Pendidikan',
        'teleponPribadi': 'TeleponPribadi',
        'teleponDarurat': 'TeleponDarurat',
        'site': 'Site',
        'jabatan': 'Jabatan',
        'idAtasan': 'IdAtasan',
        'tanggalPenerimaan': 'TanggalPenerimaan',
        'masaBerlakuPermit': 'MasaBerlakuPermit',
        'kompetensiPekerjaan': 'KompetensiPekerjaan',
        'urlKtp': 'UrlKtp',
        'urlKta': 'UrlKta',
        'urlFoto': 'UrlFoto',
        'p3tdK3lh': 'P3tdK3lh',
        'p3tdSecurity': 'P3tdSecurity',
        'urlPernyataanTidakMerokok': 'UrlPernyataanTidakMerokok',
        'wargaNegara': 'WargaNegara',
        'provinsi': 'Provinsi',
        'kotaKabupaten': 'KotaKabupaten',
        'kecamatan': 'Kecamatan',
        'kelurahan': 'Kelurahan',
        'alamatDomisili': 'AlamatDomisili',
        'feedback': 'Feedback',
        'status': 'Status',
        'token': 'Token',
        'isLockout': 'IsLockout',
        'accessFailedCount': 'AccessFailedCount',
        'active': 'Active',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'nrk': 'Nrk',
        'personnelNo': 'PersonnelNo',
        'roles': 'Roles'
      },
    );

Map<String, dynamic> _$UserApiDataModelToJson(UserApiDataModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Password': instance.password,
      'Fullname': instance.fullname,
      'Email': instance.email,
      'Mail': instance.mail,
      'PhoneNumber': instance.phoneNumber,
      'NoNrp': instance.noNrp,
      'NoKtp': instance.noKtp,
      'TempatLahir': instance.tempatLahir,
      'TanggalLahir': instance.tanggalLahir,
      'JenisKelamin': instance.jenisKelamin,
      'Pendidikan': instance.pendidikan,
      'TeleponPribadi': instance.teleponPribadi,
      'TeleponDarurat': instance.teleponDarurat,
      'Site': instance.site,
      'Jabatan': instance.jabatan,
      'IdAtasan': instance.idAtasan,
      'TanggalPenerimaan': instance.tanggalPenerimaan,
      'MasaBerlakuPermit': instance.masaBerlakuPermit,
      'KompetensiPekerjaan': instance.kompetensiPekerjaan,
      'UrlKtp': instance.urlKtp,
      'UrlKta': instance.urlKta,
      'UrlFoto': instance.urlFoto,
      'P3tdK3lh': instance.p3tdK3lh,
      'P3tdSecurity': instance.p3tdSecurity,
      'UrlPernyataanTidakMerokok': instance.urlPernyataanTidakMerokok,
      'WargaNegara': instance.wargaNegara,
      'Provinsi': instance.provinsi,
      'KotaKabupaten': instance.kotaKabupaten,
      'Kecamatan': instance.kecamatan,
      'Kelurahan': instance.kelurahan,
      'AlamatDomisili': instance.alamatDomisili,
      'Feedback': instance.feedback,
      'Status': instance.status,
      'Token': instance.token,
      'IsLockout': instance.isLockout,
      'AccessFailedCount': instance.accessFailedCount,
      'Active': instance.active,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'Nrk': instance.nrk,
      'PersonnelNo': instance.personnelNo,
      'Roles': instance.roles.map((e) => e.toJson()).toList(),
    };

UserApiResponseModel _$UserApiResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UserApiResponseModel',
      json,
      ($checkedConvert) {
        final val = UserApiResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : UserApiDataModel.fromJson(v as Map<String, dynamic>)),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
          description: $checkedConvert('Description', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'data': 'Data',
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$UserApiResponseModelToJson(
        UserApiResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };
