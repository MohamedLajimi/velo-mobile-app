import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:karaba/core/common/blocs/language_cubit/language_cubit.dart';
import 'package:karaba/core/routes/app_router.dart';
import 'package:karaba/core/services/media_service.dart';
import 'package:karaba/core/services/permission_service.dart';
import 'package:karaba/core/services/storage_service.dart';
import 'package:karaba/env_config.dart';
import 'package:karaba/features/auth/auth_injection.dart';
import 'package:karaba/features/onboarding/onboarding_injection.dart';
import 'package:karaba/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Future.wait([
    dotenv.load(fileName: ".env"),
    EasyLocalization.ensureInitialized(),
    SharedPreferences.getInstance().then(
      (prefs) => sl.registerLazySingleton(() => prefs),
    ),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  sl.registerLazySingleton(() => Supabase.instance.client);

  await GoogleSignIn.instance.initialize(
    serverClientId: EnvConfig.serverClientId,
  );

  sl.registerLazySingleton(() => StorageService(supabaseClient: sl()));

  sl.registerLazySingleton(() => LanguageCubit(sharedPreferences: sl()));

    sl.registerLazySingleton<PermissionService>(
    () => PermissionServiceImpl(),
  );
  
  sl.registerLazySingleton<MediaService>(
    () => MediaServiceImpl(permissionService: sl()),
  );

  initOnboarding(sl);

  initAuth(sl);

  sl.registerLazySingleton(
    () => AppRouter(userCubit: sl(), onboardingBloc: sl()),
  );
}
