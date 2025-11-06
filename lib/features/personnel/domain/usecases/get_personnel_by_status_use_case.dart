import 'package:injectable/injectable.dart';
import '../entities/personnel.dart';
import '../repositories/personnel_repository.dart';

@injectable
class GetPersonnelByStatusUseCase {
  final PersonnelRepository repository;

  GetPersonnelByStatusUseCase(this.repository);

  Future<List<Personnel>> call(String status, {int page = 1, int pageSize = 20}) {
    return repository.getPersonnelByStatus(status, page: page, pageSize: pageSize);
  }
}
