import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natalis_frontend/models/dashboard_stats.dart';
import 'package:natalis_frontend/models/dashboard_stats_update_event.dart';
import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/models/test-small.dart';
import 'package:natalis_frontend/modules/home/bloc/home_state.dart';
import 'package:natalis_frontend/modules/home/repository/home_repository.dart';
import 'package:natalis_frontend/core/services/test_socket_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  final TestSocketService _socketService;

  StreamSubscription<TestListItem>? _testSubscription;
  StreamSubscription<DashboardStatsUpdateEvent>? _dashboardSubscription;

  List<TestListItem> _recentTests = [];
  DoctorModel? _doctor;
  DashboardStats? _stats;
  int _version = 0;
  String doctorName = "";

  HomeCubit(this._repository, this._socketService) : super(HomeInitial());

  Future<void> loadHome({required String userId}) async {
    try {
      emit(HomeLoading());

      final doctor = await _repository.getDoctorByUserId(userId: userId);
      doctorName = doctor.name;

      final organizationId = doctor.organizationId;

      final results = await Future.wait([
        _repository.getDashboardStats(organizationId: organizationId),
        _repository.getRecentTestsByOrganization(
          organizationId: organizationId,
          limit: 5,
        ),
      ]);

      _doctor = doctor;
      _stats = results[0] as DashboardStats;
      _recentTests = results[1] as List<TestListItem>;

      _socketService.connect(organizationId: organizationId);

      _testSubscription = _socketService.testStream.listen(_handleIncomingTest);

      _dashboardSubscription = _socketService.dashboardStream.listen(
        _handleDashboardUpdate,
      );

      emit(
        HomeLoaded(
          doctor: _doctor!,
          stats: _stats!,
          recentTests: _recentTests,
          version: _version,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _handleIncomingTest(TestListItem newTest) {
    if (_recentTests.any((t) => t.id == newTest.id)) {
      return;
    }

    _recentTests.insert(0, newTest);

    if (_recentTests.length > 5) {
      _recentTests.removeLast();
    }

    _version++;

    emit(
      HomeLoaded(
        doctor: _doctor!,
        stats: _stats!,
        recentTests: List.from(_recentTests),
        version: _version,
      ),
    );
  }

  void _handleDashboardUpdate(DashboardStatsUpdateEvent event) {
    if (_stats == null) return;

    _stats = _stats!.copyWith(
      totalTests: _stats!.totalTests + event.totalTestsIncrement,
      testsToday: _stats!.testsToday + event.testsTodayIncrement,
      testsThisMonth: _stats!.testsThisMonth + event.testsThisMonthIncrement,
    );

    log("dashboard update received");

    _version++;

    emit(
      HomeLoaded(
        doctor: _doctor!,
        stats: _stats!,
        recentTests: List.from(_recentTests),
        version: _version,
      ),
    );
  }

  @override
  Future<void> close() {
    _testSubscription?.cancel();
    _dashboardSubscription?.cancel();
    _socketService.disconnect();
    return super.close();
  }
}
