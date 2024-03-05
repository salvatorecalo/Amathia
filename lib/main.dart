import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/home_page.dart';
import 'package:amathia/src/screens/home_page/pages/account_page/account_page.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:amathia/src/screens/onboard/onboard.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:amathia/src/screens/welcome_page/welcome_page.dart';
import 'package:amathia/src/theme/dark_theme_styles.dart';
import 'package:amathia/src/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Shared Preferiences
  isviewed = prefs.getInt('onBoard');
  // Supabase initialized
  await Supabase.initialize(
    url: 'https://yyiqjaekqhmdyxfcmgts.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5aXFqYWVrcWhtZHl4ZmNtZ3RzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg4OTY2ODksImV4cCI6MjAyNDQ3MjY4OX0.bg_SU8zQE9GeUAlqO4N68mKelzn-F27934gjeUAcs54',
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
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

@override
void initState() {
  super.initState();
  getCurrentAppTheme();
}

void getCurrentAppTheme() async {
  themeChangeProvider.darkTheme =
      await themeChangeProvider.darkThemePreference.getTheme();
}
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
          return themeChangeProvider;
        },
      child: Consumer<DarkThemeProvider>(
        builder: ((context, value, child) {
          return MaterialApp(
          title: 'Amathia',
          darkTheme: ThemeData.dark(),
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (_) => isviewed != 0 ? const OnBoard() : const WelcomePage(),
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
            '/recovery-password': (_) => RecoveryPasswordPage(),
            '/account': (_) => const AccountPage(),
            '/homepage': (_) => const HomePage(),
          },
        );
        }),
      ),
    );
  }
}