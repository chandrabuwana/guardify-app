import '../../domain/entities/test_member_result_entity.dart';

/// Model data untuk hasil Test anggota (DTO)
class TestMemberResultModel extends TestMemberResultEntity {
  const TestMemberResultModel({
    required super.id,
    required super.userId,
    required super.nama,
    required super.jabatan,
    required super.nilai,
    super.atasanNama,
    super.atasanImageUrl,
    super.profileImageUrl,
  });

  /// Create model dari JSON
  factory TestMemberResultModel.fromJson(Map<String, dynamic> json) {
    return TestMemberResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      nama: json['nama'] as String,
      jabatan: json['jabatan'] as String,
      nilai: json['nilai'] as int,
      atasanNama: json['atasan_nama'] as String?,
      atasanImageUrl: json['atasan_image_url'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  /// Convert model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nama': nama,
      'jabatan': jabatan,
      'nilai': nilai,
      'atasan_nama': atasanNama,
      'atasan_image_url': atasanImageUrl,
      'profile_image_url': profileImageUrl,
    };
  }

  /// Mapping ke Entity
  TestMemberResultEntity toEntity() {
    return TestMemberResultEntity(
      id: id,
      userId: userId,
      nama: nama,
      jabatan: jabatan,
      nilai: nilai,
      atasanNama: atasanNama,
      atasanImageUrl: atasanImageUrl,
      profileImageUrl: profileImageUrl,
    );
  }

  /// Create model dari Entity
  factory TestMemberResultModel.fromEntity(TestMemberResultEntity entity) {
    return TestMemberResultModel(
      id: entity.id,
      userId: entity.userId,
      nama: entity.nama,
      jabatan: entity.jabatan,
      nilai: entity.nilai,
      atasanNama: entity.atasanNama,
      atasanImageUrl: entity.atasanImageUrl,
      profileImageUrl: entity.profileImageUrl,
    );
  }
}

