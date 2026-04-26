import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/models/mother.dart';
import 'package:natalis_frontend/models/test.dart';
import 'package:natalis_frontend/modules/pdf/widgets/natalis_header.dart';
import 'package:natalis_frontend/modules/pdf/widgets/natalis_pdf_footer.dart';
import 'package:pdf/widgets.dart' as pw;

class NatalisBasePage extends pw.StatelessWidget {
  final pw.Widget body;
  final TestModel test;
  final MotherModel mother;
  final DoctorModel doctor;
  final int page;
  final int total;

  NatalisBasePage({
    required this.body,
    required this.test,
    required this.mother,
    required this.doctor,
    required this.page,
    required this.total,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      children: [
        NatalisHeader(test: test, doctor: doctor),
        pw.Expanded(
          child: pw.Padding(padding: const pw.EdgeInsets.all(20), child: body),
        ),
        NatalisPdfFooter(page: page, total: total),
      ],
    );
  }
}
