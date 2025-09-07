class PanicAlert {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String status;
  final String? location;
  final String? additionalInfo;

  const PanicAlert({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.status,
    this.location,
    this.additionalInfo,
  });

  PanicAlert copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    String? status,
    String? location,
    String? additionalInfo,
  }) {
    return PanicAlert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      location: location ?? this.location,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}
