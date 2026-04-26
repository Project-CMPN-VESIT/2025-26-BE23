import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutNatalisScreen extends StatefulWidget {
  const AboutNatalisScreen({super.key});

  @override
  State<AboutNatalisScreen> createState() => _AboutNatalisScreenState();
}

class _AboutNatalisScreenState extends State<AboutNatalisScreen>
    with SingleTickerProviderStateMixin {
  String version = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = "${info.version} (${info.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              /// HEADER 3D GLOW
              Column(
                children: [
                  Image.asset("assets/logo.png", height: 120),

                  const SizedBox(height: 6),
                  Text(
                    "AI-Powered Maternal Care System",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Version $version",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _build3DCard(
                icon: Icons.visibility_outlined,
                title: "Our Vision",
                content:
                    "Natalis transforms maternal healthcare through intelligent "
                    "AI-driven clinical systems. Our mission is to enhance medical "
                    "decision-making, enable early fetal risk detection, and support "
                    "safer pregnancies through advanced analytics.",
              ),

              const SizedBox(height: 20),

              _build3DCard(
                icon: Icons.psychology_outlined,
                title: "Intelligent Clinical Assistance",
                content:
                    "• AI-based CTG risk classification\n"
                    "• Real-time patient monitoring\n"
                    "• Secure digital test management\n"
                    "• Clinical risk alerts\n"
                    "• Institutional-level analytics",
              ),

              const SizedBox(height: 20),

              _build3DCard(
                icon: Icons.verified_user_outlined,
                title: "Medical Compliance & Security",
                content:
                    "Natalis is designed following modern medical software "
                    "architecture standards.\n\n"
                    "• Secure authentication & role-based access\n"
                    "• Encrypted storage protocols\n"
                    "• Organization-level data isolation\n"
                    "• Audit-ready architecture\n\n"
                    "Ensuring responsible AI integration in clinical environments.",
              ),

              const SizedBox(height: 40),

              Text(
                "© 2026 Natalis\nDesigned for safer pregnancies.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build3DCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.teal.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.tealAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(color: Colors.white70, height: 1.6),
          ),
        ],
      ),
    );
  }
}
