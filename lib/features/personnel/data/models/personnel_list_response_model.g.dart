// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonnelDetailResponseModel _$PersonnelDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonnelDetailResponseModel',
      json,
      ($checkedConvert) {
        final val = PersonnelDetailResponseModel(
          data: $checkedConvert(
              'Data',
              (v) => v == null
                  ? null
                  : PersonnelApiModel.fromJson(v as Map<String, dynamic>)),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
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

Map<String, dynamic> _$PersonnelDetailResponseModelToJson(
        PersonnelDetailResponseModel instance) =>
    <String, dynamic>{
      'Data': instance.data?.toJson(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

PersonnelListResponseModel _$PersonnelListResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonnelListResponseModel',
      json,
      ($checkedConvert) {
        final val = PersonnelListResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      PersonnelApiModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'count': 'Count',
        'filtered': 'Filtered',
        'list': 'List',
        'code': 'Code',
        'succeeded': 'Succeeded',
        'message': 'Message',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$PersonnelListResponseModelToJson(
        PersonnelListResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

PersonnelApiModel _$PersonnelApiModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PersonnelApiModel',
      json,
      ($checkedConvert) {
        final val = PersonnelApiModel(
          id: $checkedConvert('Id', (v) => v as String?),
          username: $checkedConvert('Username', (v) => v as String?),
          fullname: $checkedConvert('Fullname', (v) => v as String?),
          email: $checkedConvert('Email', (v) => v as String?),
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
          namaAtasan: $checkedConvert('NamaAtasan', (v) => v as String?),
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
          status: $checkedConvert('Status', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'username': 'Username',
        'fullname': 'Fullname',
        'email': 'Email',
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
        'namaAtasan': 'NamaAtasan',
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
        'createDate': 'CreateDate',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate'
      },
    );

Map<String, dynamic> _$PersonnelApiModelToJson(PersonnelApiModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Fullname': instance.fullname,
      'Email': instance.email,
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
      'NamaAtasan': instance.namaAtasan,
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
      'CreateDate': instance.createDate,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
    };
