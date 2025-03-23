import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/logic/user_logic/user_logic.dart';
import 'package:amathia/src/logic/user_logic/user_provider.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errorMessage = "";

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = "";
    });

    final authController = ref.read(authControllerProvider);

    final error = await authController.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (error == null) {
      ref.invalidate(authStateProvider); // Aggiorna subito la sessione
    } else {
      setState(() {
        _errorMessage = error;
      });
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.error,
          title: Text(
            "Error",
            style: TextStyle(color: colorScheme.onError),
          ),
          content: Text(
            _errorMessage,
            style: TextStyle(color: colorScheme.onError),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: colorScheme.onError),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/smiling-young-friends-taking-selfie-cellphone.webp',
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: 300,
                  alignment: Alignment.center,
                ),
                FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.8,
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: isDarkTheme ? colorScheme.surface : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          // Testo di benvenuto
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              localizations.loginText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),

                          // Email
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: _emailController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return localizations.mailEmpty;
                                } else if (!EmailValidator.validate(value.trim())) {
                                  return localizations.mailInvalid;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: localizations.enterMail,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),

                          // Password
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: _passwordController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localizations.passwordEmpty;
                                } else if (value.length < 8 || value.length > 72) {
                                  return localizations.passwordShort;
                                } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return localizations.passwordUpperCharacter;
                                } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return localizations.passwordNumberCharacter;
                                } else if (!RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(value)) {
                                  return localizations.passwordSpecialCharacter;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: localizations.enterPassword,
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: colorScheme.onSurface,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() => _obscureText = !_obscureText);
                                  },
                                  child: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Password Dimenticata
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RecoveryPasswordPage()),
                                );
                              },
                              child: Text(
                                localizations.passwordLost,
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),

                          // Bottone Login
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _signIn();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(localizations.loginText, style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                          ),

                          // Registrazione
                    // Registrazione
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: colorScheme.onSurface), // Stile di default
                          children: [
                            TextSpan(
                              text: localizations.dontHaveAnAccount,
                            ),
                            TextSpan(
                              text: localizations.registerNow,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                )
                ),
                )],
            ),
          ),
        ),
      ),
    );
  }
}
