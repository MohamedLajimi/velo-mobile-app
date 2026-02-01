import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/blocs/user_cubit/user_cubit.dart';
import 'package:karaba/core/common/widgets/app_snackbar.dart';
import 'package:karaba/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
    _checkUserStatus();
  }

  void _checkOnboardingStatus() {
    context.read<OnboardingBloc>().add(OnboardingCheckRequested());
  }

  void _checkUserStatus() {
    context.read<UserCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          AppSnackbar.show(
            context,
            message: context.tr(state.message),
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(body: const Center(child: CircularProgressIndicator())),
    );
  }
}
