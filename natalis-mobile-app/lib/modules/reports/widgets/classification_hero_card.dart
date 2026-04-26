import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natalis_frontend/models/test.dart';

class ClassificationHeroCard extends StatelessWidget {
  final TestModel test;

  const ClassificationHeroCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final color = _classificationColor(test.classification);

    return GlassmorphicContainer(
      width: double.infinity,
      height: 140,
      borderRadius: 24,
      blur: 18,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              test.motherName,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  test.classification.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.circle, size: 10, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _classificationColor(String classification) {
    switch (classification.toLowerCase()) {
      case 'normal':
        return Colors.greenAccent;
      case 'warning':
        return Colors.orangeAccent;
      case 'critical':
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }
}
