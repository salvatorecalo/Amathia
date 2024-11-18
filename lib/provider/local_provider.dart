import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  // Carica la lingua salvata
  Future<void> loadLocalePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('locale');
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  // Cambia lingua e salva la preferenza
  Future<void> setLocale(String langCode) async {
    state = Locale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', langCode);
  }
}


final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>(
  (ref) => LocaleNotifier()..loadLocalePreference(),
);

