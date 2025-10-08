import 'package:equatable/equatable.dart';

/// Entity untuk hasil Test anggota (untuk view PJO/Deputy/Pengawas)
class TestMemberResultEntity extends Equatable {
  final String id;
  final String userId;
  final String nama;
  final String jabatan;
  final int nilai;
  final String? atasanNama;
  final String? atasanImageUrl;
  final String? profileImageUrl;

  const TestMemberResultEntity({
    required this.id,
    required this.userId,
    required this.nama,
    required this.jabatan,
    required this.nilai,
    this.atasanNama,
    this.atasanImageUrl,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        nama,
        jabatan,
        nilai,
        atasanNama,
        atasanImageUrl,
        profileImageUrl,
      ];
}

