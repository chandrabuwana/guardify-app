import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

@injectable
class GetDaftarCutiSaya {
  final CutiRepository repository;

  GetDaftarCutiSaya(this.repository);

  Future<List<CutiEntity>> call(String userId) async {
    return await repository.getDaftarCutiSaya(userId);
  }
}
