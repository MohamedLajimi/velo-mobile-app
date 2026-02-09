part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final bool withGoogle;

  const AuthLoading({this.withGoogle = false});

  @override
  List<Object?> get props => [withGoogle];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}
