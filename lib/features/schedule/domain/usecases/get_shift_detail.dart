import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetShiftDetail {
  final ScheduleRepository repository;

  GetShiftDetail(this.repository);

  Future<ShiftDetailResult> call({
    required String userId,
    required DateTime date,
  }) async {
    return await repository.getShiftDetail(
      userId: userId,
      date: date,
    );
  }
}
