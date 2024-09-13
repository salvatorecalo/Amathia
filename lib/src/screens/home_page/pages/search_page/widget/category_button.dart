import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_screen.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Color colore;
  final IconData icon;
  final String text;
  final String title;
  final String type;

  const CategoryButton({
    super.key,
    required this.colore,
    required this.icon,
    required this.text,
    required this.title, 
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colore,
          ),
          width: 150,
          height: 60,
          child: IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(
                    bgcolor: colore,
                    category: title,
                    type: type,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}