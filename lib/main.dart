import 'package:amathia/provider/local_provider.dart';
import 'package:amathia/provider/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/src/screens/home_page/home_page.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:amathia/src/screens/onboard/onboard.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://eyjclibhojxnqhnbjzpe.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV5amNsaWJob2p4bnFobmJqenBlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5NzEzODgsImV4cCI6MjA0NTU0NzM4OH0.3jtNX80khX3Spe2olFRPzNL7lE5oSKMaCHFMBUz7IVo", // La tua chiave anonima
  );

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userId = supabase.auth.currentUser?.id;
  runApp(
    ProviderScope(
      child: MyApp(isLoggedIn: isLoggedIn, userId: userId ?? ''),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool isLoggedIn;
  final String userId;

  const MyApp({super.key, required this.isLoggedIn, required this.userId});

  Future<bool> getOnBoardViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnBoardViewed = prefs.getInt('onBoard');
    if (isOnBoardViewed == null) {
      await prefs.setInt('onBoard', 1); // 1 means "not viewed"
      return false;
    }
    return isOnBoardViewed == 0; // 0 means "already viewed"
  }

  Future<void> setOnBoardComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', 0); // 0 means "completed"
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider) ?? const Locale('en');
    final isDarkTheme = ref.watch(darkThemeProvider);

    return FutureBuilder<bool>(
      future: getOnBoardViewed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error loading onboarding: ${snapshot.error}'),
              ),
            ),
          );
        } else {
          final hasViewedOnBoard = snapshot.data ?? false;

          return MaterialApp(
            title: 'Amathia',
            locale: locale,
            theme: Styles.themeData(isDarkTheme, context),
            debugShowCheckedModeBanner: false,
            initialRoute: hasViewedOnBoard
                ? (isLoggedIn ? '/homepage' : '/onboard')
                : '/onboard',
            routes: {
              '/onboard': (_) => OnBoard(
                    onComplete: setOnBoardComplete,
                  ),
              '/login': (_) => const LoginPage(),
              '/homepage': (_) => HomePage(userId: userId),
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
      },
    );
  }
}
