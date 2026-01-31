import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required SignInParams params,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required SignUpParams params,
  });

  Future<Either<Failure, (UserEntity, bool)>> signInWithGoogle();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, Unit>> resetPassword({required String email});

  Future<Either<Failure, Unit>> logout();
}
