import 'package:injectable/injectable.dart';
import '../entities/panic_alert.dart';
import '../repositories/panic_button_repository.dart';

@injectable
class ActivatePanicButtonUseCase {
  final PanicButtonRepository repository;

  ActivatePanicButtonUseCase(this.repository);

  Future<PanicAlert> call(String userId) async {
    await repository.activatePanicButton(userId);
    return await repository.createPanicAlert(userId);
  }
}
