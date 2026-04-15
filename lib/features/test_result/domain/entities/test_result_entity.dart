import 'package:equatable/equatable.dart';

/// Status kelulusan Test
enum TestKelulusanStatus {
  lulus('lulus', 'Lulus'),
  tidakLulus('tidak_lulus', 'Tidak Lulus'),
  belumDinilai('belum_dinilai', 'Belum Dinilai');

  const TestKelulusanStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static TestKelulusanStatus fromValue(String value) {
    return TestKelulusanStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TestKelulusanStatus.belumDinilai,
    );
  }
}

/// Entity untuk hasil Test individu
class TestResultEntity extends Equatable {
  final String id;
  final String userId;
  final String namaTest;
  final DateTime tanggalTest;
  final int nilaiTest;
  final int nilaiKKM;
  final TestKelulusanStatus status;
  final String? tipeTest;
  final String? keterangan;

  const TestResultEntity({
    required this.id,
    required this.userId,
    required this.namaTest,
    required this.tanggalTest,
    required this.nilaiTest,
    required this.nilaiKKM,
    required this.status,
    this.tipeTest,
    this.keterangan,
  });

  /// Check apakah Test lulus
  bool get isLulus => status == TestKelulusanStatus.lulus;

  @override
  List<Object?> get props => [
        id,
        userId,
        namaTest,
        tanggalTest,
        nilaiTest,
        nilaiKKM,
        status,
        tipeTest,
        keterangan,
      ];
}

