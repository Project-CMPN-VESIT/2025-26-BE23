import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natalis_frontend/core/di/injection.dart';
import 'package:natalis_frontend/core/network/api_client.dart';
import 'package:natalis_frontend/core/services/segmentation_processor.dart';
import 'package:natalis_frontend/core/services/segmentation_service.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_cubit.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_state.dart';
import 'package:natalis_frontend/modules/test/screens/analyzing_scan_screen.dart';
import 'package:natalis_frontend/modules/test/service/ScanService.dart';
import 'package:natalis_frontend/modules/test/widgets/mother_summary_card.dart';
import 'package:natalis_frontend/modules/test/widgets/upload_scan_card.dart';
import 'package:natalis_frontend/modules/test/screens/scan_result_screen.dart';
import '../../../models/mother.dart';

class UploadScanScreen extends StatelessWidget {
  final MotherModel mother;

  const UploadScanScreen({super.key, required this.mother});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestFlowCubit, TestFlowState>(
      listener: (context, state) {
        final cubit = context.read<TestFlowCubit>();
        if (state is ScanAnalyzing) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnalyzingScanScreen()),
          );
        }
        if (state is ScanResultReady) {
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: ScanResultScreen(
                  result: state.result,
                  mother: state.mother,
                ),
              ),
            ),
          );
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                children: [
                  /// 🔙 BACK
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// 🧠 HEADER
                  Text(
                    "Upload Ultrasound Scan",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Select a clear prenatal ultrasound image for analysis",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 🔹 Mother summary using MotherModel
                  MotherSummaryCard(
                    motherName: mother.name,
                    age: mother.age,
                    maritalStatus: mother.maritalStatus.name,
                  ),

                  const SizedBox(height: 32),

                  UploadScanCard(),

                  const SizedBox(height: 24),

                  /// ℹ️ INFO
                  Text(
                    "Supported formats: JPG, PNG • Ensure scan is clearly visible",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF2C5364),
            onPressed: () async {
              //// this is. original code for api call
              final ImagePicker picker = ImagePicker();

              try {
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                File fileToUpload;

                if (image == null) {
                  fileToUpload = await cubit.assetImageToFile(
                    "assets/fetal_images/fetalimg1.jpg",
                  );
                } else {
                  fileToUpload = File(image.path);
                }

                cubit.uploadScan(fileToUpload);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // remove analyzing screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst("Exception:", "").trim(),
                      ),
                    ),
                  );
                }
              }

              // final ImagePicker picker = ImagePicker();

              // try {
              //   XFile? image = await picker.pickImage(
              //     source: ImageSource.gallery,
              //   );

              //   Uint8List imageBytes;

              //   if (image == null) {
              //     final data = await rootBundle.load(
              //       "assets/fetal_images/fetus2.jpeg",
              //     );
              //     imageBytes = data.buffer.asUint8List();
              //   } else {
              //     imageBytes = await File(image.path).readAsBytes();
              //   }
              //   final output = await SegmentationService.runModel(imageBytes);

              //   print("Model Output Length: ${output.length}");

              //   // 🔥 Run full medical analysis
              //   final result = MedicalHeadAnalysis.analyze(
              //     imageBytes,
              //     output,
              //     0.12, // <-- your pixel_size_mm (adjust if needed)
              //   );

              //   Uint8List annotated = result["image"];
              //   double? hc = result["hc_mm"];
              //   double? ga = result["ga_weeks"];

              //   if (context.mounted) {
              //     showDialog(
              //       context: context,
              //       builder: (_) {
              //         return Dialog(
              //           child: Padding(
              //             padding: const EdgeInsets.all(16),
              //             child: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Image.memory(annotated),

              //                 const SizedBox(height: 16),

              //                 if (hc != null)
              //                   Text(
              //                     "Head Circumference: ${hc.toStringAsFixed(1)} mm",
              //                     style: const TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),

              //                 if (ga != null)
              //                   Text(
              //                     "Gestational Age: ${ga.toStringAsFixed(1)} weeks",
              //                     style: const TextStyle(fontSize: 16),
              //                   ),

              //                 const SizedBox(height: 16),

              //                 ElevatedButton(
              //                   onPressed: () => Navigator.pop(context),
              //                   child: const Text("Close"),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   }
            },
            icon: const Icon(Icons.upload, color: Colors.white),
            label: const Text(
              "Select Scan Image",
              style: TextStyle(color: Colors.white),
            ),
          ).animate().slideY(begin: 0.4).fadeIn(),
        );
      },
    );
  }
}
