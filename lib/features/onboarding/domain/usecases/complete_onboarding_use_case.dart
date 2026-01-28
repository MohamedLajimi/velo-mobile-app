import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/core/usecase/use_case.dart';
import 'package:karaba/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase implements NoParamsUseCase<Unit> {
  final OnboardingRepository _onboardingRepository;

  const CompleteOnboardingUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  @override
  Future<Either<Failure, Unit>> call() =>
      _onboardingRepository.completeOnboarding();
}