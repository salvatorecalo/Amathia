// Import necessario per controllare la connessione
import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String erroreLogin = "";
  bool _obsureText = true;
  bool hasInternet = true; // Variabile per tracciare lo stato della connessione

  Future<String> setError(e) async {
    erroreLogin = e.statusCode;
    if (e.statusCode == "400") {
      erroreLogin = "Credenziali Invalide, ricontrolla e riprova";
    }
    return erroreLogin;
  }

  Future<void> signIn() async {
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on AuthException catch (e) {
      setError(e);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // false indica che il login è stato completato
    if (erroreLogin == "") {
      Navigator.of(context).pushReplacementNamed('/homepage');
    } else {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          return AlertDialog(
            backgroundColor: colorScheme.error,
            title: Text(
              'Errore',
              style: TextStyle(color: colorScheme.onError),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    erroreLogin,
                    style: TextStyle(color: colorScheme.onError),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'ok',
                  style: TextStyle(color: colorScheme.onError),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    return Material(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Image.asset(
                'assets/smiling-young-friends-taking-selfie-cellphone.jpg',
                fit: BoxFit.fitHeight,
                width: double.infinity,
                height: 350,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: double.infinity,
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.8,
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: isDarkTheme
                          ? colorScheme.surface
                          : colorScheme.surface,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style:
                                    const TextStyle(height: 1.5, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: localizations!.loginText1,
                                    style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : colorScheme.onSurface,
                                    ),
                                  ),
                                  TextSpan(
                                    text: localizations.loginText2,
                                    style: const TextStyle(color: blue),
                                  ),
                                  TextSpan(
                                    text: localizations.loginText3,
                                    style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : colorScheme.onSurface,
                                    ),
                                  ),
                                  TextSpan(
                                    text: localizations.loginText4,
                                    style: const TextStyle(color: blue),
                                  ),
                                  TextSpan(
                                    text: localizations.loginText5,
                                    style:
                                        TextStyle(color: colorScheme.onSurface),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            child: TextFormField(
                              controller: _emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return localizations.mailEmpty;
                                } else if (!EmailValidator.validate(
                                    value.trim())) {
                                  return localizations.mailInvalid;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: localizations.enterMail,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            child: TextFormField(
                              controller: _passwordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localizations.passwordEmpty;
                                } else if (value.length < 8) {
                                  return localizations.passwordShort;
                                } else if (!value.contains(RegExp(r'[A-Z]'))) {
                                  return localizations.passwordUpperCharacter;
                                } else if (!value.contains(RegExp(r'[0-9]'))) {
                                  return localizations.passwordNumberCharacter;
                                } else if (!value.contains(
                                    RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
                                  return localizations.passwordSpecialCharacter;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: localizations.enterPassword,
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() => _obsureText = !_obsureText);
                                  },
                                  child: Icon(
                                    _obsureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: isDarkTheme
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              obscureText: _obsureText,
                            ),
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RecoveryPasswordPage()),
                                );
                              },
                              child: Text(
                                localizations.passwordLost,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  signIn();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                                foregroundColor: white,
                                backgroundColor: blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                                child: Text(
                                  localizations.loginText,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 16,
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface,
                                ),
                                children: [
                                  TextSpan(
                                    text: localizations.dontHaveAnAccount,
                                    style: TextStyle(
                                        color: isDarkTheme
                                            ? colorScheme.onSurface
                                            : colorScheme.onSurface),
                                  ),
                                  TextSpan(
                                    text: localizations.registerText,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                    style: const TextStyle(color: blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
