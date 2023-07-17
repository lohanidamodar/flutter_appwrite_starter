import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'sizes.dart';

class AppThemes {
  static late BuildContext context;
  static final ThemeData defaultTheme =
      ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    secondaryHeaderColor: AppColors.accentColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    brightness: Brightness.dark,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
  );
}
