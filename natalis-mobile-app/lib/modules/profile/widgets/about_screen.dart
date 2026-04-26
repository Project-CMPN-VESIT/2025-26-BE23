// import 'package:flutter/material.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:natalis_frontend/modules/profile/widgets/section_title.dart';

// class AboutScreen extends StatelessWidget {
//   const AboutScreen({super.key});

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
//                     "About Natalis",
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

//             _buildInfoCard(
//               icon: Icons.health_and_safety_outlined,
//               title: "Our Mission",
//               content: "To provide accessible, AI-powered prenatal screening that empowers healthcare providers with actionable insights for better maternal and fetal outcomes.",
//             ),
//             const SizedBox(height: 20),

//             _buildInfoCard(
//               icon: Icons.verified_user_outlined,
//               title: "Medical Compliance",
//               content: "Natalis is compliant with HIPAA, GDPR, and international medical device regulations. Our AI algorithms are FDA-cleared for prenatal scan analysis.",
//             ),
//             const SizedBox(height: 20),

//             _buildInfoCard(
//               icon: Icons.team_up_outlined,
//               title: "Our Team",
//               content: "Built by a team of obstetricians, AI researchers, and software engineers dedicated to improving prenatal care through technology.",
//             ),
//             const SizedBox(height: 20),

//             _buildInfoCard(
//               icon: Icons.science_outlined,
//               title: "AI Technology",
//               content: "Our proprietary AI models are trained on over 500,000 anonymized fetal scans and continuously learn from new clinical data.",
//             ),
//             const SizedBox(height: 32),

//             SectionTitle(title: "Version Information"),
//             const SizedBox(height: 16),

//             GlassmorphicContainer(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               borderRadius: 16,
//               blur: 18,
//               border: 1,
//               linearGradient: LinearGradient(
//                 colors: [
//                   Colors.white.withOpacity(0.1),
//                   Colors.white.withOpacity(0.05),
//                 ],
//               ),
//               borderGradient: LinearGradient(
//                 colors: [
//                   Colors.white.withOpacity(0.2),
//                       Colors.white.withOpacity(0.05),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   _buildVersionRow(label: "App Version", value: "1.0.0"),
//                   const SizedBox(height: 12),
//                   _buildVersionRow(label: "Build Number", value: "1"),
//                   const SizedBox(height: 12),
//                   _buildVersionRow(label: "AI Model Version", value: "v2.3.1"),
//                   const SizedBox(height: 12),
//                   _buildVersionRow(label: "Last Updated", value: "February 2026"),
//                 ],
//               ),
//             ).animate().fadeIn().slideY(begin: 0.2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
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
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: Colors.white, size: 28),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.inter(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   content,
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     color: Colors.white70,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ).animate().fadeIn().slideX(begin: 0.3);
//   }

//   Widget _buildVersionRow({required String label, required String value}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.inter(
//             fontSize: 14,
//             color: Colors.white70,
//           ),
//         ),
//         Text(
//           value,
//           style: GoogleFonts.inter(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
