import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnalyzingScanScreen extends StatelessWidget {
  const AnalyzingScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🧠 Animated AI Ring
                Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 48,
                        color: Colors.white,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 2.seconds)
                    .fadeIn(),

                const SizedBox(height: 40),

                /// 🔍 Status
                Text(
                  "Analyzing Ultrasound Scan",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "AI model is estimating gestational age\nand generating clinical insights",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                /// 📊 Progress Indicator
                const LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF2C5364)),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 16),

                /// 🧬 Subtle reassurance
                Text(
                  "This may take a few seconds…",
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white54),
                ).animate().fadeIn(delay: 1.seconds),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
