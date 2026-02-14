import 'package:flutter_dotenv/flutter_dotenv.dart';

/// MSG91 API credentials and configuration.
/// Uses environment variables for secure credential management.
class ApiConstants {
  // Client-side (Flutter SDK) - loaded from environment variables
  static String get widgetId => dotenv.env['WIDGET_ID'] ?? '';
  static String get authToken => dotenv.env['AUTH_TOKEN'] ?? '';

  // Server-side (Backend verification) - loaded from environment variables
  static String get serverAuthKey => dotenv.env['SERVER_AUTH_KEY'] ?? '';
  static const String verifyTokenUrl =
      'https://control.msg91.com/api/v5/widget/verifyAccessToken';
}

/// MSG91 retry channel codes.
class RetryChannel {
  static const int sms = 11;
  static const int voice = 4;
  static const int email = 3;
  static const int whatsapp = 12;
}

/// Local storage keys.
class StorageKeys {
  static const String cachedAccessToken = 'CACHED_ACCESS_TOKEN';
}
