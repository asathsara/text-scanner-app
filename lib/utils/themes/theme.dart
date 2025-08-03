import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';
import 'package:text_extractor_app/utils/themes/button_theme.dart';
import 'package:text_extractor_app/utils/themes/navigation_theme.dart';

class AppThemes {
  AppThemes._(); // private constructor


  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primaryColor, brightness: Brightness.light),
    textTheme: GoogleFonts.interTextTheme(),
    navigationBarTheme: AppNavigationThemes.light,
    filledButtonTheme:  AppButtonThemes.lightFilled
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primaryColor, brightness: Brightness.dark),
    textTheme: GoogleFonts.interTextTheme(),
    navigationBarTheme: AppNavigationThemes.dark,
    filledButtonTheme:  AppButtonThemes.darkFilled
  );
}
