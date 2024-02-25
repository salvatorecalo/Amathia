import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/recovery_password/recovery_password.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obsureText = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Image.asset(
            'images/smiling-young-friends-taking-selfie-cellphone.jpg',
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
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: RichText(
                        textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                height: 1.5,
                               fontSize: 16,
                               ),
                              children: [
                                TextSpan(
                                  text: 'Accedi per ',
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
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci la tua email',
                              prefixIcon: Icon(Icons.email)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextField(
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
                      SizedBox(
                            width: double.maxFinite,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecoveryPasswordPage()),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(40),
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
                              style: const TextStyle(
                                height: 1.5,
                               fontSize: 16,
                               ),
                              children: [
                                const TextSpan(
                                  text: 'Non hai un account? ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Registrati ',
                                  recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()),
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
    );
  }
}
