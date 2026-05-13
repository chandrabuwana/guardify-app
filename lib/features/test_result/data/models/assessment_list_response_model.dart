import 'package:json_annotation/json_annotation.dart';

part 'assessment_list_response_model.g.dart';

@JsonSerializable()
class AssessmentListResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<AssessmentListItemModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  const AssessmentListResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory AssessmentListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentListResponseModelToJson(this);
}

@JsonSerializable()
class AssessmentListItemModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Code')
  final String? code;

  @JsonKey(name: 'AssesmentDate')
  final String? assessmentDate;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'IdAssesmentCategory')
  final int? idAssessmentCategory;

  @JsonKey(name: 'AssesmentCategory')
  final AssessmentCategoryModel? assessmentCategory;

  @JsonKey(name: 'IdPic')
  final String? idPic;

  @JsonKey(name: 'PicName')
  final String? picName;

  @JsonKey(name: 'MinValue')
  final int? minValue;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'IdSpv')
  final String? idSpv;

  const AssessmentListItemModel({
    required this.id,
    this.code,
    this.assessmentDate,
    this.createBy,
    this.createDate,
    this.idAssessmentCategory,
    this.assessmentCategory,
    this.idPic,
    this.picName,
    this.minValue,
    this.status,
    this.updateBy,
    this.updateDate,
    this.name,
    this.idSpv,
  });

  factory AssessmentListItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentListItemModelToJson(this);
}

@JsonSerializable()
class AssessmentCategoryModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Code')
  final String? code;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Description')
  final String? description;

  const AssessmentCategoryModel({
    required this.id,
    this.code,
    this.active,
    this.name,
    this.description,
  });

  factory AssessmentCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentCategoryModelToJson(this);
}
