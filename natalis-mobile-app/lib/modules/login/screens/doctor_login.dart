import 'package:flutter/material.dart';
import 'package:natalis_frontend/modules/home/screens/home_screen.dart';
import 'package:natalis_frontend/modules/login/bloc/login_cubit.dart';
import 'package:natalis_frontend/modules/login/bloc/login_state.dart';
import 'package:natalis_frontend/modules/login/widgets/login_button.dart';
import 'package:natalis_frontend/modules/login/widgets/login_header.dart';
import 'package:natalis_frontend/modules/login/widgets/login_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

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
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is LoginSuccess) {
                final id = state.user.id;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen(userId: id)),
                );
              }
            },
            builder: (context, state) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const LoginHeader(),
                        const SizedBox(height: 48),

                        LoginTextField(
                          controller: cubit.emailController,
                          label: "Doctor Email",
                          icon: Icons.medical_information_outlined,
                          validator: (v) =>
                              v!.isEmpty ? "Email required" : null,
                        ),
                        const SizedBox(height: 20),

                        LoginTextField(
                          controller: cubit.passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          obscureText: _obscure,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "Password required" : null,
                        ),
                        const SizedBox(height: 36),

                        LoginButton(
                          loading: state is LoginLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.login();
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        /// OR Divider
                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.white30)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "OR",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white30)),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _buildGoogleButton(
                          loading: state is GoogleLoginLoading,
                          onTap: () => cubit.loginWithGoogle(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton({
    required VoidCallback onTap,
    required bool loading,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: loading ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/google.jpeg", height: 22),
              const SizedBox(width: 12),
              Text(
                "Sign in with Google",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (loading) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
