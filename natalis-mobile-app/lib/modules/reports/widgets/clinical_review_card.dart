import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClinicalReviewCard extends StatelessWidget {
  final Map<String, dynamic> additionalResults;

  const ClinicalReviewCard({super.key, required this.additionalResults});

  @override
  Widget build(BuildContext context) {
    final growth = additionalResults["growthAssessment"] ?? "N/A";
    final aiAgreement = additionalResults["aiAgreement"] ?? "N/A";
    final recommendation = additionalResults["recommendation"] ?? "N/A";
    final risks =
        (additionalResults["riskIndicators"] as List?)?.join(", ") ?? "None";
    final observations = additionalResults["observations"] ?? "No observations";
    final remarks = additionalResults["remarks"] ?? "No remarks";
    final followUp = additionalResults["followUpDate"];
    final reviewedAt = additionalResults["reviewedAt"];

    return GlassmorphicContainer(
      width: double.infinity,
      height: 420,
      borderRadius: 20,
      blur: 18,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.35), Colors.white.withOpacity(0.1)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Growth Assessment", growth),
            const SizedBox(height: 10),
            _row("AI Agreement", aiAgreement),
            const SizedBox(height: 10),
            _row("Recommendation", recommendation),
            const SizedBox(height: 10),
            _row("Risk Indicators", risks),

            const SizedBox(height: 16),

            _section("Clinical Observations", observations),

            const SizedBox(height: 12),

            _section("Doctor Remarks", remarks),

            const Spacer(),

            if (followUp != null)
              _footerRow(
                "Follow-up",
                DateFormat('dd MMM yyyy').format(DateTime.parse(followUp)),
              ),

            if (reviewedAt != null)
              _footerRow(
                "Reviewed At",
                DateFormat(
                  'dd MMM yyyy • HH:mm',
                ).format(DateTime.parse(reviewedAt)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _section(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Widget _footerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
