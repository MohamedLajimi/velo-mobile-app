import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';

class CompleteProfileUseCase
    implements UseCase<UserEntity, CompleteProfileParams> {
  final AuthRepository _authRepository;

  const CompleteProfileUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(CompleteProfileParams params) =>
      _authRepository.completeProfile(params: params);
}

class CompleteProfileParams {
  final String userId;
  final String phoneNumber;
  final UserRole role;
  final String idCardPath;

  const CompleteProfileParams({
    required this.userId,
    required this.role,
    required this.phoneNumber,
    required this.idCardPath,
  });
}
