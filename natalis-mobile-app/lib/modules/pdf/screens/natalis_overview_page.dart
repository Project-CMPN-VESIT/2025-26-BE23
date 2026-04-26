import 'package:natalis_frontend/models/mother.dart';
import 'package:natalis_frontend/models/test.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_pdf_preview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NatalisOverviewPage extends pw.StatelessWidget {
  final TestModel test;
  final MotherModel mother;

  NatalisOverviewPage({required this.test, required this.mother});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ======================================================
          // 🧾 TOP ROW — PATIENT + CLASSIFICATION SIDE BY SIDE
          // ======================================================
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(flex: 6, child: _patientCard()),
              pw.SizedBox(width: 20),
              pw.Expanded(flex: 4, child: _classificationPanel()),
            ],
          ),

          pw.SizedBox(height: 30),

          // ======================================================
          // 📊 AI METRICS GRID (FULL WIDTH)
          // ======================================================
          _metricsSection(),

          pw.SizedBox(height: 30),

          // ======================================================
          // 🧠 INTELLIGENCE SUMMARY STRIP
          // ======================================================
          _intelligenceStrip(),

          pw.SizedBox(height: 25),

          // ======================================================
          // 🏥 META INFORMATION BAR
          // ======================================================
          _metaBar(),
        ],
      ),
    );
  }

  // ======================================================
  // 🧾 PATIENT INFORMATION CARD
  // ======================================================

  pw.Widget _patientCard() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: kNatalisLight,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: kNatalisBorder),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "PATIENT INFORMATION",
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: kNatalisPrimary,
              letterSpacing: 1,
            ),
          ),
          pw.SizedBox(height: 12),

          pw.Table(
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(3),
            },
            children: [
              _row("Mother Name", mother.name, "Age", "${mother.age}"),
              _row("Gravida", "${mother.gravida}", "Para", "${mother.para}"),
              _row(
                "Blood Group",
                mother.bloodGroup.name,
                "LMP",
                mother.lmp?.toString().split(" ").first ?? "-",
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.TableRow _row(String l1, String v1, String l2, String v2) {
    return pw.TableRow(
      children: [
        _cell(l1, bold: true),
        _cell(v1),
        _cell(l2, bold: true),
        _cell(v2),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  // ======================================================
  // 🏷️ CLASSIFICATION PANEL (RIGHT SIDE HERO)
  // ======================================================

  pw.Widget _classificationPanel() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [kNatalisPrimary, kNatalisAccent],
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "AI CLASSIFICATION",
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            test.classification.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 15),
          // pw.Text(
          //   "Percentile Band: ${test.percentileBand.replaceAll("-", " ") ?? " "}",
          //   style: const pw.TextStyle(fontSize: 9, color: PdfColors.white),
          // ),
        ],
      ),
    );
  }

  // ======================================================
  // 📊 METRICS GRID
  // ======================================================

  pw.Widget _metricsSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "AI CLINICAL METRICS",
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: kNatalisPrimary,
            letterSpacing: 1,
          ),
        ),
        pw.SizedBox(height: 18),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _metricCard("Head Circumference", "${test.hcMm ?? "-"} mm"),
            _metricCard("Gestational Age", "${test.gaWeeks ?? "-"} weeks"),
            _metricCard("Expected Delivery", test.edd ?? "-"),
            _metricCard("Trimester", test.trimester ?? "-"),
          ],
        ),
      ],
    );
  }

  pw.Widget _metricCard(String label, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: kNatalisBorder),
        color: PdfColors.white,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 7,
              color: kNatalisMuted,
              letterSpacing: 0.8,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: kNatalisPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // 🧠 INTELLIGENCE STRIP
  // ======================================================

  pw.Widget _intelligenceStrip() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: kNatalisBorder),
        borderRadius: pw.BorderRadius.circular(8),
        color: kNatalisLight,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Weeks Remaining: ${test.weeksRemaining ?? "-"}",
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: kNatalisPrimary,
            ),
          ),
          pw.Text(
            "AI-assisted prenatal analysis",
            style: pw.TextStyle(fontSize: 9, color: kNatalisMuted),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // 🏥 META BAR
  // ======================================================

  pw.Widget _metaBar() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: kNatalisBorder),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Test ID: ${test.id ?? "-"}",
            style: const pw.TextStyle(fontSize: 8),
          ),
          pw.Text(
            "Test Date: ${test.testTime.toString().split('.').first}",
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }
}
