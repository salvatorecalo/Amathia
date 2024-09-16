import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/login_page/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<String> setError(e) async {
    erroreLogin = e.statusCode;
    if (e.statusCode == "400") {
      erroreLogin =
          "Account già esistente, effettua l'accesso con questo account";
    } else if (e.statusCode == "401") {
      erroreLogin = "Questo indirizzo email nonè associato a nessun account";
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
          return AlertDialog(
            backgroundColor: Colors.red,
            title: const Text(
              'Errore',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    erroreLogin,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'ok',
                  style: TextStyle(color: Colors.white),
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Registrati per ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'goderti ',
                                  style: TextStyle(color: blue),
                                ),
                                TextSpan(
                                  text: 'la tua \n',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'vacanza ',
                                  style: TextStyle(color: blue),
                                ),
                                TextSpan(
                                  text: 'in Salento ',
                                  style: TextStyle(color: black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: TextFormField(
                            controller: _emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La mail non può essere vuota';
                              } else if (!EmailValidator.validate(
                                  value.trim())) {
                                return 'la mail non è valida';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Inserisci la tua email',
                                prefixIcon: Icon(Icons.email)),
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
                                return 'La password non può essere vuota';
                              } else if (value.length < 8) {
                                return 'la password deve essere lunga almeno 8 caratteri';
                              } else if (!value.contains(RegExp(r'[A-Z]'))) {
                                // contiene una lettera maiuscola
                                return 'la password deve contenere una lettera maiuscola';
                              } else if (!value.contains(RegExp(r'[0-9]'))) {
                                // contiene una lettera maiuscola
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
                              prefixIcon: const Icon(Icons.key),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() => _obsureText = !_obsureText);
                                },
                                child: Icon(_obsureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
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
                                return 'La password non può essere vuota';
                              } else if (value != _passwordController.text) {
                                return 'le password non coincidono';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Ripeti la tua password',
                              prefixIcon: Icon(Icons.key),
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
                                const TextSpan(
                                  text: 'Creando un account, accetti i nostri ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Termini di Servizio',
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
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              child: Text(
                                'Registrati',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                height: 1.5,
                                fontSize: 16,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Hai già un account? ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Accedi ',
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
            )
          ],
        ),
      ),
    );
  }
}
