import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements NoParamsUseCase<(UserEntity, bool)> {
  final AuthRepository _authRepository;

  const SignInWithGoogleUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, (UserEntity, bool)>> call() =>
      _authRepository.signInWithGoogle();
}
