import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'sizes.dart';

class AppThemes {
  var _darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    secondaryHeaderColor: AppColors.accentColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
    ),
  );

  var _lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    secondaryHeaderColor: AppColors.accentColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
    ),
  );

  ThemeData get lightTheme {
    _lightTheme = _lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(_lightTheme.textTheme));
    return _lightTheme;
  }

  ThemeData get darkTheme {
    _darkTheme = _darkTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(_darkTheme.textTheme));
    return _darkTheme;
  }
}
