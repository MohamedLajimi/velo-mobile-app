import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/features/onboarding/domain/usecases/check_onboarding_status_use_case.dart';
import 'package:karaba/features/onboarding/domain/usecases/complete_onboarding_use_case.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingStatusUseCase _checkStatus;
  final CompleteOnboardingUseCase _completeOnboarding;
  OnboardingBloc({
    required CheckOnboardingStatusUseCase checkStatus,
    required CompleteOnboardingUseCase completeOnboarding,
  }) : _checkStatus = checkStatus,
       _completeOnboarding = completeOnboarding,
       super(OnboardingInitial()) {
    on<OnboardingCheckRequested>(_onCheckRequested);
    on<OnboardingFinished>(_onFinished);
  }

  Future<void> _onCheckRequested(
    OnboardingCheckRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final result = await _checkStatus();

    result.fold(
      (failure) => emit(OnboardingCompleted()),
      (hasCompleted) => hasCompleted
          ? emit(OnboardingCompleted())
          : emit(OnboardingRequired()),
    );
  }

  Future<void> _onFinished(
    OnboardingFinished event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboarding();
    emit(OnboardingCompleted());
  }
}
