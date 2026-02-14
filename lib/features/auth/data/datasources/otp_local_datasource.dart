import 'package:shared_preferences/shared_preferences.dart';
import 'package:totalx/core/error/execption.dart';

import '../../../../core/constants/api_constants.dart';

/// Local storage for OTP-related data (access token cache).
abstract class OTPLocalDataSource {
  Future<void> cacheAccessToken(String token);
  Future<String?> getCachedAccessToken();
}

class OTPLocalDataSourceImpl implements OTPLocalDataSource {
  final SharedPreferences sharedPreferences;

  OTPLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAccessToken(String token) async {
    try {
      await sharedPreferences.setString(StorageKeys.cachedAccessToken, token);
    } catch (e) {
      throw CacheException('Failed to cache token: $e');
    }
  }

  @override
  Future<String?> getCachedAccessToken() async {
    try {
      return sharedPreferences.getString(StorageKeys.cachedAccessToken);
    } catch (e) {
      throw CacheException('Failed to get cached token: $e');
    }
  }
}
