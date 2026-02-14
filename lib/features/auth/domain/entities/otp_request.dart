/// Entity for OTP send/retry request.
class OtpRequestEntity {
  final String identifier;
  final int? retryChannel;

  OtpRequestEntity({required this.identifier, this.retryChannel});
}
