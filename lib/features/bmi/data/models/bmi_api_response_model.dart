import 'package:json_annotation/json_annotation.dart';
import '../../../../core/constants/enums.dart';

part 'bmi_api_response_model.g.dart';

/// Response model untuk BMI List API
@JsonSerializable()
class BmiListResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<BmiDataModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  BmiListResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory BmiListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BmiListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BmiListResponseModelToJson(this);
}

/// Model untuk data BMI dari API
@JsonSerializable()
class BmiDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Category')
  final String? category;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final DateTime? createDate;

  @JsonKey(name: 'Fullname')
  final String? fullname;

  @JsonKey(name: 'Height')
  final double height;

  @JsonKey(name: 'Nip')
  final String? nip;

  @JsonKey(name: 'Recommendation')
  final String? recommendation;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final DateTime? updateDate;

  @JsonKey(name: 'UserId')
  final String userId;

  @JsonKey(name: 'User')
  final UserDataModel? user;

  @JsonKey(name: 'Weight')
  final double weight;

  BmiDataModel({
    required this.id,
    this.category,
    this.createBy,
    this.createDate,
    this.fullname,
    required this.height,
    this.nip,
    this.recommendation,
    this.updateBy,
    this.updateDate,
    required this.userId,
    this.user,
    required this.weight,
  });

  factory BmiDataModel.fromJson(Map<String, dynamic> json) =>
      _$BmiDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$BmiDataModelToJson(this);

  /// Calculate BMI
  double get bmi => weight / ((height / 100) * (height / 100));

  /// Get BMI Status
  BMIStatus get bmiStatus {
    if (bmi < 18.5) return BMIStatus.underweight;
    if (bmi < 25) return BMIStatus.normal;
    if (bmi < 30) return BMIStatus.overweight;
    return BMIStatus.obese;
  }
}

/// Model untuk data User dari API
@JsonSerializable()
class UserDataModel {
  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Username')
  final String? username;

  @JsonKey(name: 'Fullname')
  final String fullname;

  @JsonKey(name: 'Mail')
  final String? mail;

  @JsonKey(name: 'Nrk')
  final String? nrk;

  @JsonKey(name: 'PhoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'PersonnelNo')
  final String? personnelNo;

  @JsonKey(name: 'LastSynchronize')
  final DateTime? lastSynchronize;

  @JsonKey(name: 'Status')
  final String? status;

  UserDataModel({
    required this.id,
    this.username,
    required this.fullname,
    this.mail,
    this.nrk,
    this.phoneNumber,
    this.personnelNo,
    this.lastSynchronize,
    this.status,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}

/// Request model untuk BMI List API
@JsonSerializable()
class BmiListRequestModel {
  @JsonKey(name: 'Filter')
  final List<FilterModel> filter;

  @JsonKey(name: 'Sort')
  final SortModel sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  BmiListRequestModel({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory BmiListRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BmiListRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BmiListRequestModelToJson(this);
}

@JsonSerializable()
class FilterModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Search')
  final String search;

  FilterModel({
    required this.field,
    required this.search,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) =>
      _$FilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterModelToJson(this);
}

@JsonSerializable()
class SortModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Type')
  final int type;

  SortModel({
    required this.field,
    required this.type,
  });

  factory SortModel.fromJson(Map<String, dynamic> json) =>
      _$SortModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortModelToJson(this);
}
