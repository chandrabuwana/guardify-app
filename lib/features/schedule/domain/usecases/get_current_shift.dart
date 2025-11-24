import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetCurrentShift {
  final ScheduleRepository repository;

  GetCurrentShift(this.repository);

  Future<CurrentShiftResult> call({
    required String userId,
  }) async {
    return await repository.getCurrentShift(
      userId: userId,
    );
  }
}

