import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Natalis",
          style: GoogleFonts.playfairDisplay(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Prenatal Ultrasound Intelligence",
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 700.ms).slideY(begin: -0.3);
  }
}
