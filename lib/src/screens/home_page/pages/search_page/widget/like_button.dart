import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key? key,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool cliked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
          splashRadius: 1,
          onPressed: () {
            try {
              setState(() {
                cliked = !cliked;
              });
            } catch (e) {
              print(e.toString());
            }
          },
          color: Colors.red,
          icon: Icon(
            cliked ? Icons.favorite : Icons.favorite_border,
          )),
    );
  }
}