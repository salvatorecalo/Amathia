import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeNotifier extends StateNotifier<bool> {
  DarkThemeNotifier() : super(false);

  // Leggi il tema salvato al momento dell'avvio
  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkTheme') ?? false; // Imposta il tema salvato
  }

  // Cambia tema e salva la preferenza
  Future<void> toggleTheme() async {
    state = !state; // Inverti il tema
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', state); // Salva il tema
  }
}


final darkThemeProvider = StateNotifierProvider<DarkThemeNotifier, bool>(
  (ref) => DarkThemeNotifier()..loadThemePreference(),
);

