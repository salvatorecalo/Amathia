import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends StateNotifier<Locale?> {
  LocaleProvider() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    state = languageCode != null ? Locale(languageCode) : Locale('en');
  }

  Future<void> setLocale(String langCode) async {
    state = Locale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', langCode);
  }
}

// Provider
final localeProvider = StateNotifierProvider<LocaleProvider, Locale?>((ref) {
  return LocaleProvider();
});
