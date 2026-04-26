import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natalis_frontend/models/scan_result.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_cubit.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_state.dart';
import 'package:natalis_frontend/modules/test/screens/clinical_review_screen.dart';
import '../../../models/mother.dart';
import '../service/MotherService.dart';
import '../service/TestService.dart';
import '../widgets/annotated_scan_viewer.dart';
import '../widgets/metric_grid.dart';
import '../widgets/secondary_glass_card.dart';
import '../widgets/glass_button.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanResult result;
  final MotherModel mother;

  const ScanResultScreen({
    super.key,
    required this.result,
    required this.mother,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestFlowCubit, TestFlowState>(
      listener: (context, state) {
        // if (state is TestSaved) {
        //   Navigator.popUntil(context, (route) => route.isFirst);
        // }

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
                  /// 🔙 HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Scan Analysis",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🧠 HERO IMAGE
                  AnnotatedScanViewer(base64Image: result.annotatedImageBase64),

                  const SizedBox(height: 36),

                  /// 📊 PRIMARY METRICS
                  Text(
                    "Clinical Metrics",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MetricGlassGrid(result: result),

                  const SizedBox(height: 32),

                  /// 📅 SECONDARY INFO
                  Row(
                    children: [
                      SecondaryGlassCard(
                        label: "EDD",
                        value: result.edd ?? "N/A",
                        icon: Icons.event,
                      ),
                      const SizedBox(width: 16),
                      SecondaryGlassCard(
                        label: "Trimester",
                        value: result.trimester ?? "N/A",
                        icon: Icons.layers_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// 🧬 SYSTEM CONFIDENCE NOTE
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 80,
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
                    child: Center(
                      child: Text(
                        "Results generated using AI-assisted ultrasound analysis",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  GlassButton(
                    label: "Proceeed to Clinical Review",
                    icon: Icons.save_outlined,

                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: cubit,
                            child: ClinicalReviewScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
