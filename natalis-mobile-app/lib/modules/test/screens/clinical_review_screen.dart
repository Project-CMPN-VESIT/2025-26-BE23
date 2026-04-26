import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:natalis_frontend/modules/home/bloc/home_cubit.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_cubit.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_state.dart';

class ClinicalReviewScreen extends StatefulWidget {
  const ClinicalReviewScreen({super.key});

  @override
  State<ClinicalReviewScreen> createState() => _ClinicalReviewScreenState();
}

class _ClinicalReviewScreenState extends State<ClinicalReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestFlowCubit, TestFlowState>(
      listener: (context, state) {
        if (state is TestSaved) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }

        if (state is TestFlowError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<TestFlowCubit>();
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
                children: [
                  _header(),

                  const SizedBox(height: 30),

                  _sectionTitle("Growth Assessment"),
                  _glassDropdown(
                    value: cubit.growthAssessment,
                    items: const [
                      "Appropriate for Gestational Age (AGA)",
                      "Small for Gestational Age (SGA)",
                      "Large for Gestational Age (LGA)",
                      "Suspicious – Needs Further Evaluation",
                    ],
                    onChanged: (v) => cubit.growthAssessment = v!,
                  ),

                  const SizedBox(height: 30),

                  _sectionTitle("Clinical Observations"),
                  _glassMultilineField(
                    controller: cubit.observationsController,
                    hint:
                        "Enter detailed clinical findings and interpretation...",
                  ),

                  const SizedBox(height: 30),

                  _sectionTitle("Risk Indicators"),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: cubit.riskOptions.map((risk) {
                      final isSelected = cubit.selectedRisks.contains(risk);

                      return ChoiceChip(
                        label: Text(
                          risk,
                          style: TextStyle(color: Colors.black),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.redAccent,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        labelStyle: GoogleFonts.inter(color: Colors.white),
                        onSelected: (_) {
                          setState(() {
                            if (isSelected) {
                              cubit.selectedRisks.remove(risk);
                            } else {
                              cubit.selectedRisks.add(risk);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  _sectionTitle("AI Agreement"),
                  _glassDropdown(
                    value: cubit.aiAgreement,
                    items: const [
                      "Accepted",
                      "Partially Accepted",
                      "Overridden",
                    ],
                    onChanged: (v) => setState(() => cubit.aiAgreement = v!),
                  ),

                  const SizedBox(height: 30),

                  _sectionTitle("Recommendation"),
                  _glassDropdown(
                    value: cubit.recommendation,
                    items: const [
                      "Routine Follow-up",
                      "Repeat Scan in 2 Weeks",
                      "Repeat Scan in 4 Weeks",
                      "Refer to Specialist",
                      "Immediate Evaluation Required",
                    ],
                    onChanged: (v) => setState(() => cubit.recommendation = v!),
                  ),

                  const SizedBox(height: 30),

                  _sectionTitle("Follow-up Date"),
                  _glassDatePicker(cubit),

                  const SizedBox(height: 30),

                  _sectionTitle("Doctor Remarks"),
                  _glassMultilineField(
                    controller: cubit.remarksController,
                    hint: "Additional notes...",
                  ),
                ],
              ),
            ),
          ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF2C5364),
            onPressed: () async {
              cubit.submitClinicalReview(
                growthAssessment: cubit.growthAssessment,
                aiAgreement: cubit.aiAgreement,
                recommendation: cubit.recommendation,
                risks: cubit.selectedRisks.toList(),
                observations: cubit.observationsController.text,
                remarks: cubit.remarksController.text,
              );
              final homecubit = context.read<HomeCubit>();
              final doctorName = homecubit.doctorName;
              cubit.saveTest(doctorName);
            },
            icon: const Icon(Icons.description_outlined, color: Colors.white),
            label: const Text(
              "Save Test",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // =============================
  // UI Components
  // =============================

  Widget _header() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        Text(
          "Clinical Review",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _glassDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 18,
      blur: 16,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.12),
          Colors.white.withOpacity(0.04),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: const Color(0xFF203A43),
            style: const TextStyle(color: Colors.white),
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _glassMultilineField({
    required TextEditingController controller,
    required String hint,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 140,
      borderRadius: 18,
      blur: 16,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.12),
          Colors.white.withOpacity(0.04),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controller,
          maxLines: null,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _glassDatePicker(TestFlowCubit cubit) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 14)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) =>
              Theme(data: ThemeData.dark(), child: child!),
        );

        if (picked != null) {
          setState(() => cubit.followUpDate = picked);
        }
      },
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 70,
        borderRadius: 18,
        blur: 16,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.04),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                cubit.followUpDate == null
                    ? "Select follow-up date"
                    : DateFormat('dd MMM yyyy').format(cubit.followUpDate!),
                style: GoogleFonts.inter(color: Colors.white),
              ),
              const Spacer(),
              const Icon(Icons.calendar_today, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
