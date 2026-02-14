import '../../domain/entities/otp_response.dart';

/// Model for OTP send/retry API response.
class OtpResponseModel extends OtpResponseEntity {
  OtpResponseModel({
    required super.status,
    required super.message,
    super.reqId,
  });

  factory OtpResponseModel.fromMap(Map<String, dynamic> map) {
    final type = map['type']?.toString().toLowerCase() ?? 'error';
    final status = type == 'success' ? 'success' : 'error';
    final message = map['message']?.toString() ?? map['description']?.toString() ?? 'Unknown';
    final reqId = map['reqId'] ?? map['request_id'] ?? map['message']?.toString();
    return OtpResponseModel(
      status: status,
      message: message,
      reqId: reqId?.toString(),
    );
  }
}

/// Model for OTP verify API response.
class OtpVerifyResponseModel extends VerificationResponseEntity {
  OtpVerifyResponseModel({
    required super.status,
    required super.message,
    super.accessToken,
  });

  factory OtpVerifyResponseModel.fromMap(Map<String, dynamic> map) {
    final type = map['type']?.toString().toLowerCase() ?? 'error';
    final status = type == 'success' ? 'success' : 'error';
    final message = map['message']?.toString() ?? map['description']?.toString() ?? 'Unknown';
    final accessToken = map['access_token'] ?? map['accessToken'];
    return OtpVerifyResponseModel(
      status: status,
      message: message,
      accessToken: accessToken?.toString(),
    );
  }
}

/// Model for server-side access token verification.
class AccessTokenVerifyResponseModel extends AccessTokenVerifyEntity {
  AccessTokenVerifyResponseModel({
    required super.success,
    required super.message,
  });

  factory AccessTokenVerifyResponseModel.fromMap(Map<String, dynamic> map) {
    final success = map['success'] == true || map['valid'] == true;
    final message = map['message']?.toString() ?? (success ? 'Token valid' : 'Token invalid');
    return AccessTokenVerifyResponseModel(success: success, message: message);
  }
}
