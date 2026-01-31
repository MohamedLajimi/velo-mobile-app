part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserStatusCheck extends UserState{}

class UserAuthenticated extends UserState {
  final UserEntity user;
  const UserAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class UserUnauthenticated extends UserState {}
