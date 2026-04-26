import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:natalis_frontend/core/di/injection.dart';
import 'package:natalis_frontend/core/services/pref_service.dart';
import 'package:natalis_frontend/modules/home/screens/home_screen.dart';
import 'package:natalis_frontend/modules/welcome/screen/welcome.dart';

class SplashDeciderScreen extends StatefulWidget {
  const SplashDeciderScreen({super.key});

  @override
  State<SplashDeciderScreen> createState() => _SplashDeciderScreenState();
}

class _SplashDeciderScreenState extends State<SplashDeciderScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefService = getIt<PrefService>();

    final isLoggedIn = await prefService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      final userId = await prefService.getUserId();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userId: userId!)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
