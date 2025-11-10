import 'package:injectable/injectable.dart';
import '../repositories/personnel_repository.dart';

@injectable
class ApprovePersonnelUseCase {
  final PersonnelRepository repository;

  ApprovePersonnelUseCase(this.repository);

  Future<bool> call(String personnelId, String feedback) {
    return repository.approvePersonnel(personnelId, feedback);
  }
}
