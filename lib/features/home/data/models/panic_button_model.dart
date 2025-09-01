import '../../domain/entities/panic_button.dart';

class PanicButtonModel extends PanicButton {
  const PanicButtonModel({
    required super.id,
    required super.timestamp,
    required super.status,
    required super.location,
    required super.userId,
    required super.verificationItems,
    required super.isVerified,
  });

  factory PanicButtonModel.fromJson(Map<String, dynamic> json) {
    return PanicButtonModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
      location: json['location'] as String,
      userId: json['userId'] as String,
      verificationItems: List<String>.from(json['verificationItems'] as List),
      isVerified: json['isVerified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'location': location,
      'userId': userId,
      'verificationItems': verificationItems,
      'isVerified': isVerified,
    };
  }

  factory PanicButtonModel.fromEntity(PanicButton entity) {
    return PanicButtonModel(
      id: entity.id,
      timestamp: entity.timestamp,
      status: entity.status,
      location: entity.location,
      userId: entity.userId,
      verificationItems: entity.verificationItems,
      isVerified: entity.isVerified,
    );
  }
}
