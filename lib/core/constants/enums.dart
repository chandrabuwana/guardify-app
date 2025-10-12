/// Global enums used across the application

/// Enum untuk role/jabatan user dalam sistem
/// ID sesuai dengan database: ADM, AGT, DPT, PGW, PJO
enum UserRole {
  /// Admin
  admin('ADM', 'Admin'),

  /// Anggota biasa
  anggota('AGT', 'Anggota'),

  /// Deputy/Wakil
  deputy('DPT', 'Deputy'),

  /// Pengawas
  pengawas('PGW', 'Pengawas'),

  /// Petugas Jaga (PJO)
  pjo('PJO', 'PJO'),

  /// Komandan Regu (Danton) - kept for backward compatibility
  danton('danton', 'Danton');

  const UserRole(this.value, this.displayName);

  /// Value untuk database/API (ID dari database)
  final String value;

  /// Nama yang ditampilkan ke user
  final String displayName;

  /// Check apakah role adalah anggota biasa
  bool get isAnggota => this == UserRole.anggota;

  /// Check apakah role memiliki akses tingkat tinggi (non-anggota)
  bool get isHighAccess => !isAnggota;

  /// Get role berdasarkan value string (ID dari database)
  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.anggota,
    );
  }

  /// Get semua role dengan akses tinggi (non-anggota)
  static List<UserRole> get highAccessRoles => [
        UserRole.admin,
        UserRole.danton,
        UserRole.pjo,
        UserRole.deputy,
        UserRole.pengawas,
      ];
}

/// Enum untuk status BMI
enum BMIStatus {
  underweight('underweight', 'Kurus', 'Berat badan kurang'),
  normal('normal', 'Normal', 'Berat badan ideal'),
  overweight('overweight', 'Gemuk', 'Berat badan berlebih'),
  obese('obese', 'Obesitas', 'Obesitas');

  const BMIStatus(this.value, this.label, this.description);

  final String value;
  final String label;
  final String description;

  /// Get status BMI berdasarkan nilai BMI
  static BMIStatus fromBMI(double bmi) {
    if (bmi < 18.5) {
      return BMIStatus.underweight;
    } else if (bmi < 25.0) {
      return BMIStatus.normal;
    } else if (bmi < 30.0) {
      return BMIStatus.overweight;
    } else {
      return BMIStatus.obese;
    }
  }

  /// Get warna untuk status BMI
  String get colorHex {
    switch (this) {
      case BMIStatus.underweight:
        return '#2196F3'; // Blue
      case BMIStatus.normal:
        return '#4CAF50'; // Green
      case BMIStatus.overweight:
        return '#FF9800'; // Orange
      case BMIStatus.obese:
        return '#F44336'; // Red
    }
  }
}
