import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tractianchallenge/core/theme/app_theme.dart';

class AppTypography {
  static final TextStyle mediumLg = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppTheme.textPrimary,
    height: 1.33,
  );

  static final TextStyle mediumSm = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppTheme.textPrimary,
    height: 1.42,
  );

  static final TextStyle regularLg = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppTheme.textPrimary,
    height: 1.33,
  );

  static final TextStyle bodyRegular = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppTheme.textPrimary,
    height: 1.57,
  );
}
