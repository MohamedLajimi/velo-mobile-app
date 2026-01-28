import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/onboarding/domain/repositories/onboarding_repository.dart';

class CheckOnboardingStatusUseCase implements NoParamsUseCase<bool> {
  final OnboardingRepository _onboardingRepository;

  const CheckOnboardingStatusUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  @override
  Future<Either<Failure, bool>> call() =>
      _onboardingRepository.checkOnboardingStatus();
}
