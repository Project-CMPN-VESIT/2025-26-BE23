import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natalis_frontend/modules/home/repository/home_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final HomeRepository _repository;

  ReportsCubit(this._repository) : super(ReportsInitial());

  Future<void> loadReports({required String organizationId}) async {
    try {
      emit(ReportsLoading());

      final tests = await _repository.getRecentTestsByOrganization(
        organizationId: organizationId,
        limit: 100, // full list for reports
      );

      emit(ReportsLoaded(tests));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
