import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natalis_frontend/modules/reports/widgets/classification_hero_card.dart';
import 'package:natalis_frontend/modules/reports/widgets/clinical_review_card.dart';

import 'package:natalis_frontend/modules/reports/widgets/metric_glass_card.dart';
import 'package:natalis_frontend/modules/reports/widgets/ultrasound_image_card.dart';
import 'package:natalis_frontend/modules/test/repository/test_repository.dart';

import '../../../models/test.dart';
import '../../test/service/TestService.dart';
import 'package:glassmorphism/glassmorphism.dart';

class TestDetailsScreen extends StatefulWidget {
  final String motherId;
  final String organizationId;

  const TestDetailsScreen({
    super.key,
    required this.motherId,
    required this.organizationId,
  });

  @override
  State<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {
  // final TestService _service = TestService();
  final TestRepository _repository = TestRepository();

  TestModel? _test;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    try {
      final test = await _repository.getTestByMother(
        organizationId: widget.organizationId,
        motherId: widget.motherId,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔙 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Test Details",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          'Failed to load test',
          style: GoogleFonts.inter(color: Colors.redAccent),
        ),
      );
    }

    final test = _test!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🧠 HERO CLASSIFICATION CARD
          ClassificationHeroCard(test: test),

          const SizedBox(height: 28),

          /// 📊 METRICS GRID
          Text(
            "Clinical Metrics",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              MetricGlassCard(
                label: "HC (mm)",
                value: test.hcMm.toStringAsFixed(2),
              ),
              const SizedBox(width: 16),
              MetricGlassCard(
                label: "GA (weeks)",
                value: test.gaWeeks.toStringAsFixed(2),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              MetricGlassCard(label: "EDD", value: test.edd),
              const SizedBox(width: 16),
              MetricGlassCard(label: "Trimester", value: test.trimester),
            ],
          ),

          const SizedBox(height: 32),

          /// 🖼️ IMAGE SECTION
          Text(
            "Annotated Ultrasound",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          UltrasoundImageCard(base64: test.annotatedImageBase64),
          const SizedBox(height: 32),

          /// 🩺 CLINICAL REVIEW SECTION
          if (test.additionalResults != null &&
              test.additionalResults!.isNotEmpty) ...[
            Text(
              "Clinical Review",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            ClinicalReviewCard(additionalResults: test.additionalResults!),
          ],
        ],
      ),
    );
  }

  // =========================
  // UI HELPERS
  // =========================

  Widget _title(String text) =>
      Text(text, style: GoogleFonts.inter(fontSize: 12, color: Colors.white70));

  Widget _value(String text, {Color? color}) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
    ),
  );

  Widget _metric(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_title(label), _value(value)],
      ),
    );
  }
}
