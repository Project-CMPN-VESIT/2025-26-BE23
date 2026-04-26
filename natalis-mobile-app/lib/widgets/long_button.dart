// In long_button.dart

import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final Widget? logo;
  final bool logoOnLeft; // Add this line

  const LongButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0),
    this.logo,
    this.logoOnLeft = true, // Default to left
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme
              .of(context)
              .primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.0),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          mainAxisSize: MainAxisSize.min,
          children: [
            if (logo != null && logoOnLeft) ...[
              logo!,
              const SizedBox(width: 8.0),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (logo != null && !logoOnLeft) ...[
              const SizedBox(width: 8.0),
              logo!,
            ],
          ],
        ),
      ),
    );
  }
}