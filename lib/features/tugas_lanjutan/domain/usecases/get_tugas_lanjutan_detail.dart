import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/tugas_lanjutan_entity.dart';
import '../repositories/tugas_lanjutan_repository.dart';

/// Use case untuk get detail tugas lanjutan
@injectable
class GetTugasLanjutanDetail {
  final TugasLanjutanRepository repository;

  GetTugasLanjutanDetail(this.repository);

  Future<Either<Failure, TugasLanjutanEntity>> call(String id) async {
    return await repository.getTugasLanjutanDetail(id);
  }
}

