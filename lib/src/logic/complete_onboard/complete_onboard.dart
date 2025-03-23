import 'package:shared_preferences/shared_preferences.dart';

Future<bool> hasSeenOnBoard() async {
  final prefs = await SharedPreferences.getInstance();
  final onBoard = prefs.getInt('onBoard') ?? 1; // 1 = non visto, 0 = visto
  return onBoard == 0; // true = già visto, false = non visto
}

Future<void> setOnBoardComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('onBoard', 0); // 0 = completato
}
