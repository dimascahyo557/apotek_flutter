import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color foregroundColor;
  final String label;
  const AppOutlinedButton({
    super.key,
    required this.borderColor,
    required this.foregroundColor,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        side: BorderSide(color: borderColor, width: 2), // warna border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor, // warna teks
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}