import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetingHeader extends StatelessWidget {
  final String doctorName;

  const GreetingHeader({super.key, required this.doctorName});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_greeting()},",
          style: GoogleFonts.inter(fontSize: 18, color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Text(
          doctorName,
          style: GoogleFonts.playfairDisplay(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
