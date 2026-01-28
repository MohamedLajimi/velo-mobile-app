import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingLocalDataSource {
  Future<bool> checkOnboardingStatus();

  Future<Unit> completeOnboarding();
}

class OnboardingLocalDataSourceImp implements OnboardingLocalDataSource {
  final SharedPreferences _sharedPreferences;

  const OnboardingLocalDataSourceImp({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  static const String _onboardingKey = 'onboarding_status';

  @override
  Future<bool> checkOnboardingStatus() async =>
      _sharedPreferences.getBool(_onboardingKey) ?? false;

  @override
  Future<Unit> completeOnboarding() async {
    await _sharedPreferences.setBool(_onboardingKey, true);
    return unit;
  }
}
