import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:natalis_frontend/core/di/injection.dart';
import 'package:natalis_frontend/core/services/pref_service.dart';
import 'package:natalis_frontend/modules/about/about_natalis_screen.dart';
import 'package:natalis_frontend/modules/privacy_policy/privacy_policy_screen.dart';
import 'package:natalis_frontend/modules/profile/widgets/action_card.dart';
import 'package:natalis_frontend/modules/profile/widgets/doctor_info_card.dart';
import 'package:natalis_frontend/modules/profile/widgets/edit_profile_screen.dart';
import 'package:natalis_frontend/modules/profile/widgets/logout_card.dart';
import 'package:natalis_frontend/modules/profile/widgets/section_title.dart';
import 'package:natalis_frontend/modules/welcome/screen/welcome.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      children: [
        DoctorInfoCard(),

        const SizedBox(height: 32),

        /// ⚙️ ACCOUNT
        SectionTitle(title: "Account"),
        const SizedBox(height: 16),

        ProfileActionCard(
          icon: Icons.edit_outlined,
          title: "Edit Profile",
          subtitle: "Update personal and professional details",
          onTap: () {
            // TODO: Navigate to Edit Profile

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditProfileScreen()),
            );
          },
        ),

        const SizedBox(height: 12),

        ProfileActionCard(
          icon: Icons.privacy_tip_outlined,
          title: "Privacy Policy",
          subtitle: "How we protect patient data",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
            );
            // TODO: Open Privacy Policy
          },
        ),

        const SizedBox(height: 12),

        ProfileActionCard(
          icon: Icons.info_outline,
          title: "About Natalis",
          subtitle: "Version, vision & medical compliance",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AboutNatalisScreen()),
            );
            // TODO: Open About Screen
          },
        ),

        const SizedBox(height: 40),

        /// 🚪 LOGOUT
        LogoutCard(
          onTap: () async {
            final prefs = getIt<PrefService>();

            // 🔹 Clear UI login state
            await prefs.clear();

            // 🔹 Navigate to Welcome screen and remove all previous routes
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
