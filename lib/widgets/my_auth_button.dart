import 'package:flutter/material.dart';

class MyAuthButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color color;
  const MyAuthButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: color,
        textColor: Colors.white,
        child: child,
      ),
    );
  }
}
