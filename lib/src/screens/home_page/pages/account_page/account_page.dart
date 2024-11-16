import 'package:amathia/main.dart';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/provider/local_provider.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = supabase.auth.currentUser?.email;
    final localizations = AppLocalizations.of(context);
    Future<void> signOut(WidgetRef ref) async {
      try {
        await supabase.auth.signOut();
        final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // false indica che il login è stato completato
        ref
            .read(localeProvider.notifier)
            .setLocale('en'); // Reset locale if needed
        Navigator.of(context).pushReplacementNamed('/login');
      } on AuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unexpected error occurred')),
        );
      }
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Text(
              localizations!.userProfile,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "$email",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.darkMode),
              Switch(
                value: ref.watch(darkThemeProvider),
                onChanged: (value) {
                  ref.read(darkThemeProvider.notifier).toggleTheme();
                },
                activeColor: blue,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizations.selectLanguage),
                DropdownButton<String>(
                  value: ref.watch(localeProvider)?.languageCode,
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
          TextButton(
            onPressed: () => signOut(ref),
            child: Text(
              localizations.signOut,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: blue,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 99, 21, 225)),
            label: Text(
              localizations.seeOnGithub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: white,
              ),
            ),
            onPressed: () async {
              await launchUrl(
                  Uri.parse('https://github.com/salvatorecalo/Amathia'));
            },
          ),
        ],
      ),
    );
  }
}
