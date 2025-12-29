import 'package:injectable/injectable.dart';
import '../entities/leave_request_type_entity.dart';
import '../repositories/cuti_repository.dart';

@injectable
class GetLeaveRequestTypeList {
  final CutiRepository repository;

  GetLeaveRequestTypeList(this.repository);

  Future<List<LeaveRequestTypeEntity>> call() async {
    return await repository.getLeaveRequestTypeList();
  }
}

