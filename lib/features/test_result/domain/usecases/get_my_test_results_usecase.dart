import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/test_result_entity.dart';
import '../repositories/test_result_repository.dart';

/// Use case untuk get hasil Test saya
@injectable
class GetMyTestResultsUseCase {
  final TestResultRepository repository;

  GetMyTestResultsUseCase(this.repository);

  Future<Either<Failure, List<TestResultEntity>>> call(String userId) async {
    return await repository.getMyResults(userId);
  }
}

