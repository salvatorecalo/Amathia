import 'package:amathia/provider/styles.dart';
import 'package:amathia/src/logic/auth_guard/auth_guard.dart';
import 'package:amathia/src/logic/complete_onboard/complete_onboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/src/screens/onboard/onboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: const String.fromEnvironment('API_URL'),
    anonKey:
        const String.fromEnvironment('API_KEY'),
  );
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {

  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isLoading = true;
  String _initialRoute = "";
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future _initializeApp() async {
    try {
      final hasOnBoardView = await hasSeenOnBoard();
      if (hasOnBoardView) {
        _initialRoute = "/";
      } else {
        _initialRoute = '/onboard';
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false; // Terminato il caricamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(darkThemeProvider);

    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/': (_) => AuthGuard(),
        '/onboard': (_) => OnBoard(onComplete: setOnBoardComplete),
      },
      supportedLocales: [
        Locale('en'),
        Locale('it'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Seedlyn',
      theme: Styles.themeData(isDarkTheme, context),
      initialRoute: _initialRoute,
    );
  }
}
