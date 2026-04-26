import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:natalis_frontend/core/services/pref_service.dart';
import 'package:natalis_frontend/modules/home/repository/home_repository.dart';
import 'package:natalis_frontend/core/services/test_socket_service.dart';
import 'package:natalis_frontend/modules/login/repository/auth_repository.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  /// Load env
  await dotenv.load();

  final backendUrl = dotenv.env['BACKEND_URL']!;
  final modelUrl = dotenv.env['MODEL_URL']!;

  /// 🔵 Backend API Client (Spring Boot)
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: backendUrl),
    instanceName: "backendApi",
  );

  /// 🟣 Model API Client (Flask)
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: modelUrl),
    instanceName: "modelApi",
  );

  getIt.registerLazySingleton<PrefService>(() => PrefService());

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  /// 🔵 HomeRepository
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepository());
  getIt.registerLazySingleton<TestSocketService>(() => TestSocketService());
}
