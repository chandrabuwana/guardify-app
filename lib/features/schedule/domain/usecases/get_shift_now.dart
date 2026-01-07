import 'package:injectable/injectable.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetShiftNow {
  final ScheduleRepository repository;

  GetShiftNow(this.repository);

  Future<ShiftNowResult> call() async {
    return await repository.getShiftNow();
  }
}

