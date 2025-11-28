import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color foregroundColor;
  final String label;
  final Widget? leftIcon;
  final Widget? rightIcon;

  const AppOutlinedButton({
    super.key,
    required this.borderColor,
    required this.foregroundColor,
    required this.label,
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leftIcon != null) ...[leftIcon!, const SizedBox(width: 8)],
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (rightIcon != null) ...[const SizedBox(width: 8), rightIcon!],
        ],
      ),
    );
  }
}
