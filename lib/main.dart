import 'package:amathia/provider/local_provider.dart';
import 'package:amathia/provider/styles.dart';
import 'package:amathia/src/screens/home_page/pages/account_page/account_page.dart';
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
    url: const String.fromEnvironment('API_URL'),
    anonKey:
        const String.fromEnvironment('API_KEY'),
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

class MyApp extends ConsumerStatefulWidget {
  final bool isLoggedIn;
  final String userId;

  const MyApp({super.key, required this.isLoggedIn, required this.userId});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late String _initialRoute; // Stato per la rotta iniziale
  bool _isLoading = true; // Stato per il caricamento iniziale

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final hasSeenOnBoard = await _hasSeenOnBoard();
      if (hasSeenOnBoard) {
        _initialRoute = widget.isLoggedIn ? '/homepage' : '/login';
      } else {
        _initialRoute = '/onboard';
      }
    } catch (e) {
      _initialRoute = '/login'; // Valore di fallback
    } finally {
      setState(() {
        _isLoading = false; // Terminato il caricamento
      });
    }
  }

  Future<bool> _hasSeenOnBoard() async {
    final prefs = await SharedPreferences.getInstance();
    final onBoard = prefs.getInt('onBoard') ?? 1; // 1 = non visto, 0 = visto
    return onBoard == 0; // true = già visto, false = non visto
  }

  Future<void> _setOnBoardComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', 0); // 0 = completato
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider) ?? const Locale('en');
    final isDarkTheme = ref.watch(darkThemeProvider);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return MaterialApp(
      title: 'Amathia',
      locale: locale,
      theme: Styles.themeData(isDarkTheme, context),
      debugShowCheckedModeBanner: false,
      initialRoute: _initialRoute, // Utilizza la rotta calcolata
      routes: {
        '/login': (_) => const LoginPage(),
        '/onboard': (_) => OnBoard(onComplete: _setOnBoardComplete),
        '/homepage': (_) => HomePage(userId: widget.userId),
        '/account': (_) => AccountPage(),
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
