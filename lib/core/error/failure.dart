sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'error.network_failure']);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'error.server_failure']);
}