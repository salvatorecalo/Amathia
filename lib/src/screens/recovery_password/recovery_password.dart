 import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/loginPage/login_page.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RecoveryPasswordPage extends StatefulWidget {
  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  bool _obsureText = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Image.asset(
            'images/recovery_password.png',
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
                                  text: 'Hai dimenticato la password? ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Nessun problema!\n',
                                  style: TextStyle(color: blue),
                                ),
                                TextSpan(
                                  text: 'Inserisci l’email associata al tuo account e ti invieremo le istruzioni per recuperare il tuo account.\n',
                                  style: TextStyle(color: Colors.black),
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
                              'Invia',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                       onPressed: () async {
                            Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                       child: Text("Torna alla pagina di login")
                       )
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
