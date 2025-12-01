import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/tugas_lanjutan_model.dart';
import '../models/carried_over_task_response_model.dart';
import '../models/submit_carried_over_task_request_model.dart';
import '../../domain/entities/tugas_lanjutan_entity.dart';
import '../../../../core/security/security_manager.dart';

part 'tugas_lanjutan_remote_data_source.g.dart';

/// Retrofit API client for tugas lanjutan endpoints
@RestApi()
abstract class TugasLanjutanApiClient {
  factory TugasLanjutanApiClient(Dio dio, {String baseUrl}) = _TugasLanjutanApiClient;

  /// Get carried over task list using POST /CarriedOverTask/list
  @POST('/CarriedOverTask/list')
  Future<CarriedOverTaskResponseModel> getCarriedOverTaskList(
    @Body() Map<String, dynamic> body,
  );

  /// Submit carried over task using POST /CarriedOverTask/submit
  @POST('/CarriedOverTask/submit')
  @DioResponseType(ResponseType.json)
  Future<dynamic> submitCarriedOverTask(
    @Body() SubmitCarriedOverTaskRequestModel body,
  );
}

/// Remote data source untuk Tugas Lanjutan
abstract class TugasLanjutanRemoteDataSource {
  /// Get tugas lanjutan list
  /// For tab "Hari Ini": uses get_current_task from schedule (filterByToday = true)
  /// For tab "Riwayat": uses CarriedOverTask/list API with filter by SolverId (filterByToday = false)
  /// For tab "Tugas Anggota": uses CarriedOverTask/list API with filter by Jabatan
  Future<List<TugasLanjutanModel>> getTugasLanjutanList({
    bool filterByToday = false,
    String? userId,
    bool filterByJabatan = false,
    String? jabatan,
    String? status,
  });

  Future<TugasLanjutanModel> getTugasLanjutanDetail(String id);

  Future<TugasLanjutanModel> selesaikanTugas({
    required String id,
    required String lokasi,
    required String buktiUrl,
    String? catatan,
    required String userId,
    required String userName,
  });

  Future<Map<String, dynamic>> getProgressSummary({
    String? userId,
  });
}

