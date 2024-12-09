import 'package:amathia/main.dart';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/provider/local_provider.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = supabase.auth.currentUser?.email;
    final localizations = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Text(
              localizations!.userProfile,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "$email",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),

            // Sezione Dark Mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizations.darkMode),
                Switch(
                  value: ref.watch(darkThemeProvider),
                  onChanged: (value) {
                    ref.watch(darkThemeProvider.notifier).toggleTheme();
                  },
                  activeColor: blue,
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Sezione Cambia lingua
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(localizations.selectLanguage),
                  DropdownButton<String>(
                    value: ref.read(localeProvider)?.languageCode ?? 'en',
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'it', child: Text('Italiano')),
                    ],
                    onChanged: (langCode) {
                      if (langCode != null) {
                        ref.read(localeProvider.notifier).setLocale(langCode);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cambio password
            TextButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecoveryPasswordPage()),
                );
              },
              child: Text(
                localizations.changePassword,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: blue,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout
            TextButton(
              onPressed: () async {
                try {
                  await supabase.auth.signOut();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);

                  Navigator.of(context).pushReplacementNamed('/login');
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unexpected error occurred')),
                  );
                }
              },
              child: Text(
                localizations.signOut,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: blue,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pulsante Cancella Account
            ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            localizations.deleteAccount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            localizations.warningDelete,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pulsante Conferma
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await supabase.auth.admin
                          .deleteUser(supabase.auth.currentUser!.id);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.of(context).pushReplacementNamed('/login');
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.unexpectedError),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: Text("ok"),
                ),
                const SizedBox(height: 10),
                // Pulsante Annulla
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(localizations.cancel),
                ),
              ],
            ),
          ],
        );
      },
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
  ),
  child: Text(
    localizations.deleteAccount,
    style: const TextStyle(color: Colors.white),
  ),
),

          ],
        ),
      ),
    );
  }
}
