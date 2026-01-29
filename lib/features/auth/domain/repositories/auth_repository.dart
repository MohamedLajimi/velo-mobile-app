import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail(SignInParams params);

  Future<Either<Failure, UserEntity>> signUpWithEmail(SignUpParams params);

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity>> signUpWithGoogle(UserRole role);

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> resetPassword(String email);

  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