@LazySingleton(as: TugasLanjutanRemoteDataSource)
class TugasLanjutanRemoteDataSourceImpl
    implements TugasLanjutanRemoteDataSource {
  final TugasLanjutanApiClient apiClient;

  TugasLanjutanRemoteDataSourceImpl(Dio dio)
      : apiClient = TugasLanjutanApiClient(dio);

  /// Convert CarryOverTaskItemModel to TugasLanjutanModel
  TugasLanjutanModel _carriedOverTaskToModel(CarriedOverTaskItemModel item) {
    // Parse dates
    final reportDate = DateTime.tryParse(item.reportDate) ?? DateTime.now();
    final solverDate = item.solverDate != null
        ? DateTime.tryParse(item.solverDate!)
        : null;

    // Determine status
    final status = item.status.toUpperCase() == 'OPEN'
        ? TugasLanjutanStatus.belum
        : TugasLanjutanStatus.selesai;

    // Get pelapor name from ReportName
    final pelapor = item.reportName?.fullname ?? item.createBy;

    return TugasLanjutanModel(
      id: item.id,
      title: item.reportNote.isNotEmpty
          ? item.reportNote
          : 'Tugas Lanjutan',
      lokasi: '', // Lokasi tidak ada di API response, akan diisi dari form
      pelapor: pelapor,
      tanggal: reportDate,
      deskripsi: item.reportNote,
      status: status,
      diselesaikanOleh: item.solverId != null
          ? '${item.updateBy ?? item.solverId}'
          : null,
      diselesaikanOlehId: item.solverId,
      tanggalSelesai: solverDate,
      buktiUrl: null, // Bukti tidak ada di API response
      catatan: item.solverNote,
    );
  }


  // Mock data untuk fallback (jika diperlukan)
  final List<TugasLanjutanModel> _mockData = [
    TugasLanjutanModel(
      id: '1',
      title: 'Tugas Lanjutan 1',
      lokasi: 'Pos Gajah',
      pelapor: 'Supriadi Aham',
      tanggal: DateTime(2025, 9, 29, 7, 10),
      deskripsi:
          'Pemeriksaan area gudang belum sepenuhnya selesai karena keterbatasan waktu. Beberapa titik masih belum dicek, terutama bagian pintu belakang dan rak penyimpanan barang berharga. Lanjutkan pemeriksaan menyeluruh, memastikan semua akses dalam kondisi aman, serta melaporkan hasil ke pengawas.',
      status: TugasLanjutanStatus.selesai,
      diselesaikanOleh: 'Afif Azami - 9218211',
      diselesaikanOlehId: '9218211',
      tanggalSelesai: DateTime(2025, 9, 29, 11, 23),
      buktiUrl: 'bukti.jpg',
    ),
    TugasLanjutanModel(
      id: '2',
      title: 'Tugas Lanjutan 1',
      lokasi: 'Pos Gajah',
      pelapor: 'Supriadi Aham',
      tanggal: DateTime(2025, 9, 29, 7, 10),
      deskripsi:
          'Pemeriksaan area gudang belum sepenuhnya selesai karena keterbatasan waktu. Beberapa titik masih belum dicek, terutama bagian pintu belakang dan rak penyimpanan barang berharga. Lanjutkan pemeriksaan menyeluruh, memastikan semua akses dalam kondisi aman, serta melaporkan hasil ke pengawas.',
      status: TugasLanjutanStatus.selesai,
      diselesaikanOleh: 'Afif Azami - 9218211',
      diselesaikanOlehId: '9218211',
      tanggalSelesai: DateTime(2025, 9, 29, 11, 23),
      buktiUrl: 'bukti.jpg',
    ),
    TugasLanjutanModel(
      id: '3',
      title: 'Tugas Lanjutan 2',
      lokasi: 'Pos Gajah',
      pelapor: 'Supriadi Aham',
      tanggal: DateTime(2025, 9, 29, 7, 10),
      deskripsi:
          'Pemeriksaan area gudang belum sepenuhnya selesai karena keterbatasan waktu. Beberapa titik masih belum dicek, terutama bagian pintu belakang dan rak penyimpanan barang berharga. Lanjutkan pemeriksaan menyeluruh, memastikan semua akses dalam kondisi aman, serta melaporkan hasil ke pengawas.',
      status: TugasLanjutanStatus.belum,
    ),
    TugasLanjutanModel(
      id: '4',
      title: 'Tugas Lanjutan 3',
      lokasi: 'Pos Singa',
      pelapor: 'Budi Santoso',
      tanggal: DateTime(2025, 9, 28, 8, 0),
      deskripsi:
          'Perbaikan sistem keamanan di area parkir belum selesai. Perlu pengecekan ulang dan dokumentasi.',
      status: TugasLanjutanStatus.selesai,
      diselesaikanOleh: 'John Doe - 9218212',
      diselesaikanOlehId: '9218212',
      tanggalSelesai: DateTime(2025, 9, 28, 14, 30),
      buktiUrl: 'bukti2.jpg',
    ),
  ];

  @override
  Future<List<TugasLanjutanModel>> getTugasLanjutanList({
    bool filterByToday = false,
    String? userId,
    bool filterByJabatan = false,
    String? jabatan,
    String? status,
  }) async {
    // Tab "Hari Ini" is handled in repository using GetCurrentTask
    // This method is for tab "Riwayat" and "Tugas Anggota"
    if (filterByToday) {
      // Should not reach here, but return empty for safety
      return [];
    }

    try {
      Map<String, dynamic> requestBody;

      if (filterByJabatan && jabatan != null) {
        // Tab "Tugas Anggota": Filter by Jabatan
        requestBody = {
          'Filter': [
            {'Field': 'Jabatan', 'Search': jabatan}
          ],
          'Sort': {'Field': '', 'Type': 0},
          'Start': 0,
          'Length': 0, // Get all records
        };
      } else {
        // Tab "Riwayat": Filter by SolverId
        if (userId == null) {
          throw Exception('userId is required for riwayat');
        }
        
        requestBody = {
          'Filter': [
            {'Field': 'SolverId', 'Search': userId}
          ],
          'Sort': {'Field': '', 'Type': 0},
          'Start': 0,
          'Length': 0, // Get all records
        };
      }

      final response = await apiClient.getCarriedOverTaskList(requestBody);

      if (response.succeeded) {
        // Convert List to TugasLanjutanModel
        return response.list
            .map((item) => _carriedOverTaskToModel(item))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error getting carried over task list: $e');
      return [];
    }
  }

  @override
  Future<TugasLanjutanModel> getTugasLanjutanDetail(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final tugas = _mockData.firstWhere(
      (tugas) => tugas.id == id,
      orElse: () => throw Exception('Tugas lanjutan not found'),
    );

    return tugas;
  }

  @override
  Future<TugasLanjutanModel> selesaikanTugas({
    required String id,
    required String lokasi,
    required String buktiUrl,
    String? catatan,
    required String userId,
    required String userName,
  }) async {
    try {
      // Get user data from secure storage
      final userUsername = await SecurityManager.readSecurely('user_username') ?? '';
      final userFullName = await SecurityManager.readSecurely('user_fullname') ?? userName;
      final userMail = await SecurityManager.readSecurely('user_mail') ?? '';
      final userRoleId = await SecurityManager.readSecurely('user_role_id') ?? 'AGT';
      final userRoleName = await SecurityManager.readSecurely('user_role_name') ?? 'Anggota';

      // Prepare file data if buktiUrl is provided
      FileModel? fileModel;
      if (buktiUrl.isNotEmpty && buktiUrl != 'bukti.jpg') {
        try {
          // If buktiUrl is a file path, read and encode it
          final file = File(buktiUrl);
          if (await file.exists()) {
            final fileBytes = await file.readAsBytes();
            final base64String = base64Encode(fileBytes);
            final fileName = buktiUrl.split('/').last;
            final mimeType = _getMimeType(fileName);

            fileModel = FileModel(
              filename: fileName,
              mimeType: mimeType,
              base64: base64String,
            );
          }
        } catch (e) {
          print('Error reading file: $e');
          // If file doesn't exist, create a placeholder
          fileModel = FileModel(
            filename: 'bukti.jpg',
            mimeType: 'image/jpeg',
            base64: '', // Empty base64 if file not found
          );
        }
      }

      // Create token model
      final tokenModel = TokenModel(
        id: userId,
        role: [
          RoleItemModel(
            id: userRoleId,
            nama: userRoleName,
          ),
        ],
        username: userUsername,
        fullName: userFullName,
        mail: userMail,
      );

      // Create request model
      final request = SubmitCarriedOverTaskRequestModel(
        id: id,
        notes: catatan ?? '',
        file: fileModel,
        token: tokenModel,
      );

      // Call API
      final response = await apiClient.submitCarriedOverTask(request);

      // Convert response to Map if it's not already
      final responseMap = response is Map<String, dynamic> 
          ? response 
          : Map<String, dynamic>.from(response as Map);

      // Check if API call succeeded
      if (responseMap['succeeded'] == true || responseMap['Succeeded'] == true) {
        // If API call succeeds, return updated task
        // Note: API might return the updated task, or we need to fetch it again
        // For now, we'll create a model with updated status
        return TugasLanjutanModel(
          id: id,
          title: 'Tugas Lanjutan', // Will be updated from actual response
          lokasi: lokasi,
          pelapor: '', // Will be updated from actual response
          tanggal: DateTime.now(),
          deskripsi: '', // Will be updated from actual response
          status: TugasLanjutanStatus.selesai,
          diselesaikanOleh: '$userFullName - $userId',
          diselesaikanOlehId: userId,
          tanggalSelesai: DateTime.now(),
          buktiUrl: buktiUrl,
          catatan: catatan,
        );
      } else {
        final message = responseMap['message'] ?? responseMap['Message'] ?? 'Failed to submit task';
        throw Exception(message);
      }
    } catch (e) {
      print('Error submitting task: $e');
      rethrow;
    }
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Future<Map<String, dynamic>> getProgressSummary({
    String? userId,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    final today = DateTime.now();
    final todayTasks = _mockData
        .where((tugas) =>
            tugas.tanggal.year == today.year &&
            tugas.tanggal.month == today.month &&
            tugas.tanggal.day == today.day)
        .toList();

    final total = todayTasks.length;
    final selesai = todayTasks
        .where((tugas) => tugas.status == TugasLanjutanStatus.selesai)
        .length;
    final belum = todayTasks
        .where((tugas) => tugas.status == TugasLanjutanStatus.belum)
        .length;
    final terverifikasi = todayTasks
        .where((tugas) => tugas.status == TugasLanjutanStatus.terverifikasi)
        .length;

    return {
      'total': total,
      'selesai': selesai,
      'belum': belum,
      'terverifikasi': terverifikasi,
      'progress': total > 0 ? selesai / total : 0.0,
    };
  }
}

