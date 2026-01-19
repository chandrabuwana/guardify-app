import '../models/cuti_model.dart';
import '../models/cuti_kuota_item_model.dart';
import '../models/leave_request_type_model.dart';
import '../../domain/entities/cuti_entity.dart';

/// Abstract interface for Cuti remote data source
abstract class CutiRemoteDataSource {
  /// Get kuota cuti for a user
  Future<List<CutiKuotaItemModel>> getCutiKuota(String userId);

  /// Get list of leave requests for current user
  Future<List<CutiModel>> getDaftarCutiSaya(String userId);

  /// Get list of leave requests for all members
  Future<List<CutiModel>> getDaftarCutiAnggota({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
  });

  /// Create new leave request
  Future<CutiModel> buatAjuanCuti({
    required String userId,
    required String nama,
    required CutiType tipeCuti,
    required int leaveRequestTypeId, // ID dari API
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String alasan,
    required int jumlahHari,
  });

  /// Update status of leave request
  Future<CutiModel> updateStatusCuti({
    required String cutiId,
    required CutiStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  });

  /// Filter leave requests
  Future<List<CutiModel>> filterCuti({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? userId,
  });

  /// Get detail of a leave request
  Future<CutiModel> getDetailCuti(String cutiId);

  /// Get summary/report of leave requests
  Future<List<CutiModel>> getRekapCuti({
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? status,
    String? tipeCuti,
  });

  /// Get list of leave request types
  Future<List<LeaveRequestTypeModel>> getLeaveRequestTypeList();

  /// Edit leave request
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
  });

  /// Delete leave request
  Future<void> deleteCuti(String cutiId);
}
