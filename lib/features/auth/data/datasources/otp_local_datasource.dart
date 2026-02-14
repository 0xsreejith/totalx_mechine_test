import 'package:shared_preferences/shared_preferences.dart';
import 'package:totalx/core/error/execption.dart';

import '../../../../core/constants/api_constants.dart';

/// Local storage for OTP-related data (access token cache).
abstract class OTPLocalDataSource {
  Future<void> cacheAccessToken(String token);
  Future<String?> getCachedAccessToken();
  Future<void> cachePhoneNumber(String phone);
  Future<String?> getCachedPhoneNumber();
  Future<void> setLoggedIn(bool value);
  Future<bool> isLoggedIn();
  Future<void> clearAuthData();
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

  @override
  Future<void> cachePhoneNumber(String phone) async {
    try {
      await sharedPreferences.setString(StorageKeys.cachedPhoneNumber, phone);
    } catch (e) {
      throw CacheException('Failed to cache phone number: $e');
    }
  }

  @override
  Future<String?> getCachedPhoneNumber() async {
    try {
      return sharedPreferences.getString(StorageKeys.cachedPhoneNumber);
    } catch (e) {
      throw CacheException('Failed to get cached phone number: $e');
    }
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    try {
      await sharedPreferences.setBool(StorageKeys.isLoggedIn, value);
    } catch (e) {
      throw CacheException('Failed to set login status: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return sharedPreferences.getBool(StorageKeys.isLoggedIn) ?? false;
    } catch (e) {
      throw CacheException('Failed to get login status: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await sharedPreferences.remove(StorageKeys.cachedAccessToken);
      await sharedPreferences.remove(StorageKeys.cachedPhoneNumber);
      await sharedPreferences.remove(StorageKeys.isLoggedIn);
    } catch (e) {
      throw CacheException('Failed to clear auth data: $e');
    }
  }
}
