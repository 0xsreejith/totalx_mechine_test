import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:totalx/core/error/execption.dart';

import '../../../../core/constants/api_constants.dart';

import '../models/otp_response_model.dart' show AccessTokenVerifyResponseModel;

/// Server-side access token verification via MSG91 API.
class OTPServerVerificationDataSource {
  final http.Client httpClient;
  final String baseUrl = ApiConstants.verifyTokenUrl;

  OTPServerVerificationDataSource({http.Client? client})
      : httpClient = client ?? http.Client();

  Future<AccessTokenVerifyResponseModel> verifyAccessToken(String accessToken) async {
    try {
      final response = await httpClient.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authkey': ApiConstants.serverAuthKey,
          'access-token': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        final map = jsonDecode(response.body) as Map<String, dynamic>;
        return AccessTokenVerifyResponseModel.fromMap(map);
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Token verification failed: $e');
    }
  }
}
