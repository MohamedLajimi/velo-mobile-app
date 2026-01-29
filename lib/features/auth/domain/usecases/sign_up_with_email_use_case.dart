import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmailUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository _authRepository;

  const SignUpWithEmailUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) =>
      _authRepository.signUpWithEmail(params);
}

class SignUpParams {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final UserRole role;
  final String? profilePath;
  final String? licensePath;

  const SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role,
    this.profilePath,
    this.licensePath,
  });
}
