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
        'weight': 'Weight'
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
