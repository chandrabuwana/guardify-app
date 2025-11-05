import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/test_result_entity.dart';
import '../repositories/test_result_repository.dart';

/// Use case untuk get hasil Test anggota berdasarkan PIC ID (untuk Danton)
@injectable
class GetMemberTestsByPicUseCase {
  final TestResultRepository repository;

  GetMemberTestsByPicUseCase(this.repository);

  Future<Either<Failure, List<TestResultEntity>>> call(String picId) async {
    return await repository.getMemberTestsByPic(picId);
  }
}
