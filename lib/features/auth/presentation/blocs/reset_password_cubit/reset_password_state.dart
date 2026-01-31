part of 'reset_password_cubit.dart';

enum ResetPasswordStatus { initial, loading, success, error }

class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;
  final String? errorMessage;
  final int resendCountdown;
  final bool isResending;

  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
    this.resendCountdown = 0,
    this.isResending = false,
  });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? errorMessage,
    int? resendCountdown,
    bool? isResending,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      isResending: isResending ?? this.isResending,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    resendCountdown,
    isResending,
  ];
}
