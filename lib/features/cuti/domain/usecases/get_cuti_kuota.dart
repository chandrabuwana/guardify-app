import 'package:injectable/injectable.dart';
import '../entities/cuti_kuota_item_entity.dart';
import '../repositories/cuti_repository.dart';

@injectable
class GetCutiKuota {
  final CutiRepository repository;

  GetCutiKuota(this.repository);

  Future<List<CutiKuotaItemEntity>> call(String userId) async {
    return await repository.getCutiKuota(userId);
  }
}
