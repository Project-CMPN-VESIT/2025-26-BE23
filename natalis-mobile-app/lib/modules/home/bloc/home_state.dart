import 'package:equatable/equatable.dart';
import 'package:natalis_frontend/models/dashboard_stats.dart';
import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/models/test-small.dart';
import 'package:equatable/equatable.dart';

/// ============================
/// BASE STATE
/// ============================

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// ============================
/// INITIAL
/// ============================

class HomeInitial extends HomeState {}

/// ============================
/// LOADING
/// ============================

class HomeLoading extends HomeState {}

/// ============================
/// LOADED
/// ============================

class HomeLoaded extends HomeState {
  final DoctorModel doctor;
  final DashboardStats stats;
  final List<TestListItem> recentTests;
  final int version;

  const HomeLoaded({
    required this.doctor,
    required this.stats,
    required this.recentTests,
    required this.version,
  });

  @override
  List<Object?> get props => [doctor, stats, recentTests, version];
}

/// ============================
/// ERROR
/// ============================

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
