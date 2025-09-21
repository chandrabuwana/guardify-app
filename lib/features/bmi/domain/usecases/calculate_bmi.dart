import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/entities/failure.dart';
import '../entities/bmi_record.dart';
import '../entities/bmi_input.dart';
import '../repositories/bmi_repository.dart';

@injectable
class CalculateBMI {
  final BMIRepository repository;

  CalculateBMI(this.repository);

  Future<Either<Failure, BMIRecord>> call({
    required String userId,
    required BMIInput input,
    String? recordedBy,
  }) {
    // Validasi input
    if (!input.isValid) {
      return Future.value(
          Left(ServerFailure('Data berat dan tinggi badan tidak valid')));
    }

    return repository.addBMIRecord(
      userId: userId,
      input: input,
      recordedBy: recordedBy,
    );
  }
}
