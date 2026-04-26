import 'package:equatable/equatable.dart';
import 'package:natalis_frontend/models/test-small.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<TestListItem> tests;

  const ReportsLoaded(this.tests);

  @override
  List<Object?> get props => [tests];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
