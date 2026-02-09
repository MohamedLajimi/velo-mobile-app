part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithGoogleRequested extends AuthEvent {}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final UserRole role;
  final String phoneNumber;
  final String? avatarUrl;
  final String idCardUrl;

  const SignUpWithEmailRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.idCardUrl,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    role,
    phoneNumber,
    avatarUrl,
    idCardUrl,
  ];
}

class CompleteProfileRequested extends AuthEvent {
  final String userId;
  final String phoneNumber;
  final UserRole role;
  final String idCardPath;

  const CompleteProfileRequested({
    required this.userId,
    required this.phoneNumber,
    required this.role,
    required this.idCardPath,
  });

  @override
  List<Object?> get props => [phoneNumber, role, idCardPath];
}

class LogoutRequested extends AuthEvent {}
