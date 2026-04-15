import 'incident_api_model.dart';

class IncidentDetailResponse {
  final IncidentApiModel? data;
  final int code;
  final bool succeeded;
  final String message;
  final String description;

  const IncidentDetailResponse({
    this.data,
    required this.code,
    required this.succeeded,
    required this.message,
    required this.description,
  });

  factory IncidentDetailResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['Data'] ?? json['data'];
    return IncidentDetailResponse(
      data: dataJson != null
          ? IncidentApiModel.fromJson(dataJson as Map<String, dynamic>)
          : null,
      code: json['Code'] as int? ?? 200,
      succeeded: json['Succeeded'] as bool? ?? false,
      message: json['Message']?.toString() ?? '',
      description: json['Description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Data': data?.toJson(),
      'Code': code,
      'Succeeded': succeeded,
      'Message': message,
      'Description': description,
    };
  }
}

