import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle termsText = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle termsLink = TextStyle(
    fontSize: 12,
    color: AppColors.linkBlue,
    decoration: TextDecoration.none,
  );
}
