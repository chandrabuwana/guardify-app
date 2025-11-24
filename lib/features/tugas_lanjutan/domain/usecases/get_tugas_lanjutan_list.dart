import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/tugas_lanjutan_entity.dart';
import '../repositories/tugas_lanjutan_repository.dart';

/// Use case untuk get list tugas lanjutan
@injectable
class GetTugasLanjutanList {
  final TugasLanjutanRepository repository;

  GetTugasLanjutanList(this.repository);

  Future<Either<Failure, List<TugasLanjutanEntity>>> call({
    bool filterByToday = false,
    String? userId,
  }) async {
    return await repository.getTugasLanjutanList(
      filterByToday: filterByToday,
      userId: userId,
    );
  }
}

