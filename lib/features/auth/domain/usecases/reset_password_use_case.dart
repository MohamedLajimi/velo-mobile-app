import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<void, String> {
  final AuthRepository _authRepository;
  ResetPasswordUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(String email) {
    return _authRepository.resetPassword(email: email);
  }
}
