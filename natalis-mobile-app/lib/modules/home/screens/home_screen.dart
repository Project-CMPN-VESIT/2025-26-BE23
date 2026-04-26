import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:natalis_frontend/modules/home/bloc/home_cubit.dart';
import 'package:natalis_frontend/modules/home/repository/home_repository.dart';
import 'package:natalis_frontend/modules/home/screens/home_page.dart';

import 'package:natalis_frontend/modules/reports/screens/reports_page.dart';
import 'package:natalis_frontend/modules/home/widgets/greeting_header.dart';
import 'package:natalis_frontend/modules/home/widgets/org_header_card.dart';
import 'package:natalis_frontend/modules/profile/screen/profile_page.dart';
import 'package:natalis_frontend/core/services/test_socket_service.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController pageController;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: currentPage);

    /// 🔥 Load home only once
    context.read<HomeCubit>().loadHome(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _buildBottomBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [ReportsPage(), HomePage(), ProfilePage()],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: CurvedNavigationBar(
        index: currentPage,
        height: 62,
        items: const [
          Icon(Icons.receipt_long, color: Colors.white),
          Icon(Icons.home_filled, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
        color: const Color(0xFF203A43),
        buttonBackgroundColor: const Color(0xFF2C5364),
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 650),
        animationCurve: Curves.easeInOutCubic,
        onTap: (index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() => currentPage = index);
        },
      ),
    );
  }
}
