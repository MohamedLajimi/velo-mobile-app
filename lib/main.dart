import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:karaba/core/di/injection_container.dart';
import 'package:karaba/core/theme/theme.dart';
import 'package:karaba/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:karaba/features/onboarding/presentation/screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await init();

  FlutterNativeSplash.remove();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karaba',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) =>
          Theme(data: AppTheme.getTheme(context), child: child!),
      home: BlocProvider(
        create: (context) => sl<OnboardingBloc>(),
        child: const OnboardingScreen(),
      ),
    );
  }
}
