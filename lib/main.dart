import 'package:amathia/src/screens/home_page/home_page.dart';
import 'package:amathia/src/screens/home_page/pages/account_page/account_page.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/favorite_page.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:amathia/src/screens/onboard/onboard.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:amathia/src/theme/dark_theme_styles.dart';
import 'package:amathia/src/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:amathia/src/theme/favorite_provider.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

  await Supabase.initialize(
    url: const String.fromEnvironment('API_URL'),
    anonKey: const String.fromEnvironment('API_KEY'),
  );
  runApp(const MyApp());
}

int? isviewed;
bool isSwitched = false;
final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // Metodo statico per cambiare la lingua
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Amathia',
            theme: Styles.themeData(themeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            locale: _locale, 
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
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (_) => isviewed != 0 ? const OnBoard() : const LoginPage(),
              '/login': (_) => const LoginPage(),
              '/register': (_) => const RegisterPage(),
              '/recovery-password': (_) => const RecoveryPasswordPage(),
              '/account': (_) => const AccountPage(),
              '/homepage': (_) => const HomePage(),
              '/favorite': (_) => const FavoritePage(),
            },
          );
        },
      ),
    );
  }
}
