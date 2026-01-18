import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

class EditCutiParams {
  final String cutiId;
  final DateTime startDate;
  final DateTime endDate;
  final int idLeaveRequestType;
  final String notes;
  final String userId;
  final String createBy;
  final DateTime createDate;
  final String approveBy;
  final DateTime? approveDate;
  final String notesApproval;
  final String status;

  EditCutiParams({
    required this.cutiId,
    required this.startDate,
    required this.endDate,
    required this.idLeaveRequestType,
    required this.notes,
    required this.userId,
    required this.createBy,
    required this.createDate,
    this.approveBy = '-',
    this.approveDate,
    this.notesApproval = '',
    this.status = 'WAITING_APPROVAL',
  });
}

@injectable
class EditCuti {
  final CutiRepository repository;

  EditCuti(this.repository);

  Future<CutiEntity> call(EditCutiParams params) async {
    return await repository.editCuti(
      cutiId: params.cutiId,
      startDate: params.startDate,
      endDate: params.endDate,
      idLeaveRequestType: params.idLeaveRequestType,
      notes: params.notes,
      userId: params.userId,
      createBy: params.createBy,
      createDate: params.createDate,
      approveBy: params.approveBy,
      approveDate: params.approveDate,
      notesApproval: params.notesApproval,
      status: params.status,
    );
  }
}
