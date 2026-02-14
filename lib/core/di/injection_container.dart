import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/otp_local_datasource.dart';
import '../../features/auth/data/datasources/otp_remote_datasource.dart';
import '../../features/auth/data/datasources/otp_remote_datasource_impl.dart';
import '../../features/auth/data/datasources/otp_server_verification_datasource.dart';
import '../../features/auth/data/repositories/otp_repository_impl.dart';
import '../../features/auth/domain/repositories/otp_repository.dart';
import '../../features/auth/domain/usecases/otp_usecases.dart';
import '../../features/auth/presentation/providers/otp_provider.dart';
import '../../features/home/data/datasources/user_local_data_sources.dart';
import '../../features/home/data/models/user_model.dart';
import '../../features/home/presentation/providers/user_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // ============ AUTH FEATURE ============
  
  // Data sources
  sl.registerLazySingleton<OTPRemoteDataSource>(
    () => OTPRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<OTPLocalDataSource>(
    () => OTPLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OTPServerVerificationDataSource>(
    () => OTPServerVerificationDataSource(),
  );

  // Repository
  sl.registerLazySingleton<OtpRepository>(
    () => OtpRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      serverVerificationDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => RetryOtpUseCase(sl()));

  // Provider (factory - new instance per usage for fresh state)
  sl.registerFactory(
    () => OTPProvider(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      retryOtpUseCase: sl(),
    ),
  );

  // ============ HOME/USER FEATURE ============
  
  // Data sources
  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasource(),
  );

  // Provider
  sl.registerFactory(
    () => UserProvider(sl()),
  );
}
