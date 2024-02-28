import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/account_page/account_page.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:amathia/src/screens/onboard/onboard.dart';
import 'package:amathia/src/screens/welcome_page/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amathia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        textTheme: GoogleFonts.interTextTheme(
           Theme.of(context).textTheme,
      ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: isviewed != 0 ? const OnBoard() : const WelcomePage(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => isviewed != 0 ? const OnBoard() : const WelcomePage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
      },
    );
  }
}