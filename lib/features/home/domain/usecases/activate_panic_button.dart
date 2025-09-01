import 'package:dartz/dartz.dart';
import '../entities/panic_button.dart';
import '../entities/failure.dart';
import '../repositories/panic_button_repository.dart';

class ActivatePanicButtonUseCase {
  final PanicButtonRepository repository;

  ActivatePanicButtonUseCase(this.repository);

  Future<Either<Failure, bool>> call(ActivatePanicButtonParams params) async {
    final locationResult = await repository.getCurrentLocation();

    return locationResult.fold(
      (failure) => Left(failure),
      (location) async {
        final panicButton = PanicButton(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          status: 'activated',
          location: location,
          userId: params.userId,
          verificationItems: params.verificationItems,
          isVerified: params.isVerified,
        );

        return await repository.activatePanicButton(panicButton);
      },
    );
  }
}

class ActivatePanicButtonParams {
  final String userId;
  final List<String> verificationItems;
  final bool isVerified;

  ActivatePanicButtonParams({
    required this.userId,
    required this.verificationItems,
    required this.isVerified,
  });
}
