import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/features/auth/domain/usecases/complete_profile_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/logout_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final CompleteProfileUseCase _completeProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  AuthBloc({
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required CompleteProfileUseCase completeProfileUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _signInWithGoogleUseCase = signInWithGoogle,
       _signInWithEmailUseCase = signInWithEmailUseCase,
       _signUpWithEmailUseCase = signUpWithEmailUseCase,
       _completeProfileUseCase = completeProfileUseCase,
       _logoutUseCase = logoutUseCase,
       super(AuthInitial()) {
    on<SignInWithEmailRequested>(_onSignInWithEmail);
    on<SignUpWithEmailRequested>(_onSignUpWithEmail);
    on<SignInWithGoogleRequested>(_onGoogleSignIn);
    on<CompleteProfileRequested>(_onCompleteProfile);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signInWithEmailUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signUpWithEmailUseCase(
      SignUpParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        role: event.role,
        phoneNumber: event.phoneNumber,
        avatarUrl: event.avatarUrl,
        idCardUrl: event.idCardUrl,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onGoogleSignIn(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(withGoogle: true));

    final result = await _signInWithGoogleUseCase.call();

    result.fold((failure) => emit(AuthError(failure.message)), (data) {
      final (user) = data;
      emit(AuthSuccess(user: user));
    });
  }

  Future<void> _onCompleteProfile(
    CompleteProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _completeProfileUseCase.call(
      CompleteProfileParams(
        userId: event.userId,
        role: event.role,
        phoneNumber: event.phoneNumber,
        idCardPath: event.idCardPath,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await _logoutUseCase.call();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }
}
