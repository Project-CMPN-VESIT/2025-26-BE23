import 'dart:convert';
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:natalis_frontend/models/dashboard_stats.dart';
import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/models/test-small.dart';
import '../../../core/network/api_client.dart';

class HomeRepository {
  final ApiClient _api = GetIt.instance<ApiClient>(instanceName: "backendApi");

  /// =========================
  /// GET DASHBOARD STATS
  /// =========================
  Future<DashboardStats> getDashboardStats({
    required String organizationId,
  }) async {
    final response = await _api.get(
      '/api/v1/tests/dashboard',
      queryParams: {'organizationId': organizationId},
    );

    final json = response.data;
    log(json.toString());

    return DashboardStats.fromJson(json);
  }

  /// fetch doctor info by userId (for displaying doctor's name in dashboard)
  Future<DoctorModel> getDoctorByUserId({required String userId}) async {
    final response = await _api.get('/api/v1/doctors/user/$userId');

    final json = response.data;
    log(json.toString());

    return DoctorModel.fromJson(json);
  }

  Future<List<TestListItem>> getRecentTestsByOrganization({
    required String organizationId,
    int limit = 5,
  }) async {
    final response = await _api.get(
      '/api/v1/tests/list-by-organization',
      queryParams: {
        'organizationId': organizationId,
        'limit': limit.toString(),
      },
    );

    final List<dynamic> jsonList = response.data;
    log(json.toString());

    return jsonList
        .map((e) => TestListItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
