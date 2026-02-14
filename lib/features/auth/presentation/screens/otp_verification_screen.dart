import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/otp_provider.dart';
import '../widgets/otp_illustration.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/primary_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  OTPProvider? _otpProvider;

  @override
  void initState() {
    super.initState();
    
    // Start timer after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OTPProvider>();
      _otpProvider = provider;
      provider.startResendTimer(seconds: 60);
    });
    
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    
    // Stop timer using stored reference
    _otpProvider?.stopResendTimer();
    
    super.dispose();
  }

  String _getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  bool _isOtpComplete() {
    return _getOtpCode().length == 6;
  }

  void _handleVerify() async {
    if (!_isOtpComplete()) {
      _showError('Please enter complete OTP');
      return;
    }

    final provider = context.read<OTPProvider>();
    final otp = _getOtpCode();

    if (provider.reqId == null) {
      _showError('Invalid session. Please try again.');
      return;
    }

    await provider.verifyOTPCode(provider.reqId!, otp);

    if (!mounted) return;

    if (provider.status == OTPStatus.otpVerified) {
      // Stop timer before navigation
      provider.stopResendTimer();
      
      // Save login session
      final authService = di.sl<AuthService>();
      await authService.saveLoginSession(
        widget.phoneNumber,
        provider.accessToken ?? '',
      );

      if (!mounted) return;

      // Navigate to home screen with UserProvider
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => di.getUserProvider(widget.phoneNumber)..loadUsers(),
            child: HomeScreen(phoneNumber: widget.phoneNumber),
          ),
        ),
        (route) => false,
      );
    } else if (provider.status == OTPStatus.error) {
      _showError(provider.error ?? 'Invalid OTP. Please try again.');
      _clearOtp();
    }
  }

  void _handleResend() async {
    final provider = context.read<OTPProvider>();
    
    if (!provider.canResend) return;

    if (provider.reqId == null) {
      _showError('Invalid session. Please try again.');
      return;
    }

    await provider.retryOTPCode(provider.reqId!);

    if (!mounted) return;

    if (provider.status == OTPStatus.otpSent) {
      provider.startResendTimer(seconds: 60);
      _clearOtp();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
    } else if (provider.status == OTPStatus.error) {
      _showError(provider.error ?? 'Failed to resend OTP');
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  String _getMaskedPhone() {
    if (widget.phoneNumber.length >= 10) {
      final last2 = widget.phoneNumber.substring(widget.phoneNumber.length - 2);
      return '+91 *******$last2';
    }
    return widget.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      body: SafeArea(
        child: Consumer<OTPProvider>(
          builder: (context, otpProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const OtpIllustration(),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'OTP Verification',
                      style: AppTextStyles.heading,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter the verification code we just sent to your\nnumber ${_getMaskedPhone()}.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => OtpInputField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        nextFocusNode: index < 5 ? _focusNodes[index + 1] : null,
                        previousFocusNode: index > 0 ? _focusNodes[index - 1] : null,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (otpProvider.resendSecondsRemaining > 0)
                    Text(
                      '${otpProvider.resendSecondsRemaining} Sec',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    const SizedBox(height: 20),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Get OTP? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: otpProvider.canResend ? _handleResend : null,
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: 14,
                            color: otpProvider.canResend
                                ? AppColors.linkBlue
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Verify',
                    onPressed: _isOtpComplete() ? _handleVerify : null,
                    isLoading: otpProvider.status == OTPStatus.loading,
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
