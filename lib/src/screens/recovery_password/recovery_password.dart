import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  late final TextEditingController _emailController = TextEditingController();

  Future<void> _showMyDialog() async {
    late final String email = _emailController.text;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Text('Istruzioni inviate',
              style: TextStyle(color: colorScheme.onSurface)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Abbiamo inviato una mail con le istruzioni per il recupero password a $email',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ok', style: TextStyle(color: colorScheme.primary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Material(
      child: Stack(
        children: [
          Image.asset(
            'assets/recovery_password.png',
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
                  color: isDarkTheme
                      ? colorScheme.surface
                      : colorScheme.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                                text: 'Hai dimenticato la password? ',
                                style: TextStyle(
                                    color: isDarkTheme
                                        ? colorScheme.onSurface
                                        : Colors.black),
                              ),
                              const TextSpan(
                                text: 'Nessun problema!\n',
                                style: TextStyle(color: blue),
                              ),
                              TextSpan(
                                text:
                                    'Inserisci l’email associata al tuo account e ti invieremo le istruzioni per recuperare il tuo account.\n',
                                style: TextStyle(
                                    color: isDarkTheme
                                        ? colorScheme.onSurface
                                        : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La mail non può essere vuota';
                            } else if (!EmailValidator.validate(value)) {
                              return 'La mail non è valida reinseriscila.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Inserisci la tua email',
                            errorText: _emailController.text != ""
                                ? "La mail non è valida, reinseriscila"
                                : null,
                            prefixIcon: Icon(Icons.email,
                                color: isDarkTheme
                                    ? colorScheme.onSurface
                                    : colorScheme.onBackground),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            await supabase.auth
                                .resetPasswordForEmail(_emailController.text);
                            _showMyDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            foregroundColor: Colors.white,
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            child: Text(
                              'Invia',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Torna alla pagina di login",
                          style: TextStyle(
                            color: blue,
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
    );
  }
}
