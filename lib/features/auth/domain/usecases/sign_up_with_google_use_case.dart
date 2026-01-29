import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithGoogleUseCase
    implements UseCase<UserEntity, SignUpWithGoogleParams> {
  final AuthRepository _authRepository;
  SignUpWithGoogleUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(SignUpWithGoogleParams params) {
    return _authRepository.signUpWithGoogle(params.role);
  }
}

class SignUpWithGoogleParams {
  final UserRole role;
  SignUpWithGoogleParams({required this.role});
}
