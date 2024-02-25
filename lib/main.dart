import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/onboard/onboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}
int? isviewed;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amathia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        textTheme: GoogleFonts.interTextTheme(
           Theme.of(context).textTheme,
      ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: isviewed != 0 ? const OnBoard() : const Text("Home"),
    );
  }
}