import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natalis_frontend/modules/home/bloc/home_cubit.dart';
import 'package:natalis_frontend/modules/home/bloc/home_state.dart';
import 'package:natalis_frontend/modules/home/repository/home_repository.dart';
import 'package:natalis_frontend/modules/reports/bloc/reports_cubit.dart';
import 'package:natalis_frontend/modules/reports/screens/reports_view.dart';
import '../../../models/test-small.dart';
import '../../test/service/TestService.dart';
import '../widgets/test_glass_card.dart';
import 'detailed_report_screen.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeState = context.read<HomeCubit>().state;

    if (homeState is! HomeLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final organizationId = homeState.doctor.organizationId;

    return BlocProvider(
      create: (_) =>
          ReportsCubit(HomeRepository())
            ..loadReports(organizationId: organizationId),
      child: ReportsView(
        organizationId: organizationId,
        doctor: homeState.doctor,
      ),
    );
  }
}
