import 'package:dartz/dartz.dart';
import '../entities/panic_button.dart';
import '../entities/failure.dart';

abstract class PanicButtonRepository {
  Future<Either<Failure, bool>> activatePanicButton(PanicButton panicButton);
  Future<Either<Failure, List<PanicButton>>> getPanicButtonHistory();
  Future<Either<Failure, bool>> verifyPanicButton(
      String panicButtonId, List<bool> verificationStates);
  Future<Either<Failure, String>> getCurrentLocation();
}
