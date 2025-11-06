import 'package:injectable/injectable.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/cuti_model.dart';
import '../models/cuti_kuota_model.dart';
import '../models/leave_request_response_model.dart';
import '../models/leave_request_filter_model.dart';
import 'cuti_remote_datasource.dart';
import '../../domain/entities/cuti_entity.dart';

@LazySingleton(as: CutiRemoteDataSource)
class CutiRemoteDataSourceImpl implements CutiRemoteDataSource {
  final NetworkManager networkManager;

  CutiRemoteDataSourceImpl(this.networkManager);

  @override
  Future<List<CutiModel>> getDaftarCutiSaya(String userId) async {
    try {
      // Get userId from secure storage if not provided
      final actualUserId = userId.isEmpty
          ? await SecurityManager.readSecurely(AppConstants.userIdKey) ?? userId
          : userId;

      print('🔍 Fetching leave requests for user: $actualUserId');

      // Create request body with filter by userId
      final requestBody = LeaveRequestFilterModel.byUserId(actualUserId);
      print('📤 Request body: ${requestBody.toJson()}');

      // Call API
      final response = await networkManager.post(
        '/LeaveRequest/list',
        data: requestBody.toJson(),
      );

      print('📥 Response status: ${response.statusCode}');

      // Parse response
      final leaveResponse = LeaveRequestResponseModel.fromJson(response.data);

      if (!leaveResponse.succeeded) {
        throw Exception(leaveResponse.message);
      }

      print('✅ Found ${leaveResponse.list.length} leave requests');

      // Convert to CutiModel
      final cutiList = leaveResponse.list
          .map((item) => CutiModel.fromEntity(item.toEntity()))
          .toList();

      return cutiList;
    } catch (e) {
      print('❌ Error fetching leave requests: $e');
      throw Exception('Failed to get daftar cuti saya: $e');
    }
  }

  @override
  Future<CutiKuotaModel> getCutiKuota(String userId) async {
    try {
      // TODO: Implement real API call when endpoint is available
      // For now, return mock data
      await Future.delayed(const Duration(milliseconds: 500));

      return CutiKuotaModel(
        userId: userId,
        totalKuotaPerTahun: 12,
        kuotaTerpakai: 3,
        kuotaSisa: 9,
        tahun: DateTime.now().year,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get kuota cuti: $e');
    }
  }

  @override
  Future<List<CutiModel>> getDaftarCutiAnggota({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
  }) async {
    try {
      print('🔍 Fetching all leave requests for anggota');

      // Get all leave requests (no user filter)
      final requestBody = const LeaveRequestFilterModel(
        filter: [],
        sort: SortModel(field: '', type: 0),
        start: 0,
        length: 0,
      );

      print('📤 Request body: ${requestBody.toJson()}');

      final response = await networkManager.post(
        '/LeaveRequest/list',
        data: requestBody.toJson(),
      );

      print('📥 Response status: ${response.statusCode}');

      final leaveResponse = LeaveRequestResponseModel.fromJson(response.data);

      if (!leaveResponse.succeeded) {
        throw Exception(leaveResponse.message);
      }

      print('✅ Found ${leaveResponse.list.length} leave requests');

      // Convert to CutiModel
      var cutiList = leaveResponse.list
          .map((item) => CutiModel.fromEntity(item.toEntity()))
          .toList();

      // Apply filters if provided
      if (status != null) {
        cutiList = cutiList
            .where((cuti) => cuti.status.toString().split('.').last == status)
            .toList();
      }

      if (tipeCuti != null) {
        cutiList = cutiList
            .where(
                (cuti) => cuti.tipeCuti.toString().split('.').last == tipeCuti)
            .toList();
      }

      if (tanggalMulai != null) {
        cutiList = cutiList
            .where((cuti) =>
                cuti.tanggalMulai.isAfter(tanggalMulai) ||
                cuti.tanggalMulai.isAtSameMomentAs(tanggalMulai))
            .toList();
      }

      if (tanggalSelesai != null) {
        cutiList = cutiList
            .where((cuti) =>
                cuti.tanggalSelesai.isBefore(tanggalSelesai) ||
                cuti.tanggalSelesai.isAtSameMomentAs(tanggalSelesai))
            .toList();
      }

      return cutiList;
    } catch (e) {
      print('❌ Error fetching leave requests: $e');
      throw Exception('Failed to get daftar cuti anggota: $e');
    }
  }

  @override
  Future<CutiModel> buatAjuanCuti({
    required String userId,
    required String nama,
    required CutiType tipeCuti,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String alasan,
    required int jumlahHari,
  }) async {
    try {
      print('📝 Creating leave request for user: $userId');

      // Map CutiType to IdLeaveRequestType
      int idLeaveRequestType;
      switch (tipeCuti) {
        case CutiType.tahunan:
          idLeaveRequestType = 1;
          break;
        case CutiType.sakit:
          idLeaveRequestType = 2;
          break;
        case CutiType.melahirkan:
          idLeaveRequestType = 3;
          break;
        case CutiType.menikah:
          idLeaveRequestType = 4;
          break;
        case CutiType.keluargaMeninggal:
          idLeaveRequestType = 5;
          break;
        case CutiType.lainnya:
          idLeaveRequestType = 6;
          break;
      }

      // Get NIP from secure storage (fallback to empty string if not available)
      final nip = await SecurityManager.readSecurely('user_nip') ?? '';

      // Format dates without timezone (remove 'Z' suffix)
      final startDateStr = tanggalMulai.toIso8601String().replaceAll('Z', '');
      final endDateStr = tanggalSelesai.toIso8601String().replaceAll('Z', '');

      // Build request body
      final requestBody = {
        'StartDate': startDateStr,
        'EndDate': endDateStr,
        'Fullname': nama,
        'IdLeaveRequestType': idLeaveRequestType,
        'Nip': nip.isNotEmpty ? nip : '0000000000', // Provide default if empty
        'Notes': alasan,
        'NotesApproval': alasan, // Same as Notes (required field)
        'UserId': userId,
      };

      print('📤 Request body: $requestBody');

      final response = await networkManager.post(
        '/LeaveRequest/add',
        data: requestBody,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response
      final code = response.data['Code'] as int;
      final succeeded = response.data['Succeeded'] as bool;
      final message = response.data['Message'] as String;

      if (!succeeded || code != 200) {
        throw Exception(message);
      }

      print('✅ Leave request created successfully');

      // Return the created cuti model
      // Since API doesn't return the created object, we construct it manually
      final newCuti = CutiModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}', // Temporary ID
        nama: nama,
        userId: userId,
        tipeCuti: tipeCuti,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        alasan: alasan,
        status: CutiStatus.pending,
        tanggalPengajuan: DateTime.now(),
        jumlahHari: jumlahHari,
      );

      return newCuti;
    } catch (e) {
      print('❌ Error creating leave request: $e');
      throw Exception('Failed to create ajuan cuti: $e');
    }
  }

