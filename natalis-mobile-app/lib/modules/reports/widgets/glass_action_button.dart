import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isTrailingIcon;

  const GlassActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.isTrailingIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 0.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: isTrailingIcon
              ? [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(icon, size: 16, color: Colors.white),
                ]
              : [
                  Icon(icon, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
