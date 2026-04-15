import 'package:injectable/injectable.dart';
import '../repositories/cuti_repository.dart';

@injectable
class DeleteCuti {
  final CutiRepository repository;

  DeleteCuti(this.repository);

  Future<void> call(String cutiId) async {
    return await repository.deleteCuti(cutiId);
  }
}
