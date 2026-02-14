import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:totalx/core/error/failure.dart';

import '../../../../core/constants/demo_credentials.dart';

import '../../domain/usecases/otp_usecases.dart';

/// OTP flow status.
enum OTPStatus {
  initial,
  loading,
  otpSent,
  otpVerified,
  tokenVerified,
  error,
}

/// Provider for OTP flow state and actions.
class OTPProvider extends OTPProviderBase {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final RetryOtpUseCase retryOtpUseCase;

  OTPProvider({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.retryOtpUseCase,
  });

  @override
  Future<void> sendOTPToPhone(String identifier) async {
    _setStatus(OTPStatus.loading);
    _clearError();
    try {
      final normalized = _normalizeId(identifier);
      print('🔵 [OTP] Sending OTP to: $normalized');
      
      final result = await sendOtpUseCase(SendOtpParams(identifier: normalized));
      
      _reqId = result.reqId;
      _phoneIdentifier = normalized;
      _demoOTP = DemoCredentials.useDemoMode ? DemoCredentials.getDemoOTP(normalized) : null;
      _setStatus(OTPStatus.otpSent);
      _message = result.message;
      
      print('✅ [OTP] OTP sent successfully');
      print('   ReqId: $_reqId');
      print('   Message: $_message');
      if (_demoOTP != null) {
        print('   Demo OTP: $_demoOTP');
      }
    } on Failure catch (e) {
      print('❌ [OTP] Failed to send OTP: ${e.message}');
      _setError(e.message);
    } catch (e) {
      print('❌ [OTP] Error sending OTP: $e');
      _setError(e.toString());
    }
  }

  @override
  Future<void> verifyOTPCode(String reqId, String otp) async {
    _setStatus(OTPStatus.loading);
    _clearError();
    try {
      print('🔵 [OTP] Verifying OTP');
      print('   ReqId: $reqId');
      print('   OTP: $otp');
      
      final result = await verifyOtpUseCase(VerifyOtpParams(reqId: reqId, otp: otp));
      
      _accessToken = result.accessToken;
      _setStatus(OTPStatus.otpVerified);
      _message = result.message;
      
      print('✅ [OTP] OTP verified successfully');
      print('   Access Token: ${_accessToken?.substring(0, 20)}...');
      print('   Message: $_message');
    } on Failure catch (e) {
      print('❌ [OTP] Failed to verify OTP: ${e.message}');
      _setError(e.message);
    } catch (e) {
      print('❌ [OTP] Error verifying OTP: $e');
      _setError(e.toString());
    }
  }

  @override
  Future<void> retryOTPCode(String reqId, {int? channel}) async {
    _setStatus(OTPStatus.loading);
    _clearError();
    try {
      print('🔵 [OTP] Resending OTP');
      print('   ReqId: $reqId');
      print('   Channel: $channel');
      
      await retryOtpUseCase(RetryOtpParams(reqId: reqId, channel: channel));
      
      _setStatus(OTPStatus.otpSent);
      _message = 'OTP resent successfully';
      
      print('✅ [OTP] OTP resent successfully');
    } on Failure catch (e) {
      print('❌ [OTP] Failed to resend OTP: ${e.message}');
      _setError(e.message);
    } catch (e) {
      print('❌ [OTP] Error resending OTP: $e');
      _setError(e.toString());
    }
  }

  String _normalizeId(String id) {
    final digits = id.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 10 && !digits.startsWith('91')) {
      return '91$digits';
    }
    return digits;
  }
}

/// Base provider with shared state and timer logic.
abstract class OTPProviderBase extends ChangeNotifier {
  OTPStatus _status = OTPStatus.initial;
  String? _reqId;
  String? _accessToken;
  String? _message;
  String? _error;
  String? _phoneIdentifier;
  String? _demoOTP;

  Timer? _resendTimer;
  int _resendSecondsRemaining = 0;

  OTPStatus get status => _status;
  String? get reqId => _reqId;
  String? get accessToken => _accessToken;
  String? get message => _message;
  String? get error => _error;
  String? get phoneIdentifier => _phoneIdentifier;
  String? get demoOTP => _demoOTP;
  int get resendSecondsRemaining => _resendSecondsRemaining;
  bool get canResend => _resendSecondsRemaining <= 0;
  bool get isDemoMode => DemoCredentials.useDemoMode;

  Future<void> sendOTPToPhone(String identifier);
  Future<void> verifyOTPCode(String reqId, String otp);
  Future<void> retryOTPCode(String reqId, {int? channel});

  void startResendTimer({int seconds = 60}) {
    _resendTimer?.cancel();
    _resendSecondsRemaining = seconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendSecondsRemaining > 0) {
        _resendSecondsRemaining--;
        notifyListeners();
      } else {
        _resendTimer?.cancel();
      }
    });
    notifyListeners();
  }

  void stopResendTimer() {
    _resendTimer?.cancel();
    _resendSecondsRemaining = 0;
    notifyListeners();
  }

  /// Cancels the timer without notifying. Use in dispose() to avoid
  /// notifyListeners during widget tree teardown.
  void cancelResendTimerSilently() {
    _resendTimer?.cancel();
    _resendSecondsRemaining = 0;
  }

  void reset() {
    _resendTimer?.cancel();
    _status = OTPStatus.initial;
    _reqId = null;
    _accessToken = null;
    _message = null;
    _error = null;
    _phoneIdentifier = null;
    _demoOTP = null;
    _resendSecondsRemaining = 0;
    notifyListeners();
  }

  void _setStatus(OTPStatus s) {
    _status = s;
    notifyListeners();
  }

  void _setError(String e) {
    _error = e;
    _status = OTPStatus.error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
