import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/models/mother.dart';
import 'package:natalis_frontend/models/test.dart';
import 'package:natalis_frontend/modules/pdf/screens/natalis_pdf_preview.dart';
import 'package:natalis_frontend/modules/test/repository/mother_repository.dart';
import 'package:natalis_frontend/modules/test/repository/test_repository.dart';

import '../../../models/test-small.dart';
import '../screens/detailed_report_screen.dart';
import 'status_badge.dart';
import 'glass_action_button.dart';

class TestGlassCard extends StatefulWidget {
  final TestListItem test;
  final String organizationId;
  final DoctorModel doctor;

  const TestGlassCard({
    super.key,
    required this.test,
    required this.organizationId,

    required this.doctor,
  });

  @override
  State<TestGlassCard> createState() => _TestGlassCardState();
}

class _TestGlassCardState extends State<TestGlassCard> {
  final TestRepository _repository = TestRepository();

  TestModel? _test;
  MotherModel? _mother;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadTest() async {
    try {
      final test = await _repository.getTestByMother(
        organizationId: widget.organizationId,
        motherId: widget.test.motherId,
      );

      setState(() {
        _test = test;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMother() async {
    try {
      final mother = await MotherRepository().getMotherById(
        organizationId: widget.organizationId,
        motherId: widget.test.motherId,
      );

      setState(() {
        _mother = mother;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 180,
      borderRadius: 18,
      blur: 18,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.35), Colors.white.withOpacity(0.1)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test type
            Text(
              widget.test.testType.replaceAll('_', ' '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
            ),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.test.motherName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.test.trimester,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat(
                          'dd MMM yyyy • HH:mm',
                        ).format(widget.test.testTime),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                StatusBadge(status: widget.test.classification),
              ],
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassActionButton(
                  label: 'Download PDF',
                  icon: Icons.description_outlined,
                  onTap: () async {
                    await _loadMother();
                    await _loadTest();
                    // Ensure test data is loaded before navigating
                    if (_isLoading == false &&
                        _error == null &&
                        _test != null &&
                        _mother != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NatalisPdfPreview(
                            test: _test!,
                            mother: _mother!,
                            doctor: widget.doctor,
                          ),
                        ),
                      );
                    }
                  },
                ),

                GlassActionButton(
                  label: 'View Details',
                  icon: Icons.arrow_forward_rounded,
                  isTrailingIcon: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestDetailsScreen(
                          motherId: widget.test.motherId,
                          organizationId: widget.organizationId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
