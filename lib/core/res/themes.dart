import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'sizes.dart';

class AppThemes {
  static late BuildContext context;
  static final ThemeData defaultTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    secondaryHeaderColor: AppColors.accentColor,
    primarySwatch: Colors.red,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
    useMaterial3: true,
  );
}