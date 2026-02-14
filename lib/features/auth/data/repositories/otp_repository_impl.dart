import '../../../../core/constants/demo_credentials.dart';
import '../../domain/entities/otp_response.dart';
import '../../domain/repositories/otp_repository.dart';
import '../datasources/otp_local_datasource.dart';
import '../datasources/otp_remote_datasource.dart';
import '../datasources/otp_server_verification_datasource.dart';

/// OTP repository implementation with demo mode support.
/// In demo mode: demo phones use fixed OTP; verification can bypass API for demo numbers.
class OtpRepositoryImpl implements OtpRepository {
  final OTPRemoteDataSource remoteDataSource;
  final OTPLocalDataSource localDataSource;
  final OTPServerVerificationDataSource serverVerificationDataSource;

  OtpRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.serverVerificationDataSource,
  }) {
    remoteDataSource.initialize();
  }

  @override
  Future<OtpResponseEntity> sendOtp(String identifier) async {
    final normalizedId = _normalizeIdentifier(identifier);

    // Demo mode: for demo phones, still call MSG91 (logs in dashboard) but we know fixed OTP
    if (DemoCredentials.useDemoMode && DemoCredentials.isDemoPhone(normalizedId)) {
      try {
        final result = await remoteDataSource.sendOTP(normalizedId);
        // Use result reqId if available; otherwise create demo placeholder
        return OtpResponseEntity(
          status: 'success',
          message: DemoCredentials.getDemoMessage(normalizedId),
          reqId: result.reqId ?? 'demo_${normalizedId}_${DateTime.now().millisecondsSinceEpoch}',
        );
      } catch (_) {
        // If MSG91 fails (e.g. no network), still allow demo flow with placeholder reqId
        return OtpResponseEntity(
          status: 'success',
          message: DemoCredentials.getDemoMessage(normalizedId),
          reqId: 'demo_${normalizedId}_${DateTime.now().millisecondsSinceEpoch}',
        );
      }
    }

    final result = await remoteDataSource.sendOTP(normalizedId);
    if (result.status != 'success') {
      throw Exception(result.message);
    }
    return result;
  }

  @override
  Future<VerificationResponseEntity> verifyOtp(String reqId, String otp) async {
    // Demo mode: if reqId starts with "demo_" and OTP matches any demo OTP, succeed
    if (DemoCredentials.useDemoMode && reqId.startsWith('demo_')) {
      final demoOtp = DemoCredentials.demoPhones.values.first;
      if (otp == demoOtp) {
        final token = 'demo_access_token_${DateTime.now().millisecondsSinceEpoch}';
        await localDataSource.cacheAccessToken(token);
        return VerificationResponseEntity(
          status: 'success',
          message: 'OTP verified (demo mode)',
          accessToken: token,
        );
      }
      throw Exception('Invalid OTP. Demo OTP is: $demoOtp');
    }

    // Also check: if reqId contains a demo phone and OTP matches
    for (final entry in DemoCredentials.demoPhones.entries) {
      if (reqId.contains(entry.key) && otp == entry.value) {
        final token = 'demo_access_token_${DateTime.now().millisecondsSinceEpoch}';
        await localDataSource.cacheAccessToken(token);
        return VerificationResponseEntity(
          status: 'success',
          message: 'OTP verified (demo mode)',
          accessToken: token,
        );
      }
    }

    final result = await remoteDataSource.verifyOTP(reqId, otp);
    if (result.status != 'success') {
      throw Exception(result.message);
    }
    if (result.accessToken != null) {
      await localDataSource.cacheAccessToken(result.accessToken!);
    }
    return result;
  }

  @override
  Future<OtpResponseEntity> retryOtp(String reqId, {int? channel}) async {
    if (DemoCredentials.useDemoMode && reqId.startsWith('demo_')) {
      return OtpResponseEntity(
        status: 'success',
        message: 'OTP resent (demo mode)',
        reqId: reqId,
      );
    }
    final result = await remoteDataSource.retryOTP(reqId, channel: channel);
    if (result.status != 'success') {
      throw Exception(result.message);
    }
    return result;
  }

  @override
  Future<AccessTokenVerifyEntity> verifyAccessTokenOnServer(String accessToken) async {
    if (DemoCredentials.useDemoMode && accessToken.startsWith('demo_access_token_')) {
      return AccessTokenVerifyEntity(success: true, message: 'Demo token (skipped server)');
    }
    final result =
        await serverVerificationDataSource.verifyAccessToken(accessToken);
    return result;
  }

  @override
  Future<void> cacheAccessToken(String token) =>
      localDataSource.cacheAccessToken(token);

  @override
  Future<String?> getCachedAccessToken() => localDataSource.getCachedAccessToken();

  String _normalizeIdentifier(String identifier) {
    final digits = identifier.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 10 && !digits.startsWith('91')) {
      return '91$digits';
    }
    return digits;
  }
}
