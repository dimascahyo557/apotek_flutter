import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final String label;
  const AppTextButton({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 13),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}