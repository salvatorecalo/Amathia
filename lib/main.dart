import 'package:amathia/provider/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/provider/local_provider.dart';
import 'package:amathia/src/screens/home_page/home_page.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:amathia/src/screens/onboard/onboard.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: const String.fromEnvironment('API_URL'),
    anonKey: const String.fromEnvironment('API_KEY'),
  );

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Ottieni il userId dall'utente autenticato
  final userId = supabase.auth.currentUser?.id;

  runApp(
    ProviderScope(
      child: MyApp(isLoggedIn: isLoggedIn, userId: userId ?? ''),  // Assicurati di passare l'userId
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool isLoggedIn;
  final String userId;  // Aggiungi userId come parametro

  const MyApp({super.key, required this.isLoggedIn, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider) ?? const Locale('en'); // Usa localeProvider
    final isDarkTheme = ref.watch(darkThemeProvider);

    return MaterialApp(
      title: 'Amathia',
      locale: locale,
      theme: Styles.themeData(isDarkTheme, context),
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/homepage' : '/',
      routes: {
        '/': (_) => const OnBoard(),
        '/login': (_) => const LoginPage(),
        '/homepage': (_) => HomePage(userId: userId),  // Passa l'userId a HomePage
      },
      supportedLocales: const [
        Locale('en'),
        Locale('it'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
