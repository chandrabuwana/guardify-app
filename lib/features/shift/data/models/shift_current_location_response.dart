class ShiftCurrentLocationData {
  final String? fullname;
  final String? location;
  final String? currentLocation;
  final String? routeName;
  final String? shiftDetailId;

  const ShiftCurrentLocationData({
    this.fullname,
    this.location,
    this.currentLocation,
    this.routeName,
    this.shiftDetailId,
  });

  factory ShiftCurrentLocationData.fromJson(Map<String, dynamic> json) {
    return ShiftCurrentLocationData(
      fullname: json['Fullname'] as String?,
      location: json['Location'] as String?,
      currentLocation: json['CurrentLocation'] as String?,
      routeName: json['RouteName'] as String?,
      shiftDetailId: json['IdShiftDetail'] as String? ??
          json['ShiftDetailId'] as String?,
    );
  }
}

class ShiftCurrentLocationResponse {
  final ShiftCurrentLocationData? data;
  final int? code;
  final bool? succeeded;
  final String? message;
  final String? description;

  const ShiftCurrentLocationResponse({
    this.data,
    this.code,
    this.succeeded,
    this.message,
    this.description,
  });

  factory ShiftCurrentLocationResponse.fromJson(Map<String, dynamic> json) {
    return ShiftCurrentLocationResponse(
      data: json['Data'] != null
          ? ShiftCurrentLocationData.fromJson(json['Data'] as Map<String, dynamic>)
          : null,
      code: json['Code'] as int?,
      succeeded: json['Succeeded'] as bool?,
      message: json['Message'] as String?,
      description: json['Description'] as String?,
    );
  }
}

