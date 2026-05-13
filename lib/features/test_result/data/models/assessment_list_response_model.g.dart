// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentListResponseModel _$AssessmentListResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AssessmentListResponseModel',
      json,
      ($checkedConvert) {
        final val = AssessmentListResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) => AssessmentListItemModel.fromJson(
                      e as Map<String, dynamic>))
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

Map<String, dynamic> _$AssessmentListResponseModelToJson(
        AssessmentListResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

AssessmentListItemModel _$AssessmentListItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AssessmentListItemModel',
      json,
      ($checkedConvert) {
        final val = AssessmentListItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          code: $checkedConvert('Code', (v) => v as String?),
          assessmentDate: $checkedConvert('AssesmentDate', (v) => v as String?),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          idAssessmentCategory: $checkedConvert(
              'IdAssesmentCategory', (v) => (v as num?)?.toInt()),
          assessmentCategory: $checkedConvert(
              'AssesmentCategory',
              (v) => v == null
                  ? null
                  : AssessmentCategoryModel.fromJson(
                      v as Map<String, dynamic>)),
          idPic: $checkedConvert('IdPic', (v) => v as String?),
          picName: $checkedConvert('PicName', (v) => v as String?),
          minValue: $checkedConvert('MinValue', (v) => (v as num?)?.toInt()),
          status: $checkedConvert('Status', (v) => v as String?),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          name: $checkedConvert('Name', (v) => v as String?),
          idSpv: $checkedConvert('IdSpv', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'code': 'Code',
        'assessmentDate': 'AssesmentDate',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'idAssessmentCategory': 'IdAssesmentCategory',
        'assessmentCategory': 'AssesmentCategory',
        'idPic': 'IdPic',
        'picName': 'PicName',
        'minValue': 'MinValue',
        'status': 'Status',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'name': 'Name',
        'idSpv': 'IdSpv'
      },
    );

Map<String, dynamic> _$AssessmentListItemModelToJson(
        AssessmentListItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Code': instance.code,
      'AssesmentDate': instance.assessmentDate,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'IdAssesmentCategory': instance.idAssessmentCategory,
      'AssesmentCategory': instance.assessmentCategory?.toJson(),
      'IdPic': instance.idPic,
      'PicName': instance.picName,
      'MinValue': instance.minValue,
      'Status': instance.status,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'Name': instance.name,
      'IdSpv': instance.idSpv,
    };

AssessmentCategoryModel _$AssessmentCategoryModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AssessmentCategoryModel',
      json,
      ($checkedConvert) {
        final val = AssessmentCategoryModel(
          id: $checkedConvert('Id', (v) => (v as num).toInt()),
          code: $checkedConvert('Code', (v) => v as String?),
          active: $checkedConvert('Active', (v) => v as bool?),
          name: $checkedConvert('Name', (v) => v as String?),
          description: $checkedConvert('Description', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'code': 'Code',
        'active': 'Active',
        'name': 'Name',
        'description': 'Description'
      },
    );

Map<String, dynamic> _$AssessmentCategoryModelToJson(
        AssessmentCategoryModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Code': instance.code,
      'Active': instance.active,
      'Name': instance.name,
      'Description': instance.description,
    };
