import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:natalis_frontend/modules/profile/widgets/section_title.dart';
import 'package:url_launcher/url_launcher.dart';

// class PrivacyPolicyScreen extends StatelessWidget {
//   const PrivacyPolicyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(24),
//           children: [
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Privacy Policy",
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),

//             _buildSection(
//               title: "1. Information Collection",
//               content: "We collect anonymized ultrasound scan data and patient demographics to provide AI-powered prenatal screening services. No personally identifiable information is stored without explicit consent.",
//             ),
//             const SizedBox(height: 20),

//             _buildSection(
//               title: "2. Data Security",
//               content: "All medical data is encrypted at rest and in transit using AES-256 encryption. We comply with HIPAA and GDPR medical data protection standards.",
//             ),
//             const SizedBox(height: 20),

//             _buildSection(
//               title: "3. Patient Consent",
//               content: "Patients must provide informed consent before any scan data is processed. Consent can be revoked at any time through the patient portal.",
//             ),
//             const SizedBox(height: 20),

//             _buildSection(
//               title: "4. Data Sharing",
//               content: "We do not sell patient data. Medical data may only be shared with authorized healthcare providers involved in the patient's care.",
//             ),
//             const SizedBox(height: 20),

//             _buildSection(
//               title: "5. Your Rights",
//               content: "Patients have the right to access, correct, or delete their medical data. Contact us at privacy@natalis.com to exercise your rights.",
//             ),
//             const SizedBox(height: 20),

//             _buildSection(
//               title: "6. Policy Updates",
//               content: "We may update this privacy policy periodically. Major changes will be notified to all users through the app.",
//             ),
//             const SizedBox(height: 32),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final Uri emailUri = Uri(
//                     scheme: 'mailto',
//                     path: 'privacy@natalis.com',
//                     query: 'subject=Natalis App Support',
//                   );
//                   if (await canLaunchUrl(emailUri)) {
//                     await launchUrl(emailUri);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2C5364),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: Text(
//                   "Contact Support",
//                   style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ).animate().fadeIn().slideY(begin: 0.2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection({required String title, required String content}) {
//     return GlassmorphicContainer(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       borderRadius: 16,
//       blur: 18,
//       border: 1,
//       linearGradient: LinearGradient(
//         colors: [
//           Colors.white.withOpacity(0.1),
//           Colors.white.withOpacity(0.05),
//         ],
//       ),
//       borderGradient: LinearGradient(
//         colors: [
//           Colors.white.withOpacity(0.2),
//           Colors.white.withOpacity(0.05),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.inter(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             content,
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               color: Colors.white70,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     ).animate().fadeIn().slideX(begin: 0.3);
//   }
// }
