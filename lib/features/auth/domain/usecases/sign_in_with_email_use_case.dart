import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository _authRepository;

  const SignInWithEmailUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) =>
      _authRepository.signInWithEmail(params);
}

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}
