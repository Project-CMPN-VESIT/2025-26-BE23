import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:natalis_frontend/models/test.dart';

import '../../../models/scan_result.dart';
import '../../../models/test-small.dart';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import '../../../core/network/api_client.dart';

class TestRepository {
  final ApiClient _api = GetIt.instance<ApiClient>(instanceName: "backendApi");

  /* =========================
     1. CREATE TEST
     ========================= */

  Future<void> createTest({
    required String organizationId,
    required String motherId,
    required String motherName,
    required String doctorId,
    required String doctorName,
    required ScanResult scanResult,
    Map<String, dynamic>? additionalResults,
  }) async {
    final response = await _api.post(
      '/api/v1/tests',
      queryParams: {
        'organizationId': organizationId,
        'motherId': motherId,
        'motherName': motherName,
        'doctorId': doctorId,
        'doctorName': doctorName
      },
      body: {...scanResult.toJson(), "additionalResults": additionalResults},
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create test");
    }
  }

  /* =========================
     2. LIST TESTS BY DOCTOR
     ========================= */

  Future<List<TestListItem>> listTestsByDoctor({
    required String organizationId,
    required String doctorId,
  }) async {
    final response = await _api.get(
      '/api/v1/tests/list-by-doctor',
      queryParams: {'organizationId': organizationId, 'doctorId': doctorId},
    );

    final List<dynamic> jsonList = response.data;

    return jsonList
        .map((e) => TestListItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /* =========================
     3. GET TEST BY MOTHER
     ========================= */

  Future<TestModel> getTestByMother({
    required String organizationId,
    required String motherId,
  }) async {
    final response = await _api.get(
      '/api/v1/tests/by-mother',
      queryParams: {'organizationId': organizationId, 'motherId': motherId},
    );

    return TestModel.fromJson(response.data);
  }
}
