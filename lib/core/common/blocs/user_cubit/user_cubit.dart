import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/features/auth/domain/usecases/get_current_user_use_case.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  UserCubit({required GetCurrentUserUseCase getCurrentUserUseCase})
    : _getCurrentUserUseCase = getCurrentUserUseCase,
      super(UserInitial());

  UserEntity? get getCurrentUser =>
      state is UserAuthenticated ? (state as UserAuthenticated).user : null;

  Future<void> checkAuthStatus() async {
    emit(UserStatusCheck());

    final result = await _getCurrentUserUseCase.call();

    result.fold((failure) => emit(UserUnauthenticated()), (user) {
      if (user != null) {
        emit(UserAuthenticated(user));
      } else {
        emit(UserUnauthenticated());
      }
    });
  }

  void updateUser(UserEntity? user) {
    if (user == null) {
      emit(UserUnauthenticated());
    } else {
      emit(UserAuthenticated(user));
    }
  }
}
