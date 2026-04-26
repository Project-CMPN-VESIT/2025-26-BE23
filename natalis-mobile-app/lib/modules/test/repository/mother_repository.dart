import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../models/mother.dart';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import '../../../core/network/api_client.dart';

class MotherRepository {
  final ApiClient _api = GetIt.instance<ApiClient>(instanceName: "backendApi");

  /* =========================
     1. CREATE MOTHER
     ========================= */

  Future<MotherModel> createMother({
    required String organizationId,
    required String doctorId,
    String? userId,
    required MotherModel mother,
  }) async {
    final response = await _api.post(
      '/api/v1/mothers',
      queryParams: {
        "organizationId": organizationId,
        "doctorId": doctorId,
        if (userId != null) "userId": userId,
      },
      body: mother.toJson(),
    );

    return MotherModel.fromJson(response.data);
  }

  /* =========================
     2. GET MOTHER BY ID
     ========================= */

  Future<MotherModel> getMotherById({
    required String motherId,
    required String organizationId,
  }) async {
    final response = await _api.get(
      '/api/v1/mothers/$motherId',
      queryParams: {"organizationId": organizationId},
    );

    return MotherModel.fromJson(response.data);
  }

  /* =========================
     3. GET ALL ACTIVE MOTHERS
     ========================= */

  Future<List<MotherModel>> getMothersByOrganization({
    required String organizationId,
  }) async {
    final response = await _api.get(
      '/api/v1/mothers',
      queryParams: {"organizationId": organizationId},
    );

    final List data = response.data;

    return data.map((e) => MotherModel.fromJson(e)).toList();
  }

  /* =========================
     4. GET MOTHERS BY DOCTOR
     ========================= */

  Future<List<MotherModel>> getMothersByDoctor({
    required String organizationId,
    required String doctorId,
  }) async {
    final response = await _api.get(
      '/api/v1/mothers/by-doctor',
      queryParams: {"organizationId": organizationId, "doctorId": doctorId},
    );

    final List data = response.data;

    return data.map((e) => MotherModel.fromJson(e)).toList();
  }

  /* =========================
     5. SEARCH MOTHERS BY NAME
     ========================= */

  Future<List<MotherModel>> searchMothers({
    required String organizationId,
    required String name,
  }) async {
    final response = await _api.get(
      '/api/v1/mothers/search',
      queryParams: {"organizationId": organizationId, "name": name},
    );

    final List data = response.data;

    return data.map((e) => MotherModel.fromJson(e)).toList();
  }

  /* =========================
     6. UPDATE MOTHER
     ========================= */

  Future<MotherModel> updateMother({
    required String motherId,
    required String organizationId,
    required MotherModel mother,
  }) async {
    final response = await _api.put(
      '/api/v1/mothers/$motherId',
      queryParams: {"organizationId": organizationId},
      body: mother.toJson(),
    );

    return MotherModel.fromJson(response.data);
  }

  /* =========================
     7. DEACTIVATE MOTHER
     ========================= */

  Future<void> deactivateMother({
    required String motherId,
    required String organizationId,
  }) async {
    await _api.delete(
      '/api/v1/mothers/$motherId',
      queryParams: {"organizationId": organizationId},
    );
  }
}
