import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/register_page/register_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'images/relax_post_onboard.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: 500,
          alignment: Alignment.center,
        ),
        SizedBox(
          height: double.infinity,
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.5,
            widthFactor: 1,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Un ultimo step per ',
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
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      style: ElevatedButton.styleFrom(
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
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: null,
                      child: const Text(
                        'Continua senza registrarti',
                        style: TextStyle(color: black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
