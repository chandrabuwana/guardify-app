class Contact {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? profileImageUrl;
  final String? position;
  final String? department;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? status;

  const Contact({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.profileImageUrl,
    this.position,
    this.department,
    required this.isOnline,
    this.lastSeen,
    this.status,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? profileImageUrl,
    String? position,
    String? department,
    bool? isOnline,
    DateTime? lastSeen,
    String? status,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      position: position ?? this.position,
      department: department ?? this.department,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact &&
        other.id == id &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl &&
        other.position == position &&
        other.department == department &&
        other.isOnline == isOnline &&
        other.lastSeen == lastSeen &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      phoneNumber,
      email,
      profileImageUrl,
      position,
      department,
      isOnline,
      lastSeen,
      status,
    );
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, profileImageUrl: $profileImageUrl, position: $position, department: $department, isOnline: $isOnline, lastSeen: $lastSeen, status: $status)';
  }
}
