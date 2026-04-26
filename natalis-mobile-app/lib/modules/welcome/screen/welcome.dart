import 'package:flutter/material.dart';

import 'package:natalis_frontend/modules/login/screens/doctor_login.dart';
import 'package:natalis_frontend/modules/welcome/widgets/intro_card.dart';
import 'package:natalis_frontend/modules/welcome/widgets/page_indicator.dart';

import '../../../widgets/long_button.dart';

import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_IntroPage> introPages = [
    _IntroPage(
      animationPath: 'assets/home_screen_animation.json',
      title: 'Welcome to Natalis',
      subtitle:
          'An intelligent platform for accurate prenatal ultrasound assessment.',
    ),
    _IntroPage(
      animationPath: 'assets/baby_animation.json',
      title: 'Precise Gestational Age',
      subtitle:
          'Calculate gestational age using advanced ultrasound measurements.',
    ),
    _IntroPage(
      animationPath: 'assets/report_animation.json',
      title: 'Clinical Insights',
      subtitle: 'Generate structured reports with automated prenatal analysis.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),

                /// PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: introPages.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final page = introPages[index];
                      return IntroCard(
                        animationPath: page.animationPath,
                        title: page.title,
                        subtitle: page.subtitle,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                PageIndicator(
                  current: _currentIndex,
                  count: introPages.length,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 40),

                /// CTA
                LongButton(
                  text: _currentIndex == introPages.length - 1
                      ? "Get Started"
                      : "Next",
                  logoOnLeft: false,
                  onPressed: () {
                    if (_currentIndex < introPages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DoctorLoginScreen(),
                        ),
                      );
                    }
                  },
                ).animate().slideY(begin: 0.3).fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroPage {
  final String animationPath;
  final String title;
  final String subtitle;

  _IntroPage({
    required this.animationPath,
    required this.title,
    required this.subtitle,
  });
}
