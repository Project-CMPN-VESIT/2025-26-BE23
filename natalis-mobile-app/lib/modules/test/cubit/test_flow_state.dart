import 'package:equatable/equatable.dart';
import 'package:natalis_frontend/models/mother.dart';
import 'package:natalis_frontend/models/scan_result.dart';
import 'package:equatable/equatable.dart';

abstract class TestFlowState extends Equatable {
  const TestFlowState();

  @override
  List<Object?> get props => [];
}

class TestFlowInitial extends TestFlowState {}

class MotherDetailsReady extends TestFlowState {
  final MotherModel mother;

  const MotherDetailsReady(this.mother);

  @override
  List<Object?> get props => [mother];
}

class ScanAnalyzing extends TestFlowState {}

class ScanResultReady extends TestFlowState {
  final MotherModel mother;
  final ScanResult result;

  const ScanResultReady({required this.mother, required this.result});

  @override
  List<Object?> get props => [mother, result];
}

class ClinicalReviewReady extends TestFlowState {
  final MotherModel mother;
  final ScanResult result;
  final Map<String, dynamic> additionalResults;

  const ClinicalReviewReady({
    required this.mother,
    required this.result,
    required this.additionalResults,
  });

  @override
  List<Object?> get props => [mother, result, additionalResults];
}

class TestSaving extends TestFlowState {}

class TestSaved extends TestFlowState {}

class TestFlowError extends TestFlowState {
  final String message;

  const TestFlowError(this.message);

  @override
  List<Object?> get props => [message];
}
