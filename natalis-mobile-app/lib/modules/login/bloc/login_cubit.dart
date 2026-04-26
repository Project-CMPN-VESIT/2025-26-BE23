import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:natalis_frontend/core/services/pref_service.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';
import 'login_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final PrefService prefService;

  LoginCubit({required this.authRepository, required this.prefService})
    : super(LoginInitial());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    emit(LoginLoading());

    try {
      final UserModel user = await authRepository.login(
        email: email,
        password: password,
      );
      await prefService.setLoggedIn(true);
      await prefService.setUserId(user.id);
      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(GoogleLoginLoading());

      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId:
            "560884742443-qkaouhqm04k5jumdhujgnbdbeocl93a0.apps.googleusercontent.com",
      );

      final GoogleSignInAccount account = await googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      final auth = await account.authentication;

      final idToken = auth.idToken;

      if (idToken == null) {
        emit(LoginError("Failed to get ID token"));
        return;
      }

      final user = await authRepository.loginWithGoogle(idToken: idToken);
      await prefService.setLoggedIn(true);
      await prefService.setUserId(user.id);

      emit(LoginSuccess(user: user));
    } catch (e) {
      print("Google Sign In Error: $e");
      emit(LoginError("Google login failed"));
    }
  }
}
