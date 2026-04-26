import 'package:flutter/material.dart';
import 'package:natalis_frontend/models/scan_result.dart';
import 'package:natalis_frontend/modules/test/widgets/metric_glass_card.dart';

class MetricGlassGrid extends StatelessWidget {
  final ScanResult result;

  const MetricGlassGrid({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MetricGlassCard(
              label: "HC",
              value: "${result.hcMm} mm",
              icon: Icons.straighten,
            ),
            const SizedBox(width: 16),
            MetricGlassCard(
              label: "GA",
              value: result.gaWeeks != null ? "${result.gaWeeks} w" : "N/A",
              icon: Icons.calendar_today,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            MetricGlassCard(
              label: "Classification",
              value: result.classification,
              icon: Icons.assignment_outlined,
            ),
            const SizedBox(width: 16),
            MetricGlassCard(
              label: "Percentile",
              value: result.percentileBand,
              icon: Icons.analytics_outlined,
            ),
          ],
        ),
      ],
    );
  }
}
