import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

import 'dart:convert';
import 'package:get_it/get_it.dart';
import '../../../core/network/api_client.dart';
import '../model/user_model.dart';

class AuthRepository {
  final ApiClient _api = GetIt.instance<ApiClient>(instanceName: "backendApi");

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        '/api/auth/login',
        body: {'email': email, 'password': password},
      );

      log(response.toString());

      final data = response.data;

      final userJson = data['user'];
      // final token = data['token']; // assuming backend returns token

      // /// 🔐 Save token into ApiClient
      // if (token != null) {
      //   _api.setToken(token);
      // }

      return UserModel.fromJson(userJson);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel> loginWithGoogle({required String idToken}) async {
    try {
      final response = await _api.post(
        '/api/auth/google',
        body: {"idToken": idToken},
      );

      final data = response.data;

      // final token = data['token'];
      final userJson = data['user'];

      /// 🔐 Save JWT
      // if (token != null) {
      //   _api.setToken(token);
      // }

      return UserModel.fromJson(userJson);
    } catch (e) {
      throw Exception('Google login failed: $e');
    }
  }
}
