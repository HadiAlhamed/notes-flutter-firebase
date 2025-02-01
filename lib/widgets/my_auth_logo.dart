import 'package:flutter/material.dart';

class MyAuthLogo extends StatelessWidget {
  const MyAuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(12),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          "assets/images/notes.png",
          width: 70,
          height: 70,
        ),
      ),
    );
  }
}
