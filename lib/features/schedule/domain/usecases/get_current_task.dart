import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetCurrentTask {
  final ScheduleRepository repository;

  GetCurrentTask(this.repository);

  Future<CurrentTaskResult> call({
    required String idShiftDetail,
  }) async {
    return await repository.getCurrentTask(
      idShiftDetail: idShiftDetail,
    );
  }
}

