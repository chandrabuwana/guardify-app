import '../entities/cuti_entity.dart';
import '../entities/cuti_kuota_entity.dart';
import '../entities/leave_request_type_entity.dart';

abstract class CutiRepository {
  /// Get kuota cuti untuk user tertentu
  Future<CutiKuotaEntity> getCutiKuota(String userId);

  /// Get daftar cuti saya (user yang sedang login)
  Future<List<CutiEntity>> getDaftarCutiSaya(String userId);

  /// Get daftar cuti anggota (untuk atasan)
  Future<List<CutiEntity>> getDaftarCutiAnggota({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
  });

  /// Buat ajuan cuti baru
  Future<CutiEntity> buatAjuanCuti({
    required String userId,
    required String nama,
    required CutiType tipeCuti,
    required int leaveRequestTypeId, // ID dari API
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String alasan,
    required int jumlahHari,
  });

  /// Update status cuti (approve/reject)
  Future<CutiEntity> updateStatusCuti({
    required String cutiId,
    required CutiStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  });

  /// Filter cuti berdasarkan kriteria tertentu
  Future<List<CutiEntity>> filterCuti({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? userId,
  });

  /// Get detail cuti berdasarkan ID
  Future<CutiEntity> getDetailCuti(String cutiId);

  /// Get rekap cuti (untuk pengawas)
  Future<List<CutiEntity>> getRekapCuti({
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? status,
    String? tipeCuti,
  });

  /// Get list of leave request types
  Future<List<LeaveRequestTypeEntity>> getLeaveRequestTypeList();

  /// Edit leave request
  Future<CutiEntity> editCuti({
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
