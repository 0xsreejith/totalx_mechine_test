import '../models/otp_response_model.dart';

/// Contract for OTP remote data source (MSG91 SDK integration).
abstract class OTPRemoteDataSource {
  void initialize();
  Future<OtpResponseModel> sendOTP(String identifier);
  Future<OtpVerifyResponseModel> verifyOTP(String reqId, String otp);
  Future<OtpResponseModel> retryOTP(String reqId, {int? channel});
}
