import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/tugas_lanjutan_entity.dart';
import '../repositories/tugas_lanjutan_repository.dart';

/// Use case untuk menyelesaikan tugas lanjutan
@injectable
class SelesaikanTugas {
  final TugasLanjutanRepository repository;

  SelesaikanTugas(this.repository);

  Future<Either<Failure, TugasLanjutanEntity>> call({
    required String id,
    required String lokasi,
    required String buktiUrl,
    String? catatan,
    required String userId,
    required String userName,
  }) async {
    return await repository.selesaikanTugas(
      id: id,
      lokasi: lokasi,
      buktiUrl: buktiUrl,
      catatan: catatan,
      userId: userId,
      userName: userName,
    );
  }
}

