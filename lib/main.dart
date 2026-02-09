import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:karaba/bloc_observer.dart';
import 'package:karaba/core/common/blocs/language_cubit/language_cubit.dart';
import 'package:karaba/core/common/blocs/user_cubit/user_cubit.dart';
import 'package:karaba/core/di/injection_container.dart';
import 'package:karaba/core/routes/app_router.dart';
import 'package:karaba/core/theme/theme.dart';
import 'package:karaba/features/onboarding/presentation/bloc/onboarding_bloc.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await init();

  FlutterNativeSplash.remove();

  Bloc.observer = AppBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      startLocale: sl<LanguageCubit>().state.locale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<UserCubit>()),
        BlocProvider.value(value: sl<OnboardingBloc>()),
        BlocProvider.value(value: sl<LanguageCubit>()),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Karaba',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) =>
              Theme(data: AppTheme.getTheme(context), child: child!),
          routerConfig: sl<AppRouter>().router,
        ),
      ),
    );
  }
}
