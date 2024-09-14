import 'package:flutter/material.dart';

class LabelField extends StatelessWidget {
  final IconData icon;
  final String status;
  const LabelField({
    super.key,
    required this.icon,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(status),
      ],
    );
  }
}
