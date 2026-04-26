import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutCard extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 70,
        borderRadius: 18,
        blur: 18,
        border: 1,
        linearGradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.15), Colors.red.withOpacity(0.05)],
        ),
        borderGradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.35), Colors.red.withOpacity(0.1)],
        ),
        child: Center(
          child: Text(
            "Logout",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}