  @override
  Future<CutiModel> updateStatusCuti({
    required String cutiId,
    required CutiStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  }) async {
    try {
      // TODO: Implement real API call when endpoint is available
      await Future.delayed(const Duration(milliseconds: 600));

      throw Exception('Update status cuti not implemented yet');
    } catch (e) {
      throw Exception('Failed to update status cuti: $e');
    }
  }

  @override
  Future<List<CutiModel>> filterCuti({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? userId,
  }) async {
    return await getDaftarCutiAnggota(
      status: status,
      tipeCuti: tipeCuti,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
    );
  }

  @override
  Future<CutiModel> getDetailCuti(String cutiId) async {
    try {
      print('🔍 Fetching detail for leave request ID: $cutiId');

      // Since there's no specific detail endpoint yet, we fetch from list and find by ID
      // Request body to fetch all leave requests (no filter)
      final requestBody = LeaveRequestFilterModel(
        filter: [], // Empty filter to get all
        sort: SortModel(field: '', type: 0),
        start: 0,
        length: 0, // 0 means get all
      );

      final response = await networkManager.post(
        '/LeaveRequest/list',
        data: requestBody.toJson(),
      );

      print('📥 Response status: ${response.statusCode}');

      final leaveResponse = LeaveRequestResponseModel.fromJson(response.data);

      if (!leaveResponse.succeeded) {
        throw Exception(leaveResponse.message);
      }

      // Find the specific leave request by ID
      final leaveItem = leaveResponse.list.firstWhere(
        (item) => item.id == cutiId,
        orElse: () =>
            throw Exception('Leave request with ID $cutiId not found'),
      );

      print(
          '✅ Found leave request detail: ${leaveItem.leaveRequestType?.name ?? 'Unknown'}');

      // Convert to CutiModel
      return CutiModel.fromEntity(leaveItem.toEntity());
    } catch (e) {
      print('❌ Error fetching leave request detail: $e');
      throw Exception('Failed to get detail cuti: $e');
    }
  }

  @override
  Future<List<CutiModel>> getRekapCuti({
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? status,
  }) async {
    return await getDaftarCutiAnggota(
      status: status,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
    );
  }
}
