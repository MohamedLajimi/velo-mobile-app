import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:karaba/core/di/injection_container.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:karaba/features/auth/presentation/blocs/reset_password_cubit/reset_password_cubit.dart';
import 'package:karaba/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:karaba/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:karaba/features/auth/presentation/screens/sign_up_screen.dart';

class AuthRoutes {
  static const String loginName = 'signin';
  static const String loginPath = '/auth/signin';
  static const String signupName = 'signup';
  static const String signupPath = '/auth/signup';
  static const String resetPasswordName = 'reset-password';
  static const String resetPasswordPath = '/auth/reset-password';

  static List<RouteBase> routes = [
    GoRoute(
      name: loginName,
      path: loginPath,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthBloc>(),
        child: const SignInScreen(),
      ),
    ),
    GoRoute(
      name: signupName,
      path: signupPath,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthBloc>(),
        child: const SignUpScreen(),
      ),
    ),
    GoRoute(
      name: resetPasswordName,
      path: resetPasswordPath,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<ResetPasswordCubit>(),
        child: const ResetPasswordScreen(),
      ),
    ),
  ];
}
