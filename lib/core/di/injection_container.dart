import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/otp_local_datasource.dart';
import '../../features/auth/data/datasources/otp_remote_datasource.dart';
import '../../features/auth/data/datasources/otp_remote_datasource_impl.dart';
import '../../features/auth/data/datasources/otp_server_verification_datasource.dart';
import '../../features/auth/data/repositories/otp_repository_impl.dart';
import '../../features/auth/domain/repositories/otp_repository.dart';
import '../../features/auth/domain/usecases/otp_usecases.dart';
import '../../features/auth/presentation/providers/otp_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

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
}
