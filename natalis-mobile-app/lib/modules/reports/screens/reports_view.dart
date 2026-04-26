import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natalis_frontend/models/doctor_model.dart';
import 'package:natalis_frontend/modules/home/bloc/home_cubit.dart';
import 'package:natalis_frontend/modules/home/bloc/home_state.dart';
import 'package:natalis_frontend/modules/reports/bloc/reports_cubit.dart';
import 'package:natalis_frontend/modules/reports/bloc/reports_state.dart';
import 'package:natalis_frontend/modules/reports/widgets/test_glass_card.dart';

class ReportsView extends StatelessWidget {
  final String organizationId;
  final DoctorModel doctor;
  const ReportsView({
    super.key,
    required this.organizationId,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (state is ReportsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        if (state is ReportsLoaded) {
          if (state.tests.isEmpty) {
            return const Center(
              child: Text(
                "No reports available",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final homeState = context.read<HomeCubit>().state as HomeLoaded;

              await context.read<ReportsCubit>().loadReports(
                organizationId: homeState.doctor.organizationId,
              );
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.tests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return TestGlassCard(
                  test: state.tests[index],
                  organizationId: organizationId,
                  doctor: doctor,
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
