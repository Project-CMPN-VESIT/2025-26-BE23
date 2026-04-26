import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isNormal = status.toLowerCase() == 'normal';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isNormal
            ? Colors.greenAccent.withOpacity(0.15)
            : Colors.redAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNormal ? Colors.greenAccent : Colors.redAccent,
          width: 0.6,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isNormal ? Colors.greenAccent : Colors.redAccent,
        ),
      ),
    );
  }
}
