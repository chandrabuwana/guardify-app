abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class LocationFailure extends Failure {
  final String message;

  const LocationFailure(this.message);
}
