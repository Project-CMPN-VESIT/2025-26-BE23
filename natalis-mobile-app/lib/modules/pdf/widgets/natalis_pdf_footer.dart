import 'package:natalis_frontend/modules/pdf/screens/natalis_pdf_preview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NatalisPdfFooter extends pw.StatelessWidget {
  final int page;
  final int total;

  NatalisPdfFooter({required this.page, required this.total});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: kNatalisBorder)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Generated via Natalis AI",
            style: pw.TextStyle(fontSize: 8, color: kNatalisMuted),
          ),
          pw.Text(
            "Page $page of $total",
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }
}
