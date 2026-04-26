import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:natalis_frontend/models/mother.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_cubit.dart';
import 'package:natalis_frontend/modules/test/cubit/test_flow_state.dart';
import 'package:natalis_frontend/modules/test/screens/upload_scan_screen.dart';
import 'package:natalis_frontend/modules/test/widgets/glass_section.dart';
import 'package:natalis_frontend/modules/test/widgets/glass_text_field.dart';
import 'package:natalis_frontend/modules/test/widgets/number_field.dart';
import 'package:natalis_frontend/modules/test/widgets/number_picker.dart';

class AddMotherScreen extends StatefulWidget {
  final String doctorId;
  final String organizationId;
  const AddMotherScreen({
    super.key,
    required this.doctorId,
    required this.organizationId,
  });

  @override
  State<AddMotherScreen> createState() => _AddMotherScreenState();
}

class _AddMotherScreenState extends State<AddMotherScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestFlowCubit, TestFlowState>(
      listener: (context, state) {
        final cubit = context.read<TestFlowCubit>();
        if (state is MotherDetailsReady) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: UploadScanScreen(mother: state.mother),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<TestFlowCubit>();
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Form(
                key: cubit.formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  children: [
                    /// 🔙 Back
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Mother Details",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter basic information to begin prenatal assessment",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 32),

                    GlassTextField(
                      controller: cubit.nameController,
                      label: "Mother Name",
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? "Name is required" : null,
                    ),

                    const SizedBox(height: 24),

                    GlassTextField(
                      maxlength: 10,
                      controller: cubit.phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          v!.length < 10 ? "Enter valid phone number" : null,
                    ),

                    const SizedBox(height: 32),

                    GlassSection(
                      title: "Age",
                      child: Center(
                        child: NumberPicker(
                          minValue: 15,
                          maxValue: 50,
                          value: cubit.age,
                          itemCount: 3,
                          itemHeight: 40,
                          itemWidth: 80,
                          axis: Axis.horizontal,
                          infiniteLoop: true,
                          haptics: true,
                          onChanged: (value) {
                            setState(() => cubit.age = value);
                          },
                          textStyle: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white54,
                          ),
                          selectedTextStyle: GoogleFonts.playfairDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// 💍 Marital Status
                    GlassSection(
                      title: "Marital Status",
                      child: DropdownButtonFormField<String>(
                        value: cubit.maritalStatus,
                        dropdownColor: const Color(0xFF203A43),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Married",
                            child: Text("Married"),
                          ),
                          DropdownMenuItem(
                            value: "Unmarried",
                            child: Text("Unmarried"),
                          ),
                          DropdownMenuItem(
                            value: "Divorced",
                            child: Text("Divorced"),
                          ),
                          DropdownMenuItem(
                            value: "Widowed",
                            child: Text("Widowed"),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => cubit.maritalStatus = value!),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// 🩸 Blood Group
                    GlassSection(
                      title: "Blood Group",
                      child: DropdownButtonFormField<BloodGroup>(
                        value: cubit.bloodGroup,
                        dropdownColor: const Color(0xFF203A43),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: BloodGroup.values.map((bg) {
                          return DropdownMenuItem(
                            value: bg,
                            child: Text(bg.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => cubit.bloodGroup = value!),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// 📅 LMP
                    GlassSection(
                      title: "Last Menstrual Period (LMP)",
                      child: ListTile(
                        title: Text(
                          cubit.lmpDate == null
                              ? "Select date"
                              : DateFormat(
                                  'dd MMM yyyy',
                                ).format(cubit.lmpDate!),
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: Colors.white70,
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(
                              const Duration(days: 30),
                            ),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => cubit.lmpDate = picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// 🤰 Pregnancy History
                    GlassSection(
                      title: "Pregnancy History",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NumberField(
                            label: "Gravida",
                            value: cubit.gravida,
                            onChanged: (v) => setState(() => cubit.gravida = v),
                          ),
                          NumberField(
                            label: "Para",
                            value: cubit.para,
                            onChanged: (v) => setState(() => cubit.para = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ⚠️ High Risk
                    GlassSection(
                      title: "High Risk Pregnancy",
                      child: SwitchListTile(
                        value: cubit.highRisk,
                        onChanged: (value) =>
                            setState(() => cubit.highRisk = value),
                        activeColor: Colors.redAccent,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          cubit.highRisk
                              ? "Marked as High Risk"
                              : "Normal Pregnancy",
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF2C5364),
            onPressed: () {
              if (cubit.formKey.currentState!.validate() &&
                  cubit.lmpDate != null) {
                final mother = MotherModel(
                  id: null,
                  organizationId: widget.organizationId,
                  doctorId: widget.doctorId,
                  name: cubit.nameController.text,
                  age: cubit.age,
                  maritalStatus: cubit.mapStringToMaritalStatus(
                    cubit.maritalStatus,
                  ),
                  bloodGroup: cubit.bloodGroup,
                  lmp: cubit.lmpDate!,
                  gravida: cubit.gravida,
                  para: cubit.para,
                  highRisk: cubit.highRisk,
                );

                cubit.submitMother(mother);
              }
            },
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: const Text(
              "Continue to Scan Upload",
              style: TextStyle(color: Colors.white),
            ),
          ).animate().slideY(begin: 0.4).fadeIn(),
        );
      },
    );
  }
}
