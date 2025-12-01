import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetSchedulePengawas {
  final ScheduleRepository repository;

  GetSchedulePengawas(this.repository);

  Future<ShiftDetailResult> call({
    required DateTime date,
  }) async {
    return await repository.getSchedulePengawas(
      date: date,
    );
  }
}

