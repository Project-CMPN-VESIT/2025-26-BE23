import 'dart:convert';

import 'package:natalis_frontend/models/test.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_pdf_preview.dart';
import 'package:pdf/widgets.dart' as pw;

class NatalisImagingPage extends pw.StatelessWidget {
  final TestModel test;

  NatalisImagingPage({required this.test});

  @override
  pw.Widget build(pw.Context context) {
    final rawBase64 = test.annotatedImageBase64.contains(',')
        ? test.annotatedImageBase64.split(',').last
        : test.annotatedImageBase64;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "ANNOTATED ULTRASOUND",
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 15),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: kNatalisBorder),
          ),
          child: pw.Image(pw.MemoryImage(base64Decode(rawBase64)), height: 450),
        ),
      ],
    );
  }
}
