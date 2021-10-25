import 'package:flutter/material.dart';

class RoundedRectangleButton extends StatelessWidget {
  final Color color;
  final bool isFilled;
  final Widget child;
  final VoidCallback? onPressed;

  const RoundedRectangleButton({
    Key? key,
    required this.color,
    required this.isFilled,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFilled) {
      return ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        child: child,
        style: OutlinedButton.styleFrom(
          primary: color,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
      );
    }
  }
}
