import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natalis_frontend/models/mother.dart';
import 'package:natalis_frontend/models/scan_result.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_state.dart';
import 'package:natalis_frontend/modules/test/repository/mother_repository.dart';
import 'package:natalis_frontend/modules/test/repository/test_repository.dart';
import 'package:natalis_frontend/modules/test/service/ScanService.dart';
import 'package:path_provider/path_provider.dart';

class TestFlowCubit extends Cubit<TestFlowState> {
  final MotherRepository motherRepository;
  final TestRepository testRepository;
  final ScanService scanService;

  MotherModel? _mother;
  ScanResult? _result;
  Map<String, dynamic> _additionalResults = {};

  TestFlowCubit({
    required this.motherRepository,
    required this.testRepository,
    required this.scanService,
  }) : super(TestFlowInitial());

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  int age = 25;
  String maritalStatus = "Married";
  DateTime? lmpDate;
  BloodGroup bloodGroup = BloodGroup.O_POS;
  int gravida = 1;
  int para = 0;
  bool highRisk = false;
  final TextEditingController observationsController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String growthAssessment = "Appropriate for Gestational Age (AGA)";
  String aiAgreement = "Accepted";
  String recommendation = "Routine Follow-up";

  DateTime? followUpDate;

  final List<String> riskOptions = [
    "IUGR suspected",
    "Macrosomia suspected",
    "Oligohydramnios",
    "Polyhydramnios",
    "Placental abnormality",
    "None",
  ];

  final Set<String> selectedRisks = {};

  /// ==============================
  /// 1️⃣ Submit Mother Details
  /// ==============================
  void submitMother(MotherModel mother) {
    _mother = mother;
    emit(MotherDetailsReady(mother));
  }

  /// ==============================
  /// 2️⃣ Upload & Analyze Scan
  /// ==============================
  Future<void> uploadScan(File imageFile) async {
    try {
      emit(ScanAnalyzing());

      final result = await scanService.uploadAndAnalyzeScan(
        imageFile: imageFile,
        scanDate: DateTime.now(),
      );

      _result = result;

      emit(ScanResultReady(mother: _mother!, result: result));
    } catch (e) {
      emit(TestFlowError(e.toString()));
    }
  }

  /// ==============================
  /// 3️⃣ Submit Clinical Review
  /// ==============================
  void submitClinicalReview({
    required String growthAssessment,
    required String aiAgreement,
    required String recommendation,
    required List<String> risks,
    required String observations,
    required String remarks,
    DateTime? followUpDate,
  }) {
    _additionalResults = {
      "growthAssessment": growthAssessment,
      "aiAgreement": aiAgreement,
      "recommendation": recommendation,
      "riskIndicators": risks,
      "observations": observations,
      "remarks": remarks,
      "followUpDate": followUpDate?.toIso8601String(),
      "reviewedAt": DateTime.now().toIso8601String(),
    };

    emit(
      ClinicalReviewReady(
        mother: _mother!,
        result: _result!,
        additionalResults: _additionalResults,
      ),
    );
  }

  /// ==============================
  /// 3️⃣ Save Test
  /// ==============================
  Future<void> saveTest(String doctorName) async {
    try {
      emit(TestSaving());
      log(_additionalResults.toString());

      final createdMother = await motherRepository.createMother(
        organizationId: _mother!.organizationId,
        doctorId: _mother!.doctorId,
        userId: _mother!.userId,
        mother: _mother!,
      );

      await testRepository.createTest(
        organizationId: _mother!.organizationId,
        motherId: createdMother.id!,
        motherName: createdMother.name,
        doctorId: _mother!.doctorId,
        doctorName: doctorName,
        scanResult: _result!,
        additionalResults: _additionalResults,
      );

      emit(TestSaved());
    } catch (e) {
      emit(TestFlowError(e.toString()));
    }
  }

  MaritalStatus mapStringToMaritalStatus(String value) {
    switch (value.toLowerCase()) {
      case "married":
        return MaritalStatus.MARRIED;
      case "unmarried":
        return MaritalStatus.SINGLE;
      case "divorced":
        return MaritalStatus.DIVORCED;
      case "widowed":
        return MaritalStatus.WIDOWED;
      default:
        return MaritalStatus.SINGLE;
    }
  }

  ////testing function to test on emulator

  Future<File> assetImageToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/test_scan.jpg');

    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }
}
