import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';
import 'package:totalx/core/error/execption.dart';

import '../../../../core/constants/api_constants.dart';
import 'otp_remote_datasource.dart';

import '../models/otp_response_model.dart';

/// MSG91 OTP SDK integration.
class OTPRemoteDataSourceImpl extends OTPRemoteDataSource {
  bool _isInitialized = false;

  void _ensureInitialized() {
    if (!_isInitialized) {
      OTPWidget.initializeWidget(ApiConstants.widgetId, ApiConstants.authToken);
      _isInitialized = true;
    }
  }

  @override
  void initialize() {
    _ensureInitialized();
  }

  @override
  Future<OtpResponseModel> sendOTP(String identifier) async {
    _ensureInitialized();
    try {
      final data = {'identifier': identifier};
      final response = await OTPWidget.sendOTP(data);
      return _parseOTPResponse(response);
    } catch (e) {
      throw ServerException('Failed to send OTP: $e');
    }
  }

  @override
  Future<OtpVerifyResponseModel> verifyOTP(String reqId, String otp) async {
    _ensureInitialized();
    try {
      final data = {'reqId': reqId, 'otp': otp};
      final response = await OTPWidget.verifyOTP(data);
      return _parseVerifyResponse(response);
    } catch (e) {
      throw ServerException('Failed to verify OTP: $e');
    }
  }

  @override
  Future<OtpResponseModel> retryOTP(String reqId, {int? channel}) async {
    _ensureInitialized();
    try {
      final data = {
        'reqId': reqId,
        if (channel != null) 'retryChannel': channel,
      };
      final response = await OTPWidget.retryOTP(data);
      return _parseOTPResponse(response);
    } catch (e) {
      throw ServerException('Failed to retry OTP: $e');
    }
  }

  OtpResponseModel _parseOTPResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      return OtpResponseModel.fromMap(response);
    }
    if (response case Map map) {
      return OtpResponseModel.fromMap(Map<String, dynamic>.from(map));
    }
    return OtpResponseModel(status: 'error', message: 'Invalid response: $response');
  }

  OtpVerifyResponseModel _parseVerifyResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      return OtpVerifyResponseModel.fromMap(response);
    }
    if (response is Map) {
      return OtpVerifyResponseModel.fromMap(Map<String, dynamic>.from(response));
    }
    return OtpVerifyResponseModel(status: 'error', message: 'Invalid response: $response');
  }
}
