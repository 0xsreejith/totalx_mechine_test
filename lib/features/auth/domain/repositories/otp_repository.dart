import '../entities/otp_response.dart';

abstract class OtpRepository {
  Future<OtpResponseEntity> sendOtp(String identifier);
  Future<VerificationResponseEntity> verifyOtp(String reqId, String otp);
  Future<OtpResponseEntity> retryOtp(String reqId, {int? channel});
  Future<AccessTokenVerifyEntity> verifyAccessTokenOnServer(String accessToken);
  Future<void> cacheAccessToken(String token);
  Future<String?> getCachedAccessToken();
}
