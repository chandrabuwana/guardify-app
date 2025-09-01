import 'package:dartz/dartz.dart';
import '../../domain/entities/panic_button.dart';
import '../../domain/entities/failure.dart';
import '../../domain/repositories/panic_button_repository.dart';
import '../datasources/panic_button_local_data_source.dart';
import '../datasources/panic_button_remote_data_source.dart';
import '../datasources/location_data_source.dart';
import '../models/panic_button_model.dart';

class PanicButtonRepositoryImpl implements PanicButtonRepository {
  final PanicButtonRemoteDataSource remoteDataSource;
  final PanicButtonLocalDataSource localDataSource;
  final LocationDataSource locationDataSource;

  PanicButtonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.locationDataSource,
  });

  @override
  Future<Either<Failure, bool>> activatePanicButton(
      PanicButton panicButton) async {
    try {
      final panicButtonModel = PanicButtonModel.fromEntity(panicButton);

      // Send to remote
      final remoteResult =
          await remoteDataSource.sendPanicAlert(panicButtonModel);

      if (remoteResult) {
        // Cache locally
        await localDataSource.cachePanicButton(panicButtonModel);
        return const Right(true);
      } else {
        return const Left(ServerFailure('Failed to send panic alert'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PanicButton>>> getPanicButtonHistory() async {
    try {
      final cachedData = await localDataSource.getCachedPanicButtons();
      return Right(cachedData.cast<PanicButton>());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPanicButton(
      String panicButtonId, List<bool> verificationStates) async {
    try {
      final result = await remoteDataSource.verifyPanicButton(
          panicButtonId, verificationStates);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentLocation() async {
    try {
      final location = await locationDataSource.getCurrentLocation();
      return Right(location);
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }
}
