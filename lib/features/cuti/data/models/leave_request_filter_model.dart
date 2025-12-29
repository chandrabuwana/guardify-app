import 'package:json_annotation/json_annotation.dart';

part 'leave_request_filter_model.g.dart';

/// Request model untuk filter LeaveRequest/list
@JsonSerializable()
class LeaveRequestFilterModel {
  @JsonKey(name: 'Filter')
  final List<FilterFieldModel>? filter;

  @JsonKey(name: 'Sort')
  final SortModel? sort;

  @JsonKey(name: 'Start')
  final int start;

  @JsonKey(name: 'Length')
  final int length;

  const LeaveRequestFilterModel({
    this.filter,
    this.sort,
    this.start = 0,
    this.length = 0,
  });

  factory LeaveRequestFilterModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveRequestFilterModelToJson(this);

  /// Factory untuk create filter by userId (untuk tab Ajuan Saya)
  factory LeaveRequestFilterModel.byUserId(String userId) {
    return LeaveRequestFilterModel(
      filter: [FilterFieldModel(field: 'userid', search: userId)],
      sort: const SortModel(field: '', type: 0),
      start: 0,
      length: 0,
    );
  }

  /// Factory untuk create filter by bawahan (untuk PJO/Deputy melihat cuti bawahan)
  factory LeaveRequestFilterModel.byBawahan(String atasanUserId) {
    return LeaveRequestFilterModel(
      filter: [FilterFieldModel(field: 'bawahan', search: atasanUserId)],
      sort: const SortModel(field: '', type: 0),
      start: 0,
      length: 0,
    );
  }

  /// Factory untuk create filter tanpa filter (untuk rekap semua cuti)
  factory LeaveRequestFilterModel.withoutFilter() {
    return LeaveRequestFilterModel(
      filter: null, // Tidak ada filter, ambil semua data
      sort: const SortModel(field: '', type: 0),
      start: 0,
      length: 0,
    );
  }
}

/// Model untuk filter field
@JsonSerializable()
class FilterFieldModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Search')
  final String search;

  const FilterFieldModel({required this.field, required this.search});

  factory FilterFieldModel.fromJson(Map<String, dynamic> json) =>
      _$FilterFieldModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterFieldModelToJson(this);
}

/// Model untuk sort
@JsonSerializable()
class SortModel {
  @JsonKey(name: 'Field')
  final String field;

  @JsonKey(name: 'Type')
  final int type;

  const SortModel({required this.field, required this.type});

  factory SortModel.fromJson(Map<String, dynamic> json) =>
      _$SortModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortModelToJson(this);
}
