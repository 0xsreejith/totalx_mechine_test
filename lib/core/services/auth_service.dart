import '../../features/auth/data/datasources/otp_local_datasource.dart';

class AuthService {
  final OTPLocalDataSource localDataSource;

  AuthService(this.localDataSource);

  Future<bool> isUserLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  Future<String?> getCurrentPhoneNumber() async {
    return await localDataSource.getCachedPhoneNumber();
  }

  Future<void> saveLoginSession(String phoneNumber, String accessToken) async {
    await localDataSource.cachePhoneNumber(phoneNumber);
    await localDataSource.cacheAccessToken(accessToken);
    await localDataSource.setLoggedIn(true);
    print('✅ [AUTH] Login session saved for: $phoneNumber');
  }

  Future<void> logout() async {
    await localDataSource.clearAuthData();
    print('✅ [AUTH] User logged out');
  }
}
