part of 'auth_bloc.dart';

enum AuthLoadingType { signIn, signUp, google, logout }

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final AuthLoadingType type;

  const AuthLoading({required this.type});

  @override
  List<Object?> get props => [type];

  bool get isSignIn => type == AuthLoadingType.signIn;
  bool get isSignUp => type == AuthLoadingType.signUp;
  bool get isGoogle => type == AuthLoadingType.google;
  bool get isLogout => type == AuthLoadingType.logout;
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  final bool unfinishedProfile;

  const AuthSuccess({required this.user, required this.unfinishedProfile});

  @override
  List<Object?> get props => [user, unfinishedProfile];
}
