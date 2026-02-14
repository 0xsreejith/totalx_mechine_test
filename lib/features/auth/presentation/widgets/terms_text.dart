import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.termsText,
        children: [
          const TextSpan(text: 'By Continuing, I agree to TotalX\'s '),
          TextSpan(
            text: 'Terms and condition',
            style: AppTextStyles.termsLink,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle terms tap
              },
          ),
          const TextSpan(text: ' & '),
          TextSpan(
            text: 'privacy policy',
            style: AppTextStyles.termsLink,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle privacy policy tap
              },
          ),
        ],
      ),
    );
  }
}
