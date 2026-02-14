import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Demo mode configuration for testing when DLT is not configured.
/// Real SMS won't be delivered - use fixed OTP for demo numbers.
///
/// Demo mode is controlled by USE_DEMO_MODE environment variable.
class DemoCredentials {
  /// Enable demo mode for testing. Controlled by environment variable.
  static bool get useDemoMode => 
      dotenv.env['USE_DEMO_MODE']?.toLowerCase() == 'true';

  /// Demo phone numbers (identifier format: countryCode + phone) mapped to fixed OTP.
  /// DLT not configured -> no real SMS -> use these for testing.
  static const Map<String, String> demoPhones = {
    '919746362268': '123456',
    '919946335695': '123456',
  };

  /// Check if the given identifier is a demo phone number.
  static bool isDemoPhone(String identifier) => demoPhones.containsKey(identifier);

  /// Get the fixed OTP for a demo phone. Returns null if not a demo number.
  static String? getDemoOTP(String identifier) => demoPhones[identifier];

  /// Get demo mode message for UI display.
  static String getDemoMessage(String identifier) {
    final otp = demoPhones[identifier];
    return otp != null ? '🧪 Demo Mode: Use OTP: $otp' : 'OTP sent';
  }
}
