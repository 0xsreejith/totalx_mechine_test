/// Entity for OTP send/retry response.
class OtpResponseEntity {
  final String status;
  final String message;
  final String? reqId;

  OtpResponseEntity({
    required this.status,
    required this.message,
    this.reqId,
  });
}

/// Entity for OTP verification response.
class VerificationResponseEntity {
  final String status;
  final String message;
  final String? accessToken;

  VerificationResponseEntity({
    required this.status,
    required this.message,
    this.accessToken,
  });
}

/// Entity for server-side access token verification.
class AccessTokenVerifyEntity {
  final bool success;
  final String message;

  AccessTokenVerifyEntity({required this.success, required this.message});
}
