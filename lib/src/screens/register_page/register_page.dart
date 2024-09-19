import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obsureText = true;
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _retypePasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String erroreLogin = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    Future<String> setError(e) async {
      erroreLogin = e.statusCode;
      if (e.statusCode == "400") {
        erroreLogin =
            localizations!.alreadyHaveAnAccountError;
      } else if (e.statusCode == '429') {
        erroreLogin = localizations!.tooManyRequests;
      } else if (e.statusCode == '500') {
        erroreLogin = localizations!.serverError;
      }
      return erroreLogin;
    }

    Future<void> signUpNewUser() async {
    try {
      await supabase.auth.signUp(
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


    return Material(
      child: Form(
        key: _formKey,
        child: Stack(
          children: [
            Image.asset(
              'assets/esperienze_register_page.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: 300,
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
                    color: isDarkTheme ? colorScheme.surface : white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                color: isDarkTheme
                                    ? colorScheme.onSurface
                                    : Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: localizations!.registerText2,
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : Colors.black),
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
                                          : Colors.black),
                                ),
                                TextSpan(
                                  text: localizations.loginText4,
                                  style: const TextStyle(color: blue),
                                ),
                                TextSpan(
                                  text: localizations.loginText5,
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return  localizations.mailEmpty;
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
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
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
                                // contiene una lettera maiuscola
                                return localizations.passwordUpperCharacter;
                              } else if (!value.contains(RegExp(r'[0-9]'))) {
                                // contiene un numero
                                return localizations.passwordNumberCharacter;
                              } else if (!value
                                  .contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
                                return localizations.passwordSpecialCharacter;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: localizations.enterPassword,
                              prefixIcon: Icon(Icons.key,
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : Colors.black),
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
                                        : Colors.black),
                              ),
                            ),
                            obscureText: _obsureText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: TextFormField(
                            controller: _retypePasswordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.passwordEmpty;
                              } else if (value != _passwordController.text) {
                                return localizations.passwordDoesNotMatch;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: localizations.retypePassword,
                              prefixIcon: Icon(Icons.key,
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : Colors.black),
                            ),
                            obscureText: _obsureText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: localizations.termsText1,
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? colorScheme.onSurface
                                          : Colors.black),
                                ),
                                TextSpan(
                                  text: localizations.termsText2,
                                  style: const TextStyle(color: blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                signUpNewUser();
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
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              child: Text(
                                localizations.registerText,
                                style:const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                color: isDarkTheme
                                    ? colorScheme.onSurface
                                    : Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Hai già un account? ',
                                ),
                                TextSpan(
                                  text: localizations.loginText,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
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
    );
  }
}
