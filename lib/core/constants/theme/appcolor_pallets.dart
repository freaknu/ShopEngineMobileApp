import 'package:flutter/material.dart';

class AppcolorPallets {
  // Primary Brand Colors
  static const Color primaryColor = Color(0xFF9775FA);
  static const Color primaryDark = Color(0xFF7C5CE0);
  static const Color primaryLight = Color(0xFFB99BFF);
  
  // Secondary Colors
  static const Color secondaryColor = Color(0xFFF6F2FF);
  static const Color thirdColor = Color(0xFFE7E8EA);
  
  // Social Media Colors
  static const Color faceBookColor = Color(0xFF4267B2);
  static const Color googleColor = Color(0xFFEA4335);
  static const Color twitterColor = Color(0xFF1DA1F2);
  
  // UI Colors
  static const Color boxColor = Color(0xFFF5F6FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFFAFBFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF6C727F);
  static const Color textLight = Color(0xFF9095A1);
  
  // Status Colors
  static const Color success = Color(0xFF00D66B);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFA94D);
  static const Color info = Color(0xFF4ECBFF);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9775FA), Color(0xFFB99BFF)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFBFF), Color(0xFFFFFFFF)],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FF)],
  );
  
  // Shadow Colors
  static BoxShadow primaryShadow = BoxShadow(
    color: primaryColor.withOpacity(0.3),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
  
  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );
  
  static BoxShadow softShadow = BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}