import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
          password: _passwordController.text.trim());
    } on AuthException catch (e) {
      setError(e);
    }
    if (erroreLogin == "") {
      Navigator.of(context).pushReplacementNamed('/homepage');
    } else {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Material(
      child: Form(
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
                        topRight: Radius.circular(30)),
                    color: isDarkTheme
                        ? colorScheme.surface
                        : colorScheme.background,
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
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Accedi per ',
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : colorScheme.onBackground),
                                ),
                                const TextSpan(
                                  text: 'goderti ',
                                  style: TextStyle(color: blue),
                                ),
                                TextSpan(
                                  text: 'la tua \n',
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : colorScheme.onBackground),
                                ),
                                const TextSpan(
                                  text: 'vacanza ',
                                  style: TextStyle(color: blue),
                                ),
                                TextSpan(
                                  text: 'in Salento ',
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : colorScheme.onBackground),
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
                                return 'La mail non può essere vuota';
                              } else if (!EmailValidator.validate(
                                  value.trim())) {
                                return 'la mail non è valida';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Inserisci la tua email',
                              prefixIcon: Icon(Icons.email,
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onBackground),
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
                                return 'La password non può essere vuota';
                              } else if (value.length < 8) {
                                return 'la password deve essere lunga almeno 8 caratteri';
                              } else if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'la password deve contenere una lettera maiuscola';
                              } else if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'la password deve contenere un numero';
                              } else if (!value
                                  .contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
                                return 'la password deve contenere un carattere speciale';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Inserisci la tua password',
                              prefixIcon: Icon(Icons.key,
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onBackground),
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
                                      : colorScheme.onBackground,
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
                            child: const Text(
                              'Non ricordi la tua password?',
                              textAlign: TextAlign.right,
                              style: TextStyle(
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              child: Text(
                                'Accedi',
                                style: TextStyle(fontSize: 18),
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
                                    : colorScheme.onBackground,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Non hai un account? ',
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : colorScheme.onBackground),
                                ),
                                TextSpan(
                                  text: 'Registrati ',
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
            )
          ],
        ),
      ),
    );
  }
}
