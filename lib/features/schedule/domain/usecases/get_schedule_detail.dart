import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetScheduleDetail {
  final ScheduleRepository repository;

  GetScheduleDetail(this.repository);

  Future<ShiftDetailResult> call({
    required String userId,
    required DateTime date,
  }) async {
    return await repository.getScheduleDetail(
      userId: userId,
      date: date,
    );
  }
}

