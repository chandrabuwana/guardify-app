import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetMonthlySchedule {
  final ScheduleRepository repository;

  GetMonthlySchedule(this.repository);

  Future<ScheduleResult> call({
    required String userId,
    required int year,
    required int month,
  }) async {
    return await repository.getMonthlySchedule(
      userId: userId,
      year: year,
      month: month,
    );
  }
}
