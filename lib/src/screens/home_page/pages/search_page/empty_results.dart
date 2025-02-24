import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyResult extends StatelessWidget {
  const EmptyResult({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/no_result.webp',
          width: 300,
        ),
        Text(
          localizations!.resultEmpty,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
