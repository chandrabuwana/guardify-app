import 'package:injectable/injectable.dart';
import '../../domain/entities/cuti_entity.dart';
import '../../domain/entities/cuti_kuota_entity.dart';
import '../../domain/entities/leave_request_type_entity.dart';
import '../../domain/repositories/cuti_repository.dart';
import '../datasources/cuti_remote_datasource.dart';

@LazySingleton(as: CutiRepository)
class CutiRepositoryImpl implements CutiRepository {
  final CutiRemoteDataSource remoteDataSource;

  CutiRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<CutiKuotaEntity> getCutiKuota(String userId) async {
    try {
      final result = await remoteDataSource.getCutiKuota(userId);
      return result.toEntity();
    } catch (e) {
      throw Exception('Failed to get kuota cuti: $e');
    }
  }

  @override
  Future<List<CutiEntity>> getDaftarCutiSaya(String userId) async {
    try {
      final result = await remoteDataSource.getDaftarCutiSaya(userId);
      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get daftar cuti saya: $e');
    }
  }

  @override
  Future<List<CutiEntity>> getDaftarCutiAnggota({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
  }) async {
    try {
      final result = await remoteDataSource.getDaftarCutiAnggota(
        status: status,
        tipeCuti: tipeCuti,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
      );
      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get daftar cuti anggota: $e');
    }
  }

  @override
  Future<CutiEntity> buatAjuanCuti({
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
      final result = await remoteDataSource.buatAjuanCuti(
        userId: userId,
        nama: nama,
        tipeCuti: tipeCuti,
        leaveRequestTypeId: leaveRequestTypeId,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        alasan: alasan,
        jumlahHari: jumlahHari,
      );
      return result.toEntity();
    } catch (e) {
      throw Exception('Failed to create ajuan cuti: $e');
    }
  }

  @override
  Future<CutiEntity> updateStatusCuti({
    required String cutiId,
    required CutiStatus status,
    required String reviewerId,
    required String reviewerName,
    String? umpanBalik,
  }) async {
    try {
      final result = await remoteDataSource.updateStatusCuti(
        cutiId: cutiId,
        status: status,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        umpanBalik: umpanBalik,
      );
      return result.toEntity();
    } catch (e) {
      throw Exception('Failed to update status cuti: $e');
    }
  }

  @override
  Future<List<CutiEntity>> filterCuti({
    String? status,
    String? tipeCuti,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? userId,
  }) async {
    try {
      final result = await remoteDataSource.filterCuti(
        status: status,
        tipeCuti: tipeCuti,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        userId: userId,
      );
      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to filter cuti: $e');
    }
  }

  @override
  Future<CutiEntity> getDetailCuti(String cutiId) async {
    try {
      final result = await remoteDataSource.getDetailCuti(cutiId);
      return result.toEntity();
    } catch (e) {
      throw Exception('Failed to get detail cuti: $e');
    }
  }

  @override
  Future<List<CutiEntity>> getRekapCuti({
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? status,
    String? tipeCuti,
  }) async {
    try {
      final result = await remoteDataSource.getRekapCuti(
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        status: status,
        tipeCuti: tipeCuti,
      );
      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get rekap cuti: $e');
    }
  }

  @override
  Future<List<LeaveRequestTypeEntity>> getLeaveRequestTypeList() async {
    try {
      final result = await remoteDataSource.getLeaveRequestTypeList();
      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get leave request types: $e');
    }
  }

  @override
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
  }) async {
    try {
      final result = await remoteDataSource.editCuti(
        cutiId: cutiId,
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
      return result.toEntity();
    } catch (e) {
      throw Exception('Failed to edit cuti: $e');
    }
  }

  @override
  Future<void> deleteCuti(String cutiId) async {
    try {
      await remoteDataSource.deleteCuti(cutiId);
    } catch (e) {
      throw Exception('Failed to delete cuti: $e');
    }
  }
}
