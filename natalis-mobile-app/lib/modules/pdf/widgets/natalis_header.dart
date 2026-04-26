import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/models/test.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_pdf_preview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NatalisHeader extends pw.StatelessWidget {
  final TestModel test;
  final DoctorModel doctor;

  NatalisHeader({required this.test, required this.doctor});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: const pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [kNatalisPrimary, kNatalisAccent],
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                doctor.organizationName,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "AI-Assisted Prenatal Ultrasound Report",
                style: pw.TextStyle(color: PdfColors.white, fontSize: 10),
              ),
            ],
          ),

          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _meta("Report ID", test.id ?? ""),
              _meta("Date", _formatDate(test.testTime)),
              _meta("Doctor", doctor.name),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _meta(String label, String value) {
    return pw.Text(
      "$label: $value",
      style: pw.TextStyle(fontSize: 9, color: PdfColors.white),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }
}
