import 'package:injectable/injectable.dart';
import '../entities/cuti_kuota_entity.dart';
import '../repositories/cuti_repository.dart';

@injectable
class GetCutiKuota {
  final CutiRepository repository;

  GetCutiKuota(this.repository);

  Future<CutiKuotaEntity> call(String userId) async {
    return await repository.getCutiKuota(userId);
  }
}
