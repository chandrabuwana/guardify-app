class PanicButton {
  final String id;
  final DateTime timestamp;
  final String status;
  final String location;
  final String userId;
  final List<String> verificationItems;
  final bool isVerified;

  const PanicButton({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.location,
    required this.userId,
    required this.verificationItems,
    required this.isVerified,
  });

  PanicButton copyWith({
    String? id,
    DateTime? timestamp,
    String? status,
    String? location,
    String? userId,
    List<String>? verificationItems,
    bool? isVerified,
  }) {
    return PanicButton(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      verificationItems: verificationItems ?? this.verificationItems,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PanicButton &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.status == status &&
        other.location == location &&
        other.userId == userId &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timestamp.hashCode ^
        status.hashCode ^
        location.hashCode ^
        userId.hashCode ^
        isVerified.hashCode;
  }
}
