import 'package:amathia/src/costants/costants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                    child: Text(
                      "Un ultimo step per goderti la tua meritata vacanza in Salento",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: black,
                          height: 2,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {},
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
                        child: Text('Registrati', style: TextStyle(fontSize: 18),),
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
                      child: const Text('Continua senza registrarti', style: TextStyle(color: black),),
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
