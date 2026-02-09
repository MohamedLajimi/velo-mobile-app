import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/blocs/user_cubit/user_cubit.dart';
import 'package:karaba/core/common/widgets/custom_avatar.dart';
import 'package:karaba/core/common/widgets/custom_filled_button.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';

class HomeTest extends StatelessWidget {
  const HomeTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomAvatar(
          imageUrl: context.read<UserCubit>().getCurrentUser!.avatarUrl,
        ),
        title: Text(context.read<UserCubit>().getCurrentUser!.fullName),
      ),
      body: Column(
        children: [
          BlocSelector<AuthBloc, AuthState, bool>(
            selector: (state) {
              return state is AuthLoading;
            },
            builder: (context, isLoading) {
              return CustomFilledButton(
                text: 'logout',
                isLoading: isLoading,
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
