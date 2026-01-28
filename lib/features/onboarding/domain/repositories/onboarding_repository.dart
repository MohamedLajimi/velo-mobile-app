import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/error/failure.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, bool>> checkOnboardingStatus();

  Future<Either<Failure, Unit>> completeOnboarding();
}