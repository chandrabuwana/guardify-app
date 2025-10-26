// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentDetailResponseModel _$AssessmentDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AssessmentDetailResponseModel',
      json,
      ($checkedConvert) {
        final val = AssessmentDetailResponseModel(
          count: $checkedConvert('Count', (v) => (v as num).toInt()),
          filtered: $checkedConvert('Filtered', (v) => (v as num).toInt()),
          list: $checkedConvert(
              'List',
              (v) => (v as List<dynamic>)
                  .map((e) => AssessmentDetailItemModel.fromJson(
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

Map<String, dynamic> _$AssessmentDetailResponseModelToJson(
        AssessmentDetailResponseModel instance) =>
    <String, dynamic>{
      'Count': instance.count,
      'Filtered': instance.filtered,
      'List': instance.list.map((e) => e.toJson()).toList(),
      'Code': instance.code,
      'Succeeded': instance.succeeded,
      'Message': instance.message,
      'Description': instance.description,
    };

AssessmentDetailItemModel _$AssessmentDetailItemModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AssessmentDetailItemModel',
      json,
      ($checkedConvert) {
        final val = AssessmentDetailItemModel(
          id: $checkedConvert('Id', (v) => v as String),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          grade: $checkedConvert('Grade', (v) => (v as num).toInt()),
          idAssessment: $checkedConvert('IdAssesment', (v) => v as String),
          assessment: $checkedConvert(
              'Assesment',
              (v) => v == null
                  ? null
                  : AssessmentInfoModel.fromJson(v as Map<String, dynamic>)),
          status: $checkedConvert('Status', (v) => v as String),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
          userId: $checkedConvert('UserId', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'grade': 'Grade',
        'idAssessment': 'IdAssesment',
        'assessment': 'Assesment',
        'status': 'Status',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate',
        'userId': 'UserId'
      },
    );

Map<String, dynamic> _$AssessmentDetailItemModelToJson(
        AssessmentDetailItemModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'Grade': instance.grade,
      'IdAssesment': instance.idAssessment,
      'Assesment': instance.assessment?.toJson(),
      'Status': instance.status,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
      'UserId': instance.userId,
    };

AssessmentInfoModel _$AssessmentInfoModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AssessmentInfoModel',
      json,
      ($checkedConvert) {
        final val = AssessmentInfoModel(
          id: $checkedConvert('Id', (v) => v as String),
          assessmentDate: $checkedConvert('AssesmentDate', (v) => v as String?),
          createBy: $checkedConvert('CreateBy', (v) => v as String?),
          createDate: $checkedConvert('CreateDate', (v) => v as String?),
          idAssessmentCategory: $checkedConvert(
              'IdAssesmentCategory', (v) => (v as num?)?.toInt()),
          assessmentCategory: $checkedConvert('AssesmentCategory', (v) => v),
          idPic: $checkedConvert('IdPic', (v) => v as String?),
          minValue: $checkedConvert('MinValue', (v) => (v as num).toInt()),
          status: $checkedConvert('Status', (v) => v as String?),
          updateBy: $checkedConvert('UpdateBy', (v) => v as String?),
          updateDate: $checkedConvert('UpdateDate', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': 'Id',
        'assessmentDate': 'AssesmentDate',
        'createBy': 'CreateBy',
        'createDate': 'CreateDate',
        'idAssessmentCategory': 'IdAssesmentCategory',
        'assessmentCategory': 'AssesmentCategory',
        'idPic': 'IdPic',
        'minValue': 'MinValue',
        'status': 'Status',
        'updateBy': 'UpdateBy',
        'updateDate': 'UpdateDate'
      },
    );

Map<String, dynamic> _$AssessmentInfoModelToJson(
        AssessmentInfoModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'AssesmentDate': instance.assessmentDate,
      'CreateBy': instance.createBy,
      'CreateDate': instance.createDate,
      'IdAssesmentCategory': instance.idAssessmentCategory,
      'AssesmentCategory': instance.assessmentCategory,
      'IdPic': instance.idPic,
      'MinValue': instance.minValue,
      'Status': instance.status,
      'UpdateBy': instance.updateBy,
      'UpdateDate': instance.updateDate,
    };
