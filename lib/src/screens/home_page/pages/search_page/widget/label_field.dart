import 'package:flutter/material.dart';

class LabelField extends StatelessWidget {
  final IconData icon;
  final String status;
  const LabelField({
    Key? key,
    required this.icon,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
        ),
        SizedBox(
          width: 5,
        ),
        Text(status),
      ],
    );
  }
}