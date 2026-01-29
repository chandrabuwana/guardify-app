/// Model for Panic Button Mobile Response from Firebase
/// This model represents the simplified data structure sent in Firebase notification
class PanicButtonMobileResponseModel {
  final String? areasName;
  final String? description;
  final String? incidentName;
  final String? reporter;
  final String? reporterDate;
  final String? status;

  PanicButtonMobileResponseModel({
    this.areasName,
    this.description,
    this.incidentName,
    this.reporter,
    this.reporterDate,
    this.status,
  });

  factory PanicButtonMobileResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return PanicButtonMobileResponseModel(
        areasName: json['AreasName']?.toString(),
        description: json['Description']?.toString(),
        incidentName: json['IncidentName']?.toString(),
        reporter: json['Reporter']?.toString(),
        reporterDate: json['ReporterDate']?.toString(),
        status: json['Status']?.toString(),
      );
    } catch (e) {
      print('⚠️ Error parsing PanicButtonMobileResponseModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'AreasName': areasName,
      'Description': description,
      'IncidentName': incidentName,
      'Reporter': reporter,
      'ReporterDate': reporterDate,
      'Status': status,
    };
  }
}
