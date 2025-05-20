import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/routers/route.dart';
import 'package:foreglyc/data/datasources/local/chat_preferences.dart';
import 'package:foreglyc/data/datasources/local/home_preference.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/repositories/chat_repository.dart';
import 'package:foreglyc/data/repositories/dietary_repository.dart';
import 'package:foreglyc/data/repositories/food_repository.dart';
import 'package:foreglyc/data/repositories/home_repository.dart';
import 'package:foreglyc/data/repositories/monitoring_preferences_repository.dart';
import 'package:foreglyc/data/repositories/monitoring_repository.dart';
import 'package:foreglyc/data/repositories_impl/auth_repository_impl.dart';
import 'package:foreglyc/data/repositories_impl/chat_repository_impl.dart';
import 'package:foreglyc/data/repositories_impl/dietary_repository_impl.dart';
import 'package:foreglyc/data/repositories_impl/food_repository_impl.dart';
import 'package:foreglyc/data/repositories_impl/home_repository_impl.dart';
import 'package:foreglyc/data/repositories_impl/monitoring_preferences_repository_impl.dart';
import 'package:foreglyc/data/repositories_impl/monitoring_repository_impl.dart';
import 'package:foreglyc/presentation/blocs/auth/auth_bloc.dart';
import 'package:foreglyc/presentation/blocs/chat/chat_bloc.dart';
import 'package:foreglyc/presentation/blocs/dietary/dietary_bloc.dart';
import 'package:foreglyc/presentation/blocs/food_information/food_information_bloc.dart';
import 'package:foreglyc/presentation/blocs/food_recall/food_recall_bloc.dart';
import 'package:foreglyc/presentation/blocs/home/home_bloc.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_bloc.dart';
import 'package:foreglyc/presentation/blocs/monitoring_preferences/monitoring_preferences_bloc.dart';
import 'package:foreglyc/presentation/blocs/profile/profile_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiConfig = ApiConfig();
  final apiClient = ApiClient();

  final chatPreferences = ChatPreferences();
  final homePreferences = HomePreferences();

  final authRepository = AuthRepositoryImpl(
    apiClient: apiClient,
    apiConfig: apiConfig,
  );
  final chatRepository = ChatRepositoryImpl(
    apiClient: apiClient,
    apiConfig: apiConfig,
    chatPreferences: chatPreferences,
  );
  final monitoringRepository = MonitoringRepositoryImpl(
    apiClient: apiClient,
    apiConfig: apiConfig,
  );
  final monitoringPreferenceRepository = MonitoringPreferenceRepositoryImpl(
    apiClient: apiClient,
    apiConfig: apiConfig,
  );
  final homeRepository = HomeRepositoryImpl(
    apiClient: apiClient,
    apiConfig: apiConfig,
    homePreferences: homePreferences,
  );
  final dietaryRepository = DietaryRepositoryImpl(
    apiClient: apiClient,
    apiConfig: apiConfig,
  );
  final foodRepository = FoodRepositoryImpl(
    apiClient: apiClient,
    apiConfig: apiConfig,
  );

  runApp(
    MyApp(
      authRepository: authRepository,
      chatRepository: chatRepository,
      monitoringRepository: monitoringRepository,
      monitoringPreferenceRepository: monitoringPreferenceRepository,
      homeRepository: homeRepository,
      dietaryRepository: dietaryRepository,
      foodRepository: foodRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ChatRepository chatRepository;
  final MonitoringRepository monitoringRepository;
  final MonitoringPreferenceRepository monitoringPreferenceRepository;
  final HomeRepository homeRepository;
  final DietaryRepository dietaryRepository;
  final FoodRepository foodRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.chatRepository,
    required this.monitoringRepository,
    required this.monitoringPreferenceRepository,
    required this.homeRepository,
    required this.dietaryRepository,
    required this.foodRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: chatRepository),
        ),
        BlocProvider(
          create:
              (context) =>
                  MonitoringBloc(monitoringRepository: monitoringRepository),
        ),
        BlocProvider(
          create:
              (context) => MonitoringPreferenceBloc(
                repository: monitoringPreferenceRepository,
              ),
        ),
        BlocProvider(create: (context) => HomeBloc(repository: homeRepository)),
        BlocProvider(create: (context) => ProfileBloc(HomePreferences())),
        BlocProvider(
          create:
              (context) => FoodRecallBloc(dietaryRepository: dietaryRepository),
        ),
        BlocProvider(
          create:
              (context) =>
                  FoodInformationBloc(dietaryRepository: dietaryRepository),
        ),
        BlocProvider(
          create: (context) => DietaryBloc(foodRepository: foodRepository),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ),
      ),
    );
  }
}
