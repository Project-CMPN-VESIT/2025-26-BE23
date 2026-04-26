import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:natalis_frontend/core/di/injection.dart';
import 'package:natalis_frontend/core/services/pref_service.dart';
import 'package:natalis_frontend/modules/home/bloc/home_cubit.dart';
import 'package:natalis_frontend/modules/home/repository/home_repository.dart';
import 'package:natalis_frontend/core/services/test_socket_service.dart';
import 'package:natalis_frontend/splash_decider_screen.dart';
import 'modules/login/repository/auth_repository.dart';
import 'modules/login/bloc/login_cubit.dart';
import 'modules/welcome/screen/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
            authRepository: getIt<AuthRepository>(),
            prefService: getIt<PrefService>(),
          ),
        ),
        BlocProvider<HomeCubit>(
          create: (_) =>
              HomeCubit(getIt<HomeRepository>(), getIt<TestSocketService>()),
        ),
        // add more cubits here later
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Natalis Base',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor),
          primaryColor: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const SplashDeciderScreen(),
      ),
    );
  }
}
