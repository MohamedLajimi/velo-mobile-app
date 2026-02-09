import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements NoParamsUseCase<Unit> {
  final AuthRepository _authRepository;

  const LogoutUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, Unit>> call() => _authRepository.logout();
}
