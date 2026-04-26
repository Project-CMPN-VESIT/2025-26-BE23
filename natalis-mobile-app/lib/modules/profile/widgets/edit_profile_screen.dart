import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:natalis_frontend/modules/profile/widgets/section_title.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),

              SectionTitle(title: "Personal Information"),
              const SizedBox(height: 16),

              _buildTextField(label: "Full Name", initialValue: "Dr. Ved Waje"),
              const SizedBox(height: 16),

              _buildTextField(
                label: "Email Address",
                initialValue: "ved.waje@natalis.com",
                isEmail: true,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                label: "Phone Number",
                initialValue: "+91 98765 43210",
                isPhone: true,
              ),

              const SizedBox(height: 32),

              SectionTitle(title: "Professional Information"),
              const SizedBox(height: 16),

              _buildTextField(
                label: "Medical License Number",
                initialValue: "ML123456",
              ),
              const SizedBox(height: 16),

              _buildTextField(
                label: "Specialization",
                initialValue: "Obstetrics & Gynecology",
              ),
              const SizedBox(height: 16),

              _buildTextField(
                label: "Hospital/Clinic",
                initialValue: "Natalis Medical Center",
              ),

              const SizedBox(height: 40),

              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Edit Profile",
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField({
    required String label,
    required String initialValue,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 16,
      blur: 18,
      border: 1,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.white70),
          hintText: initialValue,
          hintStyle: GoogleFonts.inter(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          prefixIcon: _buildPrefixIcon(label, isEmail, isPhone),
        ),
      ),
    );
  }

  // ================= SAVE BUTTON =================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C5364),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          "Save Changes",
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  // ================= BOTTOM BAR =================

  Widget _buildBottomBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: const Border(top: BorderSide(color: Colors.white24)),
      ),
      child: const Center(
        child: Text("Natalis © 2026", style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  // ================= ICON LOGIC =================

  Widget _buildPrefixIcon(String label, bool isEmail, bool isPhone) {
    if (isEmail) return const Icon(Icons.email_outlined, color: Colors.white70);
    if (isPhone) return const Icon(Icons.phone_outlined, color: Colors.white70);
    if (label.contains("Name")) {
      return const Icon(Icons.person_outline, color: Colors.white70);
    }
    if (label.contains("Medical") || label.contains("License")) {
      return const Icon(Icons.medical_services_outlined, color: Colors.white70);
    }
    if (label.contains("Specialization")) {
      return const Icon(Icons.school_outlined, color: Colors.white70);
    }
    if (label.contains("Hospital") || label.contains("Clinic")) {
      return const Icon(
        Icons.health_and_safety_outlined,
        color: Colors.white70,
      );
    }
    return const SizedBox.shrink();
  }
}
