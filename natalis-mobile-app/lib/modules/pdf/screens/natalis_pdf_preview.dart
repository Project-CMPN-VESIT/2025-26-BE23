import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/models/mother.dart';
import 'package:natalis_frontend/models/test.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_base_page.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_clinical_review_page.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_imaging_page.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_overview_page.dart';
import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const kNatalisPrimary = PdfColor.fromInt(0xFF203A43);
const kNatalisAccent = PdfColor.fromInt(0xFF2C5364);
const kNatalisLight = PdfColor.fromInt(0xFFE6F0F3);
const kNatalisMuted = PdfColors.grey600;
const kNatalisBorder = PdfColors.grey300;

class NatalisPdfPreview extends StatelessWidget {
  final TestModel test;
  final MotherModel mother;
  final DoctorModel doctor;

  const NatalisPdfPreview({
    super.key,
    required this.test,
    required this.mother,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        initialPageFormat: PdfPageFormat.a4,
        build: (format) => _generatePdf(),
      ),
    );
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => NatalisBasePage(
          page: 1,
          total: 2,
          test: test,
          mother: mother,
          doctor: doctor,
          body: NatalisOverviewPage(test: test, mother: mother),
        ),
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => NatalisBasePage(
          page: 2,
          total: 2,
          test: test,
          mother: mother,
          doctor: doctor,
          body: pw.Column(children: [NatalisImagingPage(test: test)]),
        ),
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => NatalisBasePage(
          page: 2,
          total: 2,
          test: test,
          mother: mother,
          doctor: doctor,
          body: pw.Column(children: [NatalisClinicalReviewPage(test: test)]),
        ),
      ),
    );

    return pdf.save();
  }
}
