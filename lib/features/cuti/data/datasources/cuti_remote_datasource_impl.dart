import 'package:injectable/injectable.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/cuti_model.dart';
import '../models/cuti_kuota_model.dart';
import '../models/cuti_kuota_item_model.dart';
import '../models/leave_request_response_model.dart';
import '../models/leave_request_filter_model.dart';
import '../models/create_leave_request_model.dart';
import '../models/edit_leave_request_model.dart';
import '../models/leave_request_type_model.dart';
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
  Future<List<CutiKuotaItemModel>> getCutiKuota(String userId) async {
    try {
      print('🔍 Fetching leave quota for user: $userId');

      // Get current year
      final currentYear = DateTime.now().year;

      // Build request body
      final requestBody = {
        'UserId': userId,
        'Year': currentYear,
      };

      print('📤 Request body: $requestBody');

      // Call API
      final response = await networkManager.post(
        '/LeaveRequest/get_detail_employee',
        data: requestBody,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response
      final code = response.data['Code'] as int?;
      final succeeded = response.data['Succeeded'] as bool?;
      final message = response.data['Message'] as String?;
      final list = response.data['List'] as List<dynamic>?;

      if (succeeded != true || code != 200 || list == null) {
        throw Exception(message ?? 'Failed to get kuota cuti');
      }

      // Convert list to CutiKuotaItemModel
      final quotaList = list
          .map((item) => CutiKuotaItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      print('✅ Quota loaded: ${quotaList.length} items');

      return quotaList;
    } catch (e) {
      print('❌ Error fetching leave quota: $e');
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
      print('🔍 Fetching leave requests for bawahan');

      // Get userId atasan (current user) from secure storage
      final atasanUserId = await SecurityManager.readSecurely(AppConstants.userIdKey) ?? '';
      
      if (atasanUserId.isEmpty) {
        throw Exception('User ID not found');
      }

      print('👤 Atasan UserId: $atasanUserId');

      // Use filter "bawahan" with atasan userId
      final requestBody = LeaveRequestFilterModel.byBawahan(atasanUserId);

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
    required int leaveRequestTypeId,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String alasan,
    required int jumlahHari,
  }) async {
    try {
      print('📝 Creating leave request for user: $userId');
      print('📝 Using LeaveRequestType ID: $leaveRequestTypeId');

      // Build request body sesuai dengan API spec
      // Use ID from API instead of hardcoded mapping
      final requestBody = CreateLeaveRequestModel.create(
        startDate: tanggalMulai,
        endDate: tanggalSelesai,
        idLeaveRequestType: leaveRequestTypeId,
        notes: alasan,
        userId: userId,
        approveDate: DateTime.now(), // ApproveDate menggunakan timestamp saat ini
        notesApproval: '-',
        status: '-',
        approveBy: '-',
      );

      print('📤 Request body: ${requestBody.toJson()}');

      final response = await networkManager.post(
        '/LeaveRequest/add',
        data: requestBody.toJson(),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response
      final code = response.data['Code'] as int?;
      final succeeded = response.data['Succeeded'] as bool?;
      final message = response.data['Message'] as String?;

      if (succeeded != true || code != 200) {
        throw Exception(message ?? 'Failed to create leave request');
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
      print('📝 Updating leave request status for ID: $cutiId');
      print('📝 Status: $status');
      print('📝 Notes: $umpanBalik');

      // Determine IsApproved based on status
      final isApproved = status == CutiStatus.approved;

      // Build request body sesuai dengan format API
      final requestBody = {
        'Id': cutiId,
        'IsApproved': isApproved,
        'Notes': umpanBalik ?? '',
      };

      print('📤 Request body: $requestBody');

      // Call API endpoint untuk approve/reject
      final response = await networkManager.post(
        '/LeaveRequest/approve',
        data: requestBody,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response sesuai format yang diberikan
      final code = response.data['Code'] as int?;
      final succeeded = response.data['Succeeded'] as bool?;
      final message = response.data['Message'] as String?;

      if (succeeded != true || code != 200) {
        throw Exception(message ?? 'Failed to update status cuti');
      }

      print('✅ Leave request status updated successfully');

      // Reload detail cuti untuk mendapatkan data terbaru
      return await getDetailCuti(cutiId);
    } catch (e) {
      print('❌ Error updating leave request status: $e');
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

      // Call GET endpoint for leave request detail
      final response = await networkManager.get(
        '/LeaveRequest/get/$cutiId',
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response
      final code = response.data['Code'] as int?;
      final succeeded = response.data['Succeeded'] as bool?;
      final message = response.data['Message'] as String?;
      final data = response.data['Data'] as Map<String, dynamic>?;

      if (succeeded != true || code != 200 || data == null) {
        throw Exception(message ?? 'Failed to get detail cuti');
      }

      // Parse leave request item from data
      final leaveItem = LeaveRequestItemModel.fromJson(data);

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
    String? tipeCuti,
  }) async {
    try {
      print('🔍 Fetching rekap cuti without filter');

      // Use filter without any field filter (empty filter)
      final requestBody = LeaveRequestFilterModel.withoutFilter();

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

      // Apply filters if provided (client-side filtering)
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
      print('❌ Error fetching rekap cuti: $e');
      throw Exception('Failed to get rekap cuti: $e');
    }
  }

  @override
  Future<List<LeaveRequestTypeModel>> getLeaveRequestTypeList() async {
    try {
      print('🔍 Fetching leave request types');

      // Build request body
      final requestBody = LeaveRequestTypeListRequestModel.create();
      print('📤 Request body: ${requestBody.toJson()}');

      // Call API
      final response = await networkManager.post(
        '/LeaveRequestType/list',
        data: requestBody.toJson(),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response
      final leaveRequestTypeResponse =
          LeaveRequestTypeListResponseModel.fromJson(response.data);

      if (!leaveRequestTypeResponse.succeeded ||
          leaveRequestTypeResponse.code != 200) {
        throw Exception(leaveRequestTypeResponse.message);
      }

      print('✅ Found ${leaveRequestTypeResponse.list.length} leave request types');

      // Filter only active types (default to true if null)
      final activeTypes = leaveRequestTypeResponse.list
          .where((type) => type.active ?? true)
          .toList();

      return activeTypes;
    } catch (e) {
      print('❌ Error fetching leave request types: $e');
      throw Exception('Failed to get leave request types: $e');
    }
  }

  @override
  Future<CutiModel> editCuti({
    required String cutiId,
    required DateTime startDate,
    required DateTime endDate,
    required int idLeaveRequestType,
    required String notes,
    required String userId,
    required String createBy,
    required DateTime createDate,
    String approveBy = '-',
    DateTime? approveDate,
    String notesApproval = '',
    String status = 'WAITING_APPROVAL',
  }) async {
    try {
      print('📝 Editing leave request ID: $cutiId');

      // Build request body sesuai dengan API spec
      final requestBody = EditLeaveRequestModel.create(
        startDate: startDate,
        endDate: endDate,
        idLeaveRequestType: idLeaveRequestType,
        notes: notes,
        userId: userId,
        createBy: createBy,
        createDate: createDate,
        approveBy: approveBy,
        approveDate: approveDate,
        notesApproval: notesApproval,
        status: status,
      );

      print('📤 Request body: ${requestBody.toJson()}');

      // Call PUT endpoint untuk edit leave request
      final response = await networkManager.put(
        '/LeaveRequest/edit/$cutiId',
        data: requestBody.toJson(),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response
      final code = response.data['Code'] as int?;
      final succeeded = response.data['Succeeded'] as bool?;
      final message = response.data['Message'] as String?;

      if (succeeded != true || code != 200) {
        throw Exception(message ?? 'Failed to edit leave request');
      }

      print('✅ Leave request edited successfully');

      // Reload detail cuti untuk mendapatkan data terbaru
      return await getDetailCuti(cutiId);
    } catch (e) {
      print('❌ Error editing leave request: $e');
      throw Exception('Failed to edit leave request: $e');
    }
  }

  @override
  Future<void> deleteCuti(String cutiId) async {
    try {
      print('🗑️ Deleting leave request ID: $cutiId');

      // Call DELETE endpoint untuk delete leave request
      final response = await networkManager.delete(
        '/LeaveRequest/delete/$cutiId',
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Parse response
      final code = response.data['Code'] as int?;
      final succeeded = response.data['Succeeded'] as bool?;
      final message = response.data['Message'] as String?;

      if (succeeded != true || code != 200) {
        throw Exception(message ?? 'Failed to delete leave request');
      }

      print('✅ Leave request deleted successfully');
    } catch (e) {
      print('❌ Error deleting leave request: $e');
      throw Exception('Failed to delete leave request: $e');
    }
  }
}
