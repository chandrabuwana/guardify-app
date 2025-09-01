import 'package:dartz/dartz.dart';
import '../entities/failure.dart';
import '../repositories/panic_button_repository.dart';

class VerifyPanicButtonUseCase {
  final PanicButtonRepository repository;

  VerifyPanicButtonUseCase(this.repository);

  Future<Either<Failure, bool>> call(VerifyPanicButtonParams params) async {
    return await repository.verifyPanicButton(
      params.panicButtonId,
      params.verificationStates,
    );
  }
}

class VerifyPanicButtonParams {
  final String panicButtonId;
  final List<bool> verificationStates;

  VerifyPanicButtonParams({
    required this.panicButtonId,
    required this.verificationStates,
  });
}
