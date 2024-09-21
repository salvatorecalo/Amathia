import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeProvider extends StateNotifier<bool> {
  DarkThemeProvider() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkTheme') ?? false;
  }

  Future<void> toggleTheme() async {
    state = !state; // Inverti il tema
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', state); // Salva il tema
  }
}

// Provider
final darkThemeProvider = StateNotifierProvider<DarkThemeProvider, bool>((ref) {
  return DarkThemeProvider();
});
