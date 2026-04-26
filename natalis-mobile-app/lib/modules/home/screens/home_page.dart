import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:natalis_frontend/core/di/injection.dart';
import 'package:natalis_frontend/core/network/api_client.dart';
import 'package:natalis_frontend/modules/home/bloc/home_cubit.dart';
import 'package:natalis_frontend/modules/home/bloc/home_state.dart';
import 'package:natalis_frontend/modules/home/widgets/greeting_header.dart';
import 'package:natalis_frontend/modules/home/widgets/home_test_glass_card.dart';
import 'package:natalis_frontend/modules/home/widgets/mother_progress_card.dart';
import 'package:natalis_frontend/modules/home/widgets/org_header_card.dart';
import 'package:natalis_frontend/modules/home/widgets/primary_action_card.dart';
import 'package:natalis_frontend/modules/home/widgets/stat_card.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_cubit.dart';
import 'package:natalis_frontend/modules/test/repository/mother_repository.dart';
import 'package:natalis_frontend/modules/test/repository/test_repository.dart';
import 'package:natalis_frontend/modules/test/screens/add_mother_screen.dart';
import 'package:natalis_frontend/modules/test/service/ScanService.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (state is HomeError) {
          return Center(
            child: Text(
              "Oops! Something went wrong!",
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        if (state is HomeLoaded) {
          return _buildContent(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          children: [
            /// Doctor + Org
            GreetingHeader(doctorName: state.doctor.name),
            const SizedBox(height: 24),
            OrgSummaryCard(
              orgName: state.doctor.organizationName,
              totalTests: state.stats.totalTests,
            ),

            const SizedBox(height: 32),

            PrimaryActionCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => TestFlowCubit(
                        motherRepository: MotherRepository(),
                        testRepository: TestRepository(),
                        scanService: ScanService(
                          getIt<ApiClient>(instanceName: "modelApi"),
                        ),
                      ),
                      child: AddMotherScreen(
                        doctorId: state.doctor.id,
                        organizationId: state.doctor.organizationId,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            /// Overview
            Text(
              "Overview",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                StatCard(
                  title: "Today",
                  value: state.stats.testsToday.toString(),
                ),
                const SizedBox(width: 12),
                StatCard(
                  title: "This Month",
                  value: state.stats.testsThisMonth.toString(),
                ),
                const SizedBox(width: 12),
                StatCard(
                  title: "Last Month",
                  value: state.stats.testsLastMonth.toString(),
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// Recent Tests
            Text(
              "Recent Tests",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            ...state.recentTests.map(
              (test) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HomeTestGlassCard(
                  doctorName: state.doctor.name,
                  test: test,
                  organizationId: state.doctor.organizationId,
                ),
              ),
            ),
          ],
        ),

        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF2C5364),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => TestFlowCubit(
                      motherRepository: MotherRepository(),
                      testRepository: TestRepository(),
                      scanService: ScanService(
                        getIt<ApiClient>(instanceName: "modelApi"),
                      ),
                    ),
                    child: AddMotherScreen(
                      doctorId: state.doctor.id,
                      organizationId: state.doctor.organizationId,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "New Test",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
