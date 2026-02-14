import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/otp_provider.dart';
import '../widgets/phone_illustration.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/terms_text.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText;
  bool _isNavigating = false;
  late OTPProvider _otpProvider;

  @override
  void initState() {
    super.initState();
    _otpProvider = di.sl<OTPProvider>();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    // Don't dispose _otpProvider here as it's passed to OTP screen
    super.dispose();
  }

  void _handleGetOTP() async {
    setState(() {
      _errorText = null;
    });

    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        _errorText = 'Please enter phone number';
      });
      return;
    }

    if (phone.length != 10) {
      setState(() {
        _errorText = 'Please enter valid 10 digit phone number';
      });
      return;
    }

    await _otpProvider.sendOTPToPhone(phone);

    if (!mounted) return;

    if (_otpProvider.status == OTPStatus.otpSent) {
      // Navigate to OTP verification screen
      if (!_isNavigating) {
        _isNavigating = true;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: _otpProvider,
              child: OtpVerificationScreen(phoneNumber: phone),
            ),
          ),
        ).then((_) {
          _isNavigating = false;
        });
      }
    } else if (_otpProvider.status == OTPStatus.error) {
      setState(() {
        _errorText = _otpProvider.error ?? 'Failed to send OTP. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: _otpProvider,
          child: Consumer<OTPProvider>(
            builder: (context, otpProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const PhoneIllustration(),
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter Phone Number',
                        style: AppTextStyles.heading,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PhoneInputField(
                      controller: _phoneController,
                      errorText: _errorText,
                    ),
                    const SizedBox(height: 16),
                    const TermsText(),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Get OTP',
                      onPressed: _handleGetOTP,
                      isLoading: otpProvider.status == OTPStatus.loading,
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
