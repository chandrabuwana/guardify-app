import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/leave_request_type_entity.dart';

part 'leave_request_type_model.g.dart';

/// Model untuk LeaveRequestType dari API
@JsonSerializable()
class LeaveRequestTypeModel {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'CreateBy')
  final String? createBy;

  @JsonKey(name: 'CreateDate')
  final String? createDate;

  @JsonKey(name: 'Description')
  final String? description;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'UpdateBy')
  final String? updateBy;

  @JsonKey(name: 'UpdateDate')
  final String? updateDate;

  @JsonKey(name: 'Quota')
  final int? quota;

  const LeaveRequestTypeModel({
    required this.id,
    this.active,
    this.createBy,
    this.createDate,
    this.description,
    this.name,
    this.updateBy,
    this.updateDate,
    this.quota,
  });

  factory LeaveRequestTypeModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveRequestTypeModelToJson(this);

  /// Convert to entity
  LeaveRequestTypeEntity toEntity() {
    return LeaveRequestTypeEntity(
      id: id,
      active: active ?? true, // Default to true if null
      createBy: createBy,
      createDate: createDate,
      description: description,
      name: name ?? '', // Default to empty string if null
      updateBy: updateBy,
      updateDate: updateDate,
      quota: quota,
    );
  }
}

/// Response model untuk POST /LeaveRequestType/list
@JsonSerializable()
class LeaveRequestTypeListResponseModel {
  @JsonKey(name: 'Count')
  final int count;

  @JsonKey(name: 'Filtered')
  final int filtered;

  @JsonKey(name: 'List')
  final List<LeaveRequestTypeModel> list;

  @JsonKey(name: 'Code')
  final int code;

  @JsonKey(name: 'Succeeded')
  final bool succeeded;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Description')
  final String? description;

  const LeaveRequestTypeListResponseModel({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    this.description,
  });

  factory LeaveRequestTypeListResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$LeaveRequestTypeListResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LeaveRequestTypeListResponseModelToJson(this);
}

/// Request model untuk POST /LeaveRequestType/list
@JsonSerializable()
class LeaveRequestTypeListRequestModel {
  @JsonKey(name: 'Filter')
  final List<Map<String, String>> filter;

  @JsonKey(name: 'Sort')
  final Map<String, dynamic> sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  const LeaveRequestTypeListRequestModel({
    required this.filter,
    required this.sort,
    required this.start,
    required this.length,
  });

  factory LeaveRequestTypeListRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$LeaveRequestTypeListRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LeaveRequestTypeListRequestModelToJson(this);

  /// Factory untuk create default request
  factory LeaveRequestTypeListRequestModel.create() {
    return LeaveRequestTypeListRequestModel(
      filter: [
        {
          'Field': '',
          'Search': '',
        }
      ],
      sort: {
        'Field': '',
        'Type': 0,
      },
      start: 0,
      length: 0,
    );
  }
}

