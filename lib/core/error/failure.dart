sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'error.no_internet']);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NoSessionFailure extends Failure {
  const NoSessionFailure(super.message);
}

class UploadFailure extends Failure {
  const UploadFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class MediaFailure extends Failure {
  const MediaFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'error.server_error']);
}
