import 'package:get_it/get_it.dart';
import 'package:karaba/core/common/blocs/user_cubit/user_cubit.dart';
import 'package:karaba/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:karaba/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:karaba/features/auth/domain/repositories/auth_repository.dart';
import 'package:karaba/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/logout_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:karaba/features/auth/presentation/blocs/reset_password_cubit/reset_password_cubit.dart';

Future<void> initAuth(GetIt sl) async {
  // 1. Blocs
  sl.registerFactory(
    () => AuthBloc(
      signInWithGoogle: sl(),
      signInWithEmailUseCase: sl(),
      signUpWithEmailUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => UserCubit(getCurrentUserUseCase: sl()));

  sl.registerFactory(() => ResetPasswordCubit(resetPasswordUseCase: sl()));

  // 2. Use Cases
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignInWithEmailUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpWithEmailUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(authRepository: sl()));

  // 3. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImp(authRemoteDataSource: sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => SupabaseAuthRemoteDataSource(
      supabaseClient: sl(),
      storageService: sl(),
    ),
  );
}
