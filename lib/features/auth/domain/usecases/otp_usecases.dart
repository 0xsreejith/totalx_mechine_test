
import 'package:totalx/core/error/failure.dart';
import 'package:totalx/core/useecase/usecase.dart';

import '../entities/otp_response.dart';
import '../repositories/otp_repository.dart';

/// Send OTP to phone number (identifier = countryCode + phone, e.g. 919746362268).
class SendOtpUseCase implements UseCase<OtpResponseEntity, SendOtpParams> {
  final OtpRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<OtpResponseEntity> call(SendOtpParams params) async {
    if (params.identifier.isEmpty) {
      throw ValidationFailure('Phone number is required');
    }
    final digits = params.identifier.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 10) {
      throw ValidationFailure('Enter a valid 10-digit phone number');
    }
    return repository.sendOtp(params.identifier);
  }
}

class SendOtpParams {
  final String identifier;

  SendOtpParams({required this.identifier});
}

/// Verify OTP entered by user.
class VerifyOtpUseCase implements UseCase<VerificationResponseEntity, VerifyOtpParams> {
  final OtpRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<VerificationResponseEntity> call(VerifyOtpParams params) async {
    if (params.reqId.isEmpty || params.otp.isEmpty) {
      throw ValidationFailure('OTP is required');
    }
    if (params.otp.length < 4 || params.otp.length > 6) {
      throw ValidationFailure('OTP must be 4-6 digits');
    }
    return repository.verifyOtp(params.reqId, params.otp);
  }
}

class VerifyOtpParams {
  final String reqId;
  final String otp;

  VerifyOtpParams({required this.reqId, required this.otp});
}

/// Retry OTP on selected channel.
class RetryOtpUseCase implements UseCase<OtpResponseEntity, RetryOtpParams> {
  final OtpRepository repository;

  RetryOtpUseCase(this.repository);

  @override
  Future<OtpResponseEntity> call(RetryOtpParams params) {
    return repository.retryOtp(params.reqId, channel: params.channel);
  }
}

class RetryOtpParams {
  final String reqId;
  final int? channel;

  RetryOtpParams({required this.reqId, this.channel});
}
