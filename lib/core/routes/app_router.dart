import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaba/core/common/blocs/user_cubit/user_cubit.dart';
import 'package:karaba/core/common/widgets/root_screen.dart';
import 'package:karaba/core/routes/go_router_refresh_stream.dart';
import 'package:karaba/features/auth/presentation/routes/auth_routes.dart';
import 'package:karaba/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:karaba/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  final UserCubit userCubit;
  final OnboardingBloc onboardingBloc;

  AppRouter({required this.userCubit, required this.onboardingBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: Listenable.merge([
      GoRouterRefreshStream(userCubit.stream),
      GoRouterRefreshStream(onboardingBloc.stream),
    ]),
    redirect: (context, state) {
      final userState = userCubit.state;
      final onboardingState = onboardingBloc.state;

      final isOnOnboardingPage = state.matchedLocation == '/onboarding';
      final isOnLoginPage =
          state.matchedLocation.startsWith('/signin') ||
          state.matchedLocation.startsWith('/signup');
      final isOnRootPage = state.matchedLocation == '/';
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (onboardingState is OnboardingRequired && !isOnOnboardingPage) {
        return '/onboarding';
      }

      if (onboardingState is OnboardingCompleted ||
          onboardingState is! OnboardingRequired) {
        if (userState is UserStatusCheck || userState is UserInitial) {
          return isOnRootPage ? null : '/';
        }

        if ((userState is UserUnauthenticated || userState is UserError) &&
            !isAuthRoute) {
          return isOnLoginPage ? null : AuthRoutes.loginPath;
        }

        if (userState is UserAuthenticated) {
          if (isOnRootPage || isOnLoginPage) {
            return '/home';
          }
        }
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const RootScreen()),

      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      ...AuthRoutes.routes,
    ],
  );
}
