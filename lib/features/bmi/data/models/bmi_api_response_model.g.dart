// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmi_api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BmiListResponseModel _$BmiListResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'BmiListResponseModel',
      json,
      ($checkedConvert) {
        final val = BmiListResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) => BmiDataModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          code: $checkedConvert('Code', (v) => (v as num).toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool),
          message: $checkedConvert('Message', (v) => v as String),
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

Map<String, dynamic> _$BmiListResponseModelToJson(
        BmiListResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

BmiDataModel _$BmiDataModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BmiDataModel',
      json,
      ($checkedConvert) {
        final val = BmiDataModel(
          id: $checkedConvert('Id', (v) => v as String),
          category: $checkedConvert('Category', (v) => v as String?),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          fullname: $checkedConvert('Fullname', (v) => v as String?),
          height: $checkedConvert('Height', (v) => (v as num).toDouble()),
          nip: $checkedConvert('Nip', (v) => v as String?),
          recommendation:
              $checkedConvert('Recommendation', (v) => v as String?),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate',
              (v) => v == null ? null : DateTime.parse(v as String)),
          userId: $checkedConvert('UserId', (v) => v as String),
          user: $checkedConvert(
              'User',
              (v) => v == null
                  ? null
                  : UserDataModel.fromJson(v as Map<String, dynamic>)),
          weight: $checkedConvert('Weight', (v) => (v as num).toDouble()),
          bmiValue: $checkedConvert('BmiValue', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'category': 'Category',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'fullname': 'Fullname',
        'height': 'Height',
        'nip': 'Nip',
        'recommendation': 'Recommendation',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'userId': 'UserId',
        'user': 'User',
        'weight': 'Weight',
        'bmiValue': 'BmiValue'
      },
    );

Map<String, dynamic> _$BmiDataModelToJson(BmiDataModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Category': instance.category,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate?.toIso8601String(),
      'Fullname': instance.fullname,
      'Height': instance.height,
      'Nip': instance.nip,
      'Recommendation': instance.recommendation,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate?.toIso8601String(),
      'UserId': instance.userId,
      'User': instance.user?.toJson(),
      'Weight': instance.weight,
      'BmiValue': instance.bmiValue,
    };

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserDataModel',
      json,
      ($checkedConvert) {
        final val = UserDataModel(
          id: $checkedConvert('Id', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String?),
          fullname: $checkedConvert('Fullname', (v) => v as String),
          mail: $checkedConvert('Mail', (v) => v as String?),
          nrk: $checkedConvert('Nrk', (v) => v as String?),
          phoneNumber: $checkedConvert('PhoneNumber', (v) => v as String?),
          personnelNo: $checkedConvert('PersonnelNo', (v) => v as String?),
          lastSynchronize: $checkedConvert('LastSynchronize',
              (v) => v == null ? null : DateTime.parse(v as String)),
          status: $checkedConvert('Status', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'username': 'Username',
        'fullname': 'Fullname',
        'mail': 'Mail',
        'nrk': 'Nrk',
        'phoneNumber': 'PhoneNumber',
        'personnelNo': 'PersonnelNo',
        'lastSynchronize': 'LastSynchronize',
        'status': 'Status'
      },
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Fullname': instance.fullname,
      'Mail': instance.mail,
      'Nrk': instance.nrk,
      'PhoneNumber': instance.phoneNumber,
      'PersonnelNo': instance.personnelNo,
      'LastSynchronize': instance.lastSynchronize?.toIso8601String(),
      'Status': instance.status,
    };

BmiListRequestModel _$BmiListRequestModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BmiListRequestModel',
      json,
      ($checkedConvert) {
        final val = BmiListRequestModel(
          filter: $checkedConvert(
              'Filter',
              (v) => (v as List<dynamic>)
                  .map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          sort: $checkedConvert(
              'Sort', (v) => SortModel.fromJson(v as Map<String, dynamic>)),
          start: $checkedConvert('Start', (v) => (v as num).toInt()),
          length: $checkedConvert('Length', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'filter': 'Filter',
        'sort': 'Sort',
        'start': 'Start',
        'length': 'Length'
      },
    );

Map<String, dynamic> _$BmiListRequestModelToJson(
        BmiListRequestModel instance) =>
    <String, dynamic>{
      'Filter': instance.filter.map((e) => e.toJson()).toList(),
      'Sort': instance.sort.toJson(),
      'Start': instance.start,
      'Length': instance.length,
    };

FilterModel _$FilterModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'FilterModel',
      json,
      ($checkedConvert) {
        final val = FilterModel(
          field: $checkedConvert('Field', (v) => v as String),
          search: $checkedConvert('Search', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'field': 'Field', 'search': 'Search'},
    );

Map<String, dynamic> _$FilterModelToJson(FilterModel instance) =>
    <String, dynamic>{
      'Field': instance.field,
      'Search': instance.search,
    };

SortModel _$SortModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SortModel',
      json,
      ($checkedConvert) {
        final val = SortModel(
          field: $checkedConvert('Field', (v) => v as String),
          type: $checkedConvert('Type', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {'field': 'Field', 'type': 'Type'},
    );

Map<String, dynamic> _$SortModelToJson(SortModel instance) => <String, dynamic>{
      'Field': instance.field,
      'Type': instance.type,
    };

UserListResponseModel _$UserListResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UserListResponseModel',
      json,
      ($checkedConvert) {
        final val = UserListResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      UserListItemModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          code: $checkedConvert('Code', (v) => (v as num?)?.toInt()),
          succeeded: $checkedConvert('Succeeded', (v) => v as bool?),
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

Map<String, dynamic> _$UserListResponseModelToJson(
        UserListResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

UserListItemModel _$UserListItemModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserListItemModel',
      json,
      ($checkedConvert) {
        final val = UserListItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          username: $checkedConvert('Username', (v) => v as String?),
          fullname: $checkedConvert('Fullname', (v) => v as String),
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
          token: $checkedConvert('Token', (v) => v as String?),
          isLockout: $checkedConvert('IsLockout', (v) => v as bool?),
          accessFailedCount:
              $checkedConvert('AccessFailedCount', (v) => (v as num?)?.toInt()),
          active: $checkedConvert('Active', (v) => v as bool?),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          nrk: $checkedConvert('Nrk', (v) => v as String?),
          personnelNo: $checkedConvert('PersonnelNo', (v) => v as String?),
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
        'personnelNo': 'PersonnelNo'
      },
    );

Map<String, dynamic> _$UserListItemModelToJson(UserListItemModel instance) =>
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
    };

UserListRequestModel _$UserListRequestModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UserListRequestModel',
      json,
      ($checkedConvert) {
        final val = UserListRequestModel(
          filter: $checkedConvert(
              'Filter',
              (v) => (v as List<dynamic>)
                  .map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          sort: $checkedConvert(
              'Sort', (v) => SortModel.fromJson(v as Map<String, dynamic>)),
          start: $checkedConvert('Start', (v) => (v as num).toInt()),
          length: $checkedConvert('Length', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'filter': 'Filter',
        'sort': 'Sort',
        'start': 'Start',
        'length': 'Length'
      },
    );

Map<String, dynamic> _$UserListRequestModelToJson(
        UserListRequestModel instance) =>
    <String, dynamic>{
      'Filter': instance.filter.map((e) => e.toJson()).toList(),
      'Sort': instance.sort.toJson(),
      'Start': instance.start,
      'Length': instance.length,
    };
