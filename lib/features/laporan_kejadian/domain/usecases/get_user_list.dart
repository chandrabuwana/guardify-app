import 'package:injectable/injectable.dart';
import '../repositories/incident_repository.dart';

@injectable
class GetUserList {
  final IncidentRepository repository;

  GetUserList(this.repository);

  Future<List<Map<String, String>>> call() {
    return repository.getUserList();
  }
}

