import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/bmi_record.dart';
import '../repositories/bmi_repository.dart';

@injectable
class GetBMIHistory {
  final BMIRepository repository;

  GetBMIHistory(this.repository);

  Future<Either<Failure, List<BMIRecord>>> call(String userId) {
    return repository.getBMIHistory(userId);
  }
}
