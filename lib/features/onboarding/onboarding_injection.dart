import 'package:get_it/get_it.dart';
import 'package:karaba/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:karaba/features/onboarding/data/repositories/onboarding_repository_imp.dart';
import 'package:karaba/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:karaba/features/onboarding/domain/usecases/check_onboarding_status_use_case.dart';
import 'package:karaba/features/onboarding/domain/usecases/complete_onboarding_use_case.dart';
import 'package:karaba/features/onboarding/presentation/bloc/onboarding_bloc.dart';

void initOnboarding(GetIt sl) {
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImp(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImp(onboardingLocalDataSource: sl()),
  );

  sl.registerLazySingleton(
    () => CheckOnboardingStatusUseCase(onboardingRepository: sl()),
  );
  sl.registerLazySingleton(
    () => CompleteOnboardingUseCase(onboardingRepository: sl()),
  );

  sl.registerFactory(
    () => OnboardingBloc(checkStatus: sl(), completeOnboarding: sl()),
  );
}
