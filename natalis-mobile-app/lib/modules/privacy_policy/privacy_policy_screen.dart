import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.privacy_tip_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Natalis Privacy Policy",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
              ),

              const SizedBox(height: 30),

              _buildPolicyCard(
                title: "1. Introduction",
                content:
                    "Natalis is committed to protecting patient and institutional "
                    "data. This Privacy Policy outlines how information is collected, "
                    "processed, stored, and protected within the Natalis platform.",
              ),

              const SizedBox(height: 20),

              _buildPolicyCard(
                title: "2. Information We Collect",
                content:
                    "• Patient clinical data entered by authorized users\n"
                    "• CTG analysis inputs and results\n"
                    "• Organization and healthcare provider details\n"
                    "• Authentication credentials\n"
                    "• System usage metadata",
              ),

              const SizedBox(height: 20),

              _buildPolicyCard(
                title: "3. How We Use Information",
                content:
                    "Collected information is used strictly for:\n\n"
                    "• AI-based clinical analysis\n"
                    "• Risk classification support\n"
                    "• Secure medical record management\n"
                    "• Improving system reliability and performance",
              ),

              const SizedBox(height: 20),

              _buildPolicyCard(
                title: "4. Data Security & Protection",
                content:
                    "Natalis implements modern security standards including:\n\n"
                    "• Encrypted data storage\n"
                    "• Secure API communication\n"
                    "• Role-based access control\n"
                    "• Organization-level data isolation\n"
                    "• Audit-friendly logging architecture\n\n"
                    "We follow industry best practices for responsible medical AI usage.",
              ),

              const SizedBox(height: 20),

              _buildPolicyCard(
                title: "5. Data Sharing",
                content:
                    "Natalis does not sell, rent, or share patient data with "
                    "third parties. Data is accessible only to authorized "
                    "healthcare professionals within the registered organization.",
              ),

              const SizedBox(height: 20),

              _buildPolicyCard(
                title: "6. Compliance Commitment",
                content:
                    "Natalis is built following modern healthcare software "
                    "design principles and is structured to support compliance "
                    "with medical data protection regulations applicable within "
                    "the operating jurisdiction.",
              ),

              const SizedBox(height: 40),

              Center(
                child: Text(
                  "© 2026 Natalis\nAll rights reserved.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({required String title, required String content}) {
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
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
