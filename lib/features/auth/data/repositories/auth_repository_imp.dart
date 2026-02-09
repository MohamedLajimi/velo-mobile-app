import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/error/safe_call.dart';
import 'package:karaba/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:karaba/features/auth/data/mappers/auth_exception_mapper.dart';
import 'package:karaba/features/auth/data/models/complete_profile_params_model.dart';
import 'package:karaba/features/auth/data/models/sign_up_params_model.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';
import 'package:karaba/features/auth/domain/usecases/complete_profile_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  const AuthRepositoryImp({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required SignInParams params,
  }) async => await SafeCall.execute(
    action: () => _authRemoteDataSource.signInWithEmail(
      email: params.email,
      password: params.password,
    ),
    onException: (e) => AuthExceptionMapper.map(e),
  );

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required SignUpParams params,
  }) async => await SafeCall.execute(
    action: () async => await _authRemoteDataSource.signUpWithEmail(
      params: SignUpParamsModel.fromEntity(params),
    ),
    onException: (e) => AuthExceptionMapper.map(e),
  );

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async =>
      SafeCall.execute(
        action: () async => await _authRemoteDataSource.signInWithGoogle(),
        onException: (e) => AuthExceptionMapper.map(e),
      );

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async =>
      await SafeCall.execute(
        action: () async => await _authRemoteDataSource.getCurrentUser(),
        onException: (e) => AuthExceptionMapper.map(e),
      );

  @override
  Future<Either<Failure, UserEntity>> completeProfile({
    required CompleteProfileParams params,
  }) async => await SafeCall.execute(
    action: () async => await _authRemoteDataSource.completeProfile(
      params: CompleteProfileParamsModel.fromEntity(params),
    ),
    onException: (e) => AuthExceptionMapper.map(e),
  );

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async =>
      await SafeCall.execute(
        action: () async {
          await _authRemoteDataSource.resetPassword(email: email);
          return unit;
        },
        onException: (e) => AuthExceptionMapper.map(e),
      );

  @override
  Future<Either<Failure, Unit>> logout() async => await SafeCall.execute(
    action: () async {
      await _authRemoteDataSource.logout();
      return unit;
    },
    onException: (e) => AuthExceptionMapper.map(e),
  );
}
