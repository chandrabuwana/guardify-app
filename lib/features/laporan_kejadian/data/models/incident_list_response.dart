import 'incident_api_model.dart';

class IncidentListResponse {
  final int count;
  final int filtered;
  final List<IncidentApiModel> list;
  final int code;
  final bool succeeded;
  final String message;
  final String description;

  const IncidentListResponse({
    required this.count,
    required this.filtered,
    required this.list,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory IncidentListResponse.fromJson(Map<String, dynamic> json) {
    final listData = json['List'] as List<dynamic>?;
    final list = listData != null
        ? listData.map((item) => IncidentApiModel.fromJson(item as Map<String, dynamic>)).toList()
        : <IncidentApiModel>[];
    
    return IncidentListResponse(
      count: json['Count'] as int? ?? 0,
      filtered: json['Filtered'] as int? ?? 0,
      list: list,
      code: json['Code'] as int? ?? 200,
      succeeded: json['Succeeded'] as bool? ?? true,
      message: json['Message'] as String? ?? '',
      description: json['Description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Count': count,
      'Filtered': filtered,
      'List': list.map((item) => item.toJson()).toList(),
      'Code': code,
      'Succeeded': succeeded,
      'Message': message,
      'Description': description,
    };
  }
}

