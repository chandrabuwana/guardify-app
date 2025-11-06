import 'package:injectable/injectable.dart';
import '../entities/personnel.dart';
import '../repositories/personnel_repository.dart';

@injectable
class GetPersonnelDetailUseCase {
  final PersonnelRepository repository;

  GetPersonnelDetailUseCase(this.repository);

  Future<Personnel?> call(String personnelId) {
    return repository.getPersonnelById(personnelId);
  }
}
