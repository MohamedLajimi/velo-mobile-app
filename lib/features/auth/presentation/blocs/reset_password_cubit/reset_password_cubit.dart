import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/features/auth/domain/usecases/reset_password_use_case.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;
  Timer? _timer;
  ResetPasswordCubit({required ResetPasswordUseCase resetPasswordUseCase})
    : _resetPasswordUseCase = resetPasswordUseCase,
      super(const ResetPasswordState());

  Future<void> sendResetLink(String email) async {
    if (email.isEmpty) return;

    if (state.status == ResetPasswordStatus.success) {
      emit(state.copyWith(isResending: true));
    } else {
      emit(state.copyWith(status: ResetPasswordStatus.loading));
    }

    final result = await _resetPasswordUseCase.call(email);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ResetPasswordStatus.error,
          errorMessage: failure.message,
          isResending: false,
        ),
      ),
      (_) {
        _startResendTimer();
      },
    );
  }

  void _startResendTimer() {
    _timer?.cancel();
    emit(
      state.copyWith(
        status: ResetPasswordStatus.success,
        isResending: false,
        resendCountdown: 60,
      ),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown > 0) {
        emit(state.copyWith(resendCountdown: state.resendCountdown - 1));
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
