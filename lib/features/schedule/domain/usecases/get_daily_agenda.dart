import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetDailyAgenda {
  final ScheduleRepository repository;

  GetDailyAgenda(this.repository);

  Future<DailyAgendaResult> call({
    required String userId,
    required int year,
    required int month,
  }) async {
    return await repository.getDailyAgenda(
      userId: userId,
      year: year,
      month: month,
    );
  }
}
