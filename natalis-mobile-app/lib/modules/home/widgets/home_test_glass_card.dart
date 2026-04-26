import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:natalis_frontend/models/test-small.dart';
import 'package:natalis_frontend/modules/reports/screens/detailed_report_screen.dart';
import 'package:natalis_frontend/modules/reports/widgets/status_badge.dart';

class HomeTestGlassCard extends StatelessWidget {
  final TestListItem test;
  final String organizationId;
  final String doctorName;

  const HomeTestGlassCard({
    super.key,
    required this.test,
    required this.organizationId,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 160,
      borderRadius: 18,
      blur: 18,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.30),
          Colors.white.withOpacity(0.08),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Mother Name
            Text(
              test.motherName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            /// Clinical Row
            Row(
              children: [
                _miniInfo("Trimester", test.trimester),
                const SizedBox(width: 16),
                _miniInfo("GA", "${test.gaWeeks} w"),
              ],
            ),

            const SizedBox(height: 6),

            /// Added By
            Text(
              "Added by Dr. $doctorName",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
            ),

            const SizedBox(height: 4),

            /// Date
            Text(
              DateFormat('dd MMM yyyy • HH:mm').format(test.testTime),
              style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: test.classification),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestDetailsScreen(
                          motherId: test.motherId,
                          organizationId: organizationId,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "View",
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniInfo(String label, String value) {
    return Row(
      children: [
        Text(
          "$label:",
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
