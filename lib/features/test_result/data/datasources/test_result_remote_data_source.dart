import 'package:injectable/injectable.dart';
import '../models/test_result_model.dart';
import '../models/test_summary_model.dart';
import '../models/test_member_result_model.dart';
import '../../domain/entities/test_result_entity.dart';
import 'test_result_api_data_source.dart';

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
  
  /// Fetch member tests menggunakan IdPic filter (untuk Danton)
  Future<List<TestResultModel>> fetchMemberTestsByPic(String picId);
}

/// Implementation dengan Real API
@LazySingleton(as: TestResultRemoteDataSource)
class TestResultRemoteDataSourceImpl implements TestResultRemoteDataSource {
  final TestResultApiDataSource _apiDataSource;

  TestResultRemoteDataSourceImpl(this._apiDataSource);

  @override
  Future<List<TestResultModel>> fetchMyResults(String userId) async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 API Test Result: START FETCH');
      print('🌐 ========================================');
      print('🌐 Received userId parameter: "$userId"');
      print('🌐 userId length: ${userId.length}');
      print('🌐 userId isEmpty: ${userId.isEmpty}');
      
      // Validasi userId tidak boleh kosong
      if (userId.isEmpty) {
        print('❌ ERROR: UserId is empty! Cannot fetch test results.');
        throw Exception('UserId cannot be empty');
      }
      
      // Build request body sesuai API spec
      final requestBody = {
        "Filter": [
          {
            "Field": "UserId",
            "Search": userId,  // Gunakan userId yang sudah tervalidasi
          }
        ],
        "Sort": {
          "Field": "createDate",
          "Type": 1,
        },
        "Start": 0,
        "Length": 0,
      };

      print('🌐 Request Body:');
      print('🌐 ${requestBody.toString()}');
      final filterList = requestBody["Filter"] as List?;
      if (filterList != null && filterList.isNotEmpty) {
        final firstFilter = filterList[0] as Map?;
        print('🌐 Search value in Filter: "${firstFilter?["Search"]}"');
      }
      print('🌐 ========================================');
      print('');

      final response = await _apiDataSource.fetchAssessmentDetails(requestBody);

      if (!response.succeeded) {
        throw Exception(response.message);
      }

      // Convert API response ke TestResultModel
      return response.list.map((item) => item.toTestResultModel()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TestResultModel>> fetchMemberTestsByPic(String picId) async {
    try {
      print('');
      print('🌐 ========================================');
      print('🌐 API Test Result: FETCH MEMBER TESTS BY PIC');
      print('🌐 ========================================');
      print('🌐 Received PIC ID parameter: "$picId"');
      print('🌐 PIC ID length: ${picId.length}');
      print('🌐 PIC ID isEmpty: ${picId.isEmpty}');
      
      // Validasi picId tidak boleh kosong
      if (picId.isEmpty) {
        print('❌ ERROR: PIC ID is empty! Cannot fetch member tests.');
        throw Exception('PIC ID cannot be empty');
      }
      
      // Build request body dengan filter IdPic
      final requestBody = {
        "Filter": [
          {
            "Field": "IdPic",
            "Search": picId,
          }
        ],
        "Sort": {
          "Field": "",
          "Type": 0,
        },
        "Start": 0,
        "Length": 0,
      };

      print('🌐 Request Body (IdPic filter):');
      print('🌐 ${requestBody.toString()}');
      print('🌐 About to call API endpoint: /AssesmentDetail/list');
      print('🌐 ========================================');
      print('');

      final response = await _apiDataSource.fetchAssessmentDetails(requestBody);

      print('');
      print('🌐 ========================================');
      print('🌐 API RESPONSE RECEIVED');
      print('🌐 ========================================');
      print('🌐 Response succeeded: ${response.succeeded}');
      print('🌐 Response message: ${response.message}');
      print('🌐 Response data count: ${response.list.length}');
      if (response.list.isNotEmpty) {
        print('🌐 First item sample: ${response.list.first.toString()}');
      }
      print('🌐 ========================================');
      print('');

      if (!response.succeeded) {
        throw Exception(response.message);
      }

      // Convert API response ke TestResultModel
      final convertedResults = response.list.map((item) => item.toTestResultModel()).toList();
      print('🌐 Converted ${convertedResults.length} items to TestResultModel');
      
      return convertedResults;
    } catch (e) {
      print('❌ Exception in fetchMemberTestsByPic: $e');
      rethrow;
    }
  }

  @override
  Future<List<TestMemberResultModel>> fetchMemberResults({
    String? examId,
    String? jabatan,
  }) async {
    // TODO: Implement when API for member results is available
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<TestSummaryModel> fetchExamSummary({
    String? userId,
    String? examId,
  }) async {
    // TODO: Implement when API for summary is available
    await Future.delayed(const Duration(milliseconds: 500));
    return const TestSummaryModel(
      jumlahPesertaLulus: 0,
      jumlahPesertaTidakLulus: 0,
      nilaiRataRata: 0,
      nilaiMinimal: 0,
    );
  }
}

/// Implementation dengan mock data (untuk development/testing)
// Uncomment @LazySingleton jika ingin pakai mock data
// @LazySingleton(as: TestResultRemoteDataSource)
class TestResultRemoteDataSourceMockImpl implements TestResultRemoteDataSource {
  // Mock data untuk hasil Test
  final List<TestResultModel> _mockMyResults = [
    TestResultModel(
      id: 'PNC09272',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 0, // Will show as "-" for belum dinilai
      nilaiKKM: 78,
      status: TestKelulusanStatus.belumDinilai,
      tipeTest: 'Ujian Tahunan',
    ),
    TestResultModel(
      id: 'PNC09272',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 80,
      nilaiKKM: 78,
      status: TestKelulusanStatus.lulus,
      tipeTest: 'Ujian Tahunan',
    ),
    TestResultModel(
      id: 'PNC09272',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 65,
      nilaiKKM: 78,
      status: TestKelulusanStatus.tidakLulus,
      tipeTest: 'Ujian Tahunan',
    ),
    TestResultModel(
      id: 'PNC09272',
      userId: 'user_1',
      namaTest: 'Pengetahuan Umum',
      tanggalTest: DateTime(2025, 9, 12),
      nilaiTest: 80,
      nilaiKKM: 78,
      status: TestKelulusanStatus.lulus,
      tipeTest: 'Ujian Tahunan',
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
  Future<List<TestResultModel>> fetchMemberTestsByPic(String picId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock: return all results (in real API, filter by IdPic)
    return _mockMyResults;
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

