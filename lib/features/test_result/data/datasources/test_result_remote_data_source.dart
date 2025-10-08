import 'package:injectable/injectable.dart';
import '../models/test_result_model.dart';
import '../models/test_summary_model.dart';
import '../models/test_member_result_model.dart';
import '../../domain/entities/test_result_entity.dart';

/// Remote data source untuk Test Result
abstract class TestResultRemoteDataSource {
  Future<List<TestResultModel>> fetchMyResults(String userId);
  
  Future<List<TestMemberResultModel>> fetchMemberResults({
    String? examId,
    String? jabatan,
  });
  
  Future<TestSummaryModel> fetchExamSummary({
    String? userId,
    String? examId,
  });
}

/// Implementation dengan mock data
@LazySingleton(as: TestResultRemoteDataSource)
class TestResultRemoteDataSourceImpl implements TestResultRemoteDataSource {
  // Mock data untuk hasil Test
  final List<TestResultModel> _mockMyResults = [
    TestResultModel(
      id: 'PNCR2872',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 80,
      nilaiKKM: 78,
      status: TestKelulusanStatus.belumDinilai,
      tipeTest: 'Test Tahunan',
    ),
    TestResultModel(
      id: 'PNCR2871',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 80,
      nilaiKKM: 78,
      status: TestKelulusanStatus.lulus,
      tipeTest: 'Test Tahunan',
    ),
    TestResultModel(
      id: 'PNCR2870',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 65,
      nilaiKKM: 78,
      status: TestKelulusanStatus.tidakLulus,
      tipeTest: 'Test Tahunan',
    ),
    TestResultModel(
      id: 'PNCR2869',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 80,
      nilaiKKM: 78,
      status: TestKelulusanStatus.lulus,
      tipeTest: 'Test Tahunan',
    ),
  ];

  final List<TestMemberResultModel> _mockMemberResults = [
    const TestMemberResultModel(
      id: '1',
      userId: 'user_1',
      nama: 'Aiman Hafiz',
      jabatan: 'Anggota',
      nilai: 90,
      profileImageUrl: 'https://via.placeholder.com/150',
    ),
    const TestMemberResultModel(
      id: '2',
      userId: 'user_2',
      nama: 'Aiman Hafiz',
      jabatan: 'Danton',
      nilai: 89,
      profileImageUrl: 'https://via.placeholder.com/150',
    ),
    const TestMemberResultModel(
      id: '3',
      userId: 'user_3',
      nama: 'Aiman Hafiz',
      jabatan: 'Anggota',
      nilai: 88,
      profileImageUrl: 'https://via.placeholder.com/150',
    ),
    const TestMemberResultModel(
      id: '4',
      userId: 'user_4',
      nama: 'Aiman Hafiz',
      jabatan: 'Deputy',
      nilai: 83,
      profileImageUrl: 'https://via.placeholder.com/150',
    ),
    const TestMemberResultModel(
      id: '5',
      userId: 'user_5',
      nama: 'Aiman Hafiz',
      jabatan: 'Anggota',
      nilai: 80,
      profileImageUrl: 'https://via.placeholder.com/150',
    ),
    const TestMemberResultModel(
      id: '6',
      userId: 'user_6',
      nama: 'Aiman Hafiz',
      jabatan: 'Anggota',
      nilai: 67,
      profileImageUrl: 'https://via.placeholder.com/150',
    ),
    const TestMemberResultModel(
      id: '7',
      userId: 'user_7',
      nama: 'Aiman Hafiz',
      jabatan: 'Anggota',
      nilai: 63,
      profileImageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Future<List<TestResultModel>> fetchMyResults(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filter by userId
    return _mockMyResults.where((r) => r.userId == userId).toList();
  }

  @override
  Future<List<TestMemberResultModel>> fetchMemberResults({
    String? examId,
    String? jabatan,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    var results = _mockMemberResults;
    
    // Filter by jabatan if provided
    if (jabatan != null && jabatan.isNotEmpty) {
      results = results.where((r) => r.jabatan == jabatan).toList();
    }
    
    return results;
  }

  @override
  Future<TestSummaryModel> fetchExamSummary({
    String? userId,
    String? examId,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Generate summary based on mock data
    return const TestSummaryModel(
      jumlahPesertaLulus: 90,
      jumlahPesertaTidakLulus: 21,
      nilaiRataRata: 84.5,
      nilaiMinimal: 80,
      picPeserta: 'Nurman',
      tipeTest: 'Anggota, PJO, Deputy',
      tanggalPelaksanaan: null,
      namaPenguji: 'Ambul Test',
    );
  }
}

