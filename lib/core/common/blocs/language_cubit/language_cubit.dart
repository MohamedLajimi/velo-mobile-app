import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final SharedPreferences _sharedPreferences;

  static const String _languageKey = 'language_code';
  static const String _defaultLanguage = 'fr';
  LanguageCubit({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences,
      super(LanguageState(locale: Locale(_defaultLanguage))) {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLanguage = _sharedPreferences.getString(_languageKey);
    if (savedLanguage != null) {
      emit(LanguageState(locale: Locale(savedLanguage)));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    await _sharedPreferences.setString(_languageKey, locale.languageCode);
    emit(LanguageState(locale: locale));
  }

  String get currentLanguageCode => state.locale.languageCode;
}
