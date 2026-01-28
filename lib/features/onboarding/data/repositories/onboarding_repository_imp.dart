import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/error/safe_call.dart';
import 'package:karaba/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:karaba/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImp implements OnboardingRepository {
  final OnboardingLocalDataSource _onboardingLocalDataSource;

  const OnboardingRepositoryImp({
    required OnboardingLocalDataSource onboardingLocalDataSource,
  }) : _onboardingLocalDataSource = onboardingLocalDataSource;

  @override
  Future<Either<Failure, bool>> checkOnboardingStatus() async =>
      SafeCall.execute(
        action: () async => _onboardingLocalDataSource.checkOnboardingStatus(),
        onException: (e) => CacheFailure('message'),
      );

  @override
  Future<Either<Failure, Unit>> completeOnboarding() async => SafeCall.execute(
    action: () async => _onboardingLocalDataSource.completeOnboarding(),
    onException: (e) => CacheFailure('message'),
  );
}
