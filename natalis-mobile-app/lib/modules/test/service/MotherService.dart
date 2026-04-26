import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../models/mother.dart';
import '../repository/mother_repository.dart';

class MotherService {
  final MotherRepository _repository;

  MotherService() : _repository = MotherRepository();

  Future<MotherModel> createMother({
    required String organizationId,
    required String doctorId,
    String? userId,
    required MotherModel mother,
  }) async {
    try {
      return await _repository.createMother(
        organizationId: organizationId,
        doctorId: doctorId,
        userId: userId,
        mother: mother,
      );
    } catch (e) {
      throw Exception("Mother creation failed: $e");
    }
  }

  Future<MotherModel> getMotherById({
    required String motherId,
    required String organizationId,
  }) async {
    try {
      return await _repository.getMotherById(
        motherId: motherId,
        organizationId: organizationId,
      );
    } catch (e) {
      throw Exception("Fetching mother failed: $e");
    }
  }
}
