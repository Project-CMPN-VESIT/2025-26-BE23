import 'package:natalis_frontend/models/test.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_pdf_preview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NatalisClinicalReviewPage extends pw.StatelessWidget {
  final TestModel test;

  NatalisClinicalReviewPage({required this.test});

  @override
  pw.Widget build(pw.Context context) {
    final data = test.additionalResults ?? {};

    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ================================================
          // 🔷 HEADER BAND
          // ================================================
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 14),
            decoration: pw.BoxDecoration(
              gradient: const pw.LinearGradient(
                colors: [kNatalisPrimary, kNatalisAccent],
              ),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Center(
              child: pw.Text(
                "CLINICAL REVIEW & PHYSICIAN NOTES",
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          pw.SizedBox(height: 25),

          // ================================================
          // 🔷 STRUCTURED TABLE SECTION
          // ================================================
          if (data.isNotEmpty) _clinicalTable(data),

          pw.SizedBox(height: 25),

          // ================================================
          // 🔷 RISK INDICATORS (If Exists)
          // ================================================
          if (data.containsKey("riskIndicators"))
            _riskSection(data["riskIndicators"]),

          pw.SizedBox(height: 25),

          // ================================================
          // 🔷 REMARKS BOX
          // ================================================
          if (data.containsKey("remarks")) _remarksBox(data["remarks"]),
        ],
      ),
    );
  }

  // ======================================================
  // 📋 Clinical Table
  // ======================================================

  pw.Widget _clinicalTable(Map<String, dynamic> data) {
    final filtered = Map.from(data)
      ..remove("riskIndicators")
      ..remove("remarks");

    return pw.Table(
      border: pw.TableBorder.all(color: kNatalisBorder, width: 0.8),
      columnWidths: const {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(4)},
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: kNatalisLight),
          children: [_headerCell("PARAMETER"), _headerCell("CLINICAL VALUE")],
        ),

        ...filtered.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;

          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: index.isEven ? PdfColors.white : PdfColors.grey100,
            ),
            children: [
              _dataCell(_formatKey(e.key), isLabel: true),
              _dataCell(_formatValue(e.value)),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: kNatalisPrimary,
        ),
      ),
    );
  }

  pw.Widget _dataCell(String text, {bool isLabel = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          color: isLabel ? kNatalisPrimary : PdfColors.black,
          fontWeight: isLabel ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  // ======================================================
  // ⚠ Risk Section
  // ======================================================

  pw.Widget _riskSection(dynamic risks) {
    if (risks is! List || risks.isEmpty) {
      return pw.Container();
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.red300, width: 1),
        borderRadius: pw.BorderRadius.circular(6),
        color: PdfColors.red50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "RISK INDICATORS",
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red800,
            ),
          ),
          pw.SizedBox(height: 8),
          ...risks.map<pw.Widget>((r) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text(
                " ${r.toString()}",
                style: pw.TextStyle(fontSize: 9),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ======================================================
  // 🧾 Remarks Box
  // ======================================================

  pw.Widget _remarksBox(dynamic remarks) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: kNatalisBorder),
        borderRadius: pw.BorderRadius.circular(6),
        color: kNatalisLight,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "PHYSICIAN REMARKS",
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: kNatalisPrimary,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            remarks?.toString() ?? "-",
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // Helpers
  // ======================================================

  String _formatValue(dynamic value) {
    if (value == null) return "-";
    if (value is List) return value.join(", ");
    return value.toString();
  }

  String _formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .replaceAll('_', ' ')
        .toUpperCase();
  }
}
