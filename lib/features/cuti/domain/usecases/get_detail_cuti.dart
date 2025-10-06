import 'package:injectable/injectable.dart';
import '../entities/cuti_entity.dart';
import '../repositories/cuti_repository.dart';

@injectable
class GetDetailCuti {
  final CutiRepository repository;

  GetDetailCuti(this.repository);

  Future<CutiEntity> call(String cutiId) async {
    return await repository.getDetailCuti(cutiId);
  }
}
