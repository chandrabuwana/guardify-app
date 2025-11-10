import 'package:injectable/injectable.dart';
import '../repositories/personnel_repository.dart';

@injectable
class RevisePersonnelUseCase {
  final PersonnelRepository repository;

  RevisePersonnelUseCase(this.repository);

  Future<bool> call(String personnelId, String feedback) {
    return repository.revisePersonnel(personnelId, feedback);
  }
}
